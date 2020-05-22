package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.AbstractConcurrentLauncher
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.strategy_selector.StrategySelectionView
import org.eclipse.gemoc.executionframework.engine.commons.EngineContextException
import org.eclipse.gemoc.xdsmlframework.api.core.ExecutionMode
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentExecutionContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentExecutionEngine
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentRunConfiguration

class HenshinConcurrentEngineLauncher extends AbstractConcurrentLauncher<HenshinConcurrentRunConfiguration, HenshinConcurrentExecutionContext> {

	override protected createEngine(HenshinConcurrentRunConfiguration runConfiguration,
		ExecutionMode executionMode) throws EngineContextException, CoreException {
		val concurrentexecutionContext = new HenshinConcurrentExecutionContext(runConfiguration, executionMode)

		concurrentexecutionContext.initializeResourceModel();

		new HenshinConcurrentExecutionEngine(concurrentexecutionContext)
	}

	override protected createRunConfiguration(ILaunchConfiguration launchConfiguration) throws CoreException {
		new HenshinConcurrentRunConfiguration(launchConfiguration)
	}

	override protected getAdditionalViewsIDs() {
		// TODO: This should really be moved up
		#{StrategySelectionView.ID}
	}
}
