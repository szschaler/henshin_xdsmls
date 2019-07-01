package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.filters

import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.Heuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.HeuristicDefinition

abstract class FilteringHeuristicDefinition extends HeuristicDefinition {
	new(String ID, String label, Class<? extends Heuristic> clazz) {
		super(ID, label, HeuristicsGroup.FILTERING_HEURISTIC, clazz)
	}
}