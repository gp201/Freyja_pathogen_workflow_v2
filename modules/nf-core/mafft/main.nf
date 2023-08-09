container_name = "${moduleDir}".split('/')[-1]

process ALIGN_MAFFT {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path ref_seq
        val threads
    output:
        path "aligned.fasta", emit: align_fasta
        path '*'

    script:
        """
        mafft --auto --thread $threads --addfragments $fasta $ref_seq > aligned.fasta
        """
    stub:
        """
        touch aligned.fasta
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: fasta=${fasta}, ref_seq=${ref_seq}' >> ${task.process}.txt
        mafft --version
        """
}
