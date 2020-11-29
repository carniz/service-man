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

    public abstract UnitInfo[] list_units() throws Error;
    public abstract UnitInfo[] list_units_by_patterns(string[] states, string[] patterns) throws Error;
}
