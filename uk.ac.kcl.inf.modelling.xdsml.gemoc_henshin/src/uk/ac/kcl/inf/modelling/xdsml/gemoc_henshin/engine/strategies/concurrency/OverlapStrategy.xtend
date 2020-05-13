package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

import org.eclipse.emf.henshin.interpreter.Match
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.ConcurrencyStrategy

class OverlapStrategy implements ConcurrencyStrategy {
	
	// TODO: Should only check static parts
	override boolean canBeConcurrent (Match match1, Match match2){
		match1.overlapsWith(match2)
	}	
}
