#!/bin/bash

# Check first argument.
if [[ $# -ne 1 ]];
then
    echo "Please specify a project name!"
    exit 1
fi


# Make sure current directory is good

mkdir $1
cd $1
touch LICENSE README.md TODO.md setup.py requirements.txt
mkdir $1
cd $1
touch __init__.py
mkdir test

# Create git repository with .gitignore
cd ..
git init
touch .gitignore
echo "*__pycache__*" >> .gitignore


