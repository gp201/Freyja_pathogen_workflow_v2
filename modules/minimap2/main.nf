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
        minimap2 -t $params.threads -a $ref_seq $fasta | gofasta sam toMultiAlign > aligned.fasta
        cat $ref_seq aligned.fasta > aligned.fasta.tmp
        mv aligned.fasta.tmp aligned.fasta
        """
    stub:
        """
        touch output.txt
        echo "Hello World" > output.txt
        """    
}
