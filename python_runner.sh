#!/bin/bash

# Usage: pybuild atools create -f

# Argument checking goes here.

# Create the project.
if [ "$2" == "create" ]; then

  cd $PYTHON_PROJECT_DIR

  # TODO: Change this once we know this works.
  if [ -d "./$1" ]; then
    cp -r ./$1 $PYTHON_PROJECT_DIR/backup2
  fi

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

  # TODO: Change this.
  # mkdir -p ./$1/{$1,resources}
  # touch ./$1/$1/__init__.py
  # touch __status__
  cp -r $PYTHON_PROJECT_DIR/lebackup/$1/* ./$1

  # Write to .gitignore and then git init and commit.
  cd ./$1
  cat > .gitignore <<EOF
# Virtual env stuff.
bin/
include/
lib/
share/
# pyvenv.cfg ???

# vim
*.swp

# OSX
.DS_Store
EOF

  git init
  git add -A
  git commit -a -m "Initial commit."

fi
