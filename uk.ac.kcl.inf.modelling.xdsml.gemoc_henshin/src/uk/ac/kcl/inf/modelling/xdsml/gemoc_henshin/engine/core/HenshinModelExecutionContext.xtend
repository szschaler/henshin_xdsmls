package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.core.runtime.CoreException
import org.eclipse.gemoc.executionframework.engine.commons.EngineContextException
import org.eclipse.gemoc.executionframework.engine.commons.ModelExecutionContext
import org.eclipse.gemoc.executionframework.extensions.sirius.modelloader.DefaultModelLoader
import org.eclipse.gemoc.trace.commons.model.trace.MSEModel
import org.eclipse.gemoc.xdsmlframework.api.core.ExecutionMode
import org.eclipse.gemoc.xdsmlframework.api.core.IRunConfiguration
import org.eclipse.gemoc.xdsmlframework.api.extensions.languages.LanguageDefinitionExtension
import org.eclipse.gemoc.xdsmlframework.api.extensions.languages.LanguageDefinitionExtensionPoint
import org.eclipse.core.runtime.IConfigurationElement
import org.eclipse.core.runtime.InvalidRegistryObjectException

class HenshinModelExecutionContext extends ModelExecutionContext {

	new(IRunConfiguration runConfiguration, ExecutionMode executionMode) throws EngineContextException {
		super(runConfiguration, executionMode)
	}

	/*
	 * Need to work around the lookup from GEMOC's language-definition extension point, which doesn't align with how we define a language 
	 */
	private static class HenshinLanguageDefinitionExtension extends LanguageDefinitionExtension {
		new(HenshinModelExecutionContext hmec) {
			super()
			_configurationElement = new IConfigurationElement() {

				override createExecutableExtension(String propertyName) throws CoreException {
					switch (propertyName) {
						case LanguageDefinitionExtensionPoint.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_LOADMODEL_ATT:
							return new DefaultModelLoader
						default:
							return null
					}
				}

				override getAttribute(String name) throws InvalidRegistryObjectException {
					switch (name) {
						case LanguageDefinitionExtensionPoint.GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_NAME_ATT:
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

			}
		}
	}

	protected override LanguageDefinitionExtension getLanguageDefinition (String languageName) throws EngineContextException {
		new HenshinLanguageDefinitionExtension(this)
	}

	override MSEModel getMSEModel() { null }
}
