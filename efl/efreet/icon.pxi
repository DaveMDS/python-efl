from efl.eo cimport convert_python_list_strings_to_eina_list, \
    convert_eina_list_strings_to_python_list

#cdef class IconRectangle(object):
#    cdef:
#        icon_rectangle *embedded_text_rectangle

cdef class Icon(object):
    """

    Retrieves all of the information about the given icon.

    :param theme_name: The icon theme to look for
    :param icon: The icon to look for
    :param size: The icon size to look for
    :return: Returns the Efreet_Icon structure representing this icon or None
        if the icon is not found

    """
    cdef:
        Efreet_Icon       *icon

    def __cinit__(self, theme_name, icon, unsigned int size):
        self.icon = efreet_icon_find(_cfruni(theme_name), _cfruni(icon), size)

    def __dealloc__(self):
        efreet_icon_free(self.icon)

    property path:
        """Full path to the icon"""
        def __get__(self):
            return _ctouni(self.icon.path)

    property name:
        """Translated UTF8 string that can be used for the icon name"""
        def __get__(self):
            return _ctouni(self.icon.name)

    property embedded_text_rectangle:
        """Rectangle where text can be displayed on the icon"""
        def __get__(self):
            pass
            #return self.icon.embedded_text_rectangle

    #property attach_points:
        #"""List of points to be used as anchor points for emblems/overlays"""
        #Eina_List *attach_points

    property ref_count:
        """References to this icon"""
        def __get__(self):
            return self.icon.ref_count

    property has_embedded_text_rectangle:
        """Has the embedded rectangle set"""
        def __get__(self):
            return bool(self.icon.has_embedded_text_rectangle)

cdef class IconTheme(object):
    """theme_find(unicode theme_name) -> IconTheme

    Tries to get the icon theme structure for the given theme name

    :param theme_name: The theme to look for
    :return: Returns the icon theme related to the given theme name or None if
        none exists.

    """
    cdef:
        Efreet_Icon_Theme *icon_theme

    def __cinit__(self, theme_name):
        self.icon_theme = efreet_icon_theme_find(_cfruni(theme_name))

    property comment:
        """String describing the theme"""
        def __get__(self):
            return self.icon_theme.comment

    property example_icon:
        """Icon to use as an example of the theme"""
        def __get__(self):
            return self.icon_theme.example_icon

    property paths:
        """The paths"""
        def __get__(self):
            return convert_eina_list_strings_to_python_list(self.icon_theme.paths)

    property inherits:
        """Icon themes we inherit from"""
        def __get__(self):
            return# TODO: Eina_List *self.icon_theme.inherits

    property directories:
        """List of subdirectories for this theme"""
        def __get__(self):
            return convert_eina_list_strings_to_python_list(self.icon_theme.directories)

def user_dir_get():
    """user_dir_get() -> unicode

    Returns the user icon directory

    :return: Returns the user icon directory

    """
    return _ctouni(efreet_icon_user_dir_get())

def deprecated_user_icon_get():
    """deprecated_user_icon_get() -> unicode

    Returns the deprecated user icon directory

    :return: Returns the deprecated user icon directory

    """
    return _ctouni(efreet_icon_deprecated_user_dir_get())

def extension_add(ext):
    """extension_add(unicode ext)

    Adds the given extension to the list of possible icon extensions

    :param ext: The extension to add to the list of checked extensions

    """
    efreet_icon_extension_add(_cfruni(ext))

def extra_list_get():
    """extra_list_get() -> list

    Gets the list of all extra directories to look for icons. These
    directories are used to look for icons after looking in the user icon dir
    and before looking in standard system directories. The order of search is
    from first to last directory in this list. the strings in the list should
    be created with eina_stringshare_add().

    :return: Returns a list of strings that are paths to other icon directories

    """
    pass
    #EAPI Eina_List        **efreet_icon_extra_list_get()

def extensions_list_get():
    """extensions_list_get() -> list

    Gets the list of all icon extensions to look for

    :return: Returns a list of strings that are icon extensions to look for

    """
    return convert_eina_list_strings_to_python_list(efreet_icon_extensions_list_get())

def theme_list_get():
    """theme_list_get() -> list

    Retrieves all of the non-hidden icon themes available on the system.
    The returned list must be freed. Do not free the list data.

    :return: Returns a list of Efreet_Icon structs for all the non-hidden icon
    themes

    """
    pass
    #EAPI Eina_List         *efreet_icon_theme_list_get();

def list_find(theme_name, list icons, unsigned int size):
    """list_find(unicode theme_name, list icons, int size) -> unicode

    Retrieves all of the information about the first found icon in the list.

    There is no guarantee for how long the pointer to the path will be valid.
    If the pointer is to be kept, the user must create a copy of the path.

    .. note ::

        This function will search the given theme for all icons before falling
        back. This is useful when searching for mimetype icons.

    :param theme_name: The icon theme to look for
    :param icons: List of icons to look for
    :param size:; The icon size to look for
    :return: Returns the path representing first found icon or
        None if none of the icons are found

    """
    return _ctouni(efreet_icon_list_find(_cfruni(theme_name), convert_python_list_strings_to_eina_list(icons), size))

def path_find(theme_name, icon, unsigned int size):
    """path_find(unicode theme_name, unicode icon, int size) -> unicode

    Retrives the path to the given icon.

    There is no guarantee for how long the pointer to the path will be valid.
    If the pointer is to be kept, the user must create a copy of the path.

    :param theme_name: The icon theme to look for
    :param icon: The icon to look for
    :param size:; The icon size to look for
    :return: Returns the path to the given icon or None if none found

    """
    return _ctouni(efreet_icon_path_find(_cfruni(theme_name), _cfruni(icon), size))
