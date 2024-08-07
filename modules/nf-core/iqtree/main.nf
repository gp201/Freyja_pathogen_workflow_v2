container_name = "${moduleDir}".split('/')[-1]

process IQTREE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "${container_name}"
    publishDir "${params.outdir}/${task.process}", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        val iqtree_nucleotide_model
        val threads
    output:
        path "ml_tree.treefile", emit: tree_file
        path '*'

    script:
        """
        iqtree2 -s $fasta -T AUTO -m $iqtree_nucleotide_model --prefix ml_tree
        """
    stub:
        """
        touch ml_tree.treefile
        touch ml_tree.log
        echo ${task.process} >> ${task.process}.txt
        echo 'parameters: fasta=$fasta, threads=$threads, iqtree_nucleotide_model=$iqtree_nucleotide_model' >> ${task.process}.txt
        iqtree2 --help
        """    
}
