#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {BASIC_CHECKS   } from './modules/local/basic_checks'
include {ALIGN_MAFFT    } from './modules/nf-core/mafft'
include {ALIGN_MINIMAP2 } from './modules/nf-core/minimap2'
include {IQTREE         } from './modules/nf-core/iqtree'
include {TREETIME       } from './modules/nf-core/treetime'

workflow {
    BASIC_CHECKS(params.fasta, params.metadata, params.strain_column)
    if (params.align_method == "mafft") {
        ALIGN_MAFFT(params.fasta, params.ref_seq, params.threads)
        align = ALIGN_MAFFT.out
    } else if (params.align_method == "minimap2") {
        ALIGN_MINIMAP2(params.fasta, params.ref_seq, params.threads)
        align = ALIGN_MINIMAP2.out
    }
    IQTREE(align.align_fasta, params.iqtree_nucleotide_model, params.threads)
    TREETIME(align.align_fasta, IQTREE.out.tree_file, params.metadata, params.strain_column, params.date_column, params.threads)
}
