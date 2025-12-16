# Freyja_pathogen_workflow

> [!IMPORTANT]
> We’re deprecating this tool in favor of **BarcodeForge**, which we built to generate pathogen barcodes for the Freyja pipeline: [https://github.com/andersen-lab/BarcodeForge/](https://github.com/andersen-lab/BarcodeForge/)

This is a workflow for the Freyja Pathogen pipeline.

## Installation

1. Install the required software:
    - [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) (version 23.04 or later)
    - Package manager: [Mamba](https://mamba.readthedocs.io/en/latest/mamba-installation.html) (Recommended) or [Conda](https://docs.conda.io/en/latest/)

2. Run the pipeline:
```
nextflow run https://github.com/gp201/Freyja_pathogen_workflow_v2.git -r 'main' -profile <mamba|conda> -c <config_file>
```

Use the -r option to specify the branch or version of the workflow you want to use.

> **Note** 
> - The `-profile` is used to specify the package manager to be used.
> - The `-c` is used to specify the config file to be used. If a config file is specified, the parameters specified will override the default parameters in the [`nextflow.config`](nextflow.config) file.

3. Locate the pathogen barcode:
The pathogen barcode (barcode.csv) will be located in the `output/GENERATE_BARCODES` folder.
