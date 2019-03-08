package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.gemoc.trace.commons.model.trace.Step
import org.eclipse.gemoc.trace.commons.model.trace.State
import org.eclipse.gemoc.trace.commons.model.trace.MSEOccurrence
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.common.util.EList
import java.lang.reflect.InvocationTargetException
import org.eclipse.emf.common.notify.Notification
import org.eclipse.emf.transaction.impl.InternalTransactionalEditingDomain
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.emf.henshin.interpreter.RuleApplication
import org.eclipse.emf.henshin.interpreter.EGraph
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.impl.EClassImpl
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.trace.commons.model.trace.SmallStep
import org.eclipse.gemoc.trace.commons.model.generictrace.impl.GenericStepImpl
import org.eclipse.gemoc.trace.commons.model.generictrace.impl.GenericSmallStepImpl
import org.eclipse.gemoc.trace.commons.model.trace.TracePackage
import org.eclipse.emf.ecore.impl.EcoreFactoryImpl
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.ecore.EObject
import java.util.List

class HenshinStep extends GenericSmallStepImpl {
	
		public Match match
		public Rule rule
		public List<Rule> rules

		new(Match match, Rule rule) {
			super()
			//this.runner = runner
			//this.runner.EGraph = model
			//this.runner.rule = match.rule
			this.match = match
			this.rule = rule
		}
		new(List<Rule> rules, Match match) {
			super()
			this.rules = rules;
			this.match = match
		}
		
		override getMseoccurrence() {
			//create it on the fly each time it's called 
			//so simulate creating MSE object -> with operation same name as rule name
			//create mse occurrence -> all objects except for the main object
			//to create mseoccurrence use factory class generated from an ecore file
			if(rules === null || rules.isEmpty){
				val mse = TracePackage::eINSTANCE.traceFactory.createGenericMSE()
				mse.setCallerReference(match.mainObject)
				val eo = EcoreFactory.eINSTANCE.createEOperation()
				eo.setName(match.getRule().getName())
				mse.setActionReference(eo);
				mse.setName(match.toString())
	
				val mseoc = TracePackage::eINSTANCE.traceFactory.createMSEOccurrence()
				mseoc.setMse(mse)
				for(EObject e: match.getNodeTargets()){
					mseoc.parameters.add(e)
				}
				mseoc
			}else{
				var fullName = ''
				for(Rule r: rules){
					fullName = fullName + ' ' + r.getName()
				}
				val mse = TracePackage::eINSTANCE.traceFactory.createGenericMSE()
				mse.setCallerReference(match.mainObject)
				val eo = EcoreFactory.eINSTANCE.createEOperation()
				eo.setName(fullName)
				mse.setActionReference(eo);
				mse.setName(fullName)
	
				val mseoc = TracePackage::eINSTANCE.traceFactory.createMSEOccurrence()
				mseoc.setMse(mse)
				for(EObject e: match.getNodeTargets()){
					mseoc.parameters.add(e)
				}
				mseoc
			}
			
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
//class HenshinStep extends GenericStepImpl {
//	
//		public Match match
//		public Rule rule
//
//		new(Match match, Rule rule) {
//			super()
//			//this.runner = runner
//			//this.runner.EGraph = model
//			//this.runner.rule = match.rule
//			this.match = match
//			this.rule = rule
//		}
//		
//		override getEndingState() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override getMseoccurrence() {
//			
//		}
//		
//		override getStartingState() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override setEndingState(State value) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override setMseoccurrence(MSEOccurrence value) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override setStartingState(State value) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eAllContents() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eClass() {
//			var nodes = this.match.getNodeTargets()
//			var n = nodes.get(0)
//			var na = this.rule
//			return nodes.get(0).eClass() 
//		}
//		
//		override eContainer() {
//		}
//		
//		override eContainingFeature() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eContainmentFeature() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eContents() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eCrossReferences() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eGet(EStructuralFeature feature) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eGet(EStructuralFeature feature, boolean resolve) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eInvoke(EOperation operation, EList<?> arguments) throws InvocationTargetException {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eIsProxy() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eIsSet(EStructuralFeature feature) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eResource() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eSet(EStructuralFeature feature, Object newValue) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eUnset(EStructuralFeature feature) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eAdapters() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eDeliver() {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eNotify(Notification notification) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		
//		override eSetDeliver(boolean deliver) {
//			throw new UnsupportedOperationException("TODO: auto-generated method stub")
//		}
//		override toString(){
//			return this.match.toString()
//		}
//	}