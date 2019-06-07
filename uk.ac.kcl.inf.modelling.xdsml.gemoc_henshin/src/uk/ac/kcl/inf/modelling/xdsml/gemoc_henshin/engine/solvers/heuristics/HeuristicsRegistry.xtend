package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics

import java.util.HashMap
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Text
import org.eclipse.xtend.lib.annotations.AccessorType
import org.eclipse.xtend.lib.annotations.Accessors

import static extension org.eclipse.xtend.lib.annotations.AccessorType.*

/**
 * Registry of heuristics descriptions. Eventually to be filled from an extension point.
 * 
 */
class HeuristicsRegistry {

	public static val INSTANCE = new HeuristicsRegistry

	public static val HEURISTICS_CONFIG_KEY = "uk.ac.kcl.inf.xdsml.heuristics"
	
	enum HeuristicsGroup {
		CONCURRENCY_HEURISTIC,
		FILTERING_HEURISTIC
	}
		
	static class HeuristicDefinition {		
		
		@Accessors(AccessorType.PUBLIC_GETTER)
		val String heuristicID
		@Accessors(AccessorType.PUBLIC_GETTER)
		val String humanReadableLabel
		
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

	private new() {
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.overlap", "Overlap Heuristic", HeuristicsGroup.CONCURRENCY_HEURISTIC, OverlapHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.full_overlap", "Fully Overlap Heuristic",HeuristicsGroup.CONCURRENCY_HEURISTIC, 
			FullyOverlapHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.set_of_rules", "Set Of Rules Heuristic",HeuristicsGroup.CONCURRENCY_HEURISTIC, 
			SetOfRulesHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.non_identity_elements", "Non Identity Elements Heuristic", HeuristicsGroup.FILTERING_HEURISTIC, NonIdentityElementsHeuristic))
		add(new HeuristicDefinition("uk.ac.kcl.inf.xdsml.heuristics.num_steps", "Max Number of Steps Heuristic", HeuristicsGroup.FILTERING_HEURISTIC, 
				MaxNumberOfStepsHeuristic) {
				override getUIControl(Composite parent) {
					val control = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
					control.layoutData = new GridData(SWT.FILL, SWT.CENTER, true, false)
					control
				}
				
				override initaliseControl(Control uiElement, String configData) {
					val txt = uiElement as Text
					
					try {
						val num = Integer.parseInt(configData)
						txt.text = num.toString
					} catch (NumberFormatException nfe) {
						txt.text = "0"
					}
				}
				
				override encodeConfigInformation(Control uiElement) {
					val txt = uiElement as Text
					
					try {
						val num = Integer.parseInt(txt.text)
						num.toString
					} catch (NumberFormatException nfe) {
						"0"
					}
				}
				
				override initialise (Heuristic heuristic, String configData) {
					val h = heuristic as MaxNumberOfStepsHeuristic
					
					try {
						val num = Integer.parseInt(configData)
						h.maxNumberOfSteps = num
					} catch (NumberFormatException nfe) {
						System.err.println("Couldn't initalise heuristic: " + nfe.message)
						nfe.printStackTrace
					}					
				}
			})
	}

	val registry = new HashMap<String, HeuristicDefinition>()

	def add(HeuristicDefinition heuristic) {
		registry.put(heuristic.heuristicID, heuristic)
	}

	def getHeuristics() {
		registry.values
	}

	def get(String ID) {
		registry.get(ID)
	}
}
