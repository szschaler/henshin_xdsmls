package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency

import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.Heuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.HeuristicDefinition

abstract class ConcurrencyHeuristicDefinition extends HeuristicDefinition {
	new(String ID, String label, Class<? extends Heuristic> clazz) {
		super(ID, label, HeuristicsGroup.CONCURRENCY_HEURISTIC, clazz)
	}
}