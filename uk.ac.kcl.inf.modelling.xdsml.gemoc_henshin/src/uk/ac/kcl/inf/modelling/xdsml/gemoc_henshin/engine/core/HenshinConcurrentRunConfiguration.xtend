package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentRunConfiguration
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.core.runtime.CoreException

class HenshinConcurrentRunConfiguration extends ConcurrentRunConfiguration {
	
	public static final String maxNumberOfStepsHeuristicID = "uk.ac.kcl.inf.xdsml.heuristics.num_steps";
	public static final String overlapHeuristicID = "uk.ac.kcl.inf.xdsml.heuristics.overlap";
	public static final String fullyOverlapHeuristicID = "uk.ac.kcl.inf.xdsml.heuristics.full_overlap";
	public static final String setOfRulesHeuristicID = "uk.ac.kcl.inf.xdsml.heuristics.set_of_rules";
	
	new(ILaunchConfiguration launchConfiguration) throws CoreException {
		super(launchConfiguration)
	}
	
	var boolean maxNumberOfStepsHeuristic;
	var boolean overlapHeuristic;
	var boolean fullyOverlapHeuristic;
	var boolean setOfRulesHeuristic;
	
	def boolean getMaxNumberOfStepsHeuristic() {
		return maxNumberOfStepsHeuristic
	}
	
	def boolean getOverlapHeuristic() {
		return overlapHeuristic
	}
	
	def boolean getFullyOverlapHeuristic() {
		return fullyOverlapHeuristic
	}
	
	def boolean getSetOfRulesHeuristic() {
		return setOfRulesHeuristic
	}
	
	override extractInformation() throws CoreException {
		super.extractInformation();
		maxNumberOfStepsHeuristic = getAttribute(maxNumberOfStepsHeuristicID, Boolean.FALSE);
		overlapHeuristic = getAttribute(overlapHeuristicID, Boolean.FALSE);
		fullyOverlapHeuristic = getAttribute(fullyOverlapHeuristicID, Boolean.FALSE);
		setOfRulesHeuristic = getAttribute(setOfRulesHeuristicID, Boolean.FALSE);
	}
}
