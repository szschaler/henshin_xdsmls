package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import fr.inria.aoste.trace.EventOccurrence
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.henshin.cpa.CPAOptions
import org.eclipse.emf.henshin.cpa.CpaByAGG
import org.eclipse.emf.henshin.cpa.result.CriticalPair
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.Engine
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.model.Mapping
import org.eclipse.emf.henshin.model.Node
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
import org.eclipse.gemoc.trace.commons.model.trace.Step
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import java.util.HashMap
import org.eclipse.emf.henshin.cpa.result.Conflict
import org.eclipse.emf.henshin.cpa.result.ConflictKind

/**
 * A Solver is the visible interface of any constraint solver system that runs
 * on its corresponding input based on a Model of Execution, returns Steps upon
 * requests and provides an API to influence the constraint-solving.
 * 
 * 
 */
class HenshinSolver implements ISolver {
	
	var Engine henshinEngine 
	var EGraph modelGraph
	var List<Rule> semanticRules
	
	var boolean showSequenceRules
	var List<CriticalPair> conflictPairs
	var HashSet<Rule> conflictRules
	var HashMap<Rule, ArrayList<Node>> ruleDeletedNodesMap


	new(boolean showSequenceRules){
		super()
		this.showSequenceRules = showSequenceRules;
	}
	
	
	override computeAndGetPossibleLogicalSteps() {		
		var possibleLogicalSteps = new ArrayList()
		var matchList = new ArrayList<Match>;
		for(Rule currRule: semanticRules) {
			val match = henshinEngine.findMatches(currRule, modelGraph, null)
			for(Match m: match){
				val step = new HenshinStep(m);
				possibleLogicalSteps.add(step)
				matchList.add(m);
			}
		}
		if(showSequenceRules){
			generateSequenceRulesSteps(possibleLogicalSteps, matchList);
		}
		possibleLogicalSteps	
	}
		
	def generateSequenceRulesSteps(ArrayList<Step<?>> possibleLogicalSteps, ArrayList<Match> matchList) {
		var conflictMatchesList = new ArrayList<Match>;
		var conflictFreeMatchesList = new ArrayList<Match>;
		
		for(Match m: matchList){
			if(conflictRules.contains(m.getRule())){
				conflictMatchesList.add(m);
			}else{
				conflictFreeMatchesList.add(m);
			}
		}
		
		if(!conflictMatchesList.isEmpty()){
			var possibleSequences =  new HashSet<HashSet<Match>>;
		
			createAllStepSequences(conflictMatchesList, possibleSequences, new HashSet<Match> );
			
			for(HashSet<Match> arr: possibleSequences){
				var concatArr = new ArrayList<Match>();
				concatArr.addAll(conflictFreeMatchesList);
				concatArr.addAll(arr);
				var step = new HenshinStep(concatArr);
				possibleLogicalSteps.add(step)
			}
		}else if(!conflictFreeMatchesList.isEmpty()){
			var step = new HenshinStep(conflictFreeMatchesList);
			possibleLogicalSteps.add(step)
		}
	}
		
	def void createAllStepSequences(ArrayList<Match> allMatches, HashSet<HashSet<Match>> possibleSequences, HashSet<Match> currentStack) {
		var foundOne = false;
		for(Match m: allMatches){
			if(!currentStack.contains(m)){
				if(!hasConflicts(m, currentStack)){
					foundOne = true;
					currentStack.add(m);
					var clonedStack = currentStack.clone() as HashSet<Match>;
					createAllStepSequences(allMatches, possibleSequences, clonedStack);
					currentStack.remove(m);
				}
			}
		}
		if(!foundOne){
			possibleSequences.add(currentStack);
		}
	}
		
	def hasConflicts(Match match, HashSet<Match> matches) {
		for(Match m: matches){
			if(haveMatchesConflicts(match,m)){
				return true;
			}
		}
		return false;
	}
		
		
	def haveMatchesConflicts(Match match1, Match match2) {
		var boolean isConflictPair = false;
		for(CriticalPair cp: conflictPairs){
			var first = cp.getFirstRule();
			var second = cp.getSecondRule();
			if((first.equals(match1.getRule()) && second.equals(match2.getRule())) || 
				(first.equals(match2.getRule()) && second.equals(match1.getRule())))
				isConflictPair = true;
		}
		if(!isConflictPair)
			return false;
			
		var deletedNodes1 = ruleDeletedNodesMap.get(match1.getRule());
		var deletedNodes2 = ruleDeletedNodesMap.get(match2.getRule());
		
		var deletedNodeTargets1 = new ArrayList<EObject>();
		for(Node eo: deletedNodes1){
			deletedNodeTargets1.add(match1.getNodeTarget(eo));
		}
		var deletedNodeTargets2 = new ArrayList<EObject>();
		for(Node eo: deletedNodes2){
			deletedNodeTargets2.add(match2.getNodeTarget(eo));
		}
		
		var nodeTargets1 = match1.getNodeTargets();
		var nodeTargets2 = match2.getNodeTargets();
		
		for(EObject eo: deletedNodeTargets1){
			if(nodeTargets2.contains(eo)){
				return true;
			}
		}
		for(EObject eo: deletedNodeTargets2){
			if(nodeTargets1.contains(eo)){
				return true;
			}
		}
		return false;
	}
		
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
	def configure(EGraph modelGraph, Engine henshinEngine, List<Rule> semanticRules){
		this.modelGraph = modelGraph
		this.henshinEngine = henshinEngine
		var applicableRules = semanticRules.filter[r|r.checkParameters].toList
		this.semanticRules = applicableRules
		
		var cpa = new CpaByAGG();
		var cpaOptions = new CPAOptions();
		cpa.init(semanticRules, cpaOptions);
		var result = cpa.runConflictAnalysis();
		conflictPairs = result.getCriticalPairs();
		
		conflictRules = new HashSet<Rule>();
		for(var i = 0; i < conflictPairs.length; i++){
			var cp = conflictPairs.get(i)
			var currConflictKind = (cp as Conflict).getConflictKind();
			if(!currConflictKind.equals(ConflictKind.DELETE_USE_CONFLICT)){
				this.showSequenceRules = false;
				i = conflictPairs.length
			}
			
			var first = cp.getFirstRule();
			var second = cp.getSecondRule();
			conflictRules.add(first);
			conflictRules.add(second);
		}
		
		if(showSequenceRules){
			ruleDeletedNodesMap = new HashMap<Rule, ArrayList<Node>>();
			for(Rule r: conflictRules){
				var deletedNodes = getDeletedNodes(r);
				ruleDeletedNodesMap.put(r, deletedNodes);
			}	
		}	
	}
	
	//if its in mappings get origin then its preserved otherwise it's deleted
	
	def getDeletedNodes(Rule rule) {
		var lhsNodes = rule.getLhs().getNodes();
		var mappings = rule.getMappings();
		var deletedNodes =  new ArrayList<Node>();
		
		for(Node eo: lhsNodes){
			var isDeleted = true;
			for(Mapping m : mappings){
				if(m.getOrigin().equals(eo)){
					isDeleted = false;
				}
			}
			if(isDeleted){
				deletedNodes.add(eo);
			}
		}
		deletedNodes;
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
