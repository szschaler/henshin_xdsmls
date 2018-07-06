package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label

/**
 * Slightly annoying: this is copied from the javaengine, but I couldn't simply reuse this as it's not exported from the plugin.
 */
abstract class LaunchConfigurationTab extends AbstractLaunchConfigurationTab {

	protected def Group createGroup(Composite parent, String text) {
		val Group group = new Group(parent, SWT.NULL)
		group.text = text
		val GridLayout locationLayout = new GridLayout
		locationLayout.numColumns = 3;
		locationLayout.marginHeight = 10;
		locationLayout.marginWidth = 10;
		group.layout = locationLayout
		
		group
	}
	
	protected def createTextLabelLayout(Composite parent, String labelString) {
		val GridData gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.layoutData = gd
		val Label inputLabel = new Label(parent, SWT.NONE)
		inputLabel.text = labelString
	}
	
	protected def createTextLabelLayout(Composite parent, String labelString, String toolTipText) {
		val GridData gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.layoutData = gd
		val Label inputLabel = new Label(parent, SWT.NONE)
		inputLabel.text = labelString
		inputLabel.toolTipText = toolTipText
	}

}