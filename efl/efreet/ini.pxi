from efl.eo cimport _cfruni, _ctouni

cdef class Ini(object):

    """

    Contains all the information about an ini file.

    """

    cdef Efreet_Ini *ini
    #cdef Eina_Hash *data    # Hash of string => (Hash of string => string)
    #cdef Eina_Hash *section # currently selected section

    def __cinit__(self, file):
        """
        :param file: The file to parse
        :return: Returns a new Efreet_Ini structure initialized with the contents
        of @a file, or NULL on memory allocation failure
        Creates and initializes a new Ini structure with the contents of
        @a file, or NULL on failure

        """
        self.ini = efreet_ini_new(_cfruni(file))

    def __dealloc__(self):
        if self.ini is not NULL:
            efreet_ini_free(self.ini)

    def save(self, path):
        """save(unicode path) -> bool

        Saves the given Efree_Ini structure.

        :param path: The path to save the ini to
        :type path: unicode
        :return: Whether save succeeded
        :rtype: bool

        """
        return bool(efreet_ini_save(self.ini, _cfruni(path)))

    #TODO: property data:

    property section:
        """

        :param section: The section of the ini file we want to get values from
        :return: Returns 1 if the section exists, otherwise 0
        Sets the current working section of the ini file to @a section

        """
        #TODO: def __get__(self):

        def __set__(self, section):
            ret = efreet_ini_section_set(self.ini, _cfruni(section))
            if ret is 0:
                raise RuntimeError("Setting Ini section failed")

    def section_add(self, section):
        """section_add(unicode section)

        Adds a new working section of the ini file to section

        :param section: The section of the ini file we want to add

        """
        efreet_ini_section_add(self.ini, _cfruni(section))

    def string_get(self, key):
        """string_get(unicode key) -> unicode

        Retrieves the value for the given key or NULL if none found.

        :param key: The key to lookup
        :return: Returns the string associated with the given key or NULL if not
        found.

        """
        return _ctouni(efreet_ini_string_get(self.ini, _cfruni(key)))

    def string_set(self, key, value):
        """string_set(unicode key, unicode value)

        Sets the value for the given key

        :param key: The key to use
        :param value: The value to set

        """
        efreet_ini_string_set(self.ini, _cfruni(key), _cfruni(value))

    def localestring_get(self, key):
        """localestring_get(unicode key) -> unicode

        Retrieves the utf8 encoded string associated with key in the current locale or None if none found

        :param key: The key to search for
        :return: Returns the utf8 encoded string associated with key, or None
                if none found

        """
        _ctouni(efreet_ini_localestring_get(self.ini, _cfruni(key)))

    def localestring_set(self, key, value):
        """localestring_set(unicode key, unicode value)

        Sets the value for the given key

        :param key: The key to use
        :param value: The value to set

        """
        efreet_ini_localestring_set(self.ini, _cfruni(key), _cfruni(value))

    def boolean_get(self, key):
        """boolean_get(unicode key) -> bool

        Retrieves the boolean value at key @a key from the ini @a ini

        :param key: The key to search for
        :return: Returns 1 if the boolean is true, 0 otherwise

        """
        return bool(efreet_ini_boolean_get(self.ini, _cfruni(key)))

    def boolean_set(self, key, int value):
        """boolean_set(unicode key, bool value)

        Sets the value for the given key

        :param key: The key to use
        :param value: The value to set

        """
        efreet_ini_boolean_set(self.ini, _cfruni(key), value)

    def int_get(self, key):
        """int_get(unicode key) -> int

        Retrieves the value for the given key or -1 if none found.

        :param key: The key to lookup
        :return: Returns the integer associated with the given key or -1 if not
        found.

        """
        return efreet_ini_int_get(self.ini, _cfruni(key))

    def int_set(self, key, int value):
        """int_set(unicode key, int value)

        Sets the value for the given key

        :param key: The key to use
        :param value: The value to set

        """
        efreet_ini_int_set(self.ini, _cfruni(key), value)

    def double_get(self, key):
        """double_get(unicode key) -> double

        Retrieves the value for the given key or -1 if none found.

        :param key: The key to lookup
        :return: Returns the double associated with the given key or -1 if not
        found.

        """
        return efreet_ini_double_get(self.ini, _cfruni(key))

    def double_set(self, key, double value):
        """double_set(unicode key, double value)

        Sets the value for the given key

        :param key: The key to use
        :param value: The value to set

        """
        efreet_ini_double_set(self.ini, _cfruni(key), value)

    def key_unset(self, key):
        """key_unset(unicode key)

        Remove the given key from the ini struct

        :param key: The key to remove

        """
        efreet_ini_key_unset(self.ini, _cfruni(key))
