process ALIGN_MINIMAP2 {
    conda file("environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "python:3.11.4"
    publishDir "${params.outdir}/basic_checks", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input: 
        path fasta_file
        path metadata_file
        val column
    output:
        path "output.txt"      

    script:
        """
        basic_checks.py \\
            --fasta_file ${fasta_file} \\
            --metadata_file ${metadata_file} \\
            --column ${column}
        """
    stub:
        """
        touch output.txt
        echo "Hello World" > output.txt
        """    
}
