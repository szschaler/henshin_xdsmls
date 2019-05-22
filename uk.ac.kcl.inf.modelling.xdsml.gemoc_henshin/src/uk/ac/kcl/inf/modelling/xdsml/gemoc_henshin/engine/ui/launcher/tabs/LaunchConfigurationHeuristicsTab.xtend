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
import org.eclipse.swt.widgets.Group
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics.HeuristicsRegistry
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics.HeuristicsRegistry.HeuristicDefinition

/**
 * 
 * Tab for choosing the step heuristics.
 *
 */
class LaunchConfigurationHeuristicsTab extends LaunchConfigurationTab {
	val heuristicSelections = new HashMap<HeuristicDefinition, Boolean>
	val components = new HashMap<HeuristicDefinition, Button>

	/**
	 * get all possible heuristics and add them to the tab so the user can switch them on/off
	 */
	new() {
		HeuristicsRegistry.INSTANCE.heuristics.forEach[hd |
			heuristicSelections.put(hd, false)
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
		val groupmap = new HashMap<String, Group>()

		groupmap.put("1", createGroup(parent, "Concurrency Heuristics"))
		groupmap.put("2", createGroup(parent, "Filtering Heuristics"))

		heuristicSelections.keySet.forEach[hd |
			var parentGroup = groupmap.get("1")
			
			if(hd.heuristicID.equals("uk.ac.kcl.inf.xdsml.heuristics.num_steps")) {
				parentGroup = groupmap.get("2")
			}

			val checkbox = createCheckButton(parentGroup, hd.humanReadableLabel)
			checkbox.selection = heuristicSelections.get(hd)
			checkbox.addSelectionListener(new SelectionListener() {

				override widgetSelected(SelectionEvent e) {
					heuristicSelections.put(hd, checkbox.selection)
					updateLaunchConfigurationDialog();
				}

				override widgetDefaultSelected(SelectionEvent e) { }
			})
			components.put(hd, checkbox)
		]

		// remove empty groups
		groupmap.values.forEach[g | 
			if (g.children.length === 0) {
				g.dispose()
				parent.layout(true)
			}
		]
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(HeuristicsRegistry.HEURISTICS_CONFIG_KEY, Collections.EMPTY_LIST)
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		
		heuristicSelections.keySet.forEach[hd | heuristicSelections.put(hd, false)]
		
		val heuristics = configuration.getAttribute(HeuristicsRegistry.HEURISTICS_CONFIG_KEY, #[])
		heuristics.forEach[hid | 
			heuristicSelections.put(HeuristicsRegistry.INSTANCE.get(hid), true)
		]
		
		heuristicSelections.forEach[hd, selected|
			val checkbox = components.get(hd)
			if (checkbox !== null) {
				checkbox.selection = selected
			}
		]
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(HeuristicsRegistry.HEURISTICS_CONFIG_KEY, 
			heuristicSelections.filter[hd, selected | selected].keySet.map[it.heuristicID].toList)
	}

	override isValid(ILaunchConfiguration config) {
		errorMessage = null
		true
	}

	override getName() { "Steps Heuristics" }
}