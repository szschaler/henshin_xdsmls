package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core;

import java.util.List;
import java.util.concurrent.Semaphore;
import org.eclipse.gemoc.commons.eclipse.ui.ViewHelper;
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.SharedIcons;
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionEngine;
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.ILogicalStepDecider;
import org.eclipse.gemoc.trace.commons.model.trace.Step;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.IMenuListener2;
import org.eclipse.jface.action.IMenuManager;
import org.eclipse.jface.viewers.DoubleClickEvent;
import org.eclipse.jface.viewers.IDoubleClickListener;
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStepsView;

@SuppressWarnings("all")
public class HenshinDecider implements ILogicalStepDecider {
  public HenshinDecider() {
    super();
  }
  
  private Step _selectedLogicalStep;
  
  private Semaphore _semaphore = null;
  
  private HenshinStepsView decisionView;
  
  private boolean _preemptionHappened = false;
  
  @Override
  public Step<?> decide(final IConcurrentExecutionEngine engine, final List<Step<?>> possibleLogicalSteps) throws InterruptedException {
    abstract class __HenshinDecider_1 implements IMenuListener2 {
      Action _action;
    }
    
    this._preemptionHappened = false;
    Semaphore _semaphore = new Semaphore(0);
    this._semaphore = _semaphore;
    this.decisionView = ViewHelper.<HenshinStepsView>retrieveView(HenshinStepsView.ID);
    this.decisionView.refresh();
    __HenshinDecider_1 menuListener = new __HenshinDecider_1() {
      {
        _action = null;
      }
      @Override
      public void menuAboutToShow(final IMenuManager manager) {
        if ((((this._action == null) && (HenshinDecider.this.decisionView.getSelectedLogicalStep() != null)) && engine.getPossibleLogicalSteps().contains(HenshinDecider.this.decisionView.getSelectedLogicalStep()))) {
          this._action = HenshinDecider.this.createAction();
        }
        if (((HenshinDecider.this.decisionView.getSelectedLogicalStep() != null) && (this._action != null))) {
          manager.add(this._action);
        }
      }
      
      @Override
      public void menuAboutToHide(final IMenuManager manager) {
        if ((this._action != null)) {
          manager.remove(this._action.getId());
        }
      }
    };
    this.decisionView.addMenuListener(menuListener);
    IDoubleClickListener doubleClickListener = new IDoubleClickListener() {
      @Override
      public void doubleClick(final DoubleClickEvent event) {
        if (((HenshinDecider.this.decisionView.getSelectedLogicalStep() != null) && engine.getPossibleLogicalSteps().contains(HenshinDecider.this.decisionView.getSelectedLogicalStep()))) {
          Action selectLogicalStepAction = new Action() {
            @Override
            public void run() {
              HenshinDecider.this._selectedLogicalStep = HenshinDecider.this.decisionView.getSelectedLogicalStep();
              HenshinDecider.this._semaphore.release();
            }
          };
          selectLogicalStepAction.run();
        }
      }
    };
    this.decisionView.addDoubleClickListener(doubleClickListener);
    this._semaphore.acquire();
    this._semaphore = null;
    this.decisionView.removeMenuListener(menuListener);
    this.decisionView.removeDoubleClickListener(doubleClickListener);
    if (this._preemptionHappened) {
      return null;
    }
    return this._selectedLogicalStep;
  }
  
  @Override
  public void preempt() {
    this._preemptionHappened = true;
    if ((this._semaphore != null)) {
      this._semaphore.release();
    }
  }
  
  @Override
  public void dispose() {
    if ((this._semaphore != null)) {
      this._semaphore.release();
    }
    this.decisionView.refresh();
  }
  
  public Action createAction() {
    Action selectLogicalStepAction = new Action() {
      @Override
      public void run() {
        HenshinDecider.this._selectedLogicalStep = HenshinDecider.this.decisionView.getSelectedLogicalStep();
        HenshinDecider.this._semaphore.release();
      }
    };
    selectLogicalStepAction.setId("org.eclipse.gemoc.executionframework.engine.io.commands.SelectLogicalStep");
    selectLogicalStepAction.setText("Select LogicalStep");
    selectLogicalStepAction.setToolTipText("Use selected LogicalStep");
    selectLogicalStepAction.setImageDescriptor(SharedIcons.LOGICALSTEP_ICON);
    return selectLogicalStepAction;
  }
}
