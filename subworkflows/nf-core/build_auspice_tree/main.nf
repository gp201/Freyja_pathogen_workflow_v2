include {AUGUR_REFINE   } from '../../../modules/nf-core/augur_build_tree'
include {AUGUR_ANCESTRAL} from '../../../modules/nf-core/augur_build_tree'
include {AUGUR_EXPORT   } from '../../../modules/nf-core/augur_build_tree'


workflow BUILD_AUSPICE_TREE {
    take:
        alignment
        tree
        reference
    main:
        AUGUR_REFINE(alignment, tree)
        AUGUR_ANCESTRAL(alignment, AUGUR_REFINE.out.augur_tree)
        AUGUR_EXPORT(AUGUR_REFINE.out.augur_tree, AUGUR_REFINE.out.node_data, AUGUR_ANCESTRAL.out.nt_mut_data)
    emit:
        auspice_json = AUGUR_EXPORT.out.auspice_json
}
