#!/bin/bash

# Argument checking and general validation.
usage="ERROR: Usage - pybuild project_name {create,run,destroy}"

if [ $# -ne 2 ]; then
    echo $usage && exit 1
fi 
case $2 in
    create|run|destroy) echo "Arguments validated...";;
    *) echo $usage && exit 1;;
esac

if [[ -z "${PYTHON_PROJECT_DIR}" ]]; then
    echo "ERROR: Python project directory not specified." && exit 1
elif [ ! -d "$PYTHON_PROJECT_DIR" ]; then
    echo "ERROR: Specified Python project directory does not exist." && exit 1
else
    cd $PYTHON_PROJECT_DIR
fi

# Build project structure.
if [ "$2" == "create" ]; then

  # Install dependencies. Assumes Debian-based machine.
  # Add support for other managers as needed.
  for package in git python3-venv; do
    dpkg -l $package &> /dev/null
    if [ $? -ne 0 ]; then
      echo "Need to install dependency $package..."
      sudo apt-get install $package
    fi
  done

  # Clean old version.
  echo "Cleaning..."
  rm -rf $1

  # Make new virtual env.
  echo "Building..."
  python3 -m venv $1
  cd $1

  # Load top level files.
  echo $1 >> README.rst # NEED TO FIGURE OUT RST
  touch requirements.txt

  # Add info to .gitignore.
  cat > .gitignore <<EOF
# Byte-compiled / optimized / DLL files
__pycache__
*.py[cod]
*$py.class

# Virtual env stuff
bin/
include/
lib/
lib64/
lib64
pyvenv.cfg
share/

# vim
*.swp

#OSX
.DS_Store

# Custom
__status__
EOF

  # Make main module level directory along with resources.
  mkdir -p ./{$1,resources,docs} && touch ./$1/__init__.py

  # Activate virtual env and add status check file.
  source ./bin/activate
  touch __status__

  # Need to add something to version command below? Where it says xyz.version?

  # Dynamically generate setup.py given input arguments.
  cat > setup.py <<EOF
# -*- coding: utf-8 -*-

from setuptools import setup, find_packages
from setuptools.command.test import test as TestCommand

import imp
import logging
import os
import pip
import sys
import setuptools

logger = logging.getLogger(__name__)
#version = imp.load_source(
#  'xyz.version', os.path.join('xyz', 'version.py').version
#)
version = '1.0'

class Tox(TestCommand):

    user_options = [('tox-args=', None, "Arguments to pass to tox")]

    def initialize_options(self):
        TestCommand.initialize_options(self)
        self.tox_args = ''

    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        import tox
        errno = tox.cmdline(args = self.tox_args.split())
        sys.exit(errno)


def do_setup(input_reqs):
    setup(
        name = 'xyz',
        description = 'Make some cool packages!',
        license = 'MIT',
        packages = find_packages(exclude = ['tests*']),
        author = 'Anthony Gatti',
        author_email = 'anthony.j.gatti@gmail.com',
        install_requires = input_reqs,
        cmdclass = {
          'test': Tox,
        }
    )

if __name__ == '__main__':
    with open('requirements.txt', 'r') as f:
        reqs = [str(line).strip('\n') for line in f.readlines()]
    do_setup(reqs)
EOF

  # Set up git repository.
  git init
  git add -A
  git commit -m "Initial commit."

# Update package with pip.
elif [ "$2" == "install" ]; then

  cd $1

  # Check that build has been using __status__ file.
  if [ ! -e ./__status__ ]; then
    echo "ERROR: Build the project before installing it."
    exit 1
  fi

  # Load files into directory.

  source ./bin/activate
  pip freeze > requirements.txt
  pip install . --upgrade -r requirements.txt



else

  # SPECIFIC TO THIS EXAMPLE.
  cp /home/anthony/code/python/lebackup/dockercompose.py ./$1
  cp /home/anthony/code/python/lebackup/docker-compose.jinja ./resources/


fi
