package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics

import java.util.HashMap
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency.FullyOverlapHeuristicDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency.OverlapHeuristicDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency.SetOfRulesHeuristicDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.filters.MaxNumberOfStepsHeuristicDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.filters.NonIdentityElementsHeuristicDefinition

/**
 * Registry of heuristics descriptions. Eventually to be filled from an extension point.
 * 
 */
class HeuristicsRegistry {

	public static val INSTANCE = new HeuristicsRegistry

	public static val HEURISTICS_CONFIG_KEY = "uk.ac.kcl.inf.xdsml.heuristics"
	
	private new() {
		add(new OverlapHeuristicDefinition)
		add(new FullyOverlapHeuristicDefinition)
		add(new SetOfRulesHeuristicDefinition)
		add(new NonIdentityElementsHeuristicDefinition)
		add(new MaxNumberOfStepsHeuristicDefinition)
	}

	val registry = new HashMap<String, HeuristicDefinition>()

	def add(HeuristicDefinition heuristic) {
		registry.put(heuristic.heuristicID, heuristic)
	}

	def getHeuristics() {
		registry.values
	}

	def get(String ID) {
		registry.get(ID)
	}
}
