package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.ICodeExecutor
import org.eclipse.gemoc.trace.commons.model.trace.MSEOccurrence
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.CodeExecutionException
import java.util.List
import java.lang.annotation.Annotation

/**
 * code executor - empty shell as the concurrent engine requires it for the execution of steps
 * but in case of Henshin, execution is delegated to Henshin in the actual engine class so 
 * this class remains empty
 */
class HenshinCodeExecutor implements ICodeExecutor {
	new(){
		super()
	}
	
	override execute(MSEOccurrence mseOccurrence) throws CodeExecutionException {
		return null	
	}
	
	override execute(Object caller, String methodName, List<Object> parameters) throws CodeExecutionException {
		return null
	}
	
	override findCompatibleMethodsWithAnnotation(Object caller, List<Object> parameters, Class<? extends Annotation> annotationClass) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getExcutorID() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}
