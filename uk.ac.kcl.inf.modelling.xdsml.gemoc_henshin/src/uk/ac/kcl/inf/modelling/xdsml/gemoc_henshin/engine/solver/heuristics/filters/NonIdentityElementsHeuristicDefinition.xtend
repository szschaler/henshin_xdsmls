package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.filters

import java.beans.PropertyChangeEvent
import java.beans.PropertyChangeListener
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.List
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.Heuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.LaunchConfigurationContext

class NonIdentityElementsHeuristicDefinition extends FilteringHeuristicDefinition {
	new() {
		super("uk.ac.kcl.inf.xdsml.heuristics.non_identity_elements", "Non Identity Elements Heuristic",
			NonIdentityElementsHeuristic)
	}

	override getUIControl(Composite parent, LaunchConfigurationContext lcc) {
		val control = new List(parent, SWT.MULTI.bitwiseOr(SWT.V_SCROLL).bitwiseOr(SWT.BORDER))
		control.layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false)

		lcc.addMetamodelChangeListener([ evt |
			control.updateMetamodels(evt.newValue as java.util.List<EPackage>)
		])

		control.updateMetamodels(lcc.metamodels)

		control
	}

	override initaliseControl(Control uiElement, String configData) {
		val list = uiElement as List
		list.getSelectionIndices()
	}

	override encodeConfigInformation(Control uiElement) {
		val list = uiElement as List

		list.selectionIndices.map[i | list.items.get(i)].join("@@")
	}

	override initialise(Heuristic heuristic, String configData, LaunchConfigurationContext lcc) {
		val h = heuristic as NonIdentityElementsHeuristic

		lcc.addMetamodelChangeListener([ evt |
			h.updateMetamodels(evt.newValue as java.util.List<EPackage>, configData)
		])
		
		h.updateMetamodels(lcc.metamodels as java.util.List<EPackage>, configData)
	}

	def updateMetamodels(List control, java.util.List<EPackage> metamodels) {
		control.items = emptyList

		if (metamodels !== null) {
			metamodels.flatMap[mm|mm.eAllContents.filter(EClass).toIterable].forEach [ c |
				control.add(c.name)
			]
		}
	}

	def updateMetamodels(NonIdentityElementsHeuristic nieh, java.util.List<EPackage> metamodels, String configData) {
		nieh.nonIdentityTypes.clear
		
		if (metamodels !== null) {
			val classNames = configData.split("@@").toList
			nieh.nonIdentityTypes = metamodels.flatMap[ep | ep.eAllContents.filter(EClass).filter[ec | classNames.contains(ec.name)].toIterable].toList
		}
	}
}
