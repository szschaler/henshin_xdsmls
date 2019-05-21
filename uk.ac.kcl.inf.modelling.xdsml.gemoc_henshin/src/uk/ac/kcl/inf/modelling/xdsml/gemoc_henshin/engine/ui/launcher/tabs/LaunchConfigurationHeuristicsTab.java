package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.xtend.lib.annotations.AccessorType;
import org.eclipse.xtend.lib.annotations.Accessors;

/**
 * 
 * Tab for choosing the step heuristics.
 *
 */
public class LaunchConfigurationHeuristicsTab extends LaunchConfigurationTab {
	
	static class HeuristicDefinition {
		@Accessors(AccessorType.PUBLIC_GETTER)
		private String heuristicID;
		@Accessors(AccessorType.PUBLIC_GETTER)
		private String humanReadableLabel;
		
		public HeuristicDefinition(String ID, String label) {
			heuristicID = ID;
			humanReadableLabel = label;
		}
	}

	private Map<HeuristicDefinition, Button> _components = new HashMap<>();

	/**
	 * get all possible addons and add them to the tab so the user can switch them
	 * on/off
	 */
	public LaunchConfigurationHeuristicsTab() {
		_components.put(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.overlap", "Overlap Heuristic"), null);
		_components.put(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.full_overlap", "Fully Overlap Heuristic"), null);
		_components.put(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.set_of_rules", "Set Of Rules Heuristic"), null);
		_components.put(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.num_steps", "Max Number of Steps Heuristic"), null);
	}

	@Override
	public void createControl(Composite parent) {
		Composite content = new Composite(parent, SWT.NULL);
		GridLayout gl = new GridLayout(1, false);
		gl.marginHeight = 0;
		content.setLayout(gl);
		content.layout();
		setControl(content);

		createLayout(content);
	}

	private void createLayout(Composite parent) {
		HashMap<String, Group> groupmap = new HashMap<String, Group>();

		groupmap.put("1", createGroup(parent, "Concurrency Heuristics"));

		groupmap.put("2", createGroup(parent, "Filtering Heuristics"));

		for (HeuristicDefinition extension : _components.keySet()) {
			Group parentGroup = groupmap.get("1");
			
			if(extension.heuristicID.equals("uk.ac.kcl.inf.xdsml.heuristics.num_steps")) {
				parentGroup = groupmap.get("2");
			}

			Button checkbox = createCheckButton(parentGroup, extension.humanReadableLabel);
			checkbox.addSelectionListener(new SelectionListener() {

				@Override
				public void widgetSelected(SelectionEvent e) {
					updateLaunchConfigurationDialog();
				}

				@Override
				public void widgetDefaultSelected(SelectionEvent e) {
				}
			});
			_components.put(extension, checkbox);
		}

		// remove empty groups
		for (Group g : groupmap.values()) {
			if (g.getChildren().length == 0) {
				g.dispose();
				parent.layout(true);
			}
		}
	}

	@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		for (HeuristicDefinition entry : _components.keySet()) {
			configuration.setAttribute(entry.heuristicID, false);
		}
	}

	@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
		for (HeuristicDefinition extension : _components.keySet()) {
			try {
				boolean value = configuration.getAttribute(extension.heuristicID, false);
				// _componentsActive.put(extension, value);
				Button checkbox = _components.get(extension);
				checkbox.setSelection(value);
			} catch (CoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {		
		for (Entry<HeuristicDefinition, Button> entry : _components.entrySet()) {
			configuration.setAttribute(entry.getKey().heuristicID, entry.getValue().getSelection());
		}
	}

	@Override
	public boolean isValid(ILaunchConfiguration config) {
		// Validate each addon
		try {
//			List<IEngineAddon> addons = new ArrayList<IEngineAddon>();
//			for (Entry<String, Button> entry : _components.entrySet()) {
//				if (entry.getValue().getSelection()) {
//					addons.add(entry.getKey());
//				}
//			}
//			List<String> errors = new ArrayList<String>();
//			for (IEngineAddon iEngineAddon : addons) {
//				errors.addAll(iEngineAddon.validate(addons));
//			}
//			if (!errors.isEmpty()) {
//				for (String msg : errors) {
//					setErrorMessage(msg);
//				}
//				return false;
//			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		setErrorMessage(null);
		return true;
	}

	@Override
	public String getName() {
		return "Steps Heuristics";
	}
}
