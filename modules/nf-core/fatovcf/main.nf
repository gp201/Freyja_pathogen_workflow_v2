container_name = "${moduleDir}".split('/')[-1]

process FATOVCF {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
    output:
        path "aligned.vcf", emit: vcf
        path '*'

    script:
        """
        faToVcf $fasta aligned.vcf
        """
    stub:
        """
        touch aligned.vcf
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: fasta=${fasta}' >> ${task.process}.txt
        faToVcf --help
        """    
}
