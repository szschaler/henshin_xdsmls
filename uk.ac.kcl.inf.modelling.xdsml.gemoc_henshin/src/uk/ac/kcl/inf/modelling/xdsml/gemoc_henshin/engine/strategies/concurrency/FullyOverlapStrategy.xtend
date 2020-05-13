package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

import org.eclipse.emf.henshin.interpreter.Match
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.ConcurrencyStrategy

class FullyOverlapStrategy implements ConcurrencyStrategy {
	
	override boolean canBeConcurrent (Match match1, Match match2){
		val nodeTargets1 = match1.getNodeTargets();
		val nodeTargets2 = match2.getNodeTargets();
		
		nodeTargets1.equals(nodeTargets2)
	}	
}
