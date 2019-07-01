package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics

import org.eclipse.emf.henshin.interpreter.Match

interface ConcurrencyHeuristic extends Heuristic {
	def boolean canBeConcurrent (Match match1, Match match2)	
}
