#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {BASIC_CHECKS   } from './modules/local/basic_checks'
include {NEXUS_TO_NEWICK} from './modules/local/nexus_to_newick'
include {GENERATE_BARCODES} from './modules/local/generate_barcodes'
include {FORMAT_CLADES_TSV} from './modules/local/clades_tsv_formatter'
include {NEXTSTRAIN_DATA_EXTRACTION} from './modules/local/nextstrain_data_extraction'
include {ADD_REF_MUTS   } from './modules/local/add_ref_muts'

include {ALIGN_MAFFT    } from './modules/nf-core/mafft'
include {ALIGN_MINIMAP2 } from './modules/nf-core/minimap2'
include {IQTREE         } from './modules/nf-core/iqtree'
include {TREETIME       } from './modules/nf-core/treetime'
include {FATOVCF        } from './modules/nf-core/fatovcf'
include {GENERATE_PROTOBUF_TREE} from './modules/nf-core/usher'
include {ANNOTATE_TREE} from './modules/nf-core/usher'
include {EXTRACT_CLADES} from './modules/nf-core/usher'

include {AUTOMATED_CLADE_ASSIGNMENT} from './subworkflows/nf-core/autolin_generate_clades'

workflow {
    if (params.skip_alignment) {
        alignment = params.fasta
    } else if (params.align_method == "mafft") {
        ALIGN_MAFFT(params.fasta, params.ref_seq, params.threads)
        alignment = ALIGN_MAFFT.out.alignment
    } else if (params.align_method == "minimap2") {
        ALIGN_MINIMAP2(params.fasta, params.ref_seq, params.threads)
        alignment = ALIGN_MINIMAP2.out.alignment
    } else {
        println "No alignment method specified. Please specify either 'mafft' or 'minimap2'."
        exit 1
    }
    if (params.tree == 'None') {
        IQTREE(alignment, params.iqtree_nucleotide_model, params.threads)
        TREETIME(alignment, IQTREE.out.tree_file, params.metadata, params.strain_column, params.date_column, params.threads)
        NEXUS_TO_NEWICK(TREETIME.out.tree_file)
        tree = NEXUS_TO_NEWICK.out.newick_tree
    } else {
        tree = params.tree
    }
    FATOVCF(alignment)
    if (params.skip_clade_assignment) {
        FORMAT_CLADES_TSV(params.metadata, params.strain_column, params.lineage_column)
    } else {
        AUTOMATED_CLADE_ASSIGNMENT(alignment, tree, params.ref_seq)
        NEXTSTRAIN_DATA_EXTRACTION(AUTOMATED_CLADE_ASSIGNMENT.out.clade_assigments, 2)
        FORMAT_CLADES_TSV(NEXTSTRAIN_DATA_EXTRACTION.out.auspice_metadata, 'name', params.lineage_column)
    }
    GENERATE_PROTOBUF_TREE(FATOVCF.out.vcf, tree, params.threads)
    ANNOTATE_TREE(GENERATE_PROTOBUF_TREE.out.protobuf_tree_file, FORMAT_CLADES_TSV.out.formatted_clades_tsv)
    EXTRACT_CLADES(ANNOTATE_TREE.out.annotated_tree_file)
    ADD_REF_MUTS(params.ref_seq, EXTRACT_CLADES.out.sample_paths_file, EXTRACT_CLADES.out.lineage_definition_file, alignment)
    GENERATE_BARCODES(ADD_REF_MUTS.out.modified_lineage_paths, params.barcode_prefix)
}

workflow.onComplete {
    println "Workflow complete!"
    println "Output files are stored in $params.outdir/GENERATE_BARCODES"
}
