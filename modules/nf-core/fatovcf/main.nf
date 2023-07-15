process FATOVCF {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/mafft:7.505"
    publishDir "${params.outdir}/align_mafft", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
    output:
        path "aligned.vcf", emit: vcf

    script:
        """
        faToVcf $fasta aligned.vcf
        """
    stub:
        """
        touch aligned.vcf
        echo 'ALIGN_MAFFT'
        echo 'parameters: fasta=${fasta}'
        faToVcf --help
        """    
}
