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
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.impl.EGraphImpl
import org.eclipse.emf.henshin.interpreter.impl.EngineImpl
import org.eclipse.emf.henshin.interpreter.impl.RuleApplicationImpl
import org.eclipse.emf.henshin.model.Module
import org.eclipse.emf.henshin.model.ParameterKind
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.emf.transaction.impl.InternalTransactionalEditingDomain
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionContext
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator;
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionEngine
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentRunConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IFutureAction
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.ILogicalStepDecider
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
//import org.eclipse.gemoc.executionframework.engine.Activator
import org.eclipse.gemoc.executionframework.engine.core.AbstractExecutionEngine
import org.eclipse.gemoc.trace.commons.model.trace.Step

import static extension uk.ac.kcl.inf.modelling.xdsml.HenshinXDsmlSpecificationHelper.*
import java.util.ArrayList
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dse.IMSEStateController
import org.eclipse.gemoc.xdsmlframework.api.core.EngineStatus
import org.eclipse.gemoc.executionframework.engine.core.EngineStoppedException
import org.eclipse.gemoc.xdsmlframework.api.engine_addon.IEngineAddon
import org.eclipse.emf.transaction.TransactionalEditingDomain
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.HenshinSolver
import org.eclipse.emf.henshin.cpa.ICriticalPairAnalysis
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.henshin.cpa.criticalpair.CriticalPair
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.common.util.EList
import java.lang.reflect.InvocationTargetException
import org.eclipse.emf.common.notify.Notification
import org.eclipse.emf.henshin.cpa.criticalpair.impl.CriticalpairFactoryImpl
import org.eclipse.emf.henshin.cpa.UnsupportedRuleException
import org.eclipse.emf.henshin.cpa.CPAOptions
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.emf.henshin.cpa.CpaByAGG

class HenshinConcurrentExecutionEngine extends AbstractExecutionEngine<IConcurrentExecutionContext, IConcurrentRunConfiguration> implements IConcurrentExecutionEngine {

	val Engine henshinEngine = new EngineImpl
	val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)
	

	var EObject root
	var EGraph modelGraph
	// May be rules, too
	var List<Rule> semanticRules
	protected HenshinStep _selectedLogicalStep;
	var HenshinSolver _solver;
	var List<Step<?>> _possibleLogicalSteps = new ArrayList()
	var ILogicalStepDecider _logicalStepDecider

	new(IConcurrentExecutionContext concurrentexecutionContext, HenshinSolver s) {
		super();
		initialize(concurrentexecutionContext);
		_logicalStepDecider = concurrentexecutionContext.getLogicalStepDecider()
		_solver = s
		// Use non-deterministic matching for now to ensure we get a random trace rather than always the same one
		henshinEngine.options.put(Engine.OPTION_DETERMINISTIC, false)
	}

	/**
	 * Get the engine kinConcurrentExecutionEngined name
	 * @return a user display name for the engine kind (will be used to compute
	 *         the full name of the engine instance)
	 */
	override String engineKindName() '''Henshin Concurrent xDSML Engine'''

	/**
	 * Here, we extract information about the model that we're asked to run as well as about the language semantics.
	 * 
	 * This is currently modelled on the implementation in PlainK3ExecutionEngine, but may need adjusting further down the line.
	 */
	protected def void prepareEntryPoint() {
		// executionContext.resourceModel points to the resource GEMOC loaded for the model to be run  
		
		root = executionContext.resourceModel.contents.head
		if (root instanceof EObjectAdapter<?>) {
			root = (root as EObjectAdapter<?>).adaptee
		}
		modelGraph = new EGraphImpl(root)
		
		//var a = new CriticalPair(r1, r2, root.eClass.EPackage)

		// Load rules and units
		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		// We expect this to be a resource that contains a HenshinXDsmlSpecification or a Henshin model directly
		val entryPoint = _executionContext.runConfiguration.languageName
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
			var s = semanticRules;
			var mappings = s.get(2).getMappings();
			var amappings = s.get(2).getAllMappings();
			var graph = s.get(2).getLhs();
			var nodes = graph.getNodes();
			var edges = graph.getEdges();
			var graph2 = s.get(2).getRhs();
			var nodes2 = graph2.getNodes();
			var edges2 = graph2.getEdges();
			var dif = nodes.size() - nodes2.size();
			var dif2 = nodes.size() - nodes2.size();
			//semanticRules.get(0), semanticRules.get(1), root.eClass.EPackage
//			var a = CriticalpairFactoryImpl.init().createCriticalPair();
//			a.setFirstRule(semanticRules.get(0));
//			a.setSecondRule(semanticRules.get(0));
//			a.setMinimalModel(root.eClass.EPackage);
			
			
			
			
			
		}
		_solver.configure(modelGraph, henshinEngine, semanticRules)
	}

	private static class RuleApplicationException extends Exception {
	}

	private static class StepCommand extends RecordingCommand {
		val RuleApplication runner

		new(InternalTransactionalEditingDomain editingDomain, Match match, RuleApplication runner, EGraph model) {
			super(editingDomain, "Run a step using rule " + match.rule.name, 
				'''Runs rule «match.rule.name» from the set of rules provided as the operational semantics for this language.''')
				
			this.runner = runner
			this.runner.EGraph = model
			this.runner.rule = match.rule
			this.runner.completeMatch = match
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
//	private def performStep() {
//		//val match = pickNextMatch
//
//		if (match !== null) {
//			var result = true
//
//			val command = new StepCommand(editingDomain, _selectedLogicalStep.match , ruleRunner, modelGraph)
//			// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
//			val target = _selectedLogicalStep.match.mainObject
//			beforeExecutionStep(_selectedLogicalStep)
//
//			if (command.canExecute) {
//				try {
//					command.execute
//				} catch (RuleApplicationException rae) {
//					editingDomain.activeTransaction.abort(
//						new Status(IStatus.OK,
//							Activator.PLUGIN_ID, '''Error executing semantic rule «_selectedLogicalStep.match.rule.name».'''))
//					result = false
//				}
//			}
//
//			afterExecutionStep
//
//			result
//		} else {
//			false
//		}
//	}

	/**
	 * The object to be used as the fake target when executing this match
	 */
	private def mainObject(Match match) {
		val targetNode = match.rule.lhs.nodes.findFirst [ n |
			n.annotations.exists[a|a.key == "Target"]
		]

		if (targetNode !== null) {
			match.getNodeTarget(targetNode)
		} else {
			root
		}
	}

	/**
	 * Generate a fake operation name to be used when executing this match
	 */
	private def String operationName(Match match) '''
		«match.rule.name»
	'''

	private val rnd = new Random()

	/**
	 * Randomly pick the next rule from those that could be applied
	 */
	private def pickNextMatch() {
		var applicableRules = semanticRules.filter[r|r.checkParamters].toList
		_possibleLogicalSteps = new ArrayList()

		while (!applicableRules.empty) {
			val tentativeStepRule = applicableRules.remove(rnd.nextInt(applicableRules.size))
			val match = henshinEngine.findMatches(tentativeStepRule, modelGraph, null)
						
//			for(Match m: match){
//				//val step = new HenshinStep(m, tentativeStepRule)
//				_possibleLogicalSteps.add(step)
//			}
					
		}

		_possibleLogicalSteps
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
	override protected finishDispose() {
		//throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override protected performStart() {
		engineStatus.setNbLogicalStepRun(0)
		prepareEntryPoint()
		try {
			while (!_isStopped) {
				performExecutionStep();
			}
		} catch (EngineStoppedException ese) {
			throw ese; // forward the stop exception
		} catch (Throwable e) {
			throw new RuntimeException(e);
		}
	}
	
	override protected performStop() {
		setSelectedLogicalHenshinStep(null);
		if (getLogicalStepDecider() != null) {
			// unlock decider if this is a user decider
			getLogicalStepDecider().preempt();
		}	}
	
	override protected performInitialize(IConcurrentExecutionContext executionContext) {
		if (!(executionContext instanceof HenshinConcurrentModelExecutionContext))
			throw new IllegalArgumentException(
					"executionContext must be an HenshinConcurrentExecutionEngine when used in HenshinConcurrentExecutionEngine");

	
	}
	
	override addFutureAction(IFutureAction arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override changeLogicalStepDecider(ILogicalStepDecider newDecider) {
		_logicalStepDecider = newDecider
	}
	
	override getCodeExecutor() {
		return getConcurrentExecutionContext().getExecutionPlatform().getCodeExecutor();
	}
	
	override getConcurrentExecutionContext() {
		return _executionContext
	}
	
	override getLogicalStepDecider() {
		return _logicalStepDecider
	}
	
	override getPossibleLogicalSteps() {
		debug(_possibleLogicalSteps.toString())
		return _possibleLogicalSteps
	}
	
	override getSelectedLogicalStep() {
		synchronized (this) {
			return _selectedLogicalStep
		}
	}
	
	def setSelectedLogicalHenshinStep(HenshinStep ls) {
		synchronized (this) {
			_selectedLogicalStep = ls
		}
	}
	
	override getSolver() {
		return _solver
	}
	
	override setSolver(ISolver solver) {
		_solver = solver as HenshinSolver
	}
	
	override notifyAboutToSelectLogicalStep() {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				addon.aboutToSelectStep(this, getPossibleLogicalSteps());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	override notifyLogicalStepSelected() {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				addon.stepSelected(this, getSelectedLogicalStep());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	override notifyAboutToExecuteLogicalStep(Step<?> l) {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				//addon.aboutToExecuteStep(this, l);
			} catch (EngineStoppedException ese) {
				debug("Addon (" + addon.getClass().getSimpleName() + "@" + addon.hashCode() + ") has received stop command  with message : " + ese.getMessage());
				stop();
				throw ese; // do not continue to execute anything, forward
							// exception
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}

	override notifyLogicalStepExecuted(Step<?> l) {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				addon.aboutToExecuteStep(this, l);
				addon.stepExecuted(this, l);
			} catch (EngineStoppedException ese) {
				debug("Addon (" + addon.getClass().getSimpleName() + "@" + addon.hashCode() + ") has received stop command  with message : " + ese.getMessage());
				stop();
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	override notifyProposedLogicalStepsChanged() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	
	override computePossibleLogicalSteps() {
		//HERE USE HENSHIN TO CALCULATE STEPS
//		var applicableRules = semanticRules.filter[r|r.checkParamters].toList
//		_possibleLogicalSteps = new ArrayList()
//
//		while (!applicableRules.empty) {
//			val tentativeStepRule = applicableRules.remove(rnd.nextInt(applicableRules.size))
//			val match = henshinEngine.findMatches(tentativeStepRule, modelGraph, null)
//						
//			for(Match m: match){
//				val step = new HenshinStep(m,tentativeStepRule)
//				_possibleLogicalSteps.add(step)
//				debug(step.toString())
//			}
//					
//		}
		_possibleLogicalSteps = getSolver().computeAndGetPossibleLogicalSteps();
	
	}
	
	//i think not needed
	override updatePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override performExecutionStep() throws InterruptedException {
		//switchDeciderIfNecessary();
		computePossibleLogicalSteps();
		//updatePossibleLogicalSteps();
		
		// 2- select one solution from available logical step /
		// select interactive vs batch
		if (_possibleLogicalSteps.size() == 0) {
			debug("No more LogicalStep to run")
			stop();
		} else {
			// Activator.getDefault().debug("\t\t ---------------- LogicalStep "
			// + count);
			val selectedLogicalStep = selectAndExecuteLogicalStep();
			debug("executed")
			debug(modelGraph.toString())
			// 3 - run the selected logical step
			// inform the solver that we will run this step
			if (selectedLogicalStep != null) {
				//no solver for now
				//(getSolver() as HenshinSolver).applyHenshinStep(selectedLogicalStep as HenshinStep);

// only for testing purpose
//				List<fr.inria.aoste.timesquare.instantrelation.CCSLRelationModel.OccurrenceRelation> res = getSolver().getLastOccurrenceRelations();
//				System.out.println("/********************DEBUG OCCURRENCE RELATIONS****************\n*  "
//						+res
//						+"\n**********************************************************/");
				
				engineStatus.incrementNbLogicalStepRun();
			} else {
				// no logical step was selected, this is most probably due to a
				// preempt on the LogicalStepDecider and a change of Decider,
				// notify Addons that we'll rerun this ExecutionStep
				// recomputePossibleLogicalSteps();
			}
		}
	}
	
	def selectAndExecuteLogicalStep() {
		setEngineStatus(EngineStatus.RunStatus.WaitingLogicalStepSelection);
		notifyAboutToSelectLogicalStep();
		
		val selectedLogicalStep = getLogicalStepDecider().decide(this, getPossibleLogicalSteps());
		val r = getCodeExecutor();
		
		if (selectedLogicalStep != null) {
			setSelectedLogicalHenshinStep(selectedLogicalStep as HenshinStep);
						
			setEngineStatus(EngineStatus.RunStatus.Running);
			//notifyLogicalStepSelected();
			// run all the event occurrences of this logical
			// steprent 
			if((selectedLogicalStep as HenshinStep).matches === null || ((selectedLogicalStep as HenshinStep).matches).isEmpty){
				executeSelectedLogicalStep();
			}else{
				for(Step step : getPossibleLogicalSteps()){
					var s = step as HenshinStep
					if((s.matches === null || s.matches.isEmpty) && (selectedLogicalStep as HenshinStep).matches.contains(s.match)){
						executeStep(s);
						
					}
				}
			}
		}
		return selectedLogicalStep;
	}
	
		def executeStep(HenshinStep step) {
		if (!_isStopped) { 
			val command = new StepCommand(editingDomain, step.match , ruleRunner, modelGraph)
			// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
			val target = step.match.mainObject
			beforeExecutionStep(step,command);
			//beforeExecutionStep(_selectedLogicalStep);

			if (command.canExecute) {
				try {
					command.execute
				} catch (RuleApplicationException rae) {
					editingDomain.activeTransaction.abort(
						new Status(IStatus.OK,
							Activator.PLUGIN_ID, '''Error executing semantic rule «step.match.rule.name».'''))
				}
			}

			afterExecutionStep()


		} else {
			
			afterExecutionStep();
		}
	}
	
	override executeSelectedLogicalStep() {
		// = step in debug mode, goes to next logical step
		// -> run all event occurrences of the logical step
		// step into / open internal thread and pause them
		// each concurrent event occurrence is presented as a separate
		// thread in the debugger
		// execution feedback is sent to the solver so it can take internal
		// event into account

		if (!_isStopped) { // execute while stopped may occur when we push the
							// stop button when paused in the debugger
			
			//perform HENSHIN!! step
//			val TransactionalEditingDomain editingDomainn = TransactionalEditingDomain.Factory.INSTANCE
//					.getEditingDomain(getExecutionContext().getResourceModel().getResourceSet());
//			var e = editingDomain
//			var a = editingDomain.getResourceSet()
			val command = new StepCommand(editingDomain, _selectedLogicalStep.match , ruleRunner, modelGraph)
			// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
			val target = _selectedLogicalStep.match.mainObject
			beforeExecutionStep(_selectedLogicalStep,command);
			//beforeExecutionStep(_selectedLogicalStep);

			if (command.canExecute) {
				try {
					command.execute
				} catch (RuleApplicationException rae) {
					editingDomain.activeTransaction.abort(
						new Status(IStatus.OK,
							Activator.PLUGIN_ID, '''Error executing semantic rule «_selectedLogicalStep.match.rule.name».'''))
				}
			}

			afterExecutionStep()


		} else {
			
			afterExecutionStep();
		}
	}
	
	override recomputePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override setSelectedLogicalStep(Step<?> selectedLogicalStep) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	def protected void debug(String message) {
		getMessagingSystem().debug(message, getPluginID());
	}

	def getMessagingSystem() {
		return Activator.getDefault().getMessaggingSystem();
	}
	def String getPluginID() {
		return Activator.PLUGIN_ID;
	}
	
	override protected beforeStart() {
		debug('before start engine')
	}
	
}
