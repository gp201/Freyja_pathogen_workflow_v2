include {AUTOMATED_LINEAGE_JSON} from '../../../modules/nf-core/automated-lineage-json'
include {BUILD_AUSPICE_TREE} from '../build_auspice_tree'

workflow AUTOMATED_CLADE_ASSIGNMENT {
    take:
        fasta
        tree
        reference
    main:
        BUILD_AUSPICE_TREE(fasta, tree, reference)
        AUTOMATED_LINEAGE_JSON(BUILD_AUSPICE_TREE.out.auspice_json)
    emit:
        clade_assigments = AUTOMATED_LINEAGE_JSON.out.lineage_definition
}
