package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.util.ArrayList
import java.util.List
import java.util.Random
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.UnitApplication
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.interpreter.impl.UnitApplicationImpl
import org.eclipse.emf.henshin.model.HenshinPackage
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Unit
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.gemoc.executionframework.engine.core.AbstractSequentialExecutionEngine
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionContext
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator

class HenshinExecutionEngine extends AbstractSequentialExecutionEngine {

	private val Engine henshinEngine = new EngineImpl
	private val UnitApplication unitRunner = new UnitApplicationImpl(henshinEngine)
	private val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)

	private var EObject root
	private var EGraph modelGraph
	// May be rules, too
	private var List<Unit> semanticUnits

	new() {
		// Use non-deterministic matching for now to ensure we get a random trace rather than always the same one
		henshinEngine.options.put(Engine.OPTION_DETERMINISTIC, false)
	}

	/**
	 * Get the engine kind name
	 * @return a user display name for the engine kind (will be used to compute
	 *         the full name of the engine instance)
	 */
	override String engineKindName() '''Henshin xDSML Engine'''

	/**
	 * For now, we don't actually support any model initialisation. That is, we assume the model will already contain
	 * all relevant information for running it, including things like tokens etc. Later, we will probably wish to 
	 * extend support for languages that mix in tokens or other semantic structures. In this case, these structures may 
	 * need initialising here.
	 * 
	 * TODO: Consider initialisation of any semantic structures.  
	 */
	protected override void prepareInitializeModel(IExecutionContext executionContext) {}

	protected override void initializeModel() {}

	/**
	 * Here, we extract information about the model that we're asked to run as well as about the language semantics.
	 * 
	 * This is currently modelled on the implementation in PlainK3ExecutionEngine, but may need adjusting further down the line.
	 */
	protected override void prepareEntryPoint(IExecutionContext executionContext) {
		// We assume mainModelElementURI to point to the model element containing the full model to be simulated, relative to executionContext.resourceModel  
		val mainModelElementURI = executionContext.runConfiguration.modelEntryPoint
		root = executionContext.resourceModel.getEObject(mainModelElementURI)
		if (root instanceof EObjectAdapter<?>) {
			root = (root as EObjectAdapter<?>).adaptee
		}
		modelGraph = new EGraphImpl(root)

		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		val entryPoint = executionContext.runConfiguration.executionEntryPoint
	// TODO: Parse file and load rules and units		
	}

	/**
	 * Actually run the model using the entry point and rules and units loaded in prepareEntryPoint.
	 */
	protected override void executeEntryPoint() {
		/*
		 * The loop will eventually be broken because we either cannot make any more changes or because the user stopped execution,
		 * leading to GEMOC throwing an exception in here. 
		 */
		while (performStep) {
		}
	}

	private static class NoRuleMatchedException extends Exception {
	}

	/**
	 * Perform a single step of model execution
	 */
	private def performStep() {
		var result = true

		val rc = new RecordingCommand(editingDomain, "Run a rule step",
			"Runs a randomly picked step from the set of rules and units provided as the operational semantics for this language.") {

			override protected doExecute() {
				if (!doPerformStep) {
					throw new NoRuleMatchedException()
				}
			}

		}
		// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
		beforeExecutionStep(root, root.eClass.name, "invokeRule", rc)

		if (rc.canExecute) {
			try {
				rc.execute
			} catch (NoRuleMatchedException nrme) {
				editingDomain.activeTransaction.abort(
					new Status(IStatus.OK, Activator.PLUGIN_ID, "No longer able to apply any semantic rules"))
				result = false
			}
		}

		afterExecutionStep

		result
	}

	/**
	 * Actually perform a single step, unencumbered by the need to fit in with GEMOC machinery. Look through list of units and pick one at 
	 * random, then try to apply it. Repeat until one actually works out.
	 */
	private def doPerformStep() {
		val triedUnits = new ArrayList<Unit>()
		val rnd = new Random()

		while (triedUnits.size < semanticUnits.size) {
			val remainingUnits = semanticUnits.reject[u|triedUnits.contains(u)]

			if (remainingUnits.empty) {
				// We didn't find any matches (we should really never get here because of the while condition :-))
				return false
			}

			val operator = remainingUnits.get(rnd.nextInt(remainingUnits.size))

			if (operator.checkUnitParamters) {
				if (operator.eClass === HenshinPackage.Literals.RULE) {
					if (runRuleOperator(operator, modelGraph)) {
						println("Ran rule: " + operator.name)
						return true
					}
				} else {
					if (runUnitOperator(operator, modelGraph)) {
						println("Ran unit: " + operator.name)
						return true
					}
				}
			}

			triedUnits.add(operator)
		}

		false
	}

	private def boolean checkUnitParamters(Unit operator) {
		if (operator.parameters !== null) {
			// Currently, we only support units without parameters (other than variables). 
			// Check to make sure we're not running into problems
			if (!operator.parameters.reject[parameter|parameter.kind.equals(ParameterKind.VAR)].empty) {
				println("Invalid unit with non-var parameters: " + operator.name)
				return false
			}
		}

		true
	}

	private def boolean runRuleOperator(Unit operator, EGraph graph) {
		ruleRunner.EGraph = graph
		ruleRunner.unit = operator

		ruleRunner.execute(null)
	}

	private def boolean runUnitOperator(Unit operator, EGraph graph) {
		unitRunner.EGraph = graph
		unitRunner.unit = operator

		unitRunner.execute(null)
	}
}
