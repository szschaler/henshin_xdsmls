package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationAdvancedTab
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationMainTab
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationBackendsTab

class LauncherTabGroup extends AbstractLaunchConfigurationTabGroup {

	override createTabs(ILaunchConfigurationDialog dialog, String mode) {
		tabs = #[
			new LaunchConfigurationMainTab,
			new LaunchConfigurationBackendsTab,
			new CommonTab,
			new LaunchConfigurationAdvancedTab
		]
	}

}
