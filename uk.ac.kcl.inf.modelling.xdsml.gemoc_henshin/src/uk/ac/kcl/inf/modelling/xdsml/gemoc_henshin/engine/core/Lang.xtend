package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core;
/**
 * code taken from the GEMOC concurrent ccsl engine
 */
import org.eclipse.gemoc.execution.concurrent.ccsljavaxdsml.api.extensions.languages.ConcurrentLanguageDefinitionExtensionPoint
class Lang extends ConcurrentLanguageDefinitionExtensionPoint{
	
	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF = "XDSML_Definition";
	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_LOADMODEL_ATT = "modelLoader_class";
	public static final String GEMOC_LANGUAGE_EXTENSION_POINT_XDSML_DEF_NAME_ATT = "name";

}