package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies

import java.util.List
import org.eclipse.gemoc.trace.commons.model.trace.Step

interface FilteringStrategy extends Strategy {
	
	def List<Step<?>> filter(List<Step<?>> steps)
	
}
