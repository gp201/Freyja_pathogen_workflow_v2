#!/bin/bash

# Delete the work folder and all its contents
rm -rf work

# Delete the nextflow log files
rm -f .nextflow.log*

# Delete the nextflow cache
rm -rf .nextflow

# Delete the report and timeline files
# rm -f report.html* timeline.html* trace.txt*

# Delete the output files
rm -r output
