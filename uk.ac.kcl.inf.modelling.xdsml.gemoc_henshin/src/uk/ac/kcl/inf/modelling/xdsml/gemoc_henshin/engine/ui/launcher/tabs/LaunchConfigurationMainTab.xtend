package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.ui.launcher.tabs

import fr.inria.diverse.k3.al.annotationprocessor.InitializeModel
import java.lang.reflect.Method
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
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.gemoc.commons.eclipse.emf.URIHelper
import org.eclipse.gemoc.commons.eclipse.ui.dialogs.SelectAnyIFileDialog
import org.eclipse.gemoc.dsl.debug.ide.launch.AbstractDSLLaunchConfigurationDelegate
import org.eclipse.gemoc.dsl.debug.ide.sirius.ui.launch.AbstractDSLLaunchConfigurationDelegateSiriusUI
import org.eclipse.gemoc.execution.sequential.javaengine.PlainK3ExecutionEngine
import org.eclipse.gemoc.executionframework.engine.commons.DslHelper
import org.eclipse.gemoc.executionframework.engine.commons.MelangeHelper
import org.eclipse.gemoc.executionframework.engine.ui.commons.RunConfiguration
import org.eclipse.gemoc.executionframework.ui.utils.ENamedElementQualifiedNameLabelProvider
import org.eclipse.gemoc.xdsmlframework.ui.utils.dialogs.SelectAIRDIFileDialog
import org.eclipse.gemoc.xdsmlframework.ui.utils.dialogs.SelectAnyEObjectDialog
import org.eclipse.gemoc.xdsmlframework.ui.utils.dialogs.SelectMainMethodDialog
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.jface.wizard.WizardDialog
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
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.osgi.framework.Bundle
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.Activator

/**
 * Bit annoying: had to copy this from javaengine, as that plugin doesn't export it.
 */
class LaunchConfigurationMainTab extends LaunchConfigurationTab {

	protected var Composite _parent

	protected var Text _modelLocationText
	protected var Text _modelInitializationMethodText
	protected var Text _modelInitializationArgumentsText
	protected var Text _siriusRepresentationLocationText
	protected var Button _animateButton
	protected var Text _delayText
	protected var Text _melangeQueryText
	protected var Button _animationFirstBreak

	protected var Group _k3Area
	protected var Text _entryPointModelElementText
	protected var Label _entryPointModelElementLabel
	protected var Text _entryPointMethodText

	protected var Combo _languageCombo

	protected var Text modelofexecutionglml_LocationText

	protected var IProject _modelProject

	override void createControl(Composite parent) {
		_parent = parent

		val Composite area = new Composite(parent, SWT.NULL)
		val GridLayout gl = new GridLayout(1, false)
		gl.marginHeight = 0;
		area.layout = gl
		area.layout()
		control = area

		val Group modelArea = createGroup(area, "Model:")
		createModelLayout(modelArea, null)

		val Group languageArea = createGroup(area, "Language:")
		createLanguageLayout(languageArea, null)

		val Group debugArea = createGroup(area, "Animation:")
		createAnimationLayout(debugArea, null)

		_k3Area = createGroup(area, "Sequential DSA execution:")
		createK3Layout(_k3Area, null)
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(RunConfiguration.LAUNCH_DELAY, 1000)
		configuration.setAttribute(RunConfiguration.LAUNCH_MODEL_ENTRY_POINT, "")
		configuration.setAttribute(RunConfiguration.LAUNCH_METHOD_ENTRY_POINT, "")
		configuration.setAttribute(RunConfiguration.LAUNCH_SELECTED_LANGUAGE, "")
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			val RunConfiguration runConfiguration = new RunConfiguration(configuration)
			_modelLocationText.text = URIHelper.removePlatformScheme(runConfiguration.getExecutedModelURI())

			if (runConfiguration.getAnimatorURI() !== null) {
				_siriusRepresentationLocationText.text = URIHelper.removePlatformScheme(
					runConfiguration.getAnimatorURI())
			} else {
				_siriusRepresentationLocationText.text = ""
			}

			_delayText.text = Integer.toString(runConfiguration.animationDelay)
			_animationFirstBreak.selection = runConfiguration.breakStart

			_entryPointModelElementText.text = runConfiguration.modelEntryPoint
			_entryPointMethodText.text = runConfiguration.executionEntryPoint
			_languageCombo.text = runConfiguration.languageName
			_modelInitializationArgumentsText.text = runConfiguration.modelInitializationArguments

			_entryPointModelElementLabel.text = ""

			updateMainElementName()
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
		configuration.setAttribute(RunConfiguration.LAUNCH_SELECTED_LANGUAGE, _languageCombo.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_MELANGE_QUERY, _melangeQueryText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_MODEL_ENTRY_POINT, _entryPointModelElementText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_METHOD_ENTRY_POINT, _entryPointMethodText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_INITIALIZATION_METHOD,
			_modelInitializationMethodText.getText());
		configuration.setAttribute(RunConfiguration.LAUNCH_INITIALIZATION_ARGUMENTS,
			_modelInitializationArgumentsText.getText());
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
		createTextLabelLayout(parent, "Model initialization method")
		_modelInitializationMethodText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_modelInitializationMethodText.layoutData = createStandardLayout
		_modelInitializationMethodText.font = font
		_modelInitializationMethodText.editable = false
		createTextLabelLayout(parent, "")
		createTextLabelLayout(parent, "Model initialization arguments")
		_modelInitializationArgumentsText = new Text(parent,
			SWT.MULTI.bitwiseOr(SWT.BORDER).bitwiseOr(SWT.WRAP).bitwiseOr(SWT.V_SCROLL))
		_modelInitializationArgumentsText.toolTipText = "one argument per line"
		val GridData gridData = new GridData(GridData.FILL_BOTH)
		gridData.heightHint = 40
		_modelInitializationArgumentsText.layoutData = gridData
		_modelInitializationArgumentsText.font = font
		_modelInitializationArgumentsText.editable = true
		_modelInitializationArgumentsText.addModifyListener(new ModifyListener() {
			override void modifyText(ModifyEvent e) {
				updateLaunchConfigurationDialog()
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

	/***
	 * Create the Field where user enters the language used to execute
	 * 
	 * @param parent container composite
	 * @param font used font
	 * @return the created composite containing the fields
	 */
	public def Composite createLanguageLayout(Composite parent, Font font) {
		// Language
		createTextLabelLayout(parent, "Languages")
		_languageCombo = new Combo(parent, SWT.NONE)
		_languageCombo.layoutData = createStandardLayout

		val List<String> languagesNames = DslHelper.allLanguages
		_languageCombo.items = languagesNames
		_languageCombo.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				updateLaunchConfigurationDialog()
			}
		})
		createTextLabelLayout(parent, "")

		createTextLabelLayout(parent, "Melange resource adapter query")
		_melangeQueryText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_melangeQueryText.layoutData = createStandardLayout
		_melangeQueryText.font = font
		_melangeQueryText.editable = false
		createTextLabelLayout(parent, "")

		parent
	}

	private def Composite createK3Layout(Composite parent, Font font) {
		createTextLabelLayout(parent, "Main method")
		_entryPointMethodText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_entryPointMethodText.layoutData = createStandardLayout
		_entryPointMethodText.font = font
		_entryPointMethodText.editable = false
		_entryPointMethodText.addModifyListener(fBasicModifyListener)
		val Button mainMethodBrowseButton = createPushButton(parent, "Browse", null)
		mainMethodBrowseButton.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				if (_languageCombo.getText() === null) {
					setErrorMessage("Please select a language.")
				} else {
					val Set<Class<?>> candidateAspects = MelangeHelper.getAspects(_languageCombo.text)
					val SelectMainMethodDialog dialog = new SelectMainMethodDialog(candidateAspects,
						new ENamedElementQualifiedNameLabelProvider)
					val int res = dialog.open()
					if (res === WizardDialog.OK) {
						val Method selection = dialog.firstResult as Method
						_entryPointMethodText.text = selection.toString
					}
				}
			}
		})

		createTextLabelLayout(parent, "Main model element path")
		_entryPointModelElementText = new Text(parent, SWT.SINGLE.bitwiseOr(SWT.BORDER))
		_entryPointModelElementText.layoutData = createStandardLayout
		_entryPointModelElementText.font = font
		_entryPointModelElementText.editable = false
		_entryPointModelElementText.addModifyListener([updateMainElementName])
		_entryPointModelElementText.addModifyListener(fBasicModifyListener)
		val Button mainModelElemBrowseButton = createPushButton(parent, "Browse", null)
		mainModelElemBrowseButton.addSelectionListener(new SelectionAdapter() {
			override widgetSelected(SelectionEvent e) {
				val Resource model = getModel()
				if (model === null) {
					setErrorMessage("Please select a model to execute.")
				} else if (_entryPointMethodText.text === null || _entryPointMethodText.text == "") {
					setErrorMessage("Please select a main method.")
				} else {
					val SelectAnyEObjectDialog dialog = new SelectAnyEObjectDialog(
						PlatformUI.workbench.activeWorkbenchWindow.shell, model.resourceSet,
						new ENamedElementQualifiedNameLabelProvider) {
							protected override select(EObject obj) {
								val String methodSignature = _entryPointMethodText.text
								val String firstParamType = MelangeHelper.getParametersType(methodSignature).head
								val String simpleParamType = MelangeHelper.lastSegment(firstParamType)
								obj.eClass().name == simpleParamType
							}
						}
						val int res = dialog.open()
						if (res === WizardDialog.OK) {
							val EObject selection = dialog.firstResult as EObject
							val String uriFragment = selection.eResource().getURIFragment(selection)
							_entryPointModelElementText.text = uriFragment
						}
					}
				}
			})

			createTextLabelLayout(parent, "Main model element name")
			_entryPointModelElementLabel = new Label(parent, SWT.HORIZONTAL)
			_entryPointModelElementLabel.text = ""

			parent
		}

		protected override updateLaunchConfigurationDialog() {
			super.updateLaunchConfigurationDialog
			_k3Area.visible = true
			_modelInitializationMethodText.text = modelInitializationMethodName
			_modelInitializationArgumentsText.enabled = !_modelInitializationMethodText.text.empty
			_melangeQueryText.text = computeMelangeQuery
		}

		/**
		 * compute the Melange query for loading the given model as the requested language
		 * If the language is already the good one, the query will be empty. (ie. melange downcast is not used)
		 * @return
		 */
		protected def String computeMelangeQuery() {
			var String result = ""
			val String languageName = this._languageCombo.text
			if (!this._modelLocationText.text.empty && !languageName.empty) {
				val Resource model = getModel
				val List<String> modelNativeLanguages = MelangeHelper.getNativeLanguagesUsedByResource(model)
				if (!modelNativeLanguages.empty && !(modelNativeLanguages.head == languageName)) {
					// TODO this version consider only the first native language, we need to think about models containing elements coming from several languages
					var String languageMT = MelangeHelper.getModelType(languageName)
					if (languageMT === null) {
						languageMT = languageName + "MT"
					}

					result = "?lang=" + languageName; // we need a simple downcast without adapter
				}
			}

			result
		}

		protected def String getModelInitializationMethodName() {
			var String entryPointClassName = null

			val String prefix = "public static void "
			val int startName = prefix.length
			val int endName = _entryPointMethodText.text.lastIndexOf("(")
			if(endName == -1) return ""

			val String entryMethod = _entryPointMethodText.text.substring(startName, endName)
			val int lastDot = entryMethod.lastIndexOf(".")
			if (lastDot != -1) {
				entryPointClassName = entryMethod.substring(0, lastDot);
			}

			val Bundle bundle = DslHelper.getDslBundle(_languageCombo.text)

			if (entryPointClassName !== null && bundle !== null) {
				try {
					val Class<?> entryPointClass = bundle.loadClass(entryPointClassName)
					for (Method m : entryPointClass.getMethods()) {
						// TODO find a better search mechanism (check signature, inheritance, aspects, etc)
						if (m.isAnnotationPresent(InitializeModel)) {
							return entryPointClassName + "." + m.name
						}
					}
				} catch (ClassNotFoundException e) {
				}
			}

			return ""
		}

		/**
		 *  caches the current model resource in order to avoid to reload it many times
		 *  use {@link getModel()} in order to access it.
		 */
		private var Resource currentModelResource;

		private def Resource getModel() {
			val URI modelURI = URI.createPlatformResourceURI(_modelLocationText.getText(), true);
			if (currentModelResource === null || !(currentModelResource.URI == modelURI)) {
				currentModelResource = PlainK3ExecutionEngine.loadModel(modelURI);
			}
			return currentModelResource;
		}

		override boolean isValid(ILaunchConfiguration config) {
			setErrorMessage(null)
			setMessage(null)
			val IWorkspace workspace = ResourcesPlugin.workspace
			val String modelName = _modelLocationText.text.trim()
			if (modelName.length() > 0) {

				val IResource modelIResource = workspace.root.findMember(modelName)
				if (modelIResource === null || !modelIResource.exists) {
					setErrorMessage("SequentialMainTab_model_doesnt_exist " + modelName)
					return false
				}
				if (modelName.equals("/")) {
					setErrorMessage("SequentialMainTab_Model_not_specified")
					return false
				}
				if (! (modelIResource instanceof IFile)) {
					setErrorMessage("SequentialMainTab_invalid_model_file " + modelName)
					return false
				}
			}
			if (modelName.length() == 0) {
				setErrorMessage("SequentialMainTab_Model_not_specified")
				return false
			}

			val String languageName = _languageCombo.text.trim
			if (languageName.length() === 0) {
				setErrorMessage("SequentialMainTab_Language_not_specified")
				return false
			} else if (MelangeHelper.getEntryPoints(languageName).empty) {
				setErrorMessage("SequentialMainTab_Language_main_methods_dont_exist")
				return false
			}

			val String mainMethod = _entryPointMethodText.text.trim
			if (mainMethod.length() === 0) {
				setErrorMessage("SequentialMainTab_Language_main_method_not_selected")
				return false
			}

			val String rootElement = _entryPointModelElementText.text.trim
			if (rootElement.length === 0) {
				setErrorMessage("SequentialMainTab_Language_root_element_not_selected")
				return false
			}

			val String[] params = MelangeHelper.getParametersType(mainMethod)
			val String firstParam = MelangeHelper.lastSegment(params.head)
			val String rootEClass = getModel().getEObject(rootElement).eClass.name
			if (!(params.length === 1 && firstParam == rootEClass)) {
				setErrorMessage("SequentialMainTab_Language_incompatible_root_and_main")
				return false
			}

			true
		}

		/**
		 * Update _entryPointModelElement with pretty name
		 */
		private def updateMainElementName() {
			try {
				val Resource model = getModel()
				var EObject mainElement = null
				if (model !== null) {
					mainElement = model.getEObject(_entryPointModelElementText.text);
				}
				if (mainElement !== null) {
					val DefaultDeclarativeQualifiedNameProvider nameprovider = new DefaultDeclarativeQualifiedNameProvider()
					val QualifiedName qname = nameprovider.getFullyQualifiedName(mainElement)
					val String objectName = if(qname !== null) qname.toString else mainElement.toString
					val String prettyName = objectName + " : " + mainElement.eClass.name
					_entryPointModelElementLabel.text = prettyName
				}
			} catch (Exception e) {
			}
		}

	}
	