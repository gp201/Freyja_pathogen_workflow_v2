container_name = "${moduleDir}".split('/')[-1]

process NEXTSTRAIN_DATA_EXTRACTION {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path json_tree
        val prefix
    output:
        path "${prefix}_auspice_metadata.tsv", emit: auspice_metadata
        path "${prefix}_auspice_tree.nwk", emit: auspice_tree

    script:
        """
        auspice_tree_to_table.py \
            --tree $json_tree \
            --output-metadata ${prefix}_auspice_metadata.tsv \
            --output-tree ${prefix}_auspice_tree.nwk
        """
    stub:
        """
        touch ${prefix}_auspice_metadata.tsv
        touch ${prefix}_auspice_tree.nwk
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: json_tree=${json_tree}' >> ${task.process}.txt
        auspice_tree_to_table.py --help
        """    
}
