package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import fr.inria.aoste.trace.EventOccurrence
import java.util.ArrayList
import java.util.HashMap
import java.util.HashSet
import java.util.List
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.henshin.cpa.result.CriticalPair
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
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.util.CPAHelper

/**
 * A HenshinSolver class implementing an ISolver
 * it's main purpose is to generate a list of possible steps
 * and handle the concurrent steps as rule sequences feature
 */
class HenshinSolver implements ISolver {

	var Engine henshinEngine
	var EGraph modelGraph
	var List<Rule> semanticRules

	//handling concurrent steps
	var extension CPAHelper cpa
	var boolean showConcurrentSteps
//	var List<CriticalPair> conflictPairs
//	var HashSet<Rule> conflictRules
//	var HashMap<Rule, ArrayList<Node>> ruleDeletedNodesMap
//	var HashMap<Rule, ArrayList<Edge>> ruleDeletedEdgesMap

	/**
	 * create new HenshinSolver with the concurrent steps on/off
	 * @param flag to enable the concurrent steps feature
	 */
	new(boolean showConcurrentSteps) {
		super()
		this.showConcurrentSteps = showConcurrentSteps;
	}

	/**
	 * compute and create all possible steps by finding rule matches
	 * and generate concurrent steps
	 * @return a list of possible steps
	 */
	override computeAndGetPossibleLogicalSteps() {
		var possibleLogicalSteps = new ArrayList()
		var matchList = new ArrayList<Match>;
		for (Rule currRule : semanticRules) {
			val match = henshinEngine.findMatches(currRule, modelGraph, null)
			for (Match m : match) {
				val step = new HenshinStep(m);
				possibleLogicalSteps.add(step)
				matchList.add(m);
			}
		}
		// only generate Concurrent Steps if the flag is on
		if (showConcurrentSteps) {
			generateConcurrentSteps(possibleLogicalSteps, matchList);
		}
		possibleLogicalSteps
	}

	/**
	 * generate all possible maximum concurrent steps
	 * @param a list of all possible steps and a list of all current matches
	 */
	def generateConcurrentSteps(ArrayList<Step<?>> possibleLogicalSteps, ArrayList<Match> matchList) {
//		var conflictMatchesList = new ArrayList<Match>;
//		var conflictFreeMatchesList = new ArrayList<Match>;
//		
//		//get a list of max matches that definitely have no conflicts
//		for(Match m: matchList){
//			if(conflictRules.contains(m.getRule())){
//				conflictMatchesList.add(m);
//			}else{
//				conflictFreeMatchesList.add(m);
//			}
//		}
//		
//		//if there are matches with potential conflicts then create all the possible valid sequences
//		if(!conflictMatchesList.isEmpty()){
			var possibleSequences =  new HashSet<HashSet<Match>>;
		
			createAllStepSequences(matchList, possibleSequences, new HashSet<Match> );
			
			//for all lists of max sequences add the conflict free matches and create a henshinStep
			for(HashSet<Match> arr: possibleSequences){
				var concatArr = new ArrayList<Match>();
//				concatArr.addAll(conflictFreeMatchesList);
				concatArr.addAll(arr);
				if (concatArr.length > 1) {
					var step = new HenshinStep(concatArr);
					possibleLogicalSteps.add(step)
				}
			}
		
//		//if no matches with conflicts then just append one step with the rest of conflict free matches
//		}else if(!conflictFreeMatchesList.isEmpty()){
//			var step = new HenshinStep(conflictFreeMatchesList);
//			possibleLogicalSteps.add(step)
//		}
	}

	/**
	 * recursively explore all matches, check if they have conflicts and create max valid rule sequence
	 * @param a list of all matches, a list of lists of all possible sequences, current stack
	 */
	def void createAllStepSequences(ArrayList<Match> allMatches, HashSet<HashSet<Match>> possibleSequences,
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
		for (Match m : matches) {
			if (haveMatchesConflicts(match, m)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * check if two matches have conflicts with each other
	 * @param match1 and match2
	 * @output true if there are conflicts, false otherwise
	 */
	def haveMatchesConflicts(Match match1, Match match2) {
		match1.conflictsWith(match2)
		
//		//check if the two corresponding rules of the matches are in conflict pairs
//		var boolean isConflictPair = false;
//		for(CriticalPair cp: conflictPairs){
//			var first = cp.getFirstRule();
//			var second = cp.getSecondRule();
//			if((first.equals(match1.getRule()) && second.equals(match2.getRule())) || 
//				(first.equals(match2.getRule()) && second.equals(match1.getRule())))
//				isConflictPair = true;
//		}
//		//return false if they are not
//		if(!isConflictPair)
//			return false;
//		
//		//otherwise get nodes that get deleted for each rule
//		var deletedNodes1 = ruleDeletedNodesMap.get(match1.getRule());
//		var deletedNodes2 = ruleDeletedNodesMap.get(match2.getRule());
//		
//		//compare the nodes with the current node targets of a match 
//		//and make a list of the deleted node targets from each match
//		var deletedNodeTargets1 = new ArrayList<EObject>();
//		for(Node eo: deletedNodes1){
//			deletedNodeTargets1.add(match1.getNodeTarget(eo));
//		}
//		var deletedNodeTargets2 = new ArrayList<EObject>();
//		for(Node eo: deletedNodes2){
//			deletedNodeTargets2.add(match2.getNodeTarget(eo));
//		}
//		
//		//get all node targets of each match
//		var nodeTargets1 = match1.getNodeTargets();
//		var nodeTargets2 = match2.getNodeTargets();
//		
//		//check if the node targets deleted by match1 are in node targets of match2
//		//and vice versa
//		for(EObject eo: deletedNodeTargets1){
//			if(nodeTargets2.contains(eo)){
//				return true;
//			}
//		}
//		for(EObject eo: deletedNodeTargets2){
//			if(nodeTargets1.contains(eo)){
//				return true;
//			}
//		}
//		
//		//get a list of deleted edges by each rule
//		var deletedEdges1 = ruleDeletedEdgesMap.get(match1.getRule());
//		var deletedEdges2 = ruleDeletedEdgesMap.get(match2.getRule());
//		
//		//get a list of all edges in the LHS of a rule
//		var lhsEdges1 = match1.getRule().getLhs().getEdges();
//		var lhsEdges2 = match1.getRule().getLhs().getEdges();
//		
//		//iterate through all deleted edges and get the edge type, source node target 
//		//and target node target in the current match
//		//then compare with all edges from the LHS of the other match
//		//if the other match has an edge of this type and the source node target
//		//and target node target are the same then return false as we have found a conflict
//		//do this for edges in match 1 and match 2
//		for(Edge e: deletedEdges1){
//			var type = e.getType();
//			var sourceNode = match1.getNodeTarget(e.getSource());
//			var targetNode = match1.getNodeTarget(e.getTarget());
//			//if the 2nd mathc has both the source and target nodes and there is a mapping
//			for(Edge e2: lhsEdges2){
//				if(e2.getType() == type && match2.getNodeTarget(e2.getSource()) == sourceNode && match2.getNodeTarget(e2.getTarget()) == targetNode){
//					return true;
//				}
//			}
//		}
//		for(Edge e: deletedEdges2){
//			var type = e.getType();
//			var sourceNode = match2.getNodeTarget(e.getSource());
//			var targetNode = match2.getNodeTarget(e.getTarget());
//			//if the 2nd mathc has both the source and target nodes and there is a mapping
//			for(Edge e1: lhsEdges1){
//				if(e1.getType() == type && match1.getNodeTarget(e1.getSource()) == sourceNode && match1.getNodeTarget(e1.getTarget()) == targetNode){
//					return true;
//				}
//			}
//		}		
//		//if no conflicts found return false	
//		return false;
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
