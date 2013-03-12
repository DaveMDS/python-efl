EAPI extern int EFREET_DESKTOP_TYPE_APPLICATION;
EAPI extern int EFREET_DESKTOP_TYPE_LINK;
EAPI extern int EFREET_DESKTOP_TYPE_DIRECTORY;

cdef class EfreetDesktop(object):

    int type                # type of desktop file

    int ref                 # reference count - internal

    char *version           # version of spec file conforms to

    char *orig_path         # original path to .desktop file
    long long load_time     # modified time of .desktop on disk

    char *name              # Specific name of the application
    char *generic_name      # Generic name of the application
    char *comment           # Tooltip for the entry
    char *icon              # Icon to display in file manager, menus, etc
    char *try_exec          # Binary to determine if app is installed
    char *exec              # Program to execute
    char *path              # Working directory to run app in
    char *startup_wm_class  # If specified will map at least one window with
                            # the given string as it's WM class or WM name
    char *url               # URL to access if type is EFREET_TYPE_LINK

    Eina_List  *only_show_in    # list of environments that should
                                # display the icon
    Eina_List  *not_show_in     # list of environments that shoudn't
                                # display the icon
    Eina_List  *categories      # Categories in which item should be shown
    Eina_List  *mime_types      # The mime types supppored by this app

    unsigned char no_display        # Don't display this application in menus
    unsigned char hidden            # User delete the item
    unsigned char terminal          # Does the program run in a terminal
    unsigned char startup_notify    # The starup notify settings of the app
    unsigned char eet:1             # The desktop file is in eet cache

    Eina_Hash *x    # Keep track of all user extensions, keys that begin with X-
    void *type_data # Type specific data for custom types
