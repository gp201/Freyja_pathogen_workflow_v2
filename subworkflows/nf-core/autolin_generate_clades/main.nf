include {AUTOMATED_LINEAGE_JSON} from '../../../modules/nf-core/automated-lineage-json'
include {NEXSTRAIN_JSON_GENERATION} from '../../../modules/nf-core/nextstrain_json_generation'

workflow AUTOMATED_CLADE_ASSIGNMENT {
    take:
        fasta
        tree
        metadata_file
        strain_column
        date_column
    main:
        NEXSTRAIN_JSON_GENERATION(fasta, tree, metadata_file, strain_column, date_column)
        AUTOMATED_LINEAGE_JSON(NEXSTRAIN_JSON_GENERATION.out.nextstrain_json)
    emit:
        clade_assigments = AUTOMATED_LINEAGE_JSON.out.lineage_definition
}