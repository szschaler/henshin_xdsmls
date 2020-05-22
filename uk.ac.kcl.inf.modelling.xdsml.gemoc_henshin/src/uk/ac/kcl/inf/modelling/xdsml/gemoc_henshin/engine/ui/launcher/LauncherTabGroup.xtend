package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import java.beans.PropertyChangeListener
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationBackendsTab
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationMainTab
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.launcher.tabs.LaunchConfigurationStrategiesTab
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.strategies.LaunchConfigurationContext

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
			new LaunchConfigurationBackendsTab,
			new LaunchConfigurationStrategiesTab(new LaunchConfigurationContext {
				
				override getMetamodels() {
					val mms = mainTab.metamodels
					
					if (mms !== null) mms.unmodifiableView else null
				}
				
				override addMetamodelChangeListener(PropertyChangeListener pcl) {
					mainTab.addMetamodelListener(pcl)
				}
				
				override getSemantics() {
					val semantics = mainTab.semantics
					
					if (semantics !== null) semantics else emptySet
				}
				
				override addSemanticsChangeListener(PropertyChangeListener pcl) {
					mainTab.addSemanticsListener(pcl)
				}
				
			}),
			new CommonTab
		]
	}

}
