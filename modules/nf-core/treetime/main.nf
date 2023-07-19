container_name = "${moduleDir}".split('/')[-1]

process TREETIME {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        path tree
        path metadata_file
        val strain_column
        val date_column
        val clock_filter
    output:
        path "clock_results/timetree.nexus", emit: tree_file
        path 'clock_results/*'

    script:
        """
        treetime --aln $aligned_fasta --tree $tree --dates $metadata_file --name-column $strain_column --date-column $date_column --clock-filter $clock_filter --outdir clock_results
        """
    stub:
        """
        mkdir clock_results
        cd clock_results
        touch timetree.nexus
        touch timetree.log
        echo ${task.process}
        echo 'parameters: fasta=${fasta}, tree=${tree}, metadata_file=${metadata_file}, strain_column=${strain_column}, date_column=${date_column}, clock_filter=${clock_filter}'
        treetime --help
        """    
}
