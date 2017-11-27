#!/bin/bash

# Argument checking.

if [ "$2" == "create" ]; then

  cd $PYTHON_PROJECT_DIR
  python3 -m venv $1

  # TODO: Change this.
  # mkdir -p ./$1/{$1,resources}
  # touch ./$1/$1/__init__.py
  # touch __status__
  cp -r $PYTHON_PROJECT_DIR/lebackup/$1 ./$1

  # Write to .gitignore and then git init and commit.
  cat > .gitignore <<EOF
#

EOF


  ls -l ./$1




fi
