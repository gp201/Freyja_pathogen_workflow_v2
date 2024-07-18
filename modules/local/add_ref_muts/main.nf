container_name = "${moduleDir}".split('/')[-1]

process ADD_REF_MUTS {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path reference_sequence
        path sample_mutations
        path lineage_mutations
        path sample_sequences
    output:
        path "*.rerooted", emit: modified_lineage_paths
        path '*'

    script:
        """
        ref_muts.py -s ${sample_mutations} -l ${lineage_mutations} -r ${reference_sequence} -f ${sample_sequences} -o additional_mutations.tsv
        """
    stub:
        """
        touch additional_mutations.tsv
        touch lineagePaths.txt.rerooted
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: reference_sequence=${reference_sequence}, sample_mutations=${sample_mutations}, lineage_mutations=${lineage_mutations}, sample_sequences=${sample_sequences}' >> ${task.process}.txt
        ref_muts.py --help
        """    
}
