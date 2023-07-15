process IQTREE {
    conda file("${moduleDir}/environment.yml")
    // TODO-GP: check if docker image is available for all processes
    container "staphb/iqtree2:2.2.2.6"
    publishDir "${params.outdir}/iqtree", mode: params.publish_dir_mode, overwrite: params.force_overwrite

    input:
        path fasta
        val iqtree_nucleotide_model
        val threads
    output:
        path "ml_tree.treefile", emit: tree_file
        path "ml_tree.*"

    script:
        """
        iqtree2 -s $fasta -T $threads -m $iqtree_nucleotide_model --prefix ml_tree
        """
    stub:
        """
        touch ml_tree.treefile
        touch ml_tree.log
        echo 'IQTREE'
        echo 'parameters: fasta=$fasta, threads=$threads, iqtree_nucleotide_model=$iqtree_nucleotide_model'
        iqtree2 --help
        """    
}
