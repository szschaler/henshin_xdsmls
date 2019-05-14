package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.util

import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.henshin.cpa.CPAOptions
import org.eclipse.emf.henshin.cpa.CpaByAGG
import org.eclipse.emf.henshin.cpa.result.CriticalElement
import org.eclipse.emf.henshin.cpa.result.CriticalPair
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.model.Attribute
import org.eclipse.emf.henshin.model.Edge
import org.eclipse.emf.henshin.model.GraphElement
import org.eclipse.emf.henshin.model.Node
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.xtend.lib.annotations.Data

/**
 * Helper methods for analysing rules using Critical Pair Information
 */
class CPAHelper {
	@Data
	private static class Pair<T, U> {
		val T first
		val U second
	}

	val Map<Pair<Rule, Rule>, List<CriticalPair>> conflictIndex = new HashMap

	new(Set<Rule> rules) {
		// Run Critical-Pair Analysis
		val cpa = new CpaByAGG()
		cpa.init(rules.toList, new CPAOptions())
		var result = cpa.runConflictAnalysis()
		// FIXME: With Henshin 1.5, can do: val criticalPairs = result.initialCriticalPairs
		val criticalPairs = result.criticalPairs

		criticalPairs.forEach [ cp |
			val rulePair = new Pair(cp.firstRule, cp.secondRule)
			var pairIndex = conflictIndex.get(rulePair)
			if (pairIndex === null) {
				pairIndex = new ArrayList
				conflictIndex.put(rulePair, pairIndex)
			}

			pairIndex.add(cp)
		]
	}

	/**
	 * Return true if the two matches are not parallely independent / locally confluent
	 */
	def conflictsWith(Match m1, Match m2) {
		val rule1 = m1.rule
		val rule2 = m2.rule

		val conflicts12 = conflictIndex.get(new Pair(rule1, rule2))
		val conflicts21 = conflictIndex.get(new Pair(rule2, rule1))

		((conflicts12 !== null) && conflicts12.exists[cp|cp.showsConflictFor(m1, m2)]) ||
			((conflicts21 !== null) && conflicts21.exists[cp|cp.showsConflictFor(m2, m1)])
	}

	/**
	 * Check if the two matches are in conflict according to the given critical pair
	 */
	private def showsConflictFor(CriticalPair cp, Match m1, Match m2) {
		cp.criticalElements.forall[ce|ce.hasMatchingOverlap(m1, m2)]
	}

	/**
	 * Check if the elements marked as overlapping by the given critical element also overlap in the two matches
	 */
	private def boolean hasMatchingOverlap(CriticalElement ce, Match m1, Match m2) {
		ce.elementInFirstRule.hasMatchingOverlap(m1, ce.elementInSecondRule, m2)
	}

	private dispatch def boolean hasMatchingOverlap(GraphElement ge1, Match m1, GraphElement ge2, Match m2) {
		false
	}

	private dispatch def boolean hasMatchingOverlap(Node n1, Match m1, GraphElement ge2, Match m2) {
		m1.getNodeTarget(n1) === m2.getNodeTarget(ge2 as Node)
	}

	private dispatch def boolean hasMatchingOverlap(Edge e1, Match m1, GraphElement ge2, Match m2) {
		val e2 = ge2 as Edge

		if (e1.type === e2.type) {
			e1.source.hasMatchingOverlap(m1, e2.source, m2) && e1.target.hasMatchingOverlap(m1, e2.target, m2)
		} else {
			throw new IllegalArgumentException
		}
	}

	private dispatch def boolean hasMatchingOverlap(Attribute a1, Match m1, GraphElement ge2, Match m2) {
		val a2 = ge2 as Attribute

		if (a1.type === a2.type) {
			a1.node.hasMatchingOverlap(m1, a2.node, m2)
		} else {
			throw new IllegalArgumentException
		}	
	}
}
