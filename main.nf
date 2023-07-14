#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {BASIC_CHECKS} from './modules/basic_checks'
include {ALIGN_MAFFT} from './modules/mafft'
include {ALIGN_MINIMAP2} from './modules/minimap2'

workflow {
    BASIC_CHECKS('wow')
    (params.align_method == "mafft" ? ALIGN_MAFFT : ALIGN_MINIMAP2)
}
