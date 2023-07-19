process NEXUS_TO_NEWICK {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "python:3.11.4"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path nexus_tree
    output:
        path "timetree.newick", emit: newick_tree

    script:
        """
        nexus_to_newick.py -i $nexus_tree -o timetree.newick -r
        """
    stub:
        """
        touch timetree.newick
        echo ${task.process}
        echo 'parameters: \n nexus_tree: ${nexus_tree}'
        nexus_to_newick.py --help
        """    
}
