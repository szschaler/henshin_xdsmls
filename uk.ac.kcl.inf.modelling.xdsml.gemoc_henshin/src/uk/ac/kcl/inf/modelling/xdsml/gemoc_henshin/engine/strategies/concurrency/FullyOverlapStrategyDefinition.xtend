package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

class FullyOverlapStrategyDefinition extends ConcurrencyStrategyDefinition {
	new() {
		super("uk.ac.kcl.inf.xdsml.heuristics.full_overlap", "Fully Overlap Heuristic", FullyOverlapStrategy)
	}
}
