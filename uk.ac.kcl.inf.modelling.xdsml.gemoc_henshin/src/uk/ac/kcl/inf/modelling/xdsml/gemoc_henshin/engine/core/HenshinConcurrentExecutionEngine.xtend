package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.model.Module
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.AbstractConcurrentExecutionEngine
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.CodeExecutionException
import org.eclipse.gemoc.trace.commons.model.generictrace.GenerictraceFactory
import org.eclipse.gemoc.trace.commons.model.trace.SmallStep
import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.ConcurrencyHeuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.FilteringHeuristic
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.HeuristicDefinition.HeuristicsGroup
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.LaunchConfigurationContext
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.util.CPAHelper

/**
 * Henshin Concurrent Execution Engine implementation class that handles the main workflow
 */
class HenshinConcurrentExecutionEngine extends AbstractConcurrentExecutionEngine<HenshinConcurrentExecutionContext, HenshinConcurrentRunConfiguration> {
	
	val Engine henshinEngine = new EngineImpl
	val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)
	var EGraph modelGraph
	var List<Rule> semanticRules
	
	// handling concurrent steps
	var extension CPAHelper cpa
	var boolean showConcurrentSteps = true
	
	@Accessors
	var List<ConcurrencyHeuristic> concurrencyHeuristics = new ArrayList<ConcurrencyHeuristic>()
	@Accessors
	var List<FilteringHeuristic> filteringHeuristics = new ArrayList<FilteringHeuristic>()
	
	val lcc = new LCC(this)

	new(HenshinConcurrentExecutionContext executionContext) {
		initialize(executionContext)
		
		val config = executionContext.getRunConfiguration() as HenshinConcurrentRunConfiguration
		
		config.heuristics.forEach[extension hd | 
			val h = hd.instantiate
			h.initialise(config.getConfigDetailFor(hd), lcc)
			
			if (hd.group === HeuristicsGroup.FILTERING_HEURISTIC) {
				filteringHeuristics.add(h as FilteringHeuristic)
			} else {
				concurrencyHeuristics.add(h as ConcurrencyHeuristic)
			}
		]
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
		val semantics = semanticsResource.contents.head as Module

		if (!semantics.imports.contains(root.eClass.EPackage)) {
			throw new IllegalArgumentException(
				"Mismatch between metamodel of model to be executed and metamodel over which operational semantics have been defined.")
		}

		semanticRules = semantics.units.filter(Rule).filter[r|r.checkParameters].toList

		cpa = new CPAHelper(new HashSet<Rule>(semanticRules))
	
		lcc.configured	
	}

	/**
	 * Compute and create all possible steps by finding rule matches and generate concurrent steps
	 * 
	 * @return a list of possible steps
	 */
	override protected computePossibleLogicalSteps() {
		var possibleLogicalSteps = new ArrayList<Step<?>>()

		val atomicMatches = semanticRules.flatMap[r|henshinEngine.findMatches(r, modelGraph, null)].toList

		// only generate Concurrent Steps if the flag is on
		if (showConcurrentSteps) {
			possibleLogicalSteps.addAll(atomicMatches.generateConcurrentSteps.map[seq| 
				if(seq.length > 1) {
					val parStep = GenerictraceFactory.eINSTANCE.createGenericParallelStep
					parStep.subSteps.addAll(seq.map[m | new HenshinStep(m)])
					parStep
				}].filterNull)
		}

		possibleLogicalSteps.addAll(atomicMatches.map[m| new HenshinStep(m)])

		possibleLogicalSteps.filterByHeuristics		
	}
	
	override protected executeSmallStep(SmallStep<?> smallStep) throws CodeExecutionException {
		val henshinStep = smallStep as HenshinStep
		
		ruleRunner.EGraph = modelGraph
		ruleRunner.rule = henshinStep.match.rule
		ruleRunner.completeMatch = henshinStep.match
		
		if (!ruleRunner.execute(null)) {
				throw new CodeExecutionException('''Couldn't apply rule «henshinStep.match.rule.name».''', henshinStep.mseoccurrence)
		}
	}

	override protected doAfterLogicalStepExecution(Step<?> logicalStep) { }
	
	override protected finishDispose() { }
	
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
	
	/**
	 * Generate all possible maximally concurrent steps
	 * 
	 * @param matchList all current atomic matches
	 */
	private def generateConcurrentSteps(List<Match> matchList) {
		var possibleSequences = new HashSet<Set<Match>>;

		createAllStepSequences(matchList, possibleSequences, new HashSet<Match>);
		
		possibleSequences
	}

	/**
	 * Recursively explore all matches, check if they have conflicts and create max valid rule sequence
	 * 
	 * @param a list of all matches, a list of lists of all possible sequences, current stack
	 */
	private def void createAllStepSequences(List<Match> allMatches, Set<Set<Match>> possibleSequences,
		HashSet<Match> currentStack) {
		var foundOne = false;
		for (Match m : allMatches) {
			if (!currentStack.contains(m)) {
				if (!hasConflicts(m, currentStack)) {
					foundOne = true;
					currentStack.add(m);
					var clonedStack = currentStack.clone() as HashSet<Match>;
					createAllStepSequences(allMatches, possibleSequences, clonedStack);
					currentStack.remove(m);
				}
			}
		}
		if (!foundOne) {
			possibleSequences.add(currentStack);
		}
	}
	
	/**
	 * Check if a match has conflicts with a set of other matches
	 * 
	 * @param match and a list of matches
	 */
	private def hasConflicts(Match match, HashSet<Match> matches) {
		matches.exists[m|match.cannotRunConcurrently(m)]
	}
	
	/**
	 * Check if two matches cannot be executed in parallel. First checks if the two matches 
	 * conflict based on the CPA analysis. Then checks if all concurrency heuristics agree 
	 * that they should be run in parallel.
	 * 
	 * @param match1 and match2
	 * 
	 * @output true if the two matches should not run in parallel
	 */
	private def cannotRunConcurrently(Match match1, Match match2) {
		match1.conflictsWith(match2) || concurrencyHeuristics.exists[ch|!ch.canBeConcurrent(match1, match2)]
	}
	
	/**
	 * Return a list of steps filtered by all filtering heuristics
	 */	
	private def filterByHeuristics(List<Step<?>> possibleSteps) {
		filteringHeuristics.fold(possibleSteps, [steps, fh | fh.filter(steps)])
	}
	
	private static class LCC implements LaunchConfigurationContext {
		
		val HenshinConcurrentExecutionEngine engine
		
		new(HenshinConcurrentExecutionEngine engine) {
			this.engine = engine
		}
		
		override getMetamodels() {
			if (engine.modelGraph !== null) {
				engine.modelGraph.roots.flatMap[eo | eo.eClass.eResource.contents.filter(EPackage)].toList				
			} else {
				emptyList
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
			engine.semanticRules
		}
		
		override addSemanticsChangeListener(PropertyChangeListener pcl) {
			pcs.addPropertyChangeListener("semantics", pcl)
		}
		
	}
	
	
}