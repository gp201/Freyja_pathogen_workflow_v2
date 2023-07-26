This folder contains the scripts used by the subworkflow `nextstrain_data_extraction_workflow`. The scripts are symlinked to the `bin` folder of the project root directory. This was done in order to allow the subworkflow to be run independetly using the following command:
```
nextflow -c nextflow.config run subworkflows/local/nextstrain_data_extraction/main.nf --json_tree /nextstrain.json -profile mamba
```
