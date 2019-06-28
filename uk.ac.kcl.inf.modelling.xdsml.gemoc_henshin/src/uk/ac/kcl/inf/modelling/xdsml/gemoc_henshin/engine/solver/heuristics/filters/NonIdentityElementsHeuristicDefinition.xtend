package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.filters

import java.util.ArrayList
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.List
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.Heuristic

class NonIdentityElementsHeuristicDefinition extends FilteringHeuristicDefinition {
	new() {
		super("uk.ac.kcl.inf.xdsml.heuristics.non_identity_elements", "Non Identity Elements Heuristic",
			NonIdentityElementsHeuristic)
	}

	override getUIControl(Composite parent) {
		var modelObjects = new ArrayList<String>()
		modelObjects.add("Hammer")
		modelObjects.add("Handle")

		val control = new List(parent, SWT.MULTI.bitwiseOr(SWT.V_SCROLL).bitwiseOr(SWT.BORDER))
		control.layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false)
		for (var i = 0; i < modelObjects.length; i++)
			control.add(modelObjects.get(i))

		control
	}

	override initaliseControl(Control uiElement, String configData) {
		val list = uiElement as List
		list.getSelectionIndices()
	}

	override encodeConfigInformation(Control uiElement) {
		val list = uiElement as List

		var sb = new StringBuilder();
		for (var i = 0; i < list.getSelectionIndices().length; i++) {
			sb.append(list.items.get(list.getSelectionIndices().get(i)))
			sb.append(" ")
		}
		sb.toString()
	}

	override initialise(Heuristic heuristic, String configData) {
		val h = heuristic as NonIdentityElementsHeuristic

	// how to access the list of eclasses? from the list of string?
	}

}
