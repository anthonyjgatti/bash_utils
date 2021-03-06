#!/usr/bin/env bash

# A helper program for generating the folder 
# structure for Python projects.
# Symlinked with py_build on my machine.


# TODO:
# Figure out how to autogenerate documentation with Sphinx.
# Figure out branching strategy of some kind.
# Create Docker support of some kind.
# Figure out travis integration.


# Check first argument.
if [[ $# -ne 1 ]];
then
    echo "Please specify a project name!"
    exit 1
fi

# Make sure current directory is good


################################################################
#### Tracking setup of virtualenv
# pip install virtualenvwrapper
# echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
# I also changed the location of $WORKON_HOME and $PROJECT_HOME
# in my ~/.bashrc.
# source ~/.bashrc
################################################################

# Create virtualenv.
mkvirtualenv $1
pip install sphinx sphinx-gallery

# Generate base directory and important files.
mkdir $1
cd $1
touch LICENSE README.md TODO.md setup.py requirements.txt
mkdir -p docs/generated

# Create git repository with .gitignore
### MAY NEED TO REVISION IF WANT TO AUTOPUSH DOC CHANGES WITH HTML.
git init
cat > .gitignore << EOM
*__pycache__*
*.pyc
*~
.DS_Store
$1/**/*.html
.cache
.tox/
*.pdf

EOM


################## This part questionable. ####################################
# Generate markdown docs directory. Because I like Markdown better,
# I write docs in markdown, then use pandoc to convert them to .rst for Sphinx.
# There are other solutions but this is my preferred.
mkdir md_docs
###############################################################################

# Generate boilerplate contents of setup.py.
cat > setup.py << EOM
import os
from setuptools import setup, find_packages

setup(
    name = '$1',
    # version = $1.__version__,
    url = '',
    license = 'MIT',
    author = 'Anthony Gatti',
    author_email = 'anthony.j.gatti@gmail.com',
    tests_require = ['pytest'],
    install_requires = [],
    description = '',
    # long_description = long_description,
    packages = find_packages(),
    # test_suite = 'test.test_$1'
)

EOM

# Create directories and set up main module.
mkdir -p $1/tests
touch ./$1/__init__.py
touch ./$1/tests/__init__.py

# Create build script to be used to build project.
cat > build.sh << EOM
#!/usr/bin/env bash

if [[ \$# -ge 1 ]];
then
    message="\$1";
else
    message="New commit at time \$(date -u)"
fi

# Convert files in md_docs to .rst, output in docs.
# find ./md_docs -iname "*.md" -type f -exec sh -c 'pandoc "\${1}" -o "./docs/\${0%.md}.rst"' {} \;

# Start virtualenv.
workon \$1
# pip freeze > requirements.txt
### DO LOOKUP HERE to replace == with >= in package versions.
# pip install -r requirements.txt

# Build the docs. Figure out versioning!
sphinx-apidoc -F -A "Anthony Gatti" -o docs $1

# Source python project.
sudo python setup.py develop
### CHANGE THIS PLEASE.

# Make the docs.
cd docs
make clean
make html
cd ..

# Commit and push.
### NEED TO ADD GIT FLOWISH STUFF HERE.
#git add -A
#git commit -m \$message


EOM

