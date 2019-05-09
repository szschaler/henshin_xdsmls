package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IWorkspace
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.gemoc.commons.eclipse.emf.URIHelper
import org.eclipse.gemoc.commons.eclipse.ui.dialogs.SelectAnyIFileDialog
import org.eclipse.gemoc.dsl.debug.ide.launch.AbstractDSLLaunchConfigurationDelegate
import org.eclipse.gemoc.dsl.debug.ide.sirius.ui.launch.AbstractDSLLaunchConfigurationDelegateSiriusUI
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
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator
import org.eclipse.gemoc.executionframework.engine.core.RunConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentRunConfiguration

/**
 * 
 * Main tab to let the user specify input to the engine
 * such as model/language/animator
 *
 */
class LaunchConfigurationMainTab extends AbstractLaunchConfigurationTab {

	protected var Composite _parent

	protected var Text _modelLocationText

	protected var Text _languageText

	protected var Text _siriusRepresentationLocationText
	protected var Button _animateButton
	protected var Text _delayText
	protected var Button _animationFirstBreak

	protected var Text modelofexecutionglml_LocationText

	protected var IProject _modelProject

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
		ConcurrentRunConfiguration.DECIDER_ASKUSER_STEP_BY_STEP);}

	/**
	 * define run configiguration
	 */
	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			//define concurrent run config
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

			_languageText.text = runConfiguration.languageName
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
	}

	override String getName() '''Main'''

	// -----------------------------------
	/**
	 * Basic modify listener that can be reused if there is no more precise need
	 */
	private val ModifyListener fBasicModifyListener = new ModifyListener() {
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

//		/**
//		 *  caches the current model resource in order to avoid to reload it many times
//		 *  use {@link getModel()} in order to access it.
//		 */
//		private var Resource currentModelResource;
//
//		private def Resource getModel() {
//			val URI modelURI = URI.createPlatformResourceURI(_modelLocationText.getText(), true);
//			if (currentModelResource === null || !(currentModelResource.URI == modelURI)) {
//				currentModelResource = PlainK3ExecutionEngine.loadModel(modelURI);
//			}
//			return currentModelResource;
//		}
	override boolean isValid(ILaunchConfiguration config) {
		setErrorMessage(null)
		setMessage(null)
		val IWorkspace workspace = ResourcesPlugin.workspace
		val String modelName = _modelLocationText.text.trim()
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
}
