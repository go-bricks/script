#!/usr/bin/env zsh

ORGANIZATION="go-bricks"

# cycle through all the folders in the parent folder and delete the .git folder
for folder in ../*; do
  if [ -d "$folder" ]; then
    echo "Deleting .git folder in $folder"
    rm -rf "$folder/.git"
    # extract folder name
    folder_name=$(basename "$folder")

    gh repo delete github.com/${ORGANIZATION}/"$folder_name" --confirm 2> /dev/null
  fi
done