package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.concurrency

import java.util.List
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.model.Rule
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solver.heuristics.ConcurrencyHeuristic

class SetOfRulesHeuristic implements ConcurrencyHeuristic {

	var List<Rule> rules

	new(List<Rule> rules) {
		super()
		this.rules = rules;
	}

	override boolean canBeConcurrent(Match match1, Match match2) {
		rules.contains(match1.rule) && rules.contains(match2.rule)
	}
}
