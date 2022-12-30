#!/usr/bin/env zsh

# this script is used to rename all the projects in the parent folder
# and update the relevant files with the new name


OLD_PROJECT_NAME="mortar"
NEW_PROJECT_NAME="bricks"
ORGANIZATION="go-bricks"
OLD_ORGANIZATION="go-masonry"

# cycle through all the folders in the parent folder from the deepest to the shallowest level
for folder in $(find .. -type d -depth -print  | sort -r)
do
  # if the folder contains the word $OLD_PROJECT_NAME then rename it to $NEW_PROJECT_NAME
  if [[ "$folder" == *"$OLD_PROJECT_NAME"* ]]; then
    echo "Renaming $folder to ${folder/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME}"
    mv "$folder" "${folder/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME}"
  fi
done

# cycle through all the go, txt, jpg files in the parent folder from the deepest to the shallowest level
for file in $(find .. -type f -name "*.go" -o -name "*.mod" -o -name "*.htm*" -o -name "*.yml" -o -name "*.yaml" -o -name "*.sum" -o -name "*.md" -o -name ".gitignore" -o -name "Makefile" -o -name "LICENSE" | sort -r)
do
  echo "Replacing $OLD_PROJECT_NAME with $NEW_PROJECT_NAME in $file"
  # if the file contains the word $OLD_PROJECT_NAME then rename it to $NEW_PROJECT_NAME
  if [[ "$file" == *"$OLD_PROJECT_NAME"* ]]; then
    echo "Renaming $file to ${file/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME}"
    mv "$file" "${file/$OLD_PROJECT_NAME/$NEW_PROJECT_NAME}"
  fi

  # replace $OLD_PROJECT_NAME with $NEW_PROJECT_NAME in the file content and save the changes to the same file (in-place) using sed using a case sensitive search

  echo "Replacing $OLD_PROJECT_NAME with $NEW_PROJECT_NAME in $file"
  echo "Replacing ${(C)OLD_PROJECT_NAME} with ${(C)NEW_PROJECT_NAME} in $file"
  echo "Replacing ${(U)OLD_PROJECT_NAME} with ${(U)NEW_PROJECT_NAME} in $file"

  sed -i '' "s/${OLD_PROJECT_NAME}/${NEW_PROJECT_NAME}/g" "$file"
  sed -i '' "s/${(C)OLD_PROJECT_NAME}/${(C)NEW_PROJECT_NAME}/g" "$file"
  sed -i '' "s/${(U)OLD_PROJECT_NAME}/${(U)NEW_PROJECT_NAME}/g" "$file"
  sed -i '' "s/$OLD_ORGANIZATION/$ORGANIZATION/g" "$file"

done