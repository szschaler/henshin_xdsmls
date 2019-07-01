package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency

import org.eclipse.emf.henshin.interpreter.Match
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.ConcurrencyHeuristic

class OverlapHeuristic implements ConcurrencyHeuristic {
	
	override boolean canBeConcurrent (Match match1, Match match2){
		match1.overlapsWith(match2)
	}	
}
