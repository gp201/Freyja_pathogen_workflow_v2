process FORMAT_CLADES_TSV {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "python:3.11.4"
    publishDir "${params.outdir}/basic_checks", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path metadata_file
        val strain_column
        val lineage_column
    output:
        path "formatted_clades.tsv", emit: formatted_clades_tsv

    script:
        """
        clades_tsv_formatter.py -m ${metadata_file} -s ${strain_column} -l ${lineage_column} -o formatted_clades.tsv
        """
    stub:
        """
        touch formatted_clades.tsv
        echo 'FORMAT_CLADES_TSV'
        echo 'parameters: metadata_file=${metadata_file}, strain_column=${strain_column}, lineage_column=${lineage_column}'
        clades_tsv_formatter.py --help
        """    
}