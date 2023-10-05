package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import java.beans.PropertyChangeListener
import java.beans.PropertyChangeSupport
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.henshin.model.Module
import org.eclipse.emf.henshin.model.Rule
import org.eclipse.gemoc.commons.eclipse.emf.URIHelper
import org.eclipse.gemoc.commons.eclipse.ui.dialogs.SelectAnyIFileDialog
import org.eclipse.gemoc.dsl.debug.ide.launch.AbstractDSLLaunchConfigurationDelegate
import org.eclipse.gemoc.dsl.debug.ide.sirius.ui.launch.AbstractDSLLaunchConfigurationDelegateSiriusUI
import org.eclipse.gemoc.executionframework.engine.concurrency.ConcurrentRunConfiguration
import org.eclipse.gemoc.executionframework.engine.concurrency.deciders.DeciderSpecificationExtensionPoint
import org.eclipse.gemoc.executionframework.engine.core.RunConfiguration
import org.eclipse.gemoc.executionframework.engine.ui.concurrency.strategies.LaunchConfigurationContext
import org.eclipse.gemoc.xdsmlframework.ui.utils.dialogs.SelectAIRDIFileDialog
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.graphics.Font
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.xtext.resource.XtextResourceSet
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator

class LaunchConfigurationMainTab extends AbstractLaunchConfigurationTab implements LaunchConfigurationContext {
	protected var Composite _parent

	protected var Text _modelLocationText

	protected var Text _languageText

	protected var Text _siriusRepresentationLocationText
	protected var Button _animateButton
	protected var Text _delayText
	protected var Button _animationFirstBreak
	protected var Combo _deciderCombo

	protected var Text modelofexecutionglml_LocationText

	protected var IProject _modelProject

	var List<EPackage> metamodels
	var Module semantics

	override void createControl(Composite parent) {
		_parent = parent

		val Composite area = new Composite(parent, SWT.NULL)
		val GridLayout gl = new GridLayout(1, false)
		gl.marginHeight = 0
		area.layout = gl
		area.layout()
		control = area

		val Group modelArea = createGroup(area, "Model:")
		createModelLayout(modelArea, null)

		val Group languageArea = createGroup(area, "Language:")
		createLanguageLayout(languageArea, null)

		val Group debugArea = createGroup(area, "Animation:")
		createAnimationLayout(debugArea, null)
	}

	/**
	 * add logical step decider to the run config
	 */
	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(RunConfiguration.LAUNCH_DELAY, 1000);

		configuration.setAttribute(ConcurrentRunConfiguration.LAUNCH_SELECTED_DECIDER,
			ConcurrentRunConfiguration.DECIDER_ASKUSER_STEP_BY_STEP);
	}

	/**
	 * define run configiguration
	 */
	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			// define concurrent run config
			val ConcurrentRunConfiguration runConfiguration = new ConcurrentRunConfiguration(configuration)
			_modelLocationText.text = URIHelper.removePlatformScheme(runConfiguration.getExecutedModelURI())

			if (runConfiguration.getAnimatorURI() !== null) {
				_siriusRepresentationLocationText.text = URIHelper.removePlatformScheme(
					runConfiguration.getAnimatorURI())
			} else {
				_siriusRepresentationLocationText.text = ""
			}

			_delayText.text = Integer.toString(runConfiguration.animationDelay)
			_animationFirstBreak.selection = runConfiguration.breakStart
			_deciderCombo.text = runConfiguration.deciderName

			_languageText.text = runConfiguration.languageName
			updateMetamodels
		} catch (CoreException e) {
			Activator.error(e.getMessage(), e);
		}
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(AbstractDSLLaunchConfigurationDelegate.RESOURCE_URI,
			this._modelLocationText.getText());
		configuration.setAttribute(AbstractDSLLaunchConfigurationDelegateSiriusUI.SIRIUS_RESOURCE_URI,
			this._siriusRepresentationLocationText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_DELAY, Integer.parseInt(_delayText.getText()));
		configuration.setAttribute(RunConfiguration.LAUNCH_SELECTED_LANGUAGE, _languageText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_BREAK_START, _animationFirstBreak.getSelection());
		// DebugModelID for sequential engine
		configuration.setAttribute(RunConfiguration.DEBUG_MODEL_ID, Activator.DEBUG_MODEL_ID);
		
		configuration.setAttribute(ConcurrentRunConfiguration.LAUNCH_SELECTED_DECIDER, this._deciderCombo.getText());
	}

	override String getName() '''Main'''

	// -----------------------------------
	/**
	 * Basic modify listener that can be reused if there is no more precise need
	 */
	val ModifyListener fBasicModifyListener = new ModifyListener() {
		override void modifyText(ModifyEvent event) {
			updateLaunchConfigurationDialog()
		}
	}

	// -----------------------------------
	def Composite createModelLayout(Composite parent, Font font) {
		createTextLabelLayout(parent, "Model to execute")

		_modelLocationText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_modelLocationText.layoutData = createStandardLayout
		_modelLocationText.font = font
		_modelLocationText.addModifyListener(fBasicModifyListener)
		val Button modelLocationButton = createPushButton(parent, "Browse", null)

		modelLocationButton.addSelectionListener(new SelectionAdapter() {

			override widgetSelected(SelectionEvent evt) {
				val SelectAnyIFileDialog dialog = new SelectAnyIFileDialog
				if (dialog.open === Dialog.OK) {
					val String modelPath = (dialog.result.head as IResource).fullPath.toPortableString
					_modelLocationText.text = modelPath
					updateLaunchConfigurationDialog
					_modelProject = (dialog.result.head as IResource).project

					// extracting a list of EClass instances with a modelPath
					val resourceSet = new ResourceSetImpl();
					val ecoreResource = resourceSet.getResource(URI.createPlatformResourceURI(modelPath, true), true);
					val ePackage = ecoreResource.getContents().get(0);

					var eclassList = new HashSet<EClass>()
					for (var i = 0; i < ePackage.eContents.length; i++) {
						eclassList.add(ePackage.eContents.get(i).eClass)
					}
				// ------
				}
			}
		})

		createTextLabelLayout(parent, "")

		parent
	}

	private def Composite createLanguageLayout(Composite parent, Font font) {
		// Language
		createTextLabelLayout(parent, "Languages")
		_languageText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_languageText.layoutData = createStandardLayout
		_languageText.font = font
		_languageText.addModifyListener(fBasicModifyListener)
		val Button modelLocationButton = createPushButton(parent, "Browse", null)
		modelLocationButton.addSelectionListener(new SelectionAdapter() {

			override widgetSelected(SelectionEvent evt) {
				val SelectAnyIFileDialog dialog = new SelectAnyIFileDialog
				if (dialog.open === Dialog.OK) {
					val String modelPath = (dialog.result.head as IResource).fullPath.toPortableString
					_languageText.text = modelPath

					updateMetamodels

					updateLaunchConfigurationDialog
				}
			}
		})

		createTextLabelLayout(parent, "")

		parent
	}

	private def Composite createAnimationLayout(Composite parent, Font font) {
		createTextLabelLayout(parent, "Animator")

		_siriusRepresentationLocationText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_siriusRepresentationLocationText.layoutData = createStandardLayout
		_siriusRepresentationLocationText.font = font
		_siriusRepresentationLocationText.addModifyListener(fBasicModifyListener)
		val Button siriusRepresentationLocationButton = createPushButton(parent, "Browse", null)
		siriusRepresentationLocationButton.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent evt) {
				val SelectAIRDIFileDialog dialog = new SelectAIRDIFileDialog
				if (dialog.open === Dialog.OK) {
					val String modelPath = (dialog.result.head as IResource).fullPath.toPortableString
					_siriusRepresentationLocationText.text = modelPath
					updateLaunchConfigurationDialog()
				}
			}
		})

		createTextLabelLayout(parent, "Delay")
		_delayText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_delayText.layoutData = createStandardLayout
		_delayText.addModifyListener(new ModifyListener() {

			override void modifyText(ModifyEvent e) {
				updateLaunchConfigurationDialog()
			}
		})
		createTextLabelLayout(parent, "(in milliseconds)")
		
		createTextLabelLayout(parent, "Decider")
		_deciderCombo = new Combo(parent, SWT.BORDER)
		_deciderCombo.layoutData = createStandardLayout

		val deciders = DeciderSpecificationExtensionPoint.specifications.map[name].toList.toArray(#[""])
		_deciderCombo.items = deciders
		_deciderCombo.select = 0
		_deciderCombo.addModifyListener(fBasicModifyListener)


		new Label(parent, SWT.NONE).text = ""
		_animationFirstBreak = new Button(parent, SWT.CHECK)
		_animationFirstBreak.text = "Break at start"
		_animationFirstBreak.addSelectionListener(new SelectionAdapter() {

			override void widgetSelected(SelectionEvent event) {
				updateLaunchConfigurationDialog()
			}
		})

		parent
	}

	private def GridData createStandardLayout() {
		new GridData(SWT.FILL, SWT.CENTER, true, false)
	}

	override boolean isValid(ILaunchConfiguration config) {
		setErrorMessage(null)
		setMessage(null)
		val IWorkspace workspace = ResourcesPlugin.workspace
		val String modelName = _modelLocationText.text.trim
		if (modelName.length() > 0) {

			val IResource modelIResource = workspace.root.findMember(modelName)
			if (modelIResource === null || !modelIResource.exists) {
				errorMessage = "Specified model does not exist: " + modelName
				return false
			}
			if (modelName.equals("/")) {
				errorMessage = "Please specify a model"
				return false
			}
			if (! (modelIResource instanceof IFile)) {
				errorMessage = "Not a valid file " + modelName
				return false
			}
		}
		if (modelName.length === 0) {
			errorMessage = "Please specify a model"
			return false
		}

		val String languageName = _languageText.text.trim
		if (languageName.length === 0) {
			errorMessage = "Please specify a language-semantics file"
			return false
		} else {
			val languageResource = workspace.root.findMember(languageName)
			if (languageResource === null || !languageResource.exists) {
				errorMessage = "Specified language-semantics file doesn't exist: " + languageName
				return false
			}

			if (! (languageResource instanceof IFile)) {
				errorMessage = "Not a valid file " + languageName
				return false
			}

			if (! languageName.endsWith(".henshin_xdsml") && ! languageName.endsWith(".henshin")) {
				errorMessage = "Wrong type of file for language semantics: " + languageName
				return false
			}
		}

		true
	}

	private def Group createGroup(Composite parent, String text) {
		val Group group = new Group(parent, SWT.NULL)
		group.text = text
		val GridLayout locationLayout = new GridLayout
		locationLayout.numColumns = 3;
		locationLayout.marginHeight = 10;
		locationLayout.marginWidth = 10;
		group.layout = locationLayout

		group
	}

	private def createTextLabelLayout(Composite parent, String labelString) {
		val GridData gd = new GridData(GridData.FILL_HORIZONTAL)
		parent.layoutData = gd
		val Label inputLabel = new Label(parent, SWT.NONE)
		inputLabel.text = labelString
	}

	/**
	 * print debug messages to console
	 */
	def protected void debug(String message) {
		getMessagingSystem().debug(message, getPluginID());
	}

	def getMessagingSystem() {
		return Activator.getDefault().getMessaggingSystem();
	}

	def String getPluginID() {
		return Activator.PLUGIN_ID;
	}

	val pcs = new PropertyChangeSupport(this)

	def updateMetamodels() {
		try {
			val resourceSet = new XtextResourceSet
			val semanticsResource = resourceSet.getResource(URI.createPlatformResourceURI(_languageText.text, false), true)
	
			val oldSemantics = semantics
			semantics = semanticsResource.contents.head as Module
	
			val oldmms = metamodels
			metamodels = semantics.imports
	
			pcs.firePropertyChange(SEMANTICS, getRuleNameSet(oldSemantics), getRuleNameSet(semantics))
			if (oldmms !== metamodels) {
				pcs.firePropertyChange(METAMODELS, getMetamodelsSet(oldmms), getMetamodelsSet(metamodels))
			}			
		}
		catch (Exception e) {
			e.printStackTrace
		}
	}
	
	override Set<String> getSemantics() { getRuleNameSet(semantics) }
	
	private def getRuleNameSet(Module semantics) {
		if(semantics !== null) semantics.units.filter(Rule).map[name].toSet else emptySet
	}

	override getMetamodels() {
		getMetamodelsSet(metamodels)
	}

	private def getMetamodelsSet(List<EPackage> mms) {
		if (mms !== null) mms.toSet.unmodifiableView else emptySet
	}

	override addMetamodelChangeListener(PropertyChangeListener pcl) {
		pcs.addPropertyChangeListener(METAMODELS, pcl)
	}

	override addSemanticsChangeListener(PropertyChangeListener pcl) {
		pcs.addPropertyChangeListener(SEMANTICS, pcl)
	}
	
	override getEngine() {
		throw new UnsupportedOperationException("No engine at this point")
	}
	
	override getModelRoot() {
		throw new UnsupportedOperationException("No model at this point")
	}
	
}
