container_name = "${moduleDir}".split('/')[-1]

process GENERATE_BARCODES {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input: 
        path lineage_definition_file
        val prefix
    output:
        path '*'

    script:
        """
        generate_barcodes.py --input $lineage_definition_file --prefix "$prefix" --output barcode.csv
        plot_barcode.py --input barcode.csv
        """
    stub:
        """
        touch barcode.csv
        touch barcode.html
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: lineage_definition_file=${lineage_definition_file}' >> ${task.process}.txt
        generate_barcodes.py --help
        plot_barcode.py --help
        """    
}
