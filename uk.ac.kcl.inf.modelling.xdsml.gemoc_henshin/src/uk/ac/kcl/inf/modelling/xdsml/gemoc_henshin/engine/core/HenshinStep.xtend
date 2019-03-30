package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.gemoc.trace.commons.model.generictrace.impl.GenericSmallStepImpl
import org.eclipse.gemoc.trace.commons.model.trace.TracePackage

class HenshinStep extends GenericSmallStepImpl {
	
	protected Match match
	protected List<Match> matches

	new(Match match) {
		super()
		this.match = match
	}
	new(List<Match> matches) {
		super()
		this.matches = matches
	}
	
	//create it on the fly each time it's called 
		//so simulate creating MSE object -> with operation same name as rule name
		//create mse occurrence -> all objects except for the main object
		//to create mseoccurrence use factory class generated from an ecore file
		
	override getMseoccurrence() {
		if(matches === null || matches.isEmpty){
			generateMSE(match, match.getRule().getName(), match.toString())
		}else{
			var rulesNames = ''
			for(Match m: matches){
				var r = m.getRule();
				rulesNames = rulesNames + ' ' + r.getName()
			}
			generateMSE(matches.get(0), rulesNames, rulesNames)
		}
	}
	
	def generateMSE(Match match, String name, String name2){
		val mse = TracePackage::eINSTANCE.traceFactory.createGenericMSE()
		mse.setCallerReference(match.mainObject)
		val eo = EcoreFactory.eINSTANCE.createEOperation()
		eo.setName(name)
		mse.setActionReference(eo);
		mse.setName(name2)

		val mseoc = TracePackage::eINSTANCE.traceFactory.createMSEOccurrence()
		mseoc.setMse(mse)
		for(EObject e: match.getNodeTargets()){
			mseoc.parameters.add(e)
		}
		mseoc
	}		
	
	private def mainObject(Match match) {
		val targetNode = match.rule.lhs.nodes.findFirst [ n |
			n.annotations.exists[a|a.key == "Target"]
		]

		if (targetNode !== null) {
			match.getNodeTarget(targetNode)
		} else {
			null
		}
	}
}