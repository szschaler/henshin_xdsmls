package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.concurrency

import java.util.List
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.xtend.lib.annotations.Accessors
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.strategies.ConcurrencyStrategy

class SetOfRulesStrategy implements ConcurrencyStrategy {

	@Accessors
	var List<Rule> rules

	new(List<Rule> rules) {
		super()
		this.rules = rules;
	}

	new() {
		this(emptyList)
	}

	override boolean canBeConcurrent(Match match1, Match match2) {
		rules.contains(match1.rule) && rules.contains(match2.rule)
	}
}
