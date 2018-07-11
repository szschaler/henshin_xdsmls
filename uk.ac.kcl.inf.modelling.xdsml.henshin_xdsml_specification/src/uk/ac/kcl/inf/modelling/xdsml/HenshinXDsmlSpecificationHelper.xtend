package uk.ac.kcl.inf.modelling.xdsml

import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification

class HenshinXDsmlSpecificationHelper {
	static def getMetamodel(HenshinXDsmlSpecification spec) {
		val metamodels = spec.rules.map[r | r.module.imports].flatten.toSet
		if (metamodels.size > 1) {
			throw new IllegalArgumentException("Too many metamodels")
		} else {
			metamodels.head
		}
	}
}