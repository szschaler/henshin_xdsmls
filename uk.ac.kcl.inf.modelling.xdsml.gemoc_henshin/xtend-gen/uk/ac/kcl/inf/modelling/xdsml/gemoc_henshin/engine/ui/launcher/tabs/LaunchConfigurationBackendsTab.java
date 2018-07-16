package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs;

import java.util.Collection;
import java.util.HashMap;
import java.util.function.Consumer;
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon.EngineAddonSpecificationExtension;
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon.EngineAddonSpecificationExtensionPoint;
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon_group.EngineAddonGroupSpecificationExtension;
import org.eclipse.gemoc.xdsmlframework.api.extensions.engine_addon_group.EngineAddonGroupSpecificationExtensionPoint;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs.LaunchConfigurationDataProcessingTab;

@SuppressWarnings("all")
public class LaunchConfigurationBackendsTab extends LaunchConfigurationDataProcessingTab {
  @Override
  public String getName() {
    return "Engine Addons";
  }
  
  @Override
  protected Collection<EngineAddonSpecificationExtension> getExtensionSpecifications() {
    return IterableExtensions.<EngineAddonSpecificationExtension>toList(EngineAddonSpecificationExtensionPoint.getSpecifications());
  }
  
  @Override
  protected Collection<EngineAddonGroupSpecificationExtension> getGroupExtensionSpecifications() {
    Collection<EngineAddonGroupSpecificationExtension> _xblockexpression = null;
    {
      final HashMap<String, EngineAddonGroupSpecificationExtension> result = new HashMap<String, EngineAddonGroupSpecificationExtension>();
      final Consumer<EngineAddonGroupSpecificationExtension> _function = (EngineAddonGroupSpecificationExtension engineAddonGroupSpecificationExtension) -> {
        result.put(engineAddonGroupSpecificationExtension.getId(), engineAddonGroupSpecificationExtension);
      };
      EngineAddonGroupSpecificationExtensionPoint.getSpecifications().forEach(_function);
      _xblockexpression = result.values();
    }
    return _xblockexpression;
  }
}
