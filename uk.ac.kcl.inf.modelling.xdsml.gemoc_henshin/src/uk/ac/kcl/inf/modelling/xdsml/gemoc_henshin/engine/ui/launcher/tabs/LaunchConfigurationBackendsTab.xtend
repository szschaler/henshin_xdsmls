package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import java.util.Collection
import java.util.HashMap
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon.EngineAddonSpecificationExtension
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon.EngineAddonSpecificationExtensionPoint
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon_group.EngineAddonGroupSpecificationExtension
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon_group.EngineAddonGroupSpecificationExtensionPoint

// Copied from original GEMOC code to work around package export issue
/**
 * 
 * Tab for backend configuration. Needed so that tracing (and, thus, debugging) works
 * 
 */
class LaunchConfigurationBackendsTab extends LaunchConfigurationDataProcessingTab {

	override String getName() { "Engine Addons" }

	protected override Collection<EngineAddonSpecificationExtension> getExtensionSpecifications() {
		EngineAddonSpecificationExtensionPoint.specifications.toList
	}

	protected override Collection<EngineAddonGroupSpecificationExtension> getGroupExtensionSpecifications() {
		val HashMap<String, EngineAddonGroupSpecificationExtension> result = new HashMap<String, EngineAddonGroupSpecificationExtension>();
		// ensures to get only one group for a given id
		EngineAddonGroupSpecificationExtensionPoint.specifications.forEach [ engineAddonGroupSpecificationExtension |
			result.put(engineAddonGroupSpecificationExtension.getId(), engineAddonGroupSpecificationExtension)
		]

		result.values();
	}

}
