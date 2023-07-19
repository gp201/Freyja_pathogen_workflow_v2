process ALIGN_MINIMAP2 {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/minimap2:2.24"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path ref_seq
        val threads
    output:
        path "aligned.fasta", emit: align_fasta

    script:
        """
        minimap2 -t $threads -a $ref_seq $fasta | gofasta sam toMultiAlign > aligned.fasta
        cat $ref_seq aligned.fasta > aligned.fasta.tmp
        mv aligned.fasta.tmp aligned.fasta
        """
    stub:
        """
        touch aligned.fasta
        echo ${task.process}
        echo 'parameters: fasta=${fasta}, ref_seq=${ref_seq}'
        minimap2 --help
        gofasta --help
        samtools --help
        """    
}
