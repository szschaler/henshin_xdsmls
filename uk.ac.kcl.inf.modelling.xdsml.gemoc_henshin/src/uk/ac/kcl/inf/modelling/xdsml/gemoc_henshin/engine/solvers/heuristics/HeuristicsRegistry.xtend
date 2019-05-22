package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics

import java.util.HashMap
import org.eclipse.xtend.lib.annotations.AccessorType
import org.eclipse.xtend.lib.annotations.Accessors

import static extension org.eclipse.xtend.lib.annotations.AccessorType.*

/**
 * Registry of heuristics descriptions. Eventually to be filled from an extension point.
 * 
 */
class HeuristicsRegistry {

	public static val INSTANCE = new HeuristicsRegistry
	
	public static val HEURISTICS_CONFIG_KEY = "uk.ac.kcl.inf.xdsml.heuristics"

	static class HeuristicDefinition {
		@Accessors(AccessorType.PUBLIC_GETTER)
		val String heuristicID
		@Accessors(AccessorType.PUBLIC_GETTER)
		val String humanReadableLabel
		
		val Class<? extends Heuristic> clazz

		new(String ID, String label, Class<? extends Heuristic> clazz) {
			heuristicID = ID
			humanReadableLabel = label
			this.clazz = clazz
		}
		
		def instantiate() {
			clazz.newInstance
		}
	}

	private new() {
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.overlap", "Overlap Heuristic", OverlapHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.full_overlap", "Fully Overlap Heuristic", FullyOverlapHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.set_of_rules", "Set Of Rules Heuristic", SetOfRulesHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.num_steps", "Max Number of Steps Heuristic", MaxNumberOfStepsHeuristic))
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
