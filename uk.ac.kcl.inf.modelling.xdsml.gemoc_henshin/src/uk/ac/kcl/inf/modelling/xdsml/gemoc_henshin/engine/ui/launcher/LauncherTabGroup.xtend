package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.gemoc.executionframework.engine.ui.concurrency.launcher.LaunchConfigurationStrategiesTab
import org.eclipse.gemoc.executionframework.engine.ui.launcher.tabs.DefaultLaunchConfigurationDataProcessingTab
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs.LaunchConfigurationMainTab

/**
 * 
 * Launcher tab definitions
 * 
 */
class LauncherTabGroup extends AbstractLaunchConfigurationTabGroup {

	override createTabs(ILaunchConfigurationDialog dialog, String mode) {
		val mainTab = new LaunchConfigurationMainTab
		tabs = #[
			mainTab,
			new DefaultLaunchConfigurationDataProcessingTab,
			new LaunchConfigurationStrategiesTab(mainTab),
			new CommonTab
		]
	}

}
