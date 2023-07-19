#!/bin/bash

# pull docker ubuntu:22.04 image and run the below commands in the container

# if docker is installed run the below commands in the container else run the below commands in the host

if ! [ -x "$(command -v docker)" ]; then
    echo "Deleting files in host"
    # Delete the work folder and all its contents
    rm -rf work

    # Delete the nextflow log files
    rm -f .nextflow.log*

    # Delete the nextflow cache
    rm -rf .nextflow

    # Delete the output files
    rm -r output
else
    echo "Deleting files in docker container"
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"
    echo $DIR

    docker run --rm -v $DIR:/home/ ubuntu:22.04 rm -rf /home/work

    docker run --rm -v $DIR:/home/ ubuntu:22.04 rm -f .nextflow.log*

    docker run --rm -v $DIR:/home/ ubuntu:22.04 rm -rf /home/.nextflow*

    docker run --rm -v $DIR:/home/ ubuntu:22.04 rm -rf /home/output
fi

