using Gee;

public class ServicesPlug : Switchboard.Plug {
    private const string SYSTEM = "system";
    private const string SESSION = "session";

    private Gtk.Grid grid;
    private Gtk.Stack stack;
    private ServiceManager.ServicePaned system_services_paned;
    private ServiceManager.ServicePaned session_services_paned;

    public ServicesPlug () {
        var settings = new Gee.TreeMap<string, string?> (null, null);
        settings.set ("services", null);
        settings.set ("services/system", SYSTEM);
        settings.set ("services/session", SESSION);

        Object (
            category: Category.SYSTEM,
            code_name: "io.elementary.switchboard.services",
            description: _("Manage system and user services"),
            display_name: _("Services"),
            icon: "preferences-desktop-applications",
            supported_settings: settings
        );
    }

    public override Gtk.Widget get_widget () {
        if (grid == null) {
            stack = new Gtk.Stack () {
                expand = true
            };
            system_services_paned = create_services_paned(BusType.SYSTEM);
            session_services_paned = create_services_paned(BusType.SESSION);

            stack.add_titled (system_services_paned, SYSTEM, _("System"));
            stack.add_titled (session_services_paned, SESSION, _("Session"));

            var stack_switcher = new Gtk.StackSwitcher () {
                halign = Gtk.Align.CENTER,
                homogeneous = true,
                margin_top = 12,
                stack = stack
            };

            grid = new Gtk.Grid () {
                row_spacing = 24
            };
            grid.attach (stack_switcher, 0, 0);
            Gtk.Grid sub_grid = new Gtk.Grid ();
            sub_grid.attach(new Gtk.Separator(Gtk.Orientation.HORIZONTAL), 0, 0);
            sub_grid.attach (stack, 0, 0);
            grid.attach(sub_grid, 0, 12);
            grid.show_all ();
        }

        return grid;
    }

    private ServiceManager.ServicePaned create_services_paned(BusType bus_type) {
        var stack = new Gtk.Stack ();
        var unit_map = get_units(bus_type, {}, {"*.service"});
        bool show_header = true;
        foreach (var key in unit_map.keys) {
            var unit = unit_map.get(key);
            debug ("Unit: %s, state: %s, description: %s, sub-state: %s, unit-path: %s\n",
                unit.id,
                unit.active_state,
                unit.description,
                unit.sub_state,
                unit.unit_path
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

        //var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        var paned = new ServiceManager.ServicePaned (stack);
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

    public override void shown () {
    }

    public override void hidden () {
    }

    public override void search_callback (string location) {
        //  print("search_callback location: %s\n", location);
        //  if (system_services_paned.stack.get_child_by_name(location) != null) {
        //      system_services_paned.stack.set_visible_child_name(location);
        //  }
        //  else if (session_services_paned.stack.get_child_by_name(location) != null) {
        //      session_services_paned.stack.set_visible_child_name(location);
        //  }
        switch (location) {
            case SYSTEM:
                stack.set_visible_child_name (SYSTEM);
                break;
            case SESSION:
                stack.set_visible_child_name (SESSION);
                break;
            default:
                stack.set_visible_child_name (SYSTEM);
                break;
        }
    }

    public override async Gee.TreeMap<string, string> search (string search) {
        var search_results = new Gee.TreeMap<string, string> (
            (GLib.CompareDataFunc<string>)strcmp,
            (Gee.EqualDataFunc<string>)str_equal
        );
        search_results.set ("%s → %s".printf (display_name, _("System services")), SYSTEM);
        search_results.set ("%s → %s".printf (display_name, _("Session services")), SESSION);
        var system_unit_map = get_units(BusType.SYSTEM, {}, {"*.service"});
        foreach (var key in system_unit_map.keys) {
            var unit = system_unit_map.get(key);
            search_results.set ("%s → %s".printf (display_name, unit.id), SYSTEM);
        }
        var session_unit_map = get_units(BusType.SESSION, {}, {"*.service"});
        foreach (var key in session_unit_map.keys) {
            var unit = session_unit_map.get(key);
            search_results.set ("%s → %s".printf (display_name, unit.id), SESSION);
        }
        return search_results;
    }

}

public Switchboard.Plug get_plug (Module module) {
    return new ServicesPlug ();
}
