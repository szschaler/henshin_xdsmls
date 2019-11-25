package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.InvalidRegistryObjectException
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.BaseConcurrentModelExecutionContext
import org.eclipse.gemoc.executionframework.engine.commons.DefaultExecutionPlatform
import org.eclipse.gemoc.executionframework.engine.commons.EngineContextException
import org.eclipse.gemoc.executionframework.extensions.sirius.modelloader.DefaultModelLoader
import org.eclipse.gemoc.xdsmlframework.api.core.ExecutionMode
import org.eclipse.gemoc.xdsmlframework.api.core.IExecutionPlatform
import org.eclipse.gemoc.xdsmlframework.api.extensions.languages.LanguageDefinitionExtension

class HenshinConcurrentExecutionContext extends BaseConcurrentModelExecutionContext<HenshinConcurrentRunConfiguration, IExecutionPlatform, LanguageDefinitionExtension> {

	new(HenshinConcurrentRunConfiguration runConfiguration, ExecutionMode executionMode) throws EngineContextException {
		super(runConfiguration, executionMode)
	}

	override createExecutionPlatform() throws CoreException {
		new DefaultExecutionPlatform(_languageDefinition, _runConfiguration);
	}

	override protected getDefaultRunDeciderName() '''Random decider'''

	override protected getLanguageDefinitionExtension(String arg0) throws EngineContextException {
//		FIXME: This is really what we should do, but for now, we don't support .dsl files yet
//		LanguageDefinitionExtensionPoint.findDefinition(_runConfiguration.languageName)
		new HenshinLanguageDefinitionExtension(this)
	}

	/**
	 * class represeting the Henshin Language extension
	 */
	private static class HenshinLanguageDefinitionExtension extends LanguageDefinitionExtension {
		/**
		 * create a new Henshin Language extension
		 * @param henshin execution context
		 */
		new(HenshinConcurrentExecutionContext hmec) {
			super()
			_configurationElement = new IConfigurationElement() {
				/**
				 * configure the language settings
				 * i.e. model loader, code executor and a solver
				 */
				override createExecutableExtension(String propertyName) throws CoreException {
					switch (propertyName) {
						case Lang.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_LOADMODEL_ATT:
							return new DefaultModelLoader()
//						case Lang.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_CODEEXECUTOR_ATT:
//							return new HenshinCodeExecutor()
//						case Lang.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_SOLVER_ATT:
//							return new HenshinSolver(hmec.showConcurrentSteps)
						default:
							return null
					}
				}

				/**
				 * get the language name
				 */
				override getAttribute(String name) throws InvalidRegistryObjectException {
					switch (name) {
						case Lang.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_NAME_ATT:
							return hmec.runConfiguration.languageName
						default:
							throw new UnsupportedOperationException("TODO: auto-generated method stub")
					}
				}

				override getAttribute(String attrName, String locale) throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getAttributeAsIs(String name) throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getAttributeNames() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getChildren() throws InvalidRegistryObjectException {
					#[]
				}

				override getChildren(String name) throws InvalidRegistryObjectException {
					#[]
				}

				override getContributor() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getDeclaringExtension() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getName() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getNamespace() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getNamespaceIdentifier() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getParent() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getValue() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getValue(String locale) throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getValueAsIs() throws InvalidRegistryObjectException {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override isValid() {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

				override getHandleId() {
					throw new UnsupportedOperationException("TODO: auto-generated method stub")
				}

			}
		}
	}
}
