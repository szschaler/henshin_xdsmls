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

	
	
//	def applyHenshinStep(HenshinStep logicalStep) {
//			this.ruleRunner.EGraph = modelGraph
//			this.ruleRunner.rule = logicalStep.match.rule
//			this.ruleRunner.completeMatch = logicalStep.match
//		
//			if (!ruleRunner.execute(null)) {
//				throw new RuntimeException()
//			}	
//	}
	
	val rnd = new Random()
	
	override computeAndGetPossibleLogicalSteps() {
		//HERE USE HENSHIN TO CALCULATE STEPS
		var applicableRules = semanticRules.filter[r|r.checkParameters].toList
		var possibleLogicalSteps = new ArrayList()

		while(!applicableRules.empty) {
			val tentativeStepRule = applicableRules.remove(rnd.nextInt(applicableRules.size))
			val match = henshinEngine.findMatches(tentativeStepRule, modelGraph, null)
						
			for(Match m: match){
				val step = new HenshinStep(m,tentativeStepRule)
				possibleLogicalSteps.add(step)
			}
					
		}
		possibleLogicalSteps	
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
	def configure(EGraph m, Engine h, List<Rule> s){
		modelGraph = m
		henshinEngine = h
		semanticRules = s
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
