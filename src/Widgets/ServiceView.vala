public class ServiceManager.ServiceView : Granite.SimpleSettingsPage {
    
    //private string active_state;

    public ServiceView (string service_name, string service_description, string active_state, string? header) {
        Object ( // like super() in Java
            header: _(header),
            //  icon_name: "mouse-touchpad-clicking",
            title: service_name,
            description: service_description,
            activatable: true
        );
        this.status_switch.active = (active_state == "active");
    }

    construct {
        //  var state_label = new SettingsLabel (_("Active:"));
        //  var state_switch = new Gtk.Switch () {
        //      active = (this.active_state == "active"),
        //      halign = Gtk.Align.START
        //  };
        //  content_area.attach (state_label, 0, 0);
        //  content_area.attach (state_switch, 1, 0); 
    }

}
