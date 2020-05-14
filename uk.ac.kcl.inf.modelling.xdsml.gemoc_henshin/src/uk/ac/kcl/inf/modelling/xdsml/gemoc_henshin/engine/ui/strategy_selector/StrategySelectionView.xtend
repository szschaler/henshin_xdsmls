package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.strategy_selector

import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.util.HashMap
import java.util.List
import org.eclipse.debug.internal.ui.SWTFactory
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.henshin.model.Module
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.executionframework.ui.views.engine.EngineSelectionDependentViewPart
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionEngine
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.events.SelectionListener
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.xtend.lib.annotations.Accessors
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentExecutionEngine
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.ConcurrencyStrategy
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.FilteringStrategy
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.LaunchConfigurationContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyDefinition.StrategyGroup
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.StrategyRegistry

class StrategySelectionView extends EngineSelectionDependentViewPart {

	public static val ID = "org.eclipse.gemoc.executionframework.engine.io.views.StrategySelectionView"

	val strategySelections = new HashMap<StrategyDefinition, Boolean>
	val components = new HashMap<StrategyDefinition, Pair<Button, Control>>

	private static class EngineWrappingLaunchConfigurationContext implements LaunchConfigurationContext {
		val pcs = new PropertyChangeSupport(this)
		static val METAMODELS = "metamodels"
		static val SEMANTICS = "semantics"

		var Module semantics = null
		var List<EPackage> metamodels = null

		@Accessors(PUBLIC_GETTER)
		var IExecutionEngine<?> engine = null

		def setEngine(IExecutionEngine<?> engine) {
			this.engine = engine
			try {
				val oldSemantics = semantics
				val oldmms = metamodels

				if (engine instanceof HenshinConcurrentExecutionEngine) {
					semantics = engine.semantics
					metamodels = semantics.imports
				} else {
					semantics = null
					metamodels = null
				}

				pcs.firePropertyChange(SEMANTICS,
					if(oldSemantics !== null) oldSemantics.units.filter(Rule).toList else emptyList,
					if(semantics !== null) semantics.units.filter(Rule).toList else emptyList)
				if (oldmms !== metamodels) {
					pcs.firePropertyChange(METAMODELS, oldmms, metamodels)
				}
			} catch (Exception e) {
				e.printStackTrace
			}
		}

		override getMetamodels() {
			metamodels
		}

		override addMetamodelChangeListener(PropertyChangeListener pcl) {
			pcs.addPropertyChangeListener(METAMODELS, pcl)
		}

		override getSemantics() {
			if(semantics !== null) semantics.units.filter(Rule).toList else emptyList
		}

		override addSemanticsChangeListener(PropertyChangeListener pcl) {
			pcs.addPropertyChangeListener(SEMANTICS, pcl)
		}
	}

	/**
	 *  Engine wrapper that ignores requests to send update events. 
	 * 
	 * To be used when updating strategies from the selection in the view so that they don't get accidentally updated whenever the engine 
	 * is switched.
	 */
	private static class NonNotifyingEngineWrappingLaunchConfigurationContext implements LaunchConfigurationContext {
		val EngineWrappingLaunchConfigurationContext delegate

		new(EngineWrappingLaunchConfigurationContext delegate) {
			this.delegate = delegate
		}

		override getMetamodels() {
			delegate.metamodels
		}

		override addMetamodelChangeListener(PropertyChangeListener pcl) {
			// Ignore
		}

		override getSemantics() {
			delegate.getSemantics
		}

		override addSemanticsChangeListener(PropertyChangeListener pcl) {
			// Ignore
		}

	}

	val configContext = new EngineWrappingLaunchConfigurationContext

	new() {
		StrategyRegistry.INSTANCE.strategies.forEach [ sd |
			strategySelections.put(sd, false)
		]
	}

	// TODO: This needs refactoring: currently copied across from LaunchConfigTab	
	override createPartControl(Composite parent) {
		val content = new Composite(parent, SWT.NULL)
		val gl = new GridLayout(1, false)

		gl.marginHeight = 0
		content.setLayout(gl)
		content.layout()

		createLayout(content)
	}

	// TODO: This needs refactoring: currently copied across from LaunchConfigTab	
	private def createLayout(Composite parent) {
		createTextLabelLayout(parent, "Update strategy selection below. This will take effect from the next step.")

		val groupmap = new HashMap<StrategyGroup, Group>()

		groupmap.put(StrategyGroup.CONCURRENCY_STRATEGY, createGroup(parent, "Concurrency Strategies"))
		groupmap.put(StrategyGroup.FILTERING_STRATEGY, createGroup(parent, "Filtering Strategies"))

		strategySelections.keySet.forEach [ sd |

			var parentGroup = groupmap.get(sd.group)

			val checkbox = createCheckButton(parentGroup, sd.humanReadableLabel)
			checkbox.selection = strategySelections.get(sd)

			val uiControl = sd.getUIControl(parentGroup, configContext)
			components.put(sd, new Pair(checkbox, uiControl))

			checkbox.addSelectionListener(new SelectionListener() {

				override widgetSelected(SelectionEvent e) {
					strategySelections.put(sd, checkbox.selection)
					updateEngineStrategySelection(sd, checkbox.selection, uiControl)
				}

				override widgetDefaultSelected(SelectionEvent e) {}
			})
		]

		// remove empty groups
		groupmap.values.forEach [ g |
			if (g.children.length === 0) {
				g.dispose()
				parent.layout(true)
			}
		]
	}

	protected def createTextLabelLayout(Composite parent, String labelString) {
		val gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.setLayoutData(gd)
		val label = new Label(parent, SWT.NONE)
		label.setText(labelString)
	}

	protected def Group createGroup(Composite parent, String text) {
		val group = new Group(parent, SWT.NULL)
		group.setText(text)

		val locationLayout = new GridLayout()
		locationLayout.numColumns = 5
		locationLayout.marginHeight = 10
		locationLayout.marginWidth = 10
		group.setLayout(locationLayout)

		group
	}

	protected def Button createCheckButton(Composite parent, String label) {
		SWTFactory.createCheckButton(parent, label, null, false, 1)
	}

	override setFocus() {}

	override engineSelectionChanged(IExecutionEngine<?> engine) {
		configContext.setEngine(engine) // need to explictly call setter because Xtend is stupid
		if (engine instanceof HenshinConcurrentExecutionEngine) {
			updateSelectionsFrom(engine)
		}
	}

	private def updateSelectionsFrom(HenshinConcurrentExecutionEngine engine) {
		strategySelections.keySet.forEach[hd|strategySelections.put(hd, false)]

		val strategies = (engine.concurrencyStrategies + engine.filteringStrategies).groupBy[strategyDefinition]
		strategies.keySet.forEach[strategySelections.put(it, true)]

		strategySelections.forEach [ extension sd, selected |
			val strategyComponents = components.get(sd)
			val checkbox = strategyComponents.key
			if (checkbox !== null) {
				checkbox.selection = selected
			}

			val hComponent = strategyComponents.value
			if (hComponent !== null) {
				hComponent.initaliseControl(strategies.get(sd)?.head)
			}
		]

	}

	protected def updateEngineStrategySelection(StrategyDefinition sd, boolean selected, Control control) {
		if (configContext.engine !== null) {
			if (configContext.engine instanceof HenshinConcurrentExecutionEngine) {
				val engine = configContext.engine as HenshinConcurrentExecutionEngine
				val strategies = (engine.concurrencyStrategies + engine.filteringStrategies).toList

				strategies.filter[strategyDefinition === sd].forEach [
					if (it instanceof ConcurrencyStrategy) {
						engine.concurrencyStrategies.remove(it)
					} else {
						engine.filteringStrategies.remove(it)
					}
				]

				if (selected) {
					val strategy = sd.instantiate
					sd.initialise(strategy, sd.encodeConfigInformation(control),
						new NonNotifyingEngineWrappingLaunchConfigurationContext(configContext))

					if (strategy instanceof ConcurrencyStrategy) {
						engine.concurrencyStrategies += strategy
					} else {
						engine.filteringStrategies += strategy as FilteringStrategy
					}
				}
			}
		}
	}
}
