public class ServiceManagerApplication : Gtk.Application {

	public ServiceManagerApplication () {
		Object (
			application_id: "com.github.carniz.service-man",
			flags: ApplicationFlags.FLAGS_NONE
		);
	}

	protected override void activate () {
		var window = new ServiceManager.Window (this);
		debug ("ServiceManagerApplication.activate()\n");
		add_window (window);
	}

	public static int main (string[] args) {
		var app = new ServiceManagerApplication ();	
		return app.run (args);
	}

}

