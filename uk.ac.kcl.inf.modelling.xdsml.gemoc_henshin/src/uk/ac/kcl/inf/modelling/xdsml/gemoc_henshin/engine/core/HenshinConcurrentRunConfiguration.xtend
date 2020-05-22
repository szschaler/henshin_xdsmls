package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.ConcurrentRunConfiguration
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition

class HenshinConcurrentRunConfiguration extends ConcurrentRunConfiguration {
	
	public static val STRATEGIES_CONFIG_DATA_KEY = ".configData"
	
	new(ILaunchConfiguration launchConfiguration) throws CoreException {
		super(launchConfiguration)
	}
	
//	@Accessors(PUBLIC_GETTER)
//	var List<StrategyDefinition> strategies
		
	override extractInformation() {
		super.extractInformation
		
//		// TODO Encode strategy parameters in run configuration and extract them here so they can be stored in a copy of the strategy description
//		// I'm fairly sure this (above) is done already 
//		strategies = _launchConfiguration.getAttribute(StrategyRegistry.STRATEGIES_CONFIG_KEY, #[]).map[hdi | StrategyRegistry.INSTANCE.get(hdi)].toList
	}
	
	def getConfigDetailFor(StrategyDefinition hd) {
		_launchConfiguration.getAttribute(hd.getStrategyID + HenshinConcurrentRunConfiguration.STRATEGIES_CONFIG_DATA_KEY, "")
	}
}