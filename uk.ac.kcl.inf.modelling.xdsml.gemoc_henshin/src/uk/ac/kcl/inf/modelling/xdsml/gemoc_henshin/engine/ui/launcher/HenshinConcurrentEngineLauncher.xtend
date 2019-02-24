/*******************************************************************************
 * Copyright (c) 2017 INRIA and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     INRIA - initial API and implementation
 *     I3S Laboratory - API update and bug fix
 *******************************************************************************/
package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import java.util.Collection;
import java.util.List;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.ILaunchGroup;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.gemoc.commons.eclipse.messagingsystem.api.MessagingSystem;
import org.eclipse.gemoc.commons.eclipse.ui.ViewHelper;
import org.eclipse.gemoc.dsl.debug.ide.adapter.IDSLCurrentInstructionListener;
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentModelExecutionContext;
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentRunConfiguration;
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.views.step.LogicalStepsView;
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.views.stimulimanager.StimuliManagerView;
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext;
import org.eclipse.gemoc.executionframework.engine.core.RunConfiguration;
import org.eclipse.gemoc.executionframework.engine.ui.launcher.AbstractGemocLauncher;
import org.eclipse.gemoc.executionframework.extensions.sirius.services.AbstractGemocAnimatorServices;
import org.eclipse.gemoc.executionframework.extensions.sirius.services.AbstractGemocDebuggerServices;
import org.eclipse.gemoc.executionframework.ui.views.engine.EnginesStatusView;
import org.eclipse.gemoc.xdsmlframework.api.core.EngineStatus.RunStatus;
import org.eclipse.gemoc.xdsmlframework.api.core.ExecutionMode;
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionEngine;
import org.eclipse.gemoc.xdsmlframework.api.engine_addon.IEngineAddon;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.StructuredSelection;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.PlatformUI;
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentExecutionEngine
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentModelExecutionContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.HenshinSolver
import org.eclipse.gemoc.executionframework.extensions.sirius.services.AbstractGemocAnimatorServices.GemocModelAnimator

class HenshinConcurrentEngineLauncher extends AbstractGemocLauncher<IConcurrentExecutionContext> {

	public final static String TYPE_ID = Activator.PLUGIN_ID + ".launcher";

	var HenshinConcurrentExecutionEngine _executionEngine;
	
	override launch(ILaunchConfiguration configuration, String mode, ILaunch launch,
			IProgressMonitor monitor) throws CoreException {
		try {
			debug("About to initialize and run the GEMOC Henshin Execution Engine...");

			// make sure to have the engine view when starting the engine
			PlatformUI.getWorkbench().getDisplay().syncExec(new Runnable() {
				override run() {
					ViewHelper.retrieveView(StimuliManagerView.ID);
					ViewHelper.retrieveView(EnginesStatusView.ID);
					ViewHelper.showView(LogicalStepsView.ID);
				}
			});
			debug("aaaa22222222About to initialize and run the GEMOC Henshin Execution Engine...");
			debug("CHECKCHECK22222222About to initialize and run the GEMOC Henshin Execution Engine...");

			// We parse the run configuration
			var ConcurrentRunConfiguration runConfiguration = new ConcurrentRunConfiguration(configuration);
			debug("3333333About to initialize and run the GEMOC Henshin Execution Engine...");
			debug("aaaa3333333About to initialize and run the GEMOC Henshin Execution Engine...");

			// We detect if we are running in debug mode or not
			var ExecutionMode executionMode = null;
			if (ILaunchManager.DEBUG_MODE.equals(mode)) {
				executionMode = ExecutionMode.Animation;
			} else {
				executionMode = ExecutionMode.Run;
			}
			debug("444444444About to initialize and run the GEMOC Henshin Execution Engine..."); 

			// We stop the launch if an engine is already running for this model
			if (isEngineAlreadyRunning(runConfiguration.getExecutedModelURI())) {
				return;
			}
			
			debug("5555555About to initialize and run the GEMOC Henshin Execution Engine...");
			var HenshinConcurrentModelExecutionContext concurrentexecutionContext = new HenshinConcurrentModelExecutionContext(
					runConfiguration, executionMode);
				debug("CHECKCHECK22222222About to initialize and run the GEMOC Henshin Execution Engine...");
					 
				concurrentexecutionContext.initializeResourceModel();
//				concurrentexecutionContext.initializeResourceModel();
					
			
			debug("66666About to initialize and run the GEMOC Henshin Execution Engine...");
	
			debug("77777About to initialize and run the GEMOC Henshin Execution Engine...");
			
//			var HenshinSolver _solver
//			try {
//				_solver = concurrentexecutionContext.getLanguageDefinitionExtension().instanciateSolver() as HenshinSolver;
//				//_solver.initialize(concurrentexecutionContext);
//			} catch (CoreException e) {
//				throw new CoreException(new Status(Status.ERROR, Activator.PLUGIN_ID,
//						"Cannot instanciate solver from language definition", e));
//			}

			_executionEngine = new HenshinConcurrentExecutionEngine(concurrentexecutionContext);

			openViewsRecommandedByAddons(runConfiguration);

			// And we start it within a dedicated job
			val Job job = new Job(getDebugJobName(configuration, getFirstInstruction(configuration))) {
				override protected IStatus run(IProgressMonitor monitor) {
					// If we are debugging, we add the animator and we start
					// the execution using the super class
					// AbstractDSLLaunchConfigurationDelegateUI
					// This will start yet another job and eventually start
					// the engine
					if (ILaunchManager.DEBUG_MODE.equals(mode)) {
						val IEngineAddon animator = AbstractGemocAnimatorServices.getAnimator();
						var plat = _executionEngine.getExecutionContext().getExecutionPlatform()
						for (addon : plat.engineAddons) {
							plat.removeEngineAddon(addon)
						}
						//_executionEngine.getExecutionContext().getExecutionPlatform().addEngineAddon(animator);
						
						(AbstractGemocAnimatorServices.getAnimator() as GemocModelAnimator).addRepresentationToRefresh("Production Line Diagram")
						plat.addEngineAddon(animator);
						try {
							HenshinConcurrentEngineLauncher.super.launch(configuration, mode, launch, monitor);
							return new Status(IStatus.OK, getPluginID(), "Execution was launched successfully");
						} catch (CoreException e) {
							e.printStackTrace();
							return new Status(IStatus.ERROR, getPluginID(), "Could not start debugger.");
						}
					}

					// If we are not debugging, we simply start the engine
					// from the current job
					else {
						_executionEngine.start();
						debug("Execution finished.");
						return new Status(IStatus.OK, getPluginID(), "Execution was launched successfully");
					}
				}
			};
			debug("Initialization done, starting engine...");
			job.schedule();

		} catch (Exception e) {
			val String message = "Error occured when starting execution engine: " + e.getMessage()
					+ " (see inner exception).";
			// error(message);
			Activator.error(message, e);
			throw new CoreException(new Status(Status.ERROR, Activator.PLUGIN_ID, message, e));
		}
	}

	def boolean isEngineAlreadyRunning(URI launchedModelURI) throws CoreException {
		// make sure there is no other running engine on this model
		var Collection<IExecutionEngine<?>> engines = org.eclipse.gemoc.executionframework.engine.Activator
				.getDefault().gemocRunningEngineRegistry.getRunningEngines().values();
		for (IExecutionEngine<?> engine : engines) {
			var IExecutionEngine<?> observable = engine as IExecutionEngine<?>
			if (observable.getRunningStatus() != RunStatus.Stopped
					&& observable.getExecutionContext().getResourceModel().getURI().equals(launchedModelURI)) {
				var String message = "An engine is already running on this model, please stop it first";
				warn(message);
				return true;
			}
		}
		return false;
	}

	def protected void debug(String message) {
		getMessagingSystem().debug(message, getPluginID());
	}

	def protected void info(String message) {
		getMessagingSystem().info(message, getPluginID());
	}

	def protected void warn(String message) {
		getMessagingSystem().warn(message, getPluginID());
		PlatformUI.getWorkbench().getDisplay().asyncExec(new Runnable() {
			override void run() {
				MessageDialog.openWarning(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(),
						"GEMOC Engine Launcher", message);
			}
		});
	}

	def void error(String message) {
		getMessagingSystem().error(message, getPluginID());
		PlatformUI.getWorkbench().getDisplay().asyncExec(new Runnable() {
			override void run() {
				MessageDialog.openError(PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(),
						"GEMOC Engine Launcher", message);
			}
		});
	}

	def getMessagingSystem() {
		return Activator.getDefault().getMessaggingSystem();
	}

	override String getLaunchConfigurationTypeID() {
		return TYPE_ID;
	}

	override EObject getFirstInstruction(ISelection selection) {
		return EcorePackage.eINSTANCE;
	}

	override EObject getFirstInstruction(IEditorPart editor) {
		return EcorePackage.eINSTANCE;
	}

	override EObject getFirstInstruction(ILaunchConfiguration configuration) {
		return EcorePackage.eINSTANCE;
	}


	override String getDebugTargetName(ILaunchConfiguration configuration, EObject firstInstruction) {
		return "Gemoc debug target";
	}

	override List<IDSLCurrentInstructionListener> getCurrentInstructionListeners() {
		var List<IDSLCurrentInstructionListener> result = super.getCurrentInstructionListeners();
		result.add(AbstractGemocDebuggerServices.LISTENER);
		return result;
	}

	override String getDebugJobName(ILaunchConfiguration configuration, EObject firstInstruction) {
		return "Gemoc Henshin Concurrent debug job";
	}

	override String getPluginID() {
		return Activator.PLUGIN_ID;
	}

	override createLaunchConfiguration(IResource file, EObject firstInstruction, String mode)
			throws CoreException {
		debug("CREATE LAUNCH CONFIG");
		val ILaunchConfiguration[] launchConfigs = super.createLaunchConfiguration(file, firstInstruction, mode);

		if (launchConfigs.length == 1) {
			// open configuration for further editing
			if (launchConfigs.get(0) instanceof ILaunchConfigurationWorkingCopy) {
				var ILaunchConfigurationWorkingCopy configuration = launchConfigs.get(0) as ILaunchConfigurationWorkingCopy

				var String selectedLanguage = configuration.getAttribute(RunConfiguration.LAUNCH_SELECTED_LANGUAGE, "");
				if (selectedLanguage.equals("")) {

					// TODO try to infer possible language and other attribute
					// from project content and environment
					configuration.setAttribute(ConcurrentRunConfiguration.LAUNCH_SELECTED_DECIDER,
							ConcurrentRunConfiguration.DECIDER_ASKUSER_STEP_BY_STEP);
					val ILaunchGroup group = DebugUITools.getLaunchGroup(configuration, mode);
					if (group !== null) {
						var ILaunchConfiguration savedLaunchConfig = configuration.doSave();
						// open configuration for user validation and inputs
						DebugUITools.openLaunchConfigurationDialogOnGroup(
								PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell(),
								new StructuredSelection(savedLaunchConfig), group.getIdentifier(), null);
						// DebugUITools.openLaunchConfigurationDialog(PlatformUI.getWorkbench()
						// .getActiveWorkbenchWindow().getShell(),
						// savedLaunchConfig, group.getIdentifier(), null);
					}
				}
			}
		}
		return launchConfigs;

	}

	override IExecutionEngine getExecutionEngine() {
		return _executionEngine;
	}
	
	override getModelIdentifier() {
		if (_executionEngine instanceof HenshinConcurrentExecutionEngine){
			return Activator.PLUGIN_ID + ".debugModel";
		}else{
			return MODEL_ID;
		}
	}

}
