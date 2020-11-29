public class Application : Gtk.Application {

	public Application () {
		Object (
			application_id: "com.github.carniz.service-man",
			flags: ApplicationFlags.FLAGS_NONE
		);
	}

	protected override void activate () {
		var window = new ServiceMan.Window (this);

		add_window (window);
	}
}
