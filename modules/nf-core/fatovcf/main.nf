process FATOVCF {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/mafft:7.505"
    publishDir "${params.outdir}/fatovcf", mode: params.publish_dir_mode, overwrite: params.force_overwrite

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
        echo 'FATOVCF'
        echo 'parameters: fasta=${fasta}'
        faToVcf --help
        """    
}
