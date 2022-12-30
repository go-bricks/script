#!/usr/bin/env bash

ORGANIZATION="go-bricks"

# cycle through all the folders in the parent folder and init a new git repo if not already initialized
for folder in ../*; do
  echo "Entering in $folder"
  if [ -d "$folder" ]; then
    if [ ! -d "$folder/.git" ]; then
      echo "Init new git repo in $folder"
      cd "$folder"
      # check last error code
      if [ $? -ne 0 ]; then
        echo "Failed to enter in $folder"
        exit 1
      fi

      git init -b main
      git add .
      git commit -m "Initial commit"

      #git remote add origin https://github.com/${ORGANIZATION}/"$folder_name".git

    else
      echo "Git repo already initialized in $folder"
    fi
    # extract folder name
    folder_name=$(basename "$folder")

    gh repo create github.com/${ORGANIZATION}/"$folder_name" --source=. --public 2> /dev/null
  else
    echo "Skipping $folder"
  fi
done