package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.util.List
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
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.emf.transaction.impl.InternalTransactionalEditingDomain
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator;
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionContext
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentExecutionEngine
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IConcurrentRunConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.IFutureAction
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.core.ILogicalStepDecider
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.moc.ISolver
import org.eclipse.gemoc.executionframework.engine.core.AbstractExecutionEngine
import org.eclipse.gemoc.trace.commons.model.trace.Step

import static extension uk.ac.kcl.inf.modelling.xdsml.HenshinXDsmlSpecificationHelper.*
import java.util.ArrayList
import org.eclipse.gemoc.xdsmlframework.api.core.EngineStatus
import org.eclipse.gemoc.executionframework.engine.core.EngineStoppedException
import org.eclipse.gemoc.xdsmlframework.api.engine_addon.IEngineAddon
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.HenshinSolver

class HenshinConcurrentExecutionEngine extends AbstractExecutionEngine<IConcurrentExecutionContext, IConcurrentRunConfiguration> implements IConcurrentExecutionEngine {

	val Engine henshinEngine = new EngineImpl
	val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)
	

	var EObject root
	var EGraph modelGraph
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
		
		// Load rules and units
		// We assume entryPoint to be a string with the full workspace path to a file identifying the semantics Henshin rules
		// We expect this to be a resource that contains a HenshinXDsmlSpecification or a Henshin model directly
		val entryPoint = _executionContext.runConfiguration.languageName
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
		if (getLogicalStepDecider() !== null) {
			// unlock decider if this is a user decider
			getLogicalStepDecider().preempt();
		}	
	}
	
	override protected performInitialize(IConcurrentExecutionContext executionContext) {
		if (!(executionContext instanceof HenshinConcurrentModelExecutionContext))
			throw new IllegalArgumentException(
					"executionContext must be an HenshinConcurrentExecutionEngine when used in HenshinConcurrentExecutionEngine");
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
		debug("selected");
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				addon.stepSelected(this, getSelectedLogicalStep());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	//code that should be here commented out for now coz of GEMOC architecture
	override notifyAboutToExecuteLogicalStep(Step<?> l) {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				//addon.aboutToExecuteStep(this, l);
			} catch (EngineStoppedException ese) {
				debug("Addon (" + addon.getClass().getSimpleName() + "@" + addon.hashCode() + ") has received stop command  with message : " + ese.getMessage());
				stop();
				throw ese; 
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}

	//code moved here from notifyAboutToExecuteLogicalStep
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
		_possibleLogicalSteps = getSolver().computeAndGetPossibleLogicalSteps();
	}
	
	override updatePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override performExecutionStep() throws InterruptedException {
		computePossibleLogicalSteps();
		
		// 2- select one solution from available logical step /
		// select interactive vs batch
		if (_possibleLogicalSteps.size() == 0) {
			debug("No more LogicalSteps to run")
			stop();
		} else {
			val selectedLogicalStep = selectAndExecuteLogicalStep();

			// 3 - run the selected logical step
			// inform the solver that we will run this step
			if (selectedLogicalStep !== null) {
				
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
		
		if (selectedLogicalStep !== null) {
			setSelectedLogicalHenshinStep(selectedLogicalStep as HenshinStep);
						
			setEngineStatus(EngineStatus.RunStatus.Running);
			notifyLogicalStepSelected();
			// run all the event occurrences of this logical
			// step 
			if((selectedLogicalStep as HenshinStep).matches === null || ((selectedLogicalStep as HenshinStep).matches).isEmpty){
				executeSelectedLogicalStep();
			}else{
				for(Step<?> step : getPossibleLogicalSteps()){
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
			val command = new StepCommand(editingDomain, _selectedLogicalStep.match , ruleRunner, modelGraph)
			// We're faking the class and operation names so that GEMOC can do its step tracing even though we're not actually calling operations 
			
			beforeExecutionStep(_selectedLogicalStep,command);
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
		debug('Running engine setup...')
	}
	override protected finishDispose() {
	}
	override addFutureAction(IFutureAction arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
