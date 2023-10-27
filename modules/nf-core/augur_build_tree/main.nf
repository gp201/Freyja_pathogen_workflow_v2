container_name = "${moduleDir}".split('/')[-1]

process AUGUR_REFINE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path alignment
        path tree
    output:
        path "augur.tree", emit: augur_tree
        path "node_data.json", emit: node_data
        path '*'

    script:
        """
        augur refine --alignment $alignment --tree $tree --output-node-data node_data.json --output-tree augur.tree
        """
    stub:
        """
        touch augur.tree
        touch node_data.json
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: alignment=${alignment}, tree=${tree}' >> ${task.process}.txt
        augur --help
        """
}

process AUGUR_ANCESTRAL {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path alignment
        path augur_tree
    output:
        path "node_nt_muts.json", emit: nt_mut_data
        path '*'

    script:
        """
        augur ancestral --tree $augur_tree -a $alignment --output-node-data node_nt_muts.json
        """
    stub:
        """
        touch node_nt_muts.json
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: alignment=${alignment}, augur_tree=${augur_tree}' >> ${task.process}.txt
        augur --help
        """
}

process AUGUR_EXPORT {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path augur_tree
        path node_data
        path nt_mut_data
    output:
        path "auspice.json", emit: auspice_json
        path '*'

    script:
        """
        augur export v2 --tree $augur_tree --node-data $node_data $nt_mut_data --output auspice.json
        """
    stub:
        """
        touch auspice.json
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: augur_tree=${augur_tree}, node_data=${node_data}, nt_mut_data=${nt_mut_data}' >> ${task.process}.txt
        augur --help
        """
}
