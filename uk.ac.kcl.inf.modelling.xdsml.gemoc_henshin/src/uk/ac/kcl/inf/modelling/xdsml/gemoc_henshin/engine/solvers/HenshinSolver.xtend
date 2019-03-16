package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.Engine
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import java.util.List
import java.util.ArrayList
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.model.ParameterKind
import java.util.Random
import org.eclipse.emf.henshin.interpreter.Match
import fr.inria.diverse.melange.adapters.EObjectAdapter
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.emf.common.util.URI
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification
import static extension uk.ac.kcl.inf.modelling.xdsml.HenshinXDsmlSpecificationHelper.*
import org.eclipse.emf.henshin.model.Module
import org.eclipse.gemoc.trace.commons.model.trace.impl.StepImpl
import org.eclipse.gemoc.trace.commons.model.generictrace.impl.GenericSmallStepImpl
import org.eclipse.gemoc.trace.commons.model.trace.SmallStep
import org.eclipse.gemoc.trace.commons.model.trace.impl.SmallStepImpl
import org.eclipse.emf.henshin.cpa.CpaByAGG
import org.eclipse.emf.henshin.cpa.CPAOptions
import org.eclipse.emf.henshin.cpa.result.CriticalPair
import org.eclipse.emf.henshin.model.Graph
import java.util.HashMap
import java.util.HashSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.henshin.model.impl.NodeImpl
import org.eclipse.emf.henshin.model.impl.MappingImpl
import org.eclipse.emf.henshin.model.Mapping
import org.eclipse.emf.henshin.model.Node
import java.util.Arrays
import java.util.concurrent.CopyOnWriteArrayList

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
	// May be rules, too
	var List<Rule> semanticRules
	var List<CriticalPair> conflictPairs
	var CpaByAGG cpa
	var CPAOptions cpaOptions
	var HashSet<Rule> conflictRules

	
	
//	def applyHenshinStep(HenshinStep logicalStep) {
//			this.ruleRunner.EGraph = modelGraph
//			this.ruleRunner.rule = logicalStep.match.rule
//			this.ruleRunner.completeMatch = logicalStep.match
//		
//			if (!ruleRunner.execute(null)) {
//				throw new RuntimeException()
//			}	
//	}

	new(){
		super()
		cpa = new CpaByAGG();
		cpaOptions = new CPAOptions();
	}
	
	val rnd = new Random()
	
	override computeAndGetPossibleLogicalSteps() {
		
		
		var randomMatch = null as Match
		//HERE USE HENSHIN TO CALCULATE STEPS
		var applicableRules = semanticRules.filter[r|r.checkParameters].toList
		var possibleLogicalSteps = new ArrayList()
		var ruleList = new ArrayList<Rule>
		var matchList = new ArrayList<Match>;
		while(!applicableRules.empty) {
			val tentativeStepRule = applicableRules.remove(rnd.nextInt(applicableRules.size))
			val match = henshinEngine.findMatches(tentativeStepRule, modelGraph, null)
			for(Match m: match){
				val step = new HenshinStep(m);
				ruleList.add(tentativeStepRule)
				possibleLogicalSteps.add(step)
				randomMatch = m;
				matchList.add(m);
			}
					
		}
		
		var conflictMatchesList = new ArrayList<Match>;
		var conflictFreeMatchesList = new ArrayList<Match>;
		
		for(Match m: matchList){
			if(conflictRules.contains(m.getRule())){
				conflictMatchesList.add(m);
			}else{
				conflictFreeMatchesList.add(m);
			}
		}
		
		var possibleSequences =  new ArrayList<ArrayList<Match>>;
		
		for(Match m1: conflictMatchesList){
			var currSeq =  new CopyOnWriteArrayList<ArrayList<Match>>;
			var oneSeq =  new ArrayList<Match>;
			oneSeq.add(m1);
			currSeq.add(oneSeq);
			for(Match m2: conflictMatchesList){
				//check if has conflicts with current
				var safeToAddWithCurr = false;
				if(!m1.equals(m2) && !haveConflicts(m1,m2)){
					safeToAddWithCurr = true;
				}
				//if it doesnt then check all other elements
				if(safeToAddWithCurr){
					for(ArrayList<Match> alreadyInSeq: currSeq){
						var safeToAdd = true;
						for(Match currInnerMatch: alreadyInSeq){
							if(!currInnerMatch.equals(m1) && !currInnerMatch.equals(m2) && haveConflicts(currInnerMatch,m2)){
								safeToAdd = false;
								var newSeq =  new ArrayList<Match>;
								newSeq.add(m1);
								newSeq.add(m2);
								currSeq.add(newSeq);
							}
							
						}
						if(safeToAdd){
							alreadyInSeq.add(m2);
						}
					}
				}
//				var safeToAdd = true;
//				for(Match alreadyInSeq: currSeq){
//					if(alreadyInSeq === m2 || haveConflicts(alreadyInSeq,m2)){
//						safeToAdd = false;
//					}
//				}
//				if(safeToAdd){
//					currSeq.add(m2);
//				}
			}
			
			possibleSequences.addAll(currSeq);
//			var alreadyAdded = false;
//			for(ArrayList<Match> arr: possibleSequences){
//				if(arr.containsAll(currSeq)){
//					alreadyAdded = true;
//				}
//			}
//			if(!alreadyAdded){
//				possibleSequences.add(currSeq);
//			}
		}
		
		possibleSequences = removeDuplicates(possibleSequences);
		
		for(ArrayList<Match> arr: possibleSequences){
			var concatArr = new ArrayList<Match>();
			concatArr.addAll(conflictFreeMatchesList);
			concatArr.addAll(arr);
			var step = new HenshinStep(concatArr);
			possibleLogicalSteps.add(step)
		}
		if(possibleSequences.isEmpty() && !conflictFreeMatchesList.isEmpty()){
			var step = new HenshinStep(conflictFreeMatchesList);
			possibleLogicalSteps.add(step)
		}
		
//		if(!ruleList.isEmpty){
//			var checkedRuleList = new ArrayList<Rule>
//			for(Rule r1: ruleList){
//				var flag = true;
//				for(Rule r2: ruleList){
//					var g = r1.equals(r2);
//					var gg = r1 === r2;
//					var lala = 2;
//					if(!r1.equals(r2) || checkedRuleList.contains(r2)){
//					for(CriticalPair cp: conflictPairs){
//						if((cp.getFirstRule() === r1 && cp.getSecondRule() === r2) 
//							|| (cp.getFirstRule() === r2 && cp.getSecondRule() === r1)){
//								//checkedRuleList.remove(r1);
//								flag = false;
//							}
//					}
//					}		
//				}
//				if(flag){
//					checkedRuleList.add(r1);
//				}
//			}
//			val step = new HenshinStep(checkedRuleList,randomMatch);
//			possibleLogicalSteps.add(step)
//		}
//		for(Match m: ruleMatchMap.keySet()){
//			var cc = m.getNodeTargets();
//			var f = 5;
//		}

		possibleLogicalSteps	
	}
		
		def removeDuplicates(ArrayList<ArrayList<Match>> lists) {
			var noDuplicatesList =  new CopyOnWriteArrayList<ArrayList<Match>>;
			
			for(ArrayList<Match> list: lists){
				var isDuplicate = false;
				for(ArrayList<Match> alreadyAdded: noDuplicatesList){
					if(alreadyAdded.containsAll(list)){
						isDuplicate = true
					}
				}
				if(!isDuplicate){
					noDuplicatesList.add(list)
				}
			}
			var result =  new ArrayList<ArrayList<Match>>;
			result.addAll(noDuplicatesList);
			result
		}
		
	def haveConflicts(Match match1, Match match2) {
		var deletedNodes1 = getDeletedNodes(match1.getRule());
		var deletedNodes2 = getDeletedNodes(match2.getRule());
		
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
		
	def getDeletedNodes(Rule rule) {
		//if its in mappings get origin then its preserved otherwise it's deleted
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
	def CheckIfContainsNode(){
		
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
	def configure(EGraph eg, Engine h, List<Rule> s){
		modelGraph = eg
		henshinEngine = h
		semanticRules = s
		cpa.init(semanticRules, cpaOptions);
		//var r = cpa.runDependencyAnalysis();
		var result = cpa.runConflictAnalysis();
		//var aa = r.getCriticalPairs();
		conflictPairs = result.getCriticalPairs();
		conflictRules = new HashSet<Rule>();
		for(CriticalPair cp: conflictPairs){
			var first = cp.getFirstRule();
			var second = cp.getSecondRule();
			conflictRules.add(first);
			conflictRules.add(second);
		}
		
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
		

}
