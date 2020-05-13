package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies

import java.util.HashMap
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency.FullyOverlapStrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency.OverlapStrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency.SetOfRulesStrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.filters.MaxNumberOfStepsStrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.filters.NonIdentityElementsStrategyDefinition

/**
 * Registry of heuristics descriptions. Eventually to be filled from an extension point.
 * 
 */
class StrategyRegistry {

	public static val INSTANCE = new StrategyRegistry

	public static val HEURISTICS_CONFIG_KEY = "uk.ac.kcl.inf.xdsml.heuristics"
	
	private new() {
		add(new OverlapStrategyDefinition)
		add(new FullyOverlapStrategyDefinition)
		add(new SetOfRulesStrategyDefinition)
		add(new NonIdentityElementsStrategyDefinition)
		add(new MaxNumberOfStepsStrategyDefinition)
	}

	val registry = new HashMap<String, StrategyDefinition>()

	def add(StrategyDefinition heuristic) {
		registry.put(heuristic.heuristicID, heuristic)
	}

	def getHeuristics() {
		registry.values
	}

	def get(String ID) {
		registry.get(ID)
	}
}
