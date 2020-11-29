executable(
	meson.project_name(),

	'ServiceManagerApplication.vala',

	'DBusProxies/SystemdManager.vala',

	'Widgets/Window.vala',
	'Widgets/HeaderBar.vala',
	'Widgets/ServiceView.vala',
	'Widgets/SettingsLabel.vala',

	dependencies: [
		dependency('glib-2.0'),
		dependency('gobject-2.0'),
		dependency('gtk+-3.0'),
		dependency('gio-2.0'),
		dependency('granite'),
		dependency('gee-0.8')
	],

	install: true
)
