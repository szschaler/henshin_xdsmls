package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core;

/**
 * the class adding the additional fields such as a model loader to the concurrent language extension
 * it is used in the execution context to define a Henshin Language Extension.
 */

import org.eclipse.gemoc.xdsmlframework.api.extensions.languages.LanguageDefinitionExtensionPoint

class Lang extends LanguageDefinitionExtensionPoint {

	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF = "XDSML_Definition";
	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_LOADMODEL_ATT = "modelLoader_class";
	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_NAME_ATT = "name";

}
