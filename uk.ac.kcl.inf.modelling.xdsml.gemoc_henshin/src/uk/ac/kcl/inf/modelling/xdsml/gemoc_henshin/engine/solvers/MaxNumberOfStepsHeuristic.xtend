package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers

import java.util.ArrayList
import java.util.List
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.gemoc.trace.commons.model.trace.Step
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep

class MaxNumberOfStepsHeuristic implements FilteringHeuristic {

	var int maxNumberOfSteps

	new(int maxNumberOfSteps) {
		super()
		this.maxNumberOfSteps = maxNumberOfSteps
	}
	new() {
		super()
		maxNumberOfSteps = 2
	}

	override List<Step<?>> filter(List<Step<?>> steps) {
		var validSteps = new ArrayList<Step<?>>()

		for (Step<?> s : steps) {
			val hs = s as HenshinStep
			if (hs.matches !== null && hs.matches.length > maxNumberOfSteps) {
				var newSteps = new ArrayList<List<Match>>();
				generateSteps(
					hs.matches,
					newSteps,
					new ArrayList<Match>
				)
				validSteps.addAll(newSteps.map[step|new HenshinStep(step)])
			} else {
				validSteps.add(s)
			}
		}

		validSteps.removeDuplicates
	}

	/**
	 * Recursively produce all match sets of the given size from the list of matches and add to steps
	 */
	def void generateSteps(List<Match> matches, List<List<Match>> steps, List<Match> currentList) {
		if (currentList.size == maxNumberOfSteps) {
			steps.add(new ArrayList<Match>(currentList))
			return
		}

		matches.forEach[m, idx|
			currentList.add(m)
			
			generateSteps(matches.subList(idx + 1, matches.size), steps, currentList)
			
			currentList.remove(currentList.size - 1)			
		]
	}

	/**
	 * Remove all duplicate steps from the list.
	 * 
	 * FIXME: Not the most efficient implementation yet, and I suspect it will break if there 
	 * are multiple matches for the same rule that can be run in parallel
	 */
	def List<Step<?>> removeDuplicates(List<Step<?>> steps) {
		steps.fold(new ArrayList<Step<?>>, [list, s |
			val hs = s as HenshinStep 
			if (!list.exists[s2 |
				val hs2 = s2 as HenshinStep 
				
				((hs.match !== null) && (hs.match === hs2.match)) ||
				((hs.matches !== null) && (hs.matches.sortBy[m | m.rule.name] == hs2.matches.sortBy[m | m.rule.name]))])
				list.add(s) 

			list
		]).toList
	}
}
