package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics

import java.beans.PropertyChangeListener
import java.util.List
import org.eclipse.emf.ecore.EPackage

interface LaunchConfigurationContext {
	/**
	 * Return the metamodel currently specified in the launch configuration, if any. 
	 * 
	 * Multiple calls will return the same result unless the user has made a change to their selection in the meantime.
	 */
	def List<EPackage> getMetamodels()
	
	def void addMetamodelChangeListener(PropertyChangeListener pcl)
}
