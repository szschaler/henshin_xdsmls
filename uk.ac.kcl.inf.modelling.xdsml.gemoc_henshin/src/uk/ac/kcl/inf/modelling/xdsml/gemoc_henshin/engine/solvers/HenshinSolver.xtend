package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.henshin.model.Rule;
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext;
import org.eclipse.gemoc.trace.commons.model.trace.Step;
import org.eclipse.gemoc.xdsmlframework.api.core.IDisposable;

import fr.inria.aoste.timesquare.instantrelation.CCSLRelationModel.OccurrenceRelation;
import fr.inria.aoste.trace.EventOccurrence;
import fr.inria.aoste.trace.ModelElementReference;
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.Engine

/**
 * A Solver is the visible interface of any constraint solver system that runs
 * on its corresponding input based on a Model of Execution, returns Steps upon
 * requests and provides an API to influence the constraint-solving.
 * 
 * 
 */
class HenshinSolver implements ISolver {
		
	val Engine henshinEngine = new EngineImpl
	List<Rule> semanticRules
	var EGraph modelGraph

	
	override applyLogicalStep(Step<?> arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	private val rnd = new Random()
	override computeAndGetPossibleLogicalSteps() {
				var applicableRules = semanticRules.filter[r|r.checkParamters].toList

				while (!applicableRules.empty) {
					val tentativeStepRule = applicableRules.remove(rnd.nextInt(applicableRules.size))
					val match = henshinEngine.findMatches(tentativeStepRule, modelGraph, null)

					if (match !== null) {
						return match
					}
				}

				null
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
	
	override getState() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override initialize(IConcurrentExecutionContext arg0) {
		// executionContext.resourceModel points to the resource GEMOC loaded for the model to be run  
		root = executionContext.resourceModel.contents.head
		if (root instanceof EObjectAdapter<?>) {
			root = (root as EObjectAdapter<?>).adaptee
		}
		modelGraph = new EGraphImpl(root)

		// Load rules and units
		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		// We expect this to be a resource that contains a HenshinXDsmlSpecification or a Henshin model directly
		val entryPoint = executionContext.runConfiguration.languageName
		// FIXME: This needs injecting!
		val resourceSet = new XtextResourceSet
		val semanticsResource = resourceSet.getResource(URI.createPlatformResourceURI(entryPoint, false), true)

		// Check validity
		if (semanticsResource.contents.head instanceof HenshinXDsmlSpecification) {
			// Assume a HenshinXDsmlSpecification
			val semantics = semanticsResource.contents.head as HenshinXDsmlSpecification
			if (semantics.metamodel !== root.eClass.EPackage) {
				throw new IllegalArgumentException(
					"Mismatch between metamodel of model to be executed and metamodel over which operational semantics have been defined.")
			}

			semanticRules = semantics.rules
		} else {
			// Assume a direct link to a Henshin file
			val semantics = semanticsResource.contents.head as Module

			if (!semantics.imports.contains(root.eClass.EPackage)) {
				throw new IllegalArgumentException(
					"Mismatch between metamodel of model to be executed and metamodel over which operational semantics have been defined.")
			}

			semanticRules = semantics.units.filter(Rule).toList
		}
	}
	
	override prepareBeforeModelLoading(IConcurrentExecutionContext arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override proposeLogicalStep() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override revertForceClockEffect() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override setExecutableModelResource(Resource arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override setState(byte[] arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override updatePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override dispose() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}
