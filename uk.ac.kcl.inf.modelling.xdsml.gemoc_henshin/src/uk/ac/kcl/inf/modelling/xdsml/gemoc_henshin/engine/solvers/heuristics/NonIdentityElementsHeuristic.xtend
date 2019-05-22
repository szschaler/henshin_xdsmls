package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics

import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.gemoc.trace.commons.model.trace.Step
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core.HenshinStep

/**
 * Remove steps that differ only in objects of a specific type -- specify that objects of that type are not considered to have identity (e.g., parts in the PLS example).
 * 
 * This is a filtering heuristic to allow it to interact with concurrency computation to recognise that it is still meaningful to have two potentially concurrent applications 
 * of assemble (in the PLS case), for example. It's just not meaningful to have four ``different'' atomic assemble steps where there is only one machine. Hence, this is a filtering
 * heuristic that needs to be applied after all possible concurrent executions have been computed.
 */
class NonIdentityElementsHeuristic implements FilteringHeuristic {

	/**
	 * Objects of these types should not be considered to have independent identity. So, while we can require to match multiple, distinct objects in one rule match, two rule matches 
	 * should only be considered different if they differ in matches for objects that are not of one of these types.
	 */
	val List<? extends EClass> nonIdentityTypes

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
		val hs1 = s1 as HenshinStep
		val hs2 = s2 as HenshinStep

		if (((hs1.match !== null) && (hs2.match === null)) || ((hs2.match !== null) && (hs1.match === null))) {
			return false
		} else if (hs1.match === null) {
			if (hs1.matches.size != hs2.matches.size) {
				return false
			} else {
				// TODO This can probably be done more efficiently
				return hs1.matches.forall[m1 | hs2.matches.exists[m2 | equivalentMatches(m1, m2)]] &&
					hs2.matches.forall[m2 | hs1.matches.exists[m1 | equivalentMatches(m1, m2)]]
			}
		} else {
			return equivalentMatches(hs1.match, hs2.match)
		}
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
