package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.strategy_selector

import java.util.HashMap
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.gemoc.executionframework.ui.views.engine.EngineSelectionDependentViewPart
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionEngine
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition.StrategyGroup
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyRegistry
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Label

class StrategySelectionView extends EngineSelectionDependentViewPart {
	
	public static val ID = "org.eclipse.gemoc.executionframework.engine.io.views.StrategySelectionView"

	val strategySelections = new HashMap<StrategyDefinition, Boolean>	

	new() {
		StrategyRegistry.INSTANCE.strategies.forEach [ sd |
			strategySelections.put(sd, false)
		]
	}

	// TODO: This needs refactoring: currently copied across from LaunchConfigTab	
	override createPartControl(Composite parent) {
		val content = new Composite(parent, SWT.NULL)
		val gl = new GridLayout(1, false)

		gl.marginHeight = 0
		content.setLayout(gl)
		content.layout()

		createLayout(content)
	}
	
	// TODO: This needs refactoring: currently copied across from LaunchConfigTab	
	private def createLayout(Composite parent) {
		createTextLabelLayout(parent, "Update strategy selection below. This will take effect from the next step.")
		
		val groupmap = new HashMap<StrategyGroup, Group>()
		
		groupmap.put(StrategyGroup.CONCURRENCY_STRATEGY, createGroup(parent, "Concurrency Strategies"))
		groupmap.put(StrategyGroup.FILTERING_STRATEGY, createGroup(parent, "Filtering Strategies"))

		strategySelections.keySet.forEach [ hd |

			var parentGroup = groupmap.get(hd.group)

			val checkbox = createCheckButton(parentGroup, hd.humanReadableLabel)
			checkbox.selection = strategySelections.get(hd)
			checkbox.addSelectionListener(new SelectionListener() {

				override widgetSelected(SelectionEvent e) {
					strategySelections.put(hd, checkbox.selection)
//					updateLaunchConfigurationDialog();
				}

				override widgetDefaultSelected(SelectionEvent e) {}
			})

//			components.put(hd, new Pair(checkbox, hd.getUIControl(parentGroup, configContext)))
		]

		// remove empty groups
		groupmap.values.forEach [ g |
			if (g.children.length === 0) {
				g.dispose()
				parent.layout(true)
			}
		]
	}
	
	protected def createTextLabelLayout(Composite parent, String labelString) {
		val gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.setLayoutData(gd)
		val label = new Label(parent, SWT.NONE)
		label.setText(labelString)
	}
	
	protected def Group createGroup(Composite parent, String text) {
		val group = new Group(parent, SWT.NULL)
		group.setText(text)
		
		val locationLayout = new GridLayout()
		locationLayout.numColumns = 5
		locationLayout.marginHeight = 10
		locationLayout.marginWidth = 10
		group.setLayout(locationLayout)
		
		group
	}
	
	protected def Button createCheckButton(Composite parent, String label) {
		SWTFactory.createCheckButton(parent, label, null, false, 1)
	}

	override setFocus() {
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override engineSelectionChanged(IExecutionEngine<?> engine) {
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}