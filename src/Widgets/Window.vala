[DBus (name = "org.freedesktop.systemd1.Manager")]
public interface SystemdManager : DBusProxy {

	public struct UnitInfo {
		string id;
		string description;
		string load_state;
		string active_state;
		string sub_state;
		string following;
		ObjectPath unit_path;
		uint32 job_id;
		string job_type;
		ObjectPath job_path;
	}

	//public signal void list_units_by_patterns (string[] states, string[] patterns);
	// s s s s s s o u s o
	//[DBus (name = "ListUnits")]  
    public abstract UnitInfo[] list_units() throws Error;
}


public class ServiceMan.Window : Gtk.ApplicationWindow {
	public GLib.Settings settings;

	public Window (Application app) {
		Object (
			application: app
		);
	}

	construct {
	 	window_position = Gtk.WindowPosition.CENTER;
	 	set_default_size (350, 80);

	 	settings = new GLib.Settings ("com.github.carniz.service-man");

	 	move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
	 	resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

	 	delete_event.connect (e => {
	 		return before_destroy ();
	 	});

	 	var headerbar = new ServiceMan.HeaderBar ();
		set_titlebar (headerbar);
		 
		show_all ();
	
		stdout.printf ("Hello\n");

		SystemdManager systemdManager;
		try {
			systemdManager = Bus.get_proxy_sync (
				BusType.SYSTEM, 
				"org.freedesktop.systemd1",
				"/org/freedesktop/systemd1"
			);
			stdout.printf ("Connected\n");
			var units = systemdManager.list_units();
			foreach (var unit in units) {
				stdout.printf ("Unit: %s\n", unit.id);			
			}	
		} catch (GLib.Error e) {
			stderr.printf ("Oh crap: %s\n", e.message);
		}
	
	}

	public bool before_destroy () {
		int width, height, x, y;

		get_size (out width, out height);
		get_position (out x, out y);

		settings.set_int ("pos-x", x);
		settings.set_int ("pos-y", y);
		settings.set_int ("window-width", width);
		settings.set_int ("window-height", height);

		return false;
	}
}
