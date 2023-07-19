process NEXSTRAIN_JSON_GENERATION {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "snads/treetime:0.9.4"
    publishDir "${params.outdir}/nextstrain_json_generation", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path tree
        path metadata_file
        val strain_column
        val date_column
    output:
        path "auspice.json", emit: nextstrain_json
        path '*'

    script:
        """
        augur refine --alignment $fasta --tree $tree --metadata $metadata_file --output-node-data node_data.json --output-tree augur.tree
        augur ancestral --tree augur.tree -a $fasta --output-node-data node_data_mut.json
        augur export v2 --tree augur.tree --node-data node_data.json node_data_mut.json --output auspice.json --skip-validation
        """
    stub:
        """
        touch auspice.json
        touch augur.tree
        echo 'NEXSTRAIN_JSON_GENERATION'
        echo 'parameters: fasta=${fasta}, tree=${tree}, metadata_file=${metadata_file}, strain_column=${strain_column}, date_column=${date_column}'
        augur --help
        """    
}