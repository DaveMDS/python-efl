from efl.eo cimport convert_python_list_strings_to_eina_list, convert_eina_list_strings_to_python_list
cimport enums

EFREET_DESKTOP_TYPE_APPLICATION = enums.EFREET_DESKTOP_TYPE_APPLICATION
EFREET_DESKTOP_TYPE_LINK = enums.EFREET_DESKTOP_TYPE_LINK
EFREET_DESKTOP_TYPE_DIRECTORY = enums.EFREET_DESKTOP_TYPE_DIRECTORY

cdef void * efreet_desktop_command_cb(void *data, Efreet_Desktop *desktop, char *command, int remaining):
    """A callback used with efreet_desktop_command_get()"""

cdef int efreet_desktop_progress_cb(void *data, Efreet_Desktop *desktop, char *uri, long int total, long int current):
    """A callback used to get download progress of remote uris"""

cdef void * efreet_desktop_type_parse_cb(Efreet_Desktop *desktop, Efreet_Ini *ini):
    """A callback used to parse data for custom types"""

cdef void efreet_desktop_type_save_cb(Efreet_Desktop *desktop, Efreet_Ini *ini):
    """A callback used to save data for custom types"""

cdef void * efreet_desktop_type_free_cb(void *data):
    """A callback used to free data for custom types"""

cdef class EfreetDesktop(object):
    cdef:
        Efreet_Desktop *desktop

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
        char *executable              # Program to execute
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
        unsigned char eet             # The desktop file is in eet cache

        Eina_Hash *x    # Keep track of all user extensions, keys that begin with X-
        void *type_data # Type specific data for custom types

    def __init__(self, file, new=False, cached=True):
        if not new:
            if cached:
                self.desktop = efreet_desktop_new(_cfruni(file))
                #FIXME: What's the difference between these two?
                #self.desktop = efreet_desktop_get(_cfruni(file))
            else:
                self.desktop = efreet_desktop_uncached_new(_cfruni(file))
        else:
            self.desktop = efreet_desktop_empty_new(_cfruni(file))

        # get:
        """Gets a reference to an Efreet_Desktop structure representing the
        contents of @a file or NULL if @a file is not a valid .desktop file.

        By using efreet_desktop_get the Efreet_Desktop will be saved in an internal
        cache for quicker loading.

        Users of this command should listen to EFREET_EVENT_DESKTOP_CACHE_UPDATE
        event, if the application is to keep the reference. When the event fires
        the Efreet_Desktop struct should be invalidated and reloaded from a new
        cache file.

        :param file: The file to get the Efreet_Desktop from
        :return: Returns a reference to a cached Efreet_Desktop on success, NULL
        on failure

        """

        # uncached new:
        """
        :param file: The file to create the Efreet_Desktop from
        :return: Returns a new Efreet_Desktop on success, NULL on failure
        Creates a new Efreet_Desktop structure initialized from the
        contents of @a file or NULL on failure

        By using efreet_desktop_uncached_new the Efreet_Desktop structure will be
        read from disk, and not from any cache.

        Data in the structure is allocated with strdup, so use free and strdup to
        change values.
        """

        # empty new:
        """
        :param file: The file to create the Efreet_Desktop from
        :return: Returns a new empty_Efreet_Desktop on success, NULL on failure
        Creates a new empty Efreet_Desktop structure or NULL on failure
        """

        # new:
        """
        :param file: The file to get the Efreet_Desktop from
        :return: Returns a reference to a cached Efreet_Desktop on success, NULL
        on failure
        Gets a reference to an Efreet_Desktop structure representing the
        contents of @a file or NULL if @a file is not a valid .desktop file.

        Users of this command should listen to EFREET_EVENT_DESKTOP_CACHE_UPDATE
        event, if the application is to keep the reference. When the event fires
        the Efreet_Desktop struct should be invalidated and reloaded from a new
        cache file.
        """

    def ref(self):
        """ref() -> int

        Increases reference count on desktop

        :return: Returns the new reference count

        """
        return efreet_desktop_ref(self.desktop)

    def free(self):
        """free()

        Frees the Efreet_Desktop structure and all of it's data

        """
        efreet_desktop_free(self.desktop)

    def save(self):
        """save() -> bool

        Saves any changes made to @a desktop back to the file on the
        filesystem

        :return: Returns 1 on success or 0 on failure

        """
        #TODO: Check the return status here and raise exception if 0?
        return bool(efreet_desktop_save(self.desktop))

    def save_as(self, file):
        """save_as(unicode file) -> bool

        Saves @a desktop to @a file

        Please use efreet_desktop_uncached_new() on an existing file
        before using efreet_desktop_save_as()

        :param file: The filename to save as
        :return: Returns 1 on success or 0 on failure

        """
        #TODO: Check the return status here and raise exception if 0?
        return bool(efreet_desktop_save_as(self.desktop, _cfruni(file)))

    def exe_get(self, files, *args, **kwargs):
        """exe_get(list files, *args, **kwargs) -> efl.ecore.Exe

        Parses the @a desktop exec line and returns an Ecore_Exe.

        :param files: The files to be substituted into the exec line
        :param data: The data pointer to pass
        :return: Returns the Ecore_Exce for @a desktop

        """
        pass
        #TODO: How can this return an Exe???
        #void efreet_desktop_exec(self.desktop, python_list_strings_to_eina_list(files), void *data)

    def command_progress_get(self, files, cb_command, cb_prog, *args, **kwargs):
        """command_progress_get(list files, cb_command, cb_prog, *args, **kwargs) -> bool

        Get a command to use to execute a desktop entry, and receive progress
        updates for downloading of remote URI's passed in.

        :param files: an eina list of file names to execute, as either absolute paths,
        relative paths, or uris
        :param cb_command: a callback to call for each prepared command line
        :param cb_prog: a callback to get progress for the downloads
        :param data: user data passed to the callback
        :return: Returns 1 on success or 0 on failure

        """
        pass
        # XXX: Actually returns an int?
#        EAPI void             *efreet_desktop_command_progress_get(self.desktop,
#                                                 Eina_List *files,
#                                                 Efreet_Desktop_Command_Cb cb_command,
#                                                 Efreet_Desktop_Progress_Cb cb_prog,
#                                                 void *data);

    def command_get(self, files, func, *args, **kwargs):
        """command_get(list files, func, *args, **kwargs) -> retval

        Get a command to use to execute a desktop entry.

        :param files: an eina list of file names to execute, as either absolute paths,
        relative paths, or uris
        :param func: a callback to call for each prepared command line
        :param data: user data passed to the callback
        :return: Returns the return value of @p func on success or NULL on failure

        """
        # XXX: Actually returns an int?
#        EAPI void              *efreet_desktop_command_get(self.desktop,
#                                                 Eina_List *files,
#                                                 Efreet_Desktop_Command_Cb func,
#                                                 void *data);

    def command_local_get(self, files):
        """command_local_get(list files) -> list

        Get the command to use to execute a desktop entry

        The returned list and each of its elements must be freed.

        :param files: an eina list of local files, as absolute paths, local paths, or file// uris (or NULL to get exec string with no files appended)
        :return: Returns an eina list of exec strings

        """
        return convert_eina_list_strings_to_python_list(efreet_desktop_command_local_get(self.desktop, convert_python_list_strings_to_eina_list(files)))

    property category_count:
        """The number of categories the desktop belongs to

        :type: int

        """
        def __get__(self):
            return efreet_desktop_category_count_get(self.desktop)

    def category_add(self, category):
        """category_add(unicode category)

        Add a category to a desktop

        :param category: the category name

        """
        efreet_desktop_category_add(self.desktop, _cfruni(category))

    def category_del(self, category):
        """category_del(unicode category) -> bool

        Removes a category from a desktop

        :param category: the category name
        :return: 1 if the desktop had his category listed, 0 otherwise

        """
        # TODO: Check return status here and raise exception if 0
        return efreet_desktop_category_del(self.desktop, _cfruni(category))

    property type_data:
        """Type specific data for custom desktop types

        :type: type specific data, or None if there is none

        """
        def __get__(self):
            pass
            # TODO: void * efreet_desktop_type_data_get(self.desktop)

    def x_field_set(self, key, data):
        """x_field_set(unicode key, unicode data) -> bool

        Set the value for a X- field (Non spec) in the structure

        The key has to start with "X-"

        :param key: the key name to set
        :param data: the value to set
        :return: True on success

        """
        # TODO: Check return status and raise exception if 0
        return bool(efreet_desktop_x_field_set(self.desktop, _cfruni(key), _cfruni(data)))

    def x_field_get(self, key):
        """x_field_get(unicode key) -> unicode

        Get the value for a X- field (Non spec) in the structure

        :param key: the key
        :return: The value referenced by the key, or NULL if the key does not exist

        """
        return _ctouni(efreet_desktop_x_field_get(self.desktop, _cfruni(key)))

    def x_field_del(self, key):
        """x_field_del(unicode key) -> bool

        Delete the key and value for a X- field (Non spec) in the structure

        :param key: the key
        :return: True if the key existed

        """
        # TODO: Check return status and raise exception if 0
        return bool(efreet_desktop_x_field_del(self.desktop, _cfruni(key)))

def environment_set(environment):
    """Sets the global desktop environment name

    :param environment: the environment name

    """
    efreet_desktop_environment_set(_cfruni(environment))

def environment_get():
    """Gets the global desktop environment name

    :return: the environment name

    """
    return _ctouni(efreet_desktop_environment_get())

def type_add(type, parse_func, save_func, free_func):
    """type_add(unicode type, parse_func, save_func, free_func) -> int

    Adds the given type to the list of types in the system

    :param type: The type to add to the list of matching types
    :param parse_func: a function to parse out custom fields
    :param save_func: a function to save data returned from @a parse_func
    :param free_func: a function to free data returned from @a parse_func
    :return: Returns the id of the new type

    """
    pass
    # TODO:
#    return efreet_desktop_type_add(_cfruni(type),
#                                        Efreet_Desktop_Type_Parse_Cb parse_func,
#                                        Efreet_Desktop_Type_Save_Cb save_func,
#                                        Efreet_Desktop_Type_Free_Cb free_func)

def type_alias(int from_type, alias):
    """type_alias(int from_type, unicode alias) -> int

    Add an alias for an existing desktop type.

    This allows applications to add non-standard types that behave exactly as standard types.

    :param from_type: the type to alias (e.g. EFREE_DESKTOP_TYPE_APPLICATION)
    :param alias: the alias
    :return: the new type id, or -1 if @p from_type was not valid

    """
    return efreet_desktop_type_alias(from_type, _cfruni(alias))

def string_list_parse(string):
    """string_list_parse(unicode string) -> list

    Parse ';' separate list of strings according to the desktop spec

    :param string: the raw string list
    :return: an Eina_List of ecore string's

    """
    return convert_eina_list_strings_to_python_list(efreet_desktop_string_list_parse(_cfruni(string)))

def string_list_join(list lst):
    """string_list_join(list lst) -> unicode

    Create a ';' separate list of strings according to the desktop spec

    :param list: Eina_List with strings
    :return: a raw string list

    """
    return _ctouni(efreet_desktop_string_list_join(convert_python_list_strings_to_eina_list(lst)))
