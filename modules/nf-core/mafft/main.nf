process ALIGN_MAFFT {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/mafft:7.505"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path ref_seq
        val threads
    output:
        path "aligned.fasta", emit: align_fasta

    script:
        """
        mafft --auto --thread $threads --addfragments $fasta $ref_seq > aligned.fasta
        """
    stub:
        """
        touch aligned.fasta
        echo ${task.process}
        echo 'parameters: fasta=${fasta}, ref_seq=${ref_seq}'
        mafft --version
        """
}
