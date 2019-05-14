package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import java.util.List
import org.eclipse.gemoc.trace.commons.model.trace.Step
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import java.util.ArrayList
import org.eclipse.emf.henshin.interpreter.Match

class maxNumberOfStepsHeuristic implements FilteringHeuristic {
	
	var int maxNumberOfSteps
	
	new(int maxNumberOfSteps){
		super()
		this.maxNumberOfSteps = maxNumberOfSteps
	}
	
	override List<Step<?>> filter(List<Step<?>> steps){
		var validSteps = new ArrayList<Step<?>>()
		
		for(Step<?> s: steps){
			val hs = s as HenshinStep
			if(hs.matches !== null && hs.matches.length > maxNumberOfSteps){
				var newSteps = new ArrayList<List<Match>>();
				generateSteps(hs.matches, newSteps, 0, hs.matches.length, new ArrayList<Match>
				)
				validSteps.addAll(newSteps.map[step | new HenshinStep(step)])
			}else{
				validSteps.add(s)
			}
		}
		validSteps
	}
	
	def void generateSteps(List<Match> matches, List<List<Match>> steps, int start, int end, List<Match> currentList) {
		if (currentList.size() == maxNumberOfSteps) {
			steps.add(new ArrayList<Match>(currentList));
			return;
		}
 
		for (var i = start; i < end; i++) {
			currentList.add(matches.get(i));
			generateSteps(matches, steps, start + 1, end, currentList);
			currentList.remove(currentList.size() - 1);
		}
	}
}