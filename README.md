# Freyja_pathogen_workflow

This is a workflow for the Freyja Pathogen pipeline.

## Installation

1. Install the following softwares:
    - [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) (>=23.04)
    - Package manager: [Mamba](https://mamba.readthedocs.io/en/latest/mamba-installation.html) (Recommended) or [Conda](https://docs.conda.io/en/latest/) can be used.

2. Run
```
nextflow run https://github.com/gp201/Freyja_pathogen_workflow_v2.git -r 'main' -profile <mamba|conda> -c <config_file>
```

> **Note** 
> - The `-profile` is used to specify the package manager to be used.
> - The `-c` is used to specify the config file to be used. If a config file is specified, the parameters specified will override the default parameters in the [`nextflow.config`](nextflow.config) file.

3. The pathogen barcode (barcode.csv) can be found in the `output/GENERATE_BARCODES` folder.
