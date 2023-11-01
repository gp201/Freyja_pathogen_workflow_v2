container_name = "${moduleDir}".split('/')[-1]

process FORMAT_CLADES_TSV {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path metadata_file
        val strain_column
        val lineage_column
    output:
        path "formatted_clades.tsv", emit: formatted_clades_tsv
        path '*'

    script:
        """
        clades_tsv_formatter.py -m ${metadata_file} -s "${strain_column}" -l "${lineage_column}" -o formatted_clades.tsv
        """
    stub:
        """
        touch formatted_clades.tsv
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: metadata_file=${metadata_file}, strain_column=${strain_column}, lineage_column=${lineage_column}' >> ${task.process}.txt
        clades_tsv_formatter.py --help
        """    
}
