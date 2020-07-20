package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.util.HashSet
import java.util.List
import java.util.Set
import org.chocosolver.solver.Model
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.model.Module
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.ui.strategies.LaunchConfigurationContext
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.AbstractInterpretingConcurrentExecutionEngine
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.CodeExecutionException
import org.eclipse.gemoc.execution.concurrent.symbolic.SmallStepVariable
import org.eclipse.gemoc.trace.commons.model.generictrace.GenericSmallStep
import org.eclipse.gemoc.trace.commons.model.trace.ParallelStep
import org.eclipse.gemoc.trace.commons.model.trace.SmallStep
import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.util.CPAHelper
import org.chocosolver.solver.expression.discrete.relational.ReExpression
import static org.chocosolver.solver.constraints.nary.cnf.LogOp.*

/**
 * Henshin Concurrent Execution Engine implementation class that handles the main workflow
 */
class HenshinConcurrentExecutionEngine extends AbstractInterpretingConcurrentExecutionEngine<HenshinConcurrentExecutionContext, HenshinConcurrentRunConfiguration> {

	val Engine henshinEngine = new EngineImpl
	val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)
	var EGraph modelGraph
	var List<Rule> semanticRules
	@Accessors(PUBLIC_GETTER)
	var Module semantics

	// handling concurrent steps
	var extension CPAHelper cpa

	val lcc = new LCC(this)

	new(HenshinConcurrentExecutionContext executionContext) {
		// TODO: This seems odd. Why does this have to be here rather than in a superclass?
		initialize(executionContext)
	}

	/**
	 * Get the engine  name
	 * @return a user display name for the engine kind 
	 */
	override String engineKindName() '''Henshin Concurrent xDSML Engine'''

	/**
	 * Here, we extract information about the model that we're asked to run as well as about the language semantics.
	 * Code mostly copied from the sequential engine(Zschaler), except for where marked
	 */
	override protected performSpecificInitialize(HenshinConcurrentExecutionContext executionContext) {
		var root = executionContext.resourceModel.contents.head
		if (root instanceof EObjectAdapter<?>) {
			root = (root as EObjectAdapter<?>).adaptee
		}
		modelGraph = new EGraphImpl(root)

		// Load rules and units
		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		// We expect this to be a resource that contains a HenshinXDsmlSpecification or a Henshin model directly
		val entryPoint = _executionContext.runConfiguration.languageName
		val resourceSet = new XtextResourceSet
		val semanticsResource = resourceSet.getResource(URI.createPlatformResourceURI(entryPoint, false), true)

		// Check validity
		// Assume a direct link to a Henshin file
		semantics = semanticsResource.contents.head as Module

		if (!semantics.imports.contains(root.eClass.EPackage)) {
			throw new IllegalArgumentException(
				"Mismatch between metamodel of model to be executed and metamodel over which operational semantics have been defined.")
		}

		semanticRules = semantics.units.filter(Rule).filter[r|r.checkParameters].toList

		try {
			cpa = new CPAHelper(new HashSet<Rule>(semanticRules))
		} catch (Throwable t) {
			cpa = null
			System.err.println("Error when trying to calculate critical pairs: " + t.message +
				". Ignoring and disabling concurrent steps.")
		}

		lcc.configured
	}

	override getSemanticRules() {
		semanticRules.map[name].toSet
	}

	override getAbstractSyntax() {
		semantics.imports.toSet
	}

	private static class HenshinStepFactory extends StepFactory {
		override createClonedInnerStep(Step<?> ss) {
			if (ss instanceof HenshinStep) {
				new HenshinStep(ss.match)
			}
		}

		override isEqualInnerStepTo(Step<?> step1, Step<?> step2) {
			if (step1 instanceof HenshinStep) {
				if (step2 instanceof HenshinStep) {
					return step1.match == step2.match
				}
			}

			false
		}
	}

	override createStepFactory() {
		new HenshinStepFactory
	}

	private var int varCounter = 0
	private def String freshName() '''var_«varCounter++»'''

	override protected computeInitialLogicalSteps() {
		val steps = computePossibleSmallSteps

		val symbolicSteps = new Model

		val stepVars = steps.map[s|new SmallStepVariable(freshName, symbolicSteps, s)].toList
		
		val varMap = stepVars.groupBy[associatedSmallStep].mapValues[head]


		// Build the or combination of all small steps
		symbolicSteps.addClauses(or(stepVars))

		// where steps exclude each other because of CPA, add exclusion constraints
		if (cpa !== null) {
			steps.forEach[s1 |
				steps.forEach[s2 |
					if (!canInitiallyRunConcurrently(s1, s2)) {
						val s1Var = varMap.get(s1)
						val s2Var = varMap.get(s2)
						
						symbolicSteps.addClausesAtMostOne(#[s1Var, s2Var])
					}
				]
			]
		}
		
		symbolicSteps
	}

	override Set<? extends GenericSmallStep> computePossibleSmallSteps() {
		semanticRules.flatMap[r|henshinEngine.findMatches(r, modelGraph, null)].map[new HenshinStep(it)].toSet
	}

	private def boolean canInitiallyRunConcurrently(SmallStep<?> s1, SmallStep<?> s2) {
		if (s1 !== s2) {				
			if (s1 instanceof HenshinStep) {
				if (s2 instanceof HenshinStep) {
					if (cpa !== null) {
						return ! (s1.match.conflictsWith(s2.match))
					} else {
						// We don't know whether we can run these steps in parallel, so we're playing it safe
						return false
					}
				}
			}
			
			throw new IllegalArgumentException("Expecting both arguments to be HenshinSteps.")
		} else {
			return true
		}
	}

	override protected executeSmallStep(SmallStep<?> smallStep) throws CodeExecutionException {
		val henshinStep = smallStep as HenshinStep

		ruleRunner.EGraph = modelGraph
		ruleRunner.rule = henshinStep.match.rule
		ruleRunner.completeMatch = henshinStep.match

		if (!ruleRunner.execute(null)) {
			throw new CodeExecutionException('''Couldn't apply rule «henshinStep.match.rule.name».''',
				henshinStep.mseoccurrence)
		}
	}

	override protected doAfterLogicalStepExecution(ParallelStep<?, ?> logicalStep) {}

	override protected finishDispose() {}

	/**
	 * Check if a rule has no parameters
	 * 
	 * @param Rule
	 * @return false if a rule has parameters
	 */
	private def boolean checkParameters(Rule operator) {
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

	private static class LCC implements LaunchConfigurationContext {

		val HenshinConcurrentExecutionEngine engine

		new(HenshinConcurrentExecutionEngine engine) {
			this.engine = engine
		}

		override getMetamodels() {
			if (engine.modelGraph !== null) {
				engine.modelGraph.roots.flatMap[eo|eo.eClass.eResource.contents.filter(EPackage)].toSet
			} else {
				emptySet
			}
		}

		val pcs = new PropertyChangeSupport(this)

		override addMetamodelChangeListener(PropertyChangeListener pcl) {
			pcs.addPropertyChangeListener("metamodel", pcl)
		}

		def configured() {
			pcs.firePropertyChange("metamodel", null, metamodels)
			pcs.firePropertyChange("semantics", null, semantics)
		}

		override getSemantics() {
			engine.semanticRules.map[name].toSet
		}

		override addSemanticsChangeListener(PropertyChangeListener pcl) {
			pcs.addPropertyChangeListener("semantics", pcl)
		}

	}
}
