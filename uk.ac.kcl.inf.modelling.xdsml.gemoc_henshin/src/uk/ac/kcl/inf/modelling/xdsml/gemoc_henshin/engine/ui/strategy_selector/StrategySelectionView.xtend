package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.strategy_selector

import org.eclipse.gemoc.executionframework.ui.views.engine.EngineSelectionDependentViewPart
import org.eclipse.swt.widgets.Composite
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionEngine
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.SWT

class StrategySelectionView extends EngineSelectionDependentViewPart {
	
	public static val ID = "org.eclipse.gemoc.executionframework.engine.io.views.StrategySelectionView"
	
	override createPartControl(Composite parent) {
		val gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.setLayoutData(gd)
		val inputLabel = new Label(parent, SWT.NONE)
		inputLabel.setText("Test")
		
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override setFocus() {
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override engineSelectionChanged(IExecutionEngine<?> engine) {
//		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}