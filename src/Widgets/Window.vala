using Gee;

public class ServiceManager.Window : Gtk.ApplicationWindow {
	public GLib.Settings settings;
	private Gtk.Paned system_services_paned;
	private Gtk.Paned session_services_paned;

	public Window (ServiceManagerApplication app) {
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

	 	var headerbar = new ServiceManager.HeaderBar ();
		set_titlebar (headerbar);

		system_services_paned = create_services_paned(BusType.SYSTEM);
		session_services_paned = create_services_paned(BusType.SESSION);
		add(system_services_paned);

		show_all ();
	}

	private Gtk.Paned create_services_paned(BusType bus_type) {
		var stack = new Gtk.Stack ();
		var unit_map = get_units(bus_type, {}, {"*.service"});
		bool show_header = true;
		foreach (var key in unit_map.keys) {
			var unit = unit_map.get(key);
			stdout.printf ("Unit: %s, state: %s, description: %s, sub-state: %s\n",
				unit.id,
				unit.active_state,
				unit.description,
				unit.sub_state
			);
			ServiceManager.ServiceView service_view;
			string service_name = unit.id.replace(".service", "");
			string header = show_header ? "Services" : null;
			service_view = new ServiceManager.ServiceView(
				service_name, 
				unit.description, 
				unit.active_state, 
				header
			);
			if (show_header) {
				show_header = false;
			}
			stack.add_named (service_view, service_name);
		}

		var switcher = new Granite.SettingsSidebar (stack);

		var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
		paned.pack1 (switcher, false, false);
		paned.add (stack);
		
		return paned;
	}

	public TreeMap<string, SystemdManager.UnitInfo?> get_units(BusType bus_type, string[] states, string[] patterns) {
		SystemdManager systemd_manager;
		var tree_map = new TreeMap<string, SystemdManager.UnitInfo?>();
		try {
			systemd_manager = Bus.get_proxy_sync (
				bus_type,
				"org.freedesktop.systemd1",
				"/org/freedesktop/systemd1"
			);
			debug ("Connected\n");
			var units = systemd_manager.list_units_by_patterns(states, patterns);
			foreach (var unit in units) {
				tree_map.set(unit.id, unit);
			}
		} catch (GLib.Error e) {
			error ("Caught an error: %s\n", e.message);
		}
		return tree_map;
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
