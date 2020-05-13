package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.Strategy
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition

abstract class ConcurrencyStrategyDefinition extends StrategyDefinition {
	new(String ID, String label, Class<? extends Strategy> clazz) {
		super(ID, label, StrategyGroup.CONCURRENCY_STRATEGY, clazz)
	}
}