package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import java.util.List
import org.eclipse.gemoc.trace.commons.model.trace.Step

interface FilteringHeuristic {
	
	def List<Step<?>> filter(List<Step<?>> steps)
	
}