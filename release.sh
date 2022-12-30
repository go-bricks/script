#!/usr/bin/env bash

# This script is used to release a new version of the project.

function check_last_error() {
  # capture last error code
  LAST_ERROR_CODE=$?
  # check last error code
  if [ $LAST_ERROR_CODE -ne 0 ]; then
    # echo in red
    echo -e "\033[0;31mFailed\033[0m"
    exit 1
  else
    # echo in green
    echo -e "\033[0;32mSuccessfully\033[0m"
  fi
}

# create a bash function to get the current branch
function get_current_branch() {
  git branch | grep \* | cut -d ' ' -f2
}

# create a bash function to get the current tag
function get_current_tag() {
  git describe --tags --abbrev=0
}

# create a bash function to get the current version
function get_current_version() {
  git describe --tags --abbrev=0 | cut -d 'v' -f2
}

# create a bash function to get the last commit message
function get_last_commit_message() {
  git log -1 --pretty=%B
}

# create a bash function to get the last commit hash
function get_last_commit_hash() {
  git log -1 --pretty=%H
}

# create a bash function to get the last commit author
function get_last_commit_author() {
  git log -1 --pretty=%an
}

# create a bash function to add files to .gitignore
function add_to_gitignore() {
  # get the file to add to .gitignore
  FILE=$1
  # verify that the file is not empty
  if [ -z "$FILE" ]; then
    echo "File is empty"
    exit 1
  fi
  # verify that the file exists
  if [ ! -f "$FILE" ]; then
    echo "File does not exist"
    exit 1
  fi
  # add the file to .gitignore
  echo "$FILE" >> .gitignore
}

# create a bash function to add all untracked files to git
function add_all_untracked_files_to_git() {
  # add all untracked files to git
  echo "Adding all untracked files to git"
  git add .
}

# a bash function to create a new tag
function create_new_tag() {
  # get the tag name from first argument
  TAG_NAME=$1
  # verify that the tag name is not empty
  if [ -z "$TAG_NAME" ]; then
    echo "Tag name is empty"
    exit 1
  fi

  echo ""
  echo "###################################################"
  echo "Creating new tag from: $(get_current_branch) branch"
  echo "Folder: $(pwd)"
  echo "Last commit message: $(get_last_commit_message)"
  echo "Last commit hash: $(get_last_commit_hash)"
  echo "Last commit author: $(get_last_commit_author)"

  # create/replace a tag
  git tag -f -a "$TAG_NAME" -m "$TAG_NAME"
  git push --delete origin "$TAG_NAME" 2> /dev/null
  git push origin "$TAG_NAME"

  check_last_error

  echo "###################################################"
}

# commit to master
function commit_and_push_to_master() {
  # get the commit message from first argument
  COMMIT_MESSAGE=$1
  # verify that the commit message is not empty
  if [ -z "$COMMIT_MESSAGE" ]; then
    echo "Commit message is empty"
    exit 1
  fi

  echo ""
  echo "###################################################"
  echo "Commit to master from branch $(get_current_branch)"
  echo "Folder: $(pwd)"
  echo "Last commit message: $(get_last_commit_message)"
  echo "Last commit hash: $(get_last_commit_hash)"
  echo "Last commit author: $(get_last_commit_author)"

  # add all untracked files to git
  add_all_untracked_files_to_git
  # commit all changes
  git commit -m "$COMMIT_MESSAGE"
  # push all changes to remote
  git push origin main

  check_last_error

  echo "###################################################"
}

# a function that cycle on all folders in the parent directory of the current script excluding the current folder and commit to master
function commit_to_master_all_folders() {

  # ask the commit message from the user
  echo ""
  read -p "Enter the commit message: " COMMIT_MESSAGE

  # verify that the commit message is not empty
  if [ -z "$COMMIT_MESSAGE" ]; then
    echo "Commit message is empty"
    exit 1
  fi
  # get the current folder
  CURRENT_FOLDER=$(pwd)
  # get the parent folder
  PARENT_FOLDER=$(dirname "$CURRENT_FOLDER")
  # cycle on all folders in the parent directory of the current script excluding the current folder
  for folder in "$PARENT_FOLDER"/*; do
    # verify that the folder is not the current folder
    # go to the folder
    cd "$folder"
    # commit to master
    commit_and_push_to_master "$COMMIT_MESSAGE"
  done

  cd "$CURRENT_FOLDER" || exit
}

# a function that cycle on all folders in the parent directory of the current script excluding the current folder and create a new tag
function create_new_tag_all_folders() {
  # ask the tag name from the user
  read -p "Tag name: " TAG_NAME

  # verify that the tag name is not empty
  if [ -z "$TAG_NAME" ]; then
    echo "Tag name is empty"
    exit 1
  fi
  # get the current folder
  CURRENT_FOLDER=$(pwd)
  # get the parent folder
  PARENT_FOLDER=$(dirname "$CURRENT_FOLDER")
  # cycle on all folders in the parent directory of the current script excluding the current folder
  for folder in "$PARENT_FOLDER"/*; do
    # verify that the folder is not the current folder
    if [ "$folder" != "$CURRENT_FOLDER" ]; then
      # go to the folder
      cd "$folder"
      # create a new tag
      create_new_tag "$TAG_NAME"
    fi
  done
  cd "$CURRENT_FOLDER" || exit
}

# create a menu to select the operation to perform
PS3="Select an operation: "
options=("Commit to master" "Release a tag" "Quit")
select opt in "${options[@]}"
do
  case $opt in
    "Commit to master")
      echo "Commit to master..."
      commit_to_master_all_folders
      ;;
    "Release a tag")
      echo "releasing the project..."
      create_new_tag_all_folders
      ;;
    "Quit")
      break
      ;;
    *) echo "invalid option $REPLY";;
  esac
done



