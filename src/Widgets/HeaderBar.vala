public class ServiceManager.HeaderBar : Gtk.HeaderBar {

    public ServiceManager.Window main_window { get; construct; }

    public HeaderBar(ServiceManager.Window servicemanager_window) {
        Object (
            main_window: servicemanager_window
        );
    }

    construct {

        show_close_button = true;

        var menu_button = new Gtk.Button.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        menu_button.valign = Gtk.Align.CENTER;

        pack_end (menu_button);

        var stack_switcher = new Gtk.StackSwitcher ();
        stack_switcher.stack = main_window.stack;

        set_custom_title (stack_switcher);
    }

}
