package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics

import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.xtend.lib.annotations.AccessorType
import org.eclipse.xtend.lib.annotations.Accessors

import static extension org.eclipse.xtend.lib.annotations.AccessorType.*

class HeuristicDefinition {

	@Accessors(AccessorType.PUBLIC_GETTER)
	val String heuristicID
	@Accessors(AccessorType.PUBLIC_GETTER)
	val String humanReadableLabel

	enum HeuristicsGroup {
		CONCURRENCY_HEURISTIC,
		FILTERING_HEURISTIC
	}

	@Accessors(AccessorType.PUBLIC_GETTER)
	val HeuristicsGroup group

	val Class<? extends Heuristic> clazz

	new(String ID, String label, HeuristicsGroup group, Class<? extends Heuristic> clazz) {
		heuristicID = ID
		humanReadableLabel = label
		this.group = group
		this.clazz = clazz
	}

	def instantiate() {
		clazz.newInstance
	}

	/**
	 * Override this to define additional initialisation for a newly created heuristic
	 * 
	 * @param heuristic the heuristic to configure
	 * @param configData a string containing configuration data as defined by a previous call to {@link #encodeConfigInformation}. May be <code>null</code> if this heuristic definition does not define any additional configuration data.
	 */
	def void initialise(Heuristic heuristic, String configData) {}

	/**
	 * Provide an optional control to display in a launch tab to allow users to provide additional configuration information for the heuristic. 
	 */
	def Control getUIControl(Composite parent) { null }

	/**
	 * Encode the user choice in a string that can be saved in a launch configuration.
	 */
	def String encodeConfigInformation(Control uiElement) { null }

	/**
	 * Initialise this heuristic definition's control from the given configData
	 */
	def void initaliseControl(Control uiElement, String configData) {}

}
