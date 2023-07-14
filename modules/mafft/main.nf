process ALIGN_MAFFT {
    conda file("environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/mafft:7.505"
    publishDir "${params.outdir}/align_mafft", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta from params.fasta
        path ref_seq from params.ref_seq
    output:
        path "${params.outdir}/basic_checks/aligned.fasta"     

    script:
        """
        mafft --auto --thread $params.threads --addfragments $fasta $ref_seq > aligned.fasta
        """
    stub:
        """
        touch output.txt
        echo "Hello World" > output.txt
        """    
}
