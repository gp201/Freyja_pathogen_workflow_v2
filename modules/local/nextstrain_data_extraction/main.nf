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
        path "auspice_metadata.tsv", emit: auspice_metadata
        path "auspice_tree.nwk", emit: auspice_tree

    script:
        """
        python3 auspice_tree_to_table.py \
            --tree $json_tree \
            --output-metadata ${prefix}_auspice_metadata.tsv \
            --output-tree ${prefix}auspice_tree.nwk
        """
    stub:
        """
        touch auspice_metadata.tsv
        touch auspice_tree.nwk
        echo ${task.process}
        echo 'parameters: json_tree=${json_tree}'
        auspice_tree_to_table.py --help
        """    
}
