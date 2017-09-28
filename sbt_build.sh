#!/bin/bash

# This script generates a folder structure necessary
# for sbt to build scala projects appropriately.

# Add check requiring first argument.
if [[ $# -ne 1 ]];
then
    echo "Please pass a target directory name."
    exit 1
fi

mkdir $1
cd ./$1
mkdir -p src/{main,test}/{java,resources,scala}
mkdir lib project target


# Create initial build.sbt file.
echo "name := \"$1\" 
version := \"1.0\"
scalaVersion := \"2.12.3\"" > build.sbt
