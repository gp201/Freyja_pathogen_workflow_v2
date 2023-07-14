#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include {BASIC_CHECKS} from './modules/basic_checks'

workflow {
    BASIC_CHECKS('wow')
}
