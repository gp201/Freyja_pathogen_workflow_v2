container_name = "${moduleDir}".split('/')[-1]

process AUTOMATED_LINEAGE_JSON {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path auspice_json
    output:
        path 'auspice_lineages.json', emit: lineage_definition

    script:
        """
        // if workflow.profile is docker, then the git clone is not necessary
        if [ ${workflow.profile} != 'docker' ]; then
            git clone https://github.com/jmcbroome/automated-lineage-json.git
            cd automated-lineage-json
        fi
        python3 annotate_json.py --help
        """
    stub:
        """
        touch auspice_lineages.json
        echo ${task.process}
        echo 'parameters: auspice_json=${auspice_json}'
        git clone https://github.com/jmcbroome/automated-lineage-json.git
        cd automated-lineage-json
        python3 annotate_json.py --help
        """    
}
