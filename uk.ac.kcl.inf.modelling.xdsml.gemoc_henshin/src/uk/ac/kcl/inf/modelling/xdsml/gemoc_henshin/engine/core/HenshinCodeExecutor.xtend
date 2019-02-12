package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.ICodeExecutor
import org.eclipse.gemoc.trace.commons.model.trace.MSEOccurrence
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.dsa.executors.CodeExecutionException
import java.util.List
import java.lang.annotation.Annotation
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator

class HenshinCodeExecutor implements ICodeExecutor {
	new(){
		super()
	}
	
	override execute(MSEOccurrence mseOccurrence) throws CodeExecutionException {
		debug("execute mseo")
		return null	
	}
	
	override execute(Object caller, String methodName, List<Object> parameters) throws CodeExecutionException {
		debug("execute")
		return null
	}
	
	override findCompatibleMethodsWithAnnotation(Object caller, List<Object> parameters, Class<? extends Annotation> annotationClass) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getExcutorID() {
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
	
}
