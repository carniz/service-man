project(
    'service-manager', 
    'vala', 'c'
)

gettext_name = meson.project_name()

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(gettext_name),
    language:'c'
)

subdir('src')
subdir('data')

meson.add_install_script('meson/post_install.py')
