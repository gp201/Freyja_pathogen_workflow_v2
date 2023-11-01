container_name = "${moduleDir}".split('/')[-1]

process NEXUS_TO_NEWICK {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path nexus_tree
    output:
        path "timetree.newick", emit: newick_tree
        path '*'

    script:
        """
        format_tree.py -i $nexus_tree -f 'nexus' -o timetree.newick -r
        """
    stub:
        """
        touch timetree.newick
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: \n nexus_tree: ${nexus_tree}' >> ${task.process}.txt
        format_tree.py --help
        """    
}
