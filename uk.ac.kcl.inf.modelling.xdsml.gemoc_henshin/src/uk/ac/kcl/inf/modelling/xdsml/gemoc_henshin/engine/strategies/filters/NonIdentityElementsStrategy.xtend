package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.filters

import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.gemoc.trace.commons.model.generictrace.GenericParallelStep
import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.xtend.lib.annotations.Accessors
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.FilteringStrategy

/**
 * Remove steps that differ only in objects of a specific type -- specify that objects of that type are not considered to have identity (e.g., parts in the PLS example).
 * 
 * This is a filtering strategy to allow it to interact with concurrency computation to recognise that it is still meaningful to have two potentially concurrent applications 
 * of assemble (in the PLS case), for example. It's just not meaningful to have four ``different'' atomic assemble steps where there is only one machine. Hence, this is a filtering
 * strategy that needs to be applied after all possible concurrent executions have been computed.
 */
class NonIdentityElementsStrategy implements FilteringStrategy {

	/**
	 * Objects of these types should not be considered to have independent identity. So, while we can require to match multiple, distinct objects in one rule match, two rule matches 
	 * should only be considered different if they differ in matches for objects that are not of one of these types.
	 */
	@Accessors
	var List<? extends EClass> nonIdentityTypes

	new() {
		nonIdentityTypes = emptyList
	}

	new(List<? extends EClass> nonIdentityTypes) {
		this.nonIdentityTypes = nonIdentityTypes
	}

	override filter(List<Step<?>> steps) {
		val filteredStepsHolder = #[new ArrayList<Step<?>>]

		steps.forEach [ s, idx |
			if (s.isUniqueIn(steps.subList(idx + 1, steps.size))) {
				// Keep the step
				filteredStepsHolder.get(0).add(s)
			}
		]

		filteredStepsHolder.get(0)
	}

	private def isUniqueIn(Step<?> s, List<Step<?>> steps) {
		!steps.exists[s2|equivalentSteps(s, s2)]
	}

	private def equivalentSteps(Step<?> s1, Step<?> s2) {
		if (s1 instanceof HenshinStep) {
			if (s2 instanceof HenshinStep) {
				return equivalentMatches(s1.match, s2.match)
			}
		} else if (s1 instanceof GenericParallelStep) {
			if (s2 instanceof GenericParallelStep) {
				if (s1.subSteps.size == s2.subSteps.size) {
					// TODO This can probably be done more efficiently
					return s1.subSteps.forall[ss1 | s2.subSteps.exists[ss2 | equivalentMatches((ss1 as HenshinStep).match, (ss2 as HenshinStep).match)]] &&
						s2.subSteps.forall[ss2 | s1.subSteps.exists[ss1 | equivalentMatches((ss1 as HenshinStep).match, (ss2 as HenshinStep).match)]]
				}
			}
		}
		
		false
	}

	private def equivalentMatches(Match m1, Match m2) {
		(m1 === m2) || (m1.equals(m2) && m2.equals(m1)) || // Doing this both ways because I'm not convinced that Match::equals is actually symmetric
		((m1.rule === m2.rule) && m1.rule.lhs.nodes.forall [ n |
			n.type.isNonIdentityType || (m1.getNodeTarget(n) === m2.getNodeTarget(n))
		])
	}

	private def isNonIdentityType(EClass type) {
		nonIdentityTypes.exists[nit|(nit === type) || nit.isSuperTypeOf(type)]
	}
}
