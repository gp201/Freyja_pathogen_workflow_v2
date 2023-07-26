nextflow.enable.dsl=2

include {NEXTSTRAIN_DATA_EXTRACTION } from '../../../modules/local/nextstrain_data_extraction'
include {FORMAT_NWK_TREE            } from '../../../modules/local/format_nwk_tree'

workflow NEXTSTRAIN_DATA_EXTRACTION_WORKFLOW {
    take:
        json_tree
        prefix
    main:
        NEXTSTRAIN_DATA_EXTRACTION(json_tree, prefix)
        FORMAT_NWK_TREE(NEXTSTRAIN_DATA_EXTRACTION.out.auspice_tree)
    emit:
        metadata = NEXTSTRAIN_DATA_EXTRACTION.out.auspice_metadata
        tree = FORMAT_NWK_TREE.out.newick_tree
}

// Implicit workflow
workflow  {
  NEXTSTRAIN_DATA_EXTRACTION_WORKFLOW(params.json_tree, 'subworkflow')
}
