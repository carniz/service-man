public class ServiceManager.ServicePaned : Gtk.Paned {

    public Gtk.Stack stack;

    public ServicePaned (Gtk.Stack stack) {
        Object(
            orientation: Gtk.Orientation.HORIZONTAL
        );
        this.stack = stack;
    }

}