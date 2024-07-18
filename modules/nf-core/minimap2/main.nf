container_name = "${moduleDir}".split('/')[-1]

process ALIGN_MINIMAP2 {
    conda file("${moduleDir}/environment.yml")
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path ref_seq
        val threads
    output:
        path "aligned.fasta", emit: alignment
        path '*'

    script:
        """
        minimap2 -t $threads -a $ref_seq $fasta | gofasta sam toMultiAlign > aligned.fasta
        cat $ref_seq aligned.fasta > aligned.fasta.tmp
        mv aligned.fasta.tmp aligned.fasta
        """
    stub:
        """
        touch aligned.fasta
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: fasta=${fasta}, ref_seq=${ref_seq}' >> ${task.process}.txt
        minimap2 --help
        gofasta --help
        samtools --help
        """    
}
