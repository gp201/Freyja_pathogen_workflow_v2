container_name = "${moduleDir}".split('/')[-1]

process BASIC_CHECKS {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input: 
        path fasta_file
        path metadata_file
        val strain_column

    script:
        """
        basic_checks.py \\
            --fasta_file ${fasta_file} \\
            --metadata_file ${metadata_file} \\
            --column "${strain_column}"
        """
    stub:
        """
        echo ${task.process}
        echo 'parameters: \n fasta_file=${fasta_file} \n metadata_file=${metadata_file} \n column=${column}'
        basic_checks.py --help
        """    
}
