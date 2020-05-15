package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies

abstract class AbstractStrategy implements Strategy {
	val StrategyDefinition definition
	
	new(StrategyDefinition definition) {
		this.definition = definition
	}
	
	override StrategyDefinition getStrategyDefinition() { definition }
}
