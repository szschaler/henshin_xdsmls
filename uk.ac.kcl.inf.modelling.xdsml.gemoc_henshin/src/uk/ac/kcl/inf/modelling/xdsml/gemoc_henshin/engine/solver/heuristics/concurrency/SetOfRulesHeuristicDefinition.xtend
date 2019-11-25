package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency

import java.util.List
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.Heuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.LaunchConfigurationContext

class SetOfRulesHeuristicDefinition extends ConcurrencyHeuristicDefinition {
	new() {
		super("uk.ac.kcl.inf.xdsml.heuristics.set_of_rules", "Set Of Rules Heuristic", SetOfRulesHeuristic)
	}
	
	override getUIControl(Composite parent, LaunchConfigurationContext lcc) {
		val control = new org.eclipse.swt.widgets.List(parent, SWT.MULTI.bitwiseOr(SWT.V_SCROLL).bitwiseOr(SWT.BORDER))
		control.layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false)

		lcc.addSemanticsChangeListener([ evt |
			control.updateSemantics(evt.newValue as List<Rule>)
		])

		control.updateSemantics(lcc.semantics)

		control
	}

	override encodeConfigInformation(Control uiElement) {
		val list = uiElement as org.eclipse.swt.widgets.List

		list.selectionIndices.map[i | list.items.get(i)].join("@@")
	}

	override initaliseControl(Control uiElement, String configData) {
		val list = uiElement as org.eclipse.swt.widgets.List
		if (list.items.size > 0) {	
			val namesToSelect = configData.split("@@")
	
			list.select(#[0..list.itemCount-1].flatten.filter[namesToSelect.contains(list.items.get(it))])
		}
	}

	override initialise(Heuristic heuristic, String configData, LaunchConfigurationContext lcc) {
		val h = heuristic as SetOfRulesHeuristic

		lcc.addSemanticsChangeListener([ evt |
			h.updateSemantics(evt.newValue as List<Rule>, configData)
		])
		
		h.updateSemantics(lcc.semantics, configData)
	}

	def updateSemantics(org.eclipse.swt.widgets.List control, List<Rule> semantics) {
		control.items = emptyList

		if (semantics !== null) {
			semantics.forEach [r |
				control.add(r.name)
			]
		}
	}

	def updateSemantics(SetOfRulesHeuristic sorh, List<Rule> semantics, String configData) {
		sorh.rules.clear
		
		if (semantics !== null) {
			val ruleNames = configData.split("@@").toList
			sorh.rules = semantics.filter[r | ruleNames.contains(r.name)].toList			
		}
	}
}
