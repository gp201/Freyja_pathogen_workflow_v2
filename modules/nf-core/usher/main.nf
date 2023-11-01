container_name = "${moduleDir}".split('/')[-1]

process GENERATE_PROTOBUF_TREE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path vcf
        path tree
        val threads
    output:
        path 'tree.pb', emit: protobuf_tree_file
        path '*'

    script:
        """
        usher -t $tree -v $vcf -o tree.pb -T $threads
        """
    stub:
        """
        touch tree.pb
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: vcf=${vcf}, tree=${tree}, threads=${threads}' >> ${task.process}.txt
        usher --help
        """
}

// check if matUtils_overlap is set else check if skip_clade_assignment is true then return  0 else return 0.6
matUtils_overlap = params.matUtils_overlap != '' ? params.matUtils_overlap : (params.skip_clade_assignment ? 0.0 : 0.6)

process ANNOTATE_TREE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path protobuf_tree_file
        path clades
    output:
        path 'annotated_tree.pb', emit: annotated_tree_file
        path '*'

    script:
        """
        matUtils annotate -i $protobuf_tree_file -c $clades -o annotated_tree.pb --set-overlap $matUtils_overlap
        """
    stub:
        """
        touch annotated_tree.pb
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: protobuf_tree_file=${protobuf_tree_file}, clades=${clades}, overlap=${matUtils_overlap}' >> ${task.process}.txt
        matUtils --help
        """
}

process EXTRACT_CLADES {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path annotated_tree
    output:
        path 'lineagePaths.txt', emit: lineage_definition_file
        path 'samplePaths.txt', emit: sample_paths_file
        path '*'

    script:
        """
        matUtils extract -i $annotated_tree -C lineagePaths.txt -j auspice_tree.json -S samplePaths.txt
        """
    stub:
        """
        touch lineagePaths.txt
        touch samplePaths.txt
        touch auspice_tree.json
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: annotated_tree=${annotated_tree}'  >> ${task.process}.txt
        matUtils --help
        """
}
