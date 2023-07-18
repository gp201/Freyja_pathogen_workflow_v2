process AUTOMATED_LINEAGE_JSON {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "snads/treetime:0.9.4"
    publishDir "${params.outdir}/automated-lineage-json", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path auspice_json
    output:
        path '*'

    script:
        """
        git clone https://github.com/jmcbroome/automated-lineage-json.git
        cd automated-lineage-json
        python3 annotate_json.py --help
        """
    stub:
        """
        touch auspice.json
        touch augur.tree
        echo 'AUTOMATED_LINEAGE_JSON'
        echo 'parameters: auspice_json=${auspice_json}'
        augur --help
        """    
}
