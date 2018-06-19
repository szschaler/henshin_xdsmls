package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine

import org.eclipse.gemoc.executionframework.engine.core.AbstractSequentialExecutionEngine
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionContext

class HenshinExecutionEngine extends AbstractSequentialExecutionEngine  {
	
	protected override void executeEntryPoint() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
		
		// TODO: Actually implement execution loop
	}
	
	protected override void prepareInitializeModel(IExecutionContext executionContext) {}

	protected override void initializeModel() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
		// TODO: Set up Henshin engine and load relevant units making up the operational semantics
	}

	protected override void prepareEntryPoint(IExecutionContext executionContext) {}


	/**
	 * get the engine kind name
	 * @return a user display name for the engine kind (will be used to compute
	 *         the full name of the engine instance)
	 */
	override String engineKindName() '''Henshin xDSML Engine'''
}