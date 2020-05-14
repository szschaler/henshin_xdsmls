package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

import java.util.List
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.LaunchConfigurationContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.Strategy
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.events.SelectionEvent
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyControlUpdateListener

class SetOfRulesStrategyDefinition extends ConcurrencyStrategyDefinition {
	new() {
		super("uk.ac.kcl.inf.xdsml.strategies.set_of_rules", "Set Of Rules Strategy", SetOfRulesStrategy)
	}

	override getUIControl(Composite parent, LaunchConfigurationContext lcc, StrategyControlUpdateListener scul) {
		val control = new org.eclipse.swt.widgets.List(parent, SWT.MULTI.bitwiseOr(SWT.V_SCROLL).bitwiseOr(SWT.BORDER))
		control.layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false)

		lcc.addSemanticsChangeListener([ evt |
			control.updateSemantics(evt.newValue as List<Rule>)
		])

		control.updateSemantics(lcc.semantics)

		if (scul !== null) {
			control.addSelectionListener(new SelectionListener() {

				override widgetDefaultSelected(SelectionEvent e) {}

				override widgetSelected(SelectionEvent e) {
					scul.controlUpdated(SetOfRulesStrategyDefinition.this)
				}
			})
		}

		control
	}

	override encodeConfigInformation(Control uiElement) {
		val list = uiElement as org.eclipse.swt.widgets.List

		list.selectionIndices.map[i|list.items.get(i)].join("@@")
	}

	override initaliseControl(Control uiElement, String configData) {
		val list = uiElement as org.eclipse.swt.widgets.List
		if (list.items.size > 0) {
			val namesToSelect = configData.split("@@")

			list.select(#[0 .. list.itemCount - 1].flatten.filter[namesToSelect.contains(list.items.get(it))])
		}
	}

	override void initaliseControl(Control uiElement, Strategy strategy) {
		val list = uiElement as org.eclipse.swt.widgets.List
		list.setSelection(#[] as int[])

		if (strategy instanceof SetOfRulesStrategy) {
			list.selection = strategy.rules.map[name]
		}
	}

	override initialise(Strategy strategy, String configData, LaunchConfigurationContext lcc) {
		val h = strategy as SetOfRulesStrategy

		lcc.addSemanticsChangeListener([ evt |
			h.updateSemantics(evt.newValue as List<Rule>, configData)
		])

		h.updateSemantics(lcc.semantics, configData)
	}

	def updateSemantics(org.eclipse.swt.widgets.List control, List<Rule> semantics) {
		control.items = emptyList

		if (semantics !== null) {
			semantics.forEach [ r |
				control.add(r.name)
			]
		}
	}

	def updateSemantics(SetOfRulesStrategy sorh, List<Rule> semantics, String configData) {
		sorh.rules.clear

		if (semantics !== null) {
			val ruleNames = configData.split("@@").toList
			sorh.rules = semantics.filter[r|ruleNames.contains(r.name)].toList
		}
	}
}
