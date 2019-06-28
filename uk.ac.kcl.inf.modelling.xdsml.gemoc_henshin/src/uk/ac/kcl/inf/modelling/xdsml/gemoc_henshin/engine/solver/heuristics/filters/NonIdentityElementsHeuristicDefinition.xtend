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
		
		lcc.addMetamodelChangeListener(new PropertyChangeListener {
			
			override propertyChange(PropertyChangeEvent evt) {
				control.updateMetamodels (evt.newValue as java.util.List<EPackage>)
			}
			
		})
	
		control.updateMetamodels(lcc.metamodels)

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
		
		// TODO Add a similar context parameter here and use it to extract relevant information
	}

	def updateMetamodels (List control, java.util.List<EPackage> metamodels) {
		control.items = emptyList
		
		if (metamodels !== null) {
			metamodels.flatMap[mm | mm.eAllContents.filter(EClass).toIterable].forEach[c |
				control.add(c.name)
			]			
		}
	}

}
