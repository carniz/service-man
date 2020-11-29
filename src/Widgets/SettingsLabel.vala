public class SettingsLabel : Gtk.Label {

    public SettingsLabel (string label) {
        Object (label: label);
    }

    construct {
        halign = Gtk.Align.END;
    }
}

