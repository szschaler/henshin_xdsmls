package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import java.util.List
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentRunConfiguration
import org.eclipse.xtend.lib.annotations.Accessors
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.HeuristicDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.HeuristicsRegistry

class HenshinConcurrentRunConfiguration extends ConcurrentRunConfiguration {
	
	static val HEURISTICS_CONFIG_DATA_KEY = ".configData"
	
	new(ILaunchConfiguration launchConfiguration) throws CoreException {
		super(launchConfiguration)
	}
	
	@Accessors(PUBLIC_GETTER)
	var List<HeuristicDefinition> heuristics
		
	override extractInformation() {
		super.extractInformation
		
		// TODO Encode heuristics parameters in run configuration and extract them here so they can be stored in a copy of the heuristics description 
		heuristics = _launchConfiguration.getAttribute(HeuristicsRegistry.HEURISTICS_CONFIG_KEY, #[]).map[hdi | HeuristicsRegistry.INSTANCE.get(hdi)].toList
	}
	
	def getConfigDetailFor(HeuristicDefinition hd) {
		_launchConfiguration.getAttribute(hd.heuristicID + HEURISTICS_CONFIG_DATA_KEY, "")
	}
}