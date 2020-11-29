public class ServiceManager.ServiceView : Granite.SimpleSettingsPage {

    public ServiceView (string service_name, string service_description, string active_state, string? header) {

        var icon_widget = new Gtk.Grid();
        string icon_name = (active_state == "active") ? "user-available": "user-busy";
        icon_widget.add(new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.MENU));

        Object ( // like super() in Java
            header: _(header),
            title: service_name,
            description: service_description,
            activatable: true,
            display_widget: icon_widget
        );

        this.status_switch.active = (active_state == "active");
    }

}
