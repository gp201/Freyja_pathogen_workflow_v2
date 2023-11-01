#!/bin/bash

# stop the script if any command fails
set -e
# get the current directorys parent directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"

# get the list of all the docker files even in the subdirectories
DOCKER_FILES=$(find $DIR -name "Dockerfile")

# iterate through all the docker files
for DOCKER_FILE in $DOCKER_FILES
do
    # get the directory of the docker file
    DOCKER_FILE_DIR=$(dirname $DOCKER_FILE)
    # get the name of the docker image
    DOCKER_IMAGE_NAME=$(basename $DOCKER_FILE_DIR)
    echo "Building docker image: $DOCKER_IMAGE_NAME"
    # build the docker image
    docker build -t $DOCKER_IMAGE_NAME -f $DOCKER_FILE $DOCKER_FILE_DIR
done
