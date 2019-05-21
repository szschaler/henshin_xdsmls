package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import fr.inria.aoste.trace.EventOccurrence
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.model.Edge
import org.eclipse.emf.henshin.model.Node
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.xtend.lib.annotations.Accessors
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.util.CPAHelper
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentRunConfiguration
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinConcurrentModelExecutionContext

/**
 * A HenshinSolver class implementing an ISolver
 * it's main purpose is to generate a list of possible steps
 * and handle the concurrent steps as rule sequences feature
 */
class HenshinSolver implements ISolver {

	var Engine henshinEngine
	var EGraph modelGraph
	var List<Rule> semanticRules

	// handling concurrent steps
	var extension CPAHelper cpa
	var boolean showConcurrentSteps

	@Accessors
	var List<ConcurrencyHeuristic> concurrencyHeuristics
	@Accessors
	var List<FilteringHeuristic> filteringHeuristics

	/**
	 * create new HenshinSolver with the concurrent steps on/off
	 * @param flag to enable the concurrent steps feature
	 */
	new(boolean showConcurrentSteps) {
		super()
		this.showConcurrentSteps = showConcurrentSteps;
		concurrencyHeuristics = new ArrayList<ConcurrencyHeuristic>()
		filteringHeuristics = new ArrayList<FilteringHeuristic>()
	}

	/**
	 * compute and create all possible steps by finding rule matches
	 * and generate concurrent steps
	 * @return a list of possible steps
	 */
	override computeAndGetPossibleLogicalSteps() {
		var possibleLogicalSteps = new ArrayList<Step<?>>()

		val atomicMatches = semanticRules.flatMap[r|henshinEngine.findMatches(r, modelGraph, null)].toList

		// only generate Concurrent Steps if the flag is on
		if (showConcurrentSteps) {
			possibleLogicalSteps.addAll(atomicMatches.generateConcurrentSteps.map[seq| if(seq.length > 1) new HenshinStep(seq.toList)])
		}

		possibleLogicalSteps.addAll(atomicMatches.map[m| new HenshinStep(m)])

		possibleLogicalSteps.filterByHeuristics
	}

	/**
	 * Return a list of steps filtered by all filtering heuristics
	 */	
	private def filterByHeuristics(List<Step<?>> possibleSteps) {
		filteringHeuristics.fold(possibleSteps, [steps, fh | fh.filter(steps)])
	}

	/**
	 * Generate all possible maximally concurrent steps
	 * 
	 * @param matchList all current atomic matches
	 */
	def generateConcurrentSteps(List<Match> matchList) {
		var possibleSequences = new HashSet<Set<Match>>;

		createAllStepSequences(matchList, possibleSequences, new HashSet<Match>);
		
		possibleSequences
	}

	/**
	 * recursively explore all matches, check if they have conflicts and create max valid rule sequence
	 * @param a list of all matches, a list of lists of all possible sequences, current stack
	 */
	def void createAllStepSequences(List<Match> allMatches, Set<Set<Match>> possibleSequences,
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
	 * check if a match has conflicts with a set of other matches
	 * @param match and a list of matches
	 */
	def hasConflicts(Match match, HashSet<Match> matches) {
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
	def cannotRunConcurrently(Match match1, Match match2) {
		match1.conflictsWith(match2) || concurrencyHeuristics.exists[ch|!ch.canBeConcurrent(match1, match2)]
	}

	/**
	 * check if a rule has no parameters, method taken from the sequential engine(Zschaler)
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
	 * configure the henshin solver setup, check if concurrent steps possible by running henshin CPA
	 * and generate deleted nodes and edges if the feature enabled
	 * @param henshin egraph, henshin engine and all semantic rules
	 */
	def configure(EGraph modelGraph, Engine henshinEngine, List<Rule> semanticRules) {
		this.modelGraph = modelGraph
		this.henshinEngine = henshinEngine
		var applicableRules = semanticRules.filter[r|r.checkParameters].toList
		this.semanticRules = applicableRules

		cpa = new CPAHelper(new HashSet<Rule>(semanticRules))
		
//		filteringHeuristics.add(new NonIdentityElementsHeuristic(modelGraph.roots.head.eClass.EPackage.EClassifiers.filter(EClass).filter[ec | ec.name == "Part"].toList))
	}

	/**
	 * get deleted nodes from a rule
	 * @param a rule
	 */
	def getDeletedNodes(Rule rule) {
		var lhsNodes = rule.getLhs().getNodes();
		var rhs = rule.getRhs();
		var mappings = rule.getMappings();
		var deletedNodes = new ArrayList<Node>();

		// check if the LHS nodes are mapped to something in RHS
		for (Node eo : lhsNodes) {
			if (mappings.getImage(eo, rhs) === null)
				deletedNodes.add(eo);
		}
		deletedNodes;
	}

	/**
	 * get deleted edges from a rule
	 * @param a rule
	 */
	def getDeletedEdges(Rule rule) {
		var rhs = rule.getRhs();
		var mappings = rule.getMappings();
		var deletedEdges = new ArrayList<Edge>();
		var lhsEdges = rule.getLhs().getEdges();

		// check if the LHS edges are mapped to something in RHS
		for (Edge e : lhsEdges) {
			if (mappings.getImage(e, rhs) === null)
				deletedEdges.add(e);
		}
		deletedEdges;
	}

	override getState() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override initialize(IConcurrentExecutionContext concurrentexecutionContext) {
		var config = (concurrentexecutionContext as HenshinConcurrentModelExecutionContext).getRunConfiguration() as HenshinConcurrentRunConfiguration
		if(config.getMaxNumberOfStepsHeuristic()){
			filteringHeuristics.add(new MaxNumberOfStepsHeuristic())
		}
		if(config.getOverlapHeuristic()){
			concurrencyHeuristics.add(new OverlapHeuristic())
		}
		if(config.getFullyOverlapHeuristic()){
			concurrencyHeuristics.add(new FullyOverlapHeuristic())
			
		}
		if(config.getSetOfRulesHeuristic()){
			concurrencyHeuristics.add(new SetOfRulesHeuristic(semanticRules))
		}
	}

	override prepareBeforeModelLoading(IConcurrentExecutionContext concurrentexecutionContext) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override proposeLogicalStep() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override revertForceClockEffect() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override setExecutableModelResource(Resource execModelResource) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override setState(byte[] serializableModel) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updatePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override dispose() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override applyLogicalStep(Step<?> logicalStep) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override forbidEventOccurrence(EventOccurrence arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override forceEventOccurrence(EventOccurrence arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getAllDiscreteClocks() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override getLastOccurrenceRelations() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}
