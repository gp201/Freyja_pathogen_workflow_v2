#!/bin/bash

# chmod +x bin/*
nextflow -C nextflow.config run main.nf -profile docker
