package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies

import org.eclipse.emf.henshin.interpreter.Match

interface ConcurrencyStrategy extends Strategy {
	def boolean canBeConcurrent (Match match1, Match match2)	
}
