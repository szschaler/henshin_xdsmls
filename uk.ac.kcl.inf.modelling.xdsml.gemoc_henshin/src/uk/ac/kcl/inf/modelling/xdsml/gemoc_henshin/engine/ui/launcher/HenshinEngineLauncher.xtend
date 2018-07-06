package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher

import java.util.HashMap
import java.util.Map
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.emf.ecore.EObject
import org.eclipse.gemoc.commons.eclipse.messagingsystem.api.MessagingSystem
import org.eclipse.gemoc.commons.eclipse.ui.ViewHelper
import org.eclipse.gemoc.executionframework.engine.commons.EngineContextException
import org.eclipse.gemoc.executionframework.engine.commons.ModelExecutionContext
import org.eclipse.gemoc.executionframework.engine.ui.commons.RunConfiguration
import org.eclipse.gemoc.executionframework.engine.ui.launcher.AbstractSequentialGemocLauncher
import org.eclipse.gemoc.executionframework.ui.views.engine.EnginesStatusView
import org.eclipse.gemoc.trace.commons.model.launchconfiguration.LaunchConfiguration
import org.eclipse.gemoc.trace.commons.model.launchconfiguration.LaunchConfigurationParameter
import org.eclipse.gemoc.trace.commons.model.launchconfiguration.LaunchconfigurationPackage
import org.eclipse.gemoc.xdsmlframework.api.core.ExecutionMode
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionEngine
import org.eclipse.gemoc.xdsmlframework.api.core.IRunConfiguration
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinExecutionEngine
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinModelExecutionContext

/**
 * Launcher code based on JavaEngine launcher
 */
class HenshinEngineLauncher extends AbstractSequentialGemocLauncher {

	static val String TYPE_ID = Activator.PLUGIN_ID + ".launcher";

	protected override IExecutionEngine createExecutionEngine(RunConfiguration runConfiguration,
		ExecutionMode executionMode) throws CoreException, EngineContextException {
		val IExecutionEngine executionEngine = new HenshinExecutionEngine

		val ModelExecutionContext executioncontext = new HenshinModelExecutionContext(runConfiguration, executionMode)
		executioncontext.executionPlatform.modelLoader.progressMonitor = launchProgressMonitor
		executioncontext.initializeResourceModel
		executionEngine.initialize(executioncontext)

		executionEngine
	}

	protected override String getLaunchConfigurationTypeID() {
		return TYPE_ID;
	}

	protected override String getDebugJobName(ILaunchConfiguration configuration, EObject firstInstruction) {
		return "GEMOC Henshin Debug Job";
	}

	protected override String getPluginID() {
		return Activator.PLUGIN_ID;
	}

	override String getModelIdentifier() {
		return Activator.DEBUG_MODEL_ID;
	}

	protected override void prepareViews() {
		ViewHelper.retrieveView(EnginesStatusView.ID);
	}

	protected override RunConfiguration parseLaunchConfiguration(
		ILaunchConfiguration configuration) throws CoreException {
		new RunConfiguration(configuration)
	}

	protected override void error(String message, Exception e) {
		Activator.error(message, e);
	}

	protected override MessagingSystem getMessagingSystem() {
		return Activator.getDefault().getMessaggingSystem();
	}

	protected override void setDefaultsLaunchConfiguration(ILaunchConfigurationWorkingCopy configuration) {}

	override Map<String, Object> parseLaunchConfiguration(LaunchConfiguration launchConfiguration) {
		val Map<String, Object> attributes = new HashMap
		for (LaunchConfigurationParameter param : launchConfiguration.getParameters()) {
			switch (param.eClass().getClassifierID()) {
				case LaunchconfigurationPackage.LANGUAGE_NAME_PARAMETER: {
					attributes.put(IRunConfiguration.LAUNCH_SELECTED_LANGUAGE, param.getValue());
				}
				case LaunchconfigurationPackage.MODEL_URI_PARAMETER: {
					attributes.put("Resource", param.getValue());
				}
				case LaunchconfigurationPackage.ANIMATOR_URI_PARAMETER: {
					attributes.put("airdResource", param.getValue());
				}
				case LaunchconfigurationPackage.ENTRY_POINT_PARAMETER: {
					attributes.put(IRunConfiguration.LAUNCH_METHOD_ENTRY_POINT, param.getValue());
				}
				case LaunchconfigurationPackage.MODEL_ROOT_PARAMETER: {
					attributes.put(IRunConfiguration.LAUNCH_MODEL_ENTRY_POINT, param.getValue());
				}
				case LaunchconfigurationPackage.INITIALIZATION_METHOD_PARAMETER: {
					attributes.put(IRunConfiguration.LAUNCH_INITIALIZATION_METHOD, param.getValue());
				}
				case LaunchconfigurationPackage.INITIALIZATION_ARGUMENTS_PARAMETER: {
					attributes.put(IRunConfiguration.LAUNCH_INITIALIZATION_ARGUMENTS, param.getValue());
				}
				case LaunchconfigurationPackage.ADDON_EXTENSION_PARAMETER: {
					attributes.put(param.getValue(), true);
				}
			}
		}

		attributes
	}
}
