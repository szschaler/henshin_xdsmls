package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import fr.inria.diverse.melange.adapters.EObjectAdapter
import java.util.List
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.emf.common.util.URI
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

/**
 * Henshin Concurrent Execution Engine implementation class that handles the main workflow
 */
class HenshinConcurrentExecutionEngine extends AbstractExecutionEngine<IConcurrentExecutionContext, IConcurrentRunConfiguration> implements IConcurrentExecutionEngine {

	val Engine henshinEngine = new EngineImpl
	val RuleApplication ruleRunner = new RuleApplicationImpl(henshinEngine)
	var EGraph modelGraph
	
	var ILogicalStepDecider _logicalStepDecider
	var HenshinStep _selectedLogicalStep;
	var HenshinSolver _solver;
	var List<Step<?>> _possibleLogicalSteps = new ArrayList()
	/**
	 * create a new instance
	 * @param concurrent context and a Hensin Solver
	 */
	new(IConcurrentExecutionContext concurrentexecutionContext, HenshinSolver s) {
		super();
		initialize(concurrentexecutionContext);
		_logicalStepDecider = concurrentexecutionContext.getLogicalStepDecider()
		_solver = s
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
	protected def void prepareEntryPoint() {
		
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
		var List<Rule> semanticRules

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
		
		//configure the solver, modified for the concurrent engine
		_solver.configure(modelGraph, henshinEngine, semanticRules)
	}

	private static class RuleApplicationException extends Exception {
	}
	/**
	 * StepCommand to run the execution steps in Henshin
	 * code taken from the sequential engine(Zschaler)
	 */
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
	 * the main loop of execution
	 */
	override protected performStart() {
		engineStatus.setNbLogicalStepRun(0)
		prepareEntryPoint()
		try {
			while (!_isStopped) {
				performExecutionStep();
			}
		} catch (EngineStoppedException ese) {
			throw ese;
		} catch (Throwable e) {
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * stop the engine
	 */
	override protected performStop() {
		setSelectedLogicalHenshinStep(null);
		if (getLogicalStepDecider() !== null) {
			// unlock decider if this is a user decider
			getLogicalStepDecider().preempt();
		}	
	}
	/**
	 * initialize the engine, make sure a Henshin Model Execution Context is used
	 * @param execution context
	 */
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
	
	/**
	 * set the selected Henshin Step
	 * @param henshin step
	 */
	def setSelectedLogicalHenshinStep(HenshinStep step) {
		synchronized (this) {
			_selectedLogicalStep = step
		}
	}
	
	override getSolver() {
		return _solver
	}
	
	override setSolver(ISolver solver) {
		_solver = solver as HenshinSolver
	}
	/**
	 * notify the addons about the state of execution: about to select step
	 * code taken from the concurrent ccsl engine
	 */
	override notifyAboutToSelectLogicalStep() {
		for (IEngineAddon addon : getExecutionContext().getExecutionPlatform().getEngineAddons()) {
			try {
				addon.aboutToSelectStep(this, getPossibleLogicalSteps());
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	/**
	 * notify the addons about the state of execution:  step selected
	 * code taken from the concurrent ccsl engine
	 */
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
	
	/**
	 * notify the addons about the state of execution: about to execute step
	 * the code is commented out due to the bug that was found
	 * it should be uncommented after the fix is implemented by GEMOC
	 * except for the modification, code taken from the concurrent ccsl engine
	 */	
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

	/**
	 * notify the addons about the state of execution: step executed
	 * code moved here from notifyAboutToExecuteLogicalStep
	 * to be deleted when GEMOC implements a fix
	 * except for the modification, code taken from the concurrent ccsl engine
	 */
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
	
	/**
	 * get a list of possible steps from the solver
	 */
	override computePossibleLogicalSteps() {
		_possibleLogicalSteps = getSolver().computeAndGetPossibleLogicalSteps();
	}
	
	override updatePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	/**
	 * perform one step of execution
	 * close the engine if no more steps to choose
	 */
	override performExecutionStep() throws InterruptedException {
		computePossibleLogicalSteps();
		
		if (_possibleLogicalSteps.size() == 0) {
			debug("No more LogicalSteps to run")
			stop();
		} else {
			val selectedLogicalStep = selectAndExecuteLogicalStep();
			
			if (selectedLogicalStep !== null) {
				engineStatus.incrementNbLogicalStepRun();
			}
		}
	}
	
	/**
	 * select a step through a logical decider
	 * and run the execution
	 */
	def selectAndExecuteLogicalStep() {
		setEngineStatus(EngineStatus.RunStatus.WaitingLogicalStepSelection)
		notifyAboutToSelectLogicalStep()
		
		val selectedLogicalStep = getLogicalStepDecider().decide(this, getPossibleLogicalSteps())
		if (selectedLogicalStep !== null) {
			setSelectedLogicalHenshinStep(selectedLogicalStep as HenshinStep)
						
			setEngineStatus(EngineStatus.RunStatus.Running)
			notifyLogicalStepSelected()
			
			//if it's a single rule step execute otherwise execute the whole sequence
			if((selectedLogicalStep as HenshinStep).matches === null || ((selectedLogicalStep as HenshinStep).matches).isEmpty){
				executeSelectedLogicalStep()
			}else{
				for(Step<?> step : getPossibleLogicalSteps()){
					var s = step as HenshinStep
					if((s.matches === null || s.matches.isEmpty) && (selectedLogicalStep as HenshinStep).matches.contains(s.match)){
						setSelectedLogicalHenshinStep(s)
						executeSelectedLogicalStep()
					}
				}
			}
			
		}
		selectedLogicalStep
	}
	/**
	 * execute the selected step by creating a new step command
	 * and delegating the execution to Henshin
	 */
	override executeSelectedLogicalStep() {
		if (!_isStopped) {
			val command = new StepCommand(editingDomain, _selectedLogicalStep.match , ruleRunner, modelGraph)
			beforeExecutionStep(_selectedLogicalStep,command)
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
			afterExecutionStep()
		}
	}
	
	override recomputePossibleLogicalSteps() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override setSelectedLogicalStep(Step<?> selectedLogicalStep) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	/**
	 * print a debug message to console
	 */
	def protected void debug(String message) {
		getMessagingSystem().debug(message, getPluginID());
	}
	
	/**
	 * get messaging system
	 */
	def getMessagingSystem() {
		return Activator.getDefault().getMessaggingSystem();
	}
	
	/**
	 * get plugin id
	 */
	def String getPluginID() {
		return Activator.PLUGIN_ID;
	}
	
	/**
	 * run before start of the engine
	 */
	override protected beforeStart() {
		debug('Running engine setup...')
	}
	
	/**
	 * execution of the engine done
	 */
	override protected finishDispose() {
	}
	
	override addFutureAction(IFutureAction arg0) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
