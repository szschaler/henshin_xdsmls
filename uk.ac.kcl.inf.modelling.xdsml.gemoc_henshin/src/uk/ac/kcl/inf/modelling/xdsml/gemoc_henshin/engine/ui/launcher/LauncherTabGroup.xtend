package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs.LaunchConfigurationMainTab
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs.LaunchConfigurationBackendsTab
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs.LaunchConfigurationHeuristicsTab
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.LaunchConfigurationContext
import java.beans.PropertyChangeListener
import org.eclipse.emf.henshin.model.Rule

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
			new LaunchConfigurationHeuristicsTab(new LaunchConfigurationContext {
				
				override getMetamodels() {
					val mms = mainTab.metamodels
					
					if (mms !== null) mms.unmodifiableView else null
				}
				
				override addMetamodelChangeListener(PropertyChangeListener pcl) {
					mainTab.addMetamodelListener(pcl)
				}
				
				override getSemantics() {
					val semantics = mainTab.semantics
					
					if (semantics !== null) semantics.units.filter(Rule).toList else emptyList
				}
				
				override addSemanticsChangeListener(PropertyChangeListener pcl) {
					mainTab.addSemanticsListener(pcl)
				}
				
			}),
			new CommonTab
		]
	}

}
