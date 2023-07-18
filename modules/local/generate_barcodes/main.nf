process GENERATE_BARCODES {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "python:3.11.4"
    publishDir "${params.outdir}/generate_barcodes", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input: 
        path lineage_definition_file
    output:
        path 'barcode.csv'
        path 'barcode.html'
    script:
        """
        convert_barcodes.py $clade_assignments_file
        plot_barcode.py
        """
    stub:
        """
        touch barcode.csv
        touch barcode.html
        echo 'GENERATE_BARCODES'
        echo 'parameters: lineage_definition_file=${lineage_definition_file}'
        generate_barcodes.py --help
        plot_barcode.py --help
        """    
}
