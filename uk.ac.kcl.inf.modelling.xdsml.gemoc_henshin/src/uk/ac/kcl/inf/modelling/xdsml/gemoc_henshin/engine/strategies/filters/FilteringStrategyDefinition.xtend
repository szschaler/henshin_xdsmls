package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.filters

import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.Strategy
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition

abstract class FilteringStrategyDefinition extends StrategyDefinition {
	new(String ID, String label, Class<? extends Strategy> clazz) {
		super(ID, label, StrategyGroup.FILTERING_STRATEGY, clazz)
	}
}