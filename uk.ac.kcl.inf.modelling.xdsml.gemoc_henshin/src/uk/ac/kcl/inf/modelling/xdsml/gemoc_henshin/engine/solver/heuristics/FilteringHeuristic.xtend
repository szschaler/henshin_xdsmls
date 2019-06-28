package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics

import java.util.List
import org.eclipse.gemoc.trace.commons.model.trace.Step

interface FilteringHeuristic extends Heuristic {
	
	def List<Step<?>> filter(List<Step<?>> steps)
	
}
