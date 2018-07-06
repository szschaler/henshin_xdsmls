package uk.ac.kcl.inf.modelling.xdsml

import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification

class HenshinXDsmlSpecificationHelper {
	static def getMetamodel(HenshinXDsmlSpecification spec) {
		val metamodels = spec.units.map[u | u.module.imports].flatten
		if (metamodels.size > 1) {
			throw new IllegalArgumentException("Too many metamodels")
		} else {
			metamodels.head
		}
	}
}