cdef class EfreetMenu(object):

    """Stores information on a entry in the menu"""

    cdef:
        Efreet_Menu *menu

        Efreet_Menu_Entry_Type type
        const_char *id   # File-id for desktop and relative name for menu

        const_char *name # Name this entry should show
        const_char *icon # Icon for this entry

        Efreet_Desktop *desktop   # The desktop we refer too
        Eina_List      *entries   # The menu items

    def __init__(self, name=None, path=None):
        # TODO: change two of these into class methods?
        if name is not None:
            """
            Creates a new menu

            :param name: The internal name of the menu
            :return: Returns the Efreet_Menu on success or NULL on failure
            """
            self.menu = efreet_menu_new(_cfruni(name))
        elif path is not None:
            """
            Parses the given .menu file and creates the menu representation

            :param path: The path of the menu to load
            :return: Returns the Efreet_Menu_Internal representation on success
                or NULL on failure
            """
            self.menu = efreet_menu_parse(_cfruni(path))
        else:
            """
            Creates the default menu representation

            :return: Returns the Efreet_Menu_Internal representation of the
                default menu or NULL if none found
            """
            self.menu = efreet_menu_get()

    def save(self, path):
        """
        :param path: The path where the menu should be saved
        :return: Returns 1 on success, 0 on failure
        Saves the menu to file
        """
        # TODO: Check return status and raise exception if 0
        return bool(efreet_menu_save(self.menu, _cfruni(path)))

    def free(self):
        """
        Frees the given structure
        """
        efreet_menu_free(self.menu)

    def desktop_insert(self, EfreetDesktop desktop, int pos):
        """
        :param desktop: The desktop to insert
        :param pos: The position to place the new desktop
        :return: Returns 1 on success, 0 on failure
        Insert a desktop element in a menu structure. Only accepts desktop files
        in default directories.
        """
        return efreet_menu_desktop_insert(self.menu, desktop.desktop, pos)

    def desktop_remove(self, EfreetDesktop desktop):
        """
        :param desktop: The desktop to remove
        :return: Returns 1 on success, 0 on failure
        Remove a desktop element in a menu structure. Only accepts desktop files
        in default directories.
        """
        return efreet_menu_desktop_remove(self.menu, desktop.desktop)

    def dump(self, indent):
        """
        :param indent: The indent level to print the menu at
        :return: Returns no value
        Dumps the contents of the menu to the command line
        """
        # XXX: indent level?
        efreet_menu_dump(self.menu, _cfruni(indent))

def menu_kde_legacy_init():
    """
    :return: Returns no value
    Initialize legacy kde support. This function blocks while
    the kde-config script is run.
    """
    # XXX: Returns an int?
    efreet_menu_kde_legacy_init()

def menu_file_set(file):
    """
    Override which file is used for menu creation
    :param file: The file to use for menu creation

    This file is only used if it exists, else the standard files will be used
    for the menu.
    """
    efreet_menu_file_set(_cfruni(file))

