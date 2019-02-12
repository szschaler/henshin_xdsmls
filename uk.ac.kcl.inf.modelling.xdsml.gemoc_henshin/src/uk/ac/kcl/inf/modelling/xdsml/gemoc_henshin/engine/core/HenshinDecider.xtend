package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core;

import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.ILogicalStepDecider
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionEngine
import java.util.List
import org.eclipse.gemoc.trace.commons.model.trace.Step
import java.util.concurrent.Semaphore 
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.action.IMenuManager
import org.eclipse.jface.action.IMenuListener2
import org.eclipse.jface.action.Action
import org.eclipse.gemoc.commons.eclipse.ui.ViewHelper
import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.SharedIcons

class HenshinDecider implements ILogicalStepDecider {
	
	new() {
		super();
	}

	Step _selectedLogicalStep;

	Semaphore _semaphore = null;
	
	HenshinStepsView decisionView;
	boolean _preemptionHappened = false;
	
	
	
	override decide(IConcurrentExecutionEngine engine, List<Step<?>> possibleLogicalSteps) throws InterruptedException {
		_preemptionHappened = false;
		_semaphore = new Semaphore(0);

		decisionView = ViewHelper.<HenshinStepsView>retrieveView(HenshinStepsView.ID);
		decisionView.refresh();
		
		// add action into view menu
		var menuListener = new IMenuListener2() {
		
			private Action _action = null;
						
			override menuAboutToShow(IMenuManager manager) {
				if (_action === null && decisionView.getSelectedLogicalStep() !== null
					&& engine.getPossibleLogicalSteps().contains(decisionView.getSelectedLogicalStep())) {
					_action = createAction();
				}
				if (decisionView.getSelectedLogicalStep() !== null
					&& _action !== null)
					manager.add(_action);
			}

			override menuAboutToHide(IMenuManager manager) {
				if (_action !== null)
					manager.remove(_action.getId());
			}
		};
		decisionView.addMenuListener(menuListener);
		
		// add action on double click
		var doubleClickListener = new IDoubleClickListener() 
		{
			
			override doubleClick(DoubleClickEvent event) {
				if (decisionView.getSelectedLogicalStep() !== null
					&& engine.getPossibleLogicalSteps().contains(decisionView.getSelectedLogicalStep())) {
					var selectLogicalStepAction = new Action() {
						override run() {
							_selectedLogicalStep = decisionView.getSelectedLogicalStep();
							_semaphore.release();
						}
					};
					selectLogicalStepAction.run();
				}
			}
		};
		decisionView.addDoubleClickListener(doubleClickListener);
		
		
		// wait for user selection if it applies to this engine
		_semaphore.acquire();
		_semaphore = null;
		// clean menu listener
		decisionView.removeMenuListener(menuListener);
		decisionView.removeDoubleClickListener(doubleClickListener);
		if (_preemptionHappened)
			return null;
		return _selectedLogicalStep;	
	}
	
	
	override preempt() {
		_preemptionHappened = true;
		if (_semaphore !== null)
			_semaphore.release();	}
	
	override dispose() {
		if (_semaphore !== null){
			_semaphore.release();
		}
		decisionView.refresh();	
	}
	
	def Action createAction() {
		var selectLogicalStepAction = new Action() {
			override run() 
			{
				_selectedLogicalStep = decisionView.getSelectedLogicalStep();
				_semaphore.release();
			}
		};
		selectLogicalStepAction.setId("org.eclipse.gemoc.executionframework.engine.io.commands.SelectLogicalStep");
		selectLogicalStepAction.setText("Select LogicalStep");
		selectLogicalStepAction.setToolTipText("Use selected LogicalStep");
		selectLogicalStepAction.setImageDescriptor(SharedIcons.LOGICALSTEP_ICON);
		return selectLogicalStepAction;
	}
	
}
