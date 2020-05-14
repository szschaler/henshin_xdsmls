package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import java.util.Collections
import java.util.HashMap
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition.StrategyGroup
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.LaunchConfigurationContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyRegistry

/**
 * 
 * Tab for choosing the step strategies.
 * 
 */
class LaunchConfigurationStrategiesTab extends LaunchConfigurationTab {
	val strategySelections = new HashMap<StrategyDefinition, Boolean>
	val components = new HashMap<StrategyDefinition, Pair<Button, Control>>
	val LaunchConfigurationContext configContext
	
	/**
	 * Get all possible strategies and add them to the tab so the user can switch them on/off
	 */
	new(LaunchConfigurationContext configContext) {
		this.configContext = configContext
		StrategyRegistry.INSTANCE.strategies.forEach [ sd |
			strategySelections.put(sd, false)
		]
	}

	override createControl(Composite parent) {
		val content = new Composite(parent, SWT.NULL)
		val gl = new GridLayout(1, false)

		gl.marginHeight = 0
		content.setLayout(gl)
		content.layout()
		setControl(content)

		createLayout(content)
	}

	private def createLayout(Composite parent) {
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
					updateLaunchConfigurationDialog();
				}

				override widgetDefaultSelected(SelectionEvent e) {}
			})

			components.put(hd, new Pair(checkbox, hd.getUIControl(parentGroup, configContext, null)))
		]

		// remove empty groups
		groupmap.values.forEach [ g |
			if (g.children.length === 0) {
				g.dispose()
				parent.layout(true)
			}
		]
	}

	static val STRATEGIES_CONFIG_DATA_KEY = ".configData"

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(StrategyRegistry.STRATEGIES_CONFIG_KEY, Collections.EMPTY_LIST)
		StrategyRegistry.INSTANCE.strategies.forEach [ hd |
			configuration.removeAttribute(hd.strategyID + STRATEGIES_CONFIG_DATA_KEY)
		]
	}

	override initializeFrom(ILaunchConfiguration configuration) {

		strategySelections.keySet.forEach[hd|strategySelections.put(hd, false)]

		val strategies = configuration.getAttribute(StrategyRegistry.STRATEGIES_CONFIG_KEY, #[])
		strategies.forEach [ sid |
			strategySelections.put(StrategyRegistry.INSTANCE.get(sid), true)
		]

		strategySelections.forEach [ extension sd, selected |
			val strategyComponents = components.get(sd)
			val checkbox = strategyComponents.key
			if (checkbox !== null) {
				checkbox.selection = selected
			}

			val hComponent = strategyComponents.value
			if (hComponent !== null) {
				hComponent.initaliseControl(configuration.getAttribute(sd.strategyID + STRATEGIES_CONFIG_DATA_KEY, ""))
			}
		]
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		val selectedStrategies = strategySelections.filter[hd, selected|selected].keySet
		configuration.setAttribute(StrategyRegistry.STRATEGIES_CONFIG_KEY,
			selectedStrategies.map[it.getStrategyID].toList)
		selectedStrategies.forEach [ extension hd |
			val strategyComponent = components.get(hd).value
			if (strategyComponent !== null) {
				configuration.setAttribute(hd.getStrategyID + STRATEGIES_CONFIG_DATA_KEY,
					strategyComponent.encodeConfigInformation())
			}
		]
	}

	override isValid(ILaunchConfiguration config) {
		errorMessage = null
		true
	}

	override getName() { "Steps Strategies" }
}
