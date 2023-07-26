container_name = "${moduleDir}".split('/')[-1]

process FORMAT_NWK_TREE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path nwk_tree
    output:
        path "timetree.newick", emit: newick_tree

    script:
        """
        format_tree.py -i $nwk_tree -f 'newick' -o timetree.newick -r
        """
    stub:
        """
        touch timetree.newick
        echo ${task.process}
        echo 'parameters: \n nexus_tree: ${nexus_tree}'
        format_tree.py --help
        """    
}
