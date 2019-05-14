package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import org.eclipse.emf.henshin.interpreter.Match

interface ConcurrencyHeuristic {
	def boolean canBeConcurrent (Match match1, Match match2)	
}