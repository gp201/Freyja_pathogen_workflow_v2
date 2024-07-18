#!/bin/bash

# stop the script if any command fails
# set -e

# get the root directory of the project
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"

# get the list of all the docker files even in the subdirectories
DOCKER_FILES=$(find $DIR -name "Dockerfile")

# delete all docker images that were created
for DOCKER_FILE in $DOCKER_FILES
do
	# get the directory of the docker file
	DOCKER_FILE_DIR=$(dirname $DOCKER_FILE)
	# get the name of the docker file
	DOCKER_FILE_NAME=$(basename $DOCKER_FILE)
	# get the name of the docker image
	DOCKER_IMAGE_NAME=$(basename $DOCKER_FILE_DIR)
	echo "Deleting docker image: $DOCKER_IMAGE_NAME"
	# delete the docker image
	docker rmi $DOCKER_IMAGE_NAME
done
