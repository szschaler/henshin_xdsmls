package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.util.List
import java.util.Random
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.emf.transaction.impl.InternalTransactionalEditingDomain
import org.eclipse.gemoc.executionframework.engine.core.AbstractSequentialExecutionEngine
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionContext
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification

import static extension uk.ac.kcl.inf.modelling.xdsml.HenshinXDsmlSpecificationHelper.*

class HenshinExecutionEngine extends AbstractSequentialExecutionEngine {

	private val Engine henshinEngine = new EngineImpl
//	private val UnitApplication unitRunner = new UnitApplicationImpl(henshinEngine)
	private val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)

	private var EObject root
	private var EGraph modelGraph
	// May be rules, too
	private var List<Rule> semanticRules

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
		// executionContext.resourceModel points to the resource GEMOC loaded for the model to be run  
		root = executionContext.resourceModel.contents.head
		if (root instanceof EObjectAdapter<?>) {
			root = (root as EObjectAdapter<?>).adaptee
		}
		modelGraph = new EGraphImpl(root)

		// Load rules and units
		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		// We expect this to be a resource that contains a HenshinXDsmlSpecification
		val entryPoint = executionContext.runConfiguration.languageName
		// FIXME: This needs injecting!
		val resourceSet = new XtextResourceSet
		val semanticsResource = resourceSet.getResource(URI.createPlatformResourceURI(entryPoint, false), true)

		// Check validity
		val semantics = semanticsResource.contents.head as HenshinXDsmlSpecification
		if (semantics.metamodel !== root.eClass.getEPackage) {
			throw new IllegalArgumentException(
				"Mismatch between metamodel of model to be executed and metamodel over which operational semantics have been defined.")
		}

		if (semantics.units.exists[u | !(u instanceof Rule)]) {
			throw new IllegalArgumentException("All semantic rules must be rules. No units supported.")
		}
		semanticRules = semantics.units.filter(Rule).toList
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

	private static class RuleApplicationException extends Exception {
	}

	private static class StepCommand extends RecordingCommand {
		private val RuleApplication runner
		
		new (InternalTransactionalEditingDomain editingDomain, Rule rule, RuleApplication runner, EGraph model) {
			super(editingDomain, "Run a step using rule " + rule.name,
			'''Runs rule «rule.name» from the set of rules provided as the operational semantics for this language.''')
			
			this.runner = runner
			this.runner.EGraph = model
			this.runner.rule = rule
		}
		
		override protected doExecute() {	
			if (!runner.execute(null)) {
				throw new RuleApplicationException()
			}
		}
		
	}

	/**
	 * Perform a single step of model execution
	 */
	private def performStep() {
		var rule = pickNextRule

		if (rule !== null) {
			var result = true
			
			val command = new StepCommand (editingDomain, rule, ruleRunner, modelGraph) 
			// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
			beforeExecutionStep(root, root.eClass.name, rule.name, command)
	
			if (command.canExecute) {
				try {
					command.execute
				} catch (RuleApplicationException rae) {
					editingDomain.activeTransaction.abort(
						new Status(IStatus.OK, Activator.PLUGIN_ID, '''Error executing semantic rule «rule.name».'''))
					result = false
				}
			}
	
			afterExecutionStep
			
			result
		} else {
			false
		}
	}

	private val rnd = new Random()
	
	/**
	 * Randomly pick the next rule from those that could be applied
	 */
	private def pickNextRule() {
		val applicableRules = semanticRules.filter[r | r.checkParamters].filter[r | ! henshinEngine.findMatches(r, modelGraph, null).empty].toList
		
		if (applicableRules.empty) {
			null
		} else {
			applicableRules.get(rnd.nextInt(applicableRules.size))			
		}
	}

	private def boolean checkParamters(Rule operator) {
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
}
