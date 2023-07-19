#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {BASIC_CHECKS   } from './modules/local/basic_checks'
include {NEXUS_TO_NEWICK} from './modules/local/nexus_to_newick'

include {ALIGN_MAFFT    } from './modules/nf-core/mafft'
include {ALIGN_MINIMAP2 } from './modules/nf-core/minimap2'
include {IQTREE         } from './modules/nf-core/iqtree'
include {TREETIME       } from './modules/nf-core/treetime'
include {FATOVCF        } from './modules/nf-core/fatovcf'
include {NEXSTRAIN_JSON_GENERATION} from './modules/nf-core/nextstrain_json_generation'
include {AUTOMATED_CLADE_ASSIGNMENT} from './subworkflows/nf-core/autolin_generate_clades'
include {GENERATE_PROTOBUF_TREE} from './modules/nf-core/usher'
include {ANNOTATE_TREE} from './modules/nf-core/usher'
include {EXTRACT_CLADES} from './modules/nf-core/usher'
include {GENERATE_BARCODES} from './modules/local/generate_barcodes'
include {FORMAT_CLADES_TSV} from './modules/local/clades_tsv_formatter'
include {NEXTSTRAIN_DATA_EXTRACTION} from './modules/local/nextstrain_data_extraction'

workflow {
    if (params.use_json) {
        NEXTSTRAIN_DATA_EXTRACTION(params.json_file, 1)
    }
    // BASIC_CHECKS(params.fasta, params.metadata, params.strain_column)
    if (params.align_method == "mafft") {
        ALIGN_MAFFT(params.fasta, params.ref_seq, params.threads)
        align = ALIGN_MAFFT.out
    } else if (params.align_method == "minimap2") {
        ALIGN_MINIMAP2(params.fasta, params.ref_seq, params.threads)
        align = ALIGN_MINIMAP2.out
    } else {
        println "Invalid alignment method specified. Please choose either 'mafft' or 'minimap2'."
        exit 1
    }
    IQTREE(align.align_fasta, params.iqtree_nucleotide_model, params.threads)
    TREETIME(align.align_fasta, IQTREE.out.tree_file, params.metadata, params.strain_column, params.date_column, params.threads)
    NEXUS_TO_NEWICK(TREETIME.out.tree_file)
    FATOVCF(align.align_fasta)
    if (params.clade_assignment) {
        AUTOMATED_CLADE_ASSIGNMENT(align.align_fasta, TREETIME.out.tree_file, params.metadata, params.strain_column, params.date_column)
        NEXTSTRAIN_DATA_EXTRACTION(AUTOMATED_CLADE_ASSIGNMENT.out.clade_assigments, 2)
        FORMAT_CLADES_TSV(NEXTSTRAIN_DATA_EXTRACTION.out.auspice_metadata, params.strain_column, params.lineage_column)
    } else {
        FORMAT_CLADES_TSV(params.metadata, params.strain_column, params.lineage_column)
    }
    GENERATE_PROTOBUF_TREE(FATOVCF.out.vcf, TREETIME.out.tree_file, params.threads)
    ANNOTATE_TREE(GENERATE_PROTOBUF_TREE.out.protobuf_tree_file, FORMAT_CLADES_TSV.out.formatted_clades_tsv)
    EXTRACT_CLADES(ANNOTATE_TREE.out.annotated_tree_file)
    GENERATE_BARCODES(EXTRACT_CLADES.out.lineage_definition_file)
}

workflow.onComplete {
    println "Workflow complete!"
    println "Output files are stored in $params.output_dir"
}
