#!/bin/sh

# This script is used to clone all the projects from clone-repo-list.txt


repo=$(cat clone-repo-list.txt)
cd ..
for element in $repo
do
  echo "cloning $element"

  # clone the repo in the current folder without tags
  git clone --depth 1 --branch master --single-branch --no-tags $element
done