container_name = "${moduleDir}".split('/')[-1]

process GENERATE_BARCODES {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input: 
        path lineage_definition_file
    output:
        path 'barcode.csv'
        path 'barcode.html'
    script:
        """
        generate_barcodes.py $lineage_definition_file
        plot_barcode.py -i barcode.csv
        """
    stub:
        """
        touch barcode.csv
        touch barcode.html
        echo ${task.process}
        echo 'parameters: lineage_definition_file=${lineage_definition_file}'
        generate_barcodes.py --help
        plot_barcode.py --help
        """    
}
