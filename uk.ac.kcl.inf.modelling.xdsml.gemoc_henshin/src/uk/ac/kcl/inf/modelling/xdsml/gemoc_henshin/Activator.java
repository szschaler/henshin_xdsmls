package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin;

import org.eclipse.core.runtime.Status;
import org.eclipse.gemoc.commons.eclipse.messagingsystem.api.MessagingSystem;
import org.eclipse.gemoc.commons.eclipse.messagingsystem.api.MessagingSystemManager;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

/**
 * The activator class controls the plug-in life cycle
 */
public class Activator extends AbstractUIPlugin {

	// The plug-in ID
	public static final String PLUGIN_ID = "uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin"; //$NON-NLS-1$
	public static final String DEBUG_MODEL_ID = PLUGIN_ID + ".debugModel"; //$NON-NLS-1$

	// The shared instance
	private static Activator plugin;

	protected MessagingSystem messaggingSystem = null;
	
	/**
	 * The constructor
	 */
	public Activator() {
	}

	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#start(org.osgi.framework.BundleContext)
	 */
	public void start(BundleContext context) throws Exception {
		super.start(context);
		plugin = this;
	}

	/*
	 * (non-Javadoc)
	 * @see org.eclipse.ui.plugin.AbstractUIPlugin#stop(org.osgi.framework.BundleContext)
	 */
	public void stop(BundleContext context) throws Exception {
		plugin = null;
		super.stop(context);
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	public static Activator getDefault() {
		return plugin;
	}

	public static void error(String msg, Throwable e) {
		Activator.getDefault().getLog().log(new Status(Status.ERROR, PLUGIN_ID, Status.OK, msg, e));
	}

	public void debug(String msg) {
		getLog().log(new Status(Status.INFO, PLUGIN_ID, Status.OK, msg, null));
	}

	public MessagingSystem getMessaggingSystem() {
		if (messaggingSystem == null) {
			MessagingSystemManager msm = new MessagingSystemManager();
			messaggingSystem = msm.createBestPlatformMessagingSystem(
					org.eclipse.gemoc.executionframework.debugger.Activator.PLUGIN_ID, 
					"Model Debugger console");
		}
		return messaggingSystem;
	}
}
