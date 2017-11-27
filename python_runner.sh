#!/bin/bash

# Usage: pybuild atools create -f

# TODO: Add argument checking.
# TODO: Check for package dependencies: python3, git.

# Create the project.
if [ "$2" == "create" ]; then

  # TODO: Add setup.py.
  # TODO: Add Sphinx stuff.

  cd $PYTHON_PROJECT_DIR

  # Clean old environment.
  if [ "$3" == '-f' ]; then
    echo "Cleaning..."
    rm -rf ./$1
  else
    read -n 1 -p "Do you want to delete the current project? If yes enter y: " deleteq
    echo
    if [ "$deleteq" == 'y' ]; then
      echo "Cleaning (with force)..."
      rm -rf ./$1
    else
      echo "Exiting."
      exit 1
    fi
  fi

  # Create new virtual env.
  python3 -m venv $1
  cd ./$1

  # Add initial files and directories.
  # TODO: Change this we knowonce this works.
  # mkdir -p ./$1/{$1,docs,resources}
  # touch ./$1/$1/__init__.py
  cp -r $PYTHON_PROJECT_DIR/lebackup/$1/* .
  touch __status__ # Determines if files have been created.
  touch requirements.txt

  # Add README.
  echo "# $1" >> README.md

  # Add setup.cfg file.
  cat > setup.cfg <<EOF
[metadata]
name = $1
description-file = README.md
license = MIT

[files]
packages = $1

[build_sphinx]
source-dir = docs/
build-dir  = docs/_build
all_files  = 1

[upload_sphinx]
upload-dir = docs/_build/html
EOF

  # Write to .gitignore and then git init and commit.
  cat > .gitignore <<EOF
# Virtual env stuff.
bin/
include/
lib/
lib64
share/
# pyvenv.cfg ???

# vim
*.swp

# OSX
.DS_Store

# Custom
__status__
EOF

  git init
  git add -A
  git commit -a -m "Initial commit."

elif [ "$2" == "update" ]; then

  # Check if project has been adequately created.
  if [ ! -e $PYTHON_PROJECT_DIR/$1/__status__ ]; then
    echo "[ERROR] Please create package before calling 'update'."
    exit 1
  fi

  # Activate virtual environment.
  cd $PYTHON_PROJECT_DIR/$1/
  source ./bin/activate

  # Install or update local package.
  pip install $1 --upgrade

fi
