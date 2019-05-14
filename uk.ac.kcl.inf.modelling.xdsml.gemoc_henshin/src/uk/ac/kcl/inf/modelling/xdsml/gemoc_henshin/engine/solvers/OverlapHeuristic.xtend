package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import org.eclipse.emf.henshin.interpreter.Match

class OverlapHeuristic implements ConcurrencyHeuristic {
	
	override boolean canBeConcurrent (Match match1, Match match2){
		match1.overlapsWith(match2)
	}	
}