# Freyja Pathogen Workflow

This is a workflow for the Freyja Pathogen pipeline.

## Installation
1. Install the following software:
    - [Conda](https://docs.conda.io/en/latest/miniconda.html)
    - Install outside conda environment:
        - [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html)
    - Install inside conda environment:
        - [PhyCLIP](https://github.com/alvinxhan/PhyCLIP)
        > **Warning**
            > The [PhyCLIP](https://github.com/alvinxhan/PhyCLIP) package requires Gurobi to be installed. You will require a license **(Cannot be used in a docker container)** to use Gurobi. If you do not have a license, you can use the free [Gurobi Academic License](https://www.gurobi.com/academia/academic-program-and-licenses/).
2. Clone this repository.
    - `git clone https://github.com/gp201/Freyja_pathogen_workflow.git`
3. Enter the cloned repository.
    - `cd Freyja_pathogen_workflow`
4. Run `bash run_nf.sh` to run the pipeline.
    - Modify the [nextflow.config](/configs/nextflow.config) file to change the parameters of the pipeline.
    > **Warning**
    > Edit conda env location for `phyclip` in the `nextflow.config` file.

## Modify parameters
You can do the either of the following to modify the parameters of the pipeline:
1. Edit the [nextflow.config](/configs/nextflow.config) file.
2. Run the pipeline with the parameters you want to change.
    - Example: `bash run_nf.sh [[params]]`
    - Example: `bash run_nf.sh --fasta_file /path/to/fasta/file`

## Tips
- If "*aligned*" is present in the fasta file name then the workflow will not align the fasta file.
