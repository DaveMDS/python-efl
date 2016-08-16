# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

from efl.evas cimport Object

cdef void text_change_cb(void *data,
                         Evas_Object *obj,
                         const char *part) with gil:
    cdef Edje self
    self = <Edje>data
    if self._text_change_cb is None:
        return
    func, args, kargs = self._text_change_cb
    try:
        func(self, _ctouni(part), *args, **kargs)
    except Exception:
        traceback.print_exc()


cdef void message_handler_cb(void *data,
                             Evas_Object *obj,
                             Edje_Message_Type type,
                             int id, void *msg) with gil:
    cdef Edje self
    self = <Edje>data
    if self._message_handler_cb is None:
        return
    func, args, kargs = self._message_handler_cb
    try:
        func(self, Message_from_type(type, id, msg), *args, **kargs)
    except Exception:
        traceback.print_exc()


cdef void signal_cb(void *data, Evas_Object *obj,
                    const char *emission, const char *source) with gil:
    cdef Edje self
    self = object_from_instance(obj)
    lst = tuple(<object>data)
    for func, args, kargs in lst:
        try:
            func(self, _ctouni(emission), _ctouni(source), *args, **kargs)
        except Exception:
            traceback.print_exc()


class EdjeLoadError(Exception):
    def __init__(self, int code, char *file, char *group):
        if code == enums.EDJE_LOAD_ERROR_NONE:
            msg = "No error"
        elif code == enums.EDJE_LOAD_ERROR_GENERIC:
            msg = "Generic error"
        elif code == enums.EDJE_LOAD_ERROR_DOES_NOT_EXIST:
            msg = "Does not exist"
        elif code == enums.EDJE_LOAD_ERROR_PERMISSION_DENIED:
            msg = "Permission denied"
        elif code == enums.EDJE_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED:
            msg = "Resource allocation failed"
        elif code == enums.EDJE_LOAD_ERROR_CORRUPT_FILE:
            msg = "Corrupt file"
        elif code == enums.EDJE_LOAD_ERROR_UNKNOWN_FORMAT:
            msg = "Unknown format"
        elif code == enums.EDJE_LOAD_ERROR_INCOMPATIBLE_FILE:
            msg = "Incompatible file"
        elif code == enums.EDJE_LOAD_ERROR_UNKNOWN_COLLECTION:
            msg = "Unknown collection"

        self.code = code
        self.file = file
        self.group = group
        Exception.__init__(self, "%s (file=%r, group=%r)" % (msg, file, group))


cdef class Edje(Object):
    """

    The Edje object.

    This is a high level :class:`efl.evas.SmartObject` that is defined as a
    group of parts, usually written in text files (.edc) and compiled as a
    package using EET to store resources (.edj).

    .. attention::
        messages are one way only! If you emit a message from Python
        you will just get it from your Embryo script, if you emit from Embryo
        you just get it in Python. If you want to emit events and capture
        them on the same side, use signals.

    """
    def __cinit__(self, *a, **ka):
        self._signal_callbacks = {}

    def __init__(self, Canvas canvas not None, file=None, group=None, size=None,
                 geometry=None, **kwargs):
        """Edje(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword string file: File name
        :keyword string group: Group name
        :keyword size: Min size for the object
        :type size: tuple of ints
        :keyword geometry: Geometry for the object
        :type geometry: tuple of ints
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """
        self._set_obj(edje_object_add(canvas.obj))
        _register_decorated_callbacks(self)

        if file:
            self.file_set(file, group)

        self._set_properties_from_keyword_args(kwargs)

        if not size and not geometry:
            w, h = self.size_min_get()
            self.size_set(w, h)

    def __free_wrapper_resources(self, ed):
        self._signal_callbacks.clear()
        self._text_change_cb = None
        self._message_handler_cb = None

    def __repr__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        file, group = self.file_get()
        name = self.name_get()
        if name:
            name_str = "name=%r, "
        else:
            name_str = ""
        clip = bool(self.clip_get() is not None)
        return ("<%s(%sfile=%r, group=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%r, visible=%s)>") % \
               (self.__class__.__name__, name_str, file, group,
                x, y, w, h, r, g, b, a,
                self.layer_get(), clip, self.visible_get())

    def data_get(self, key):
        """Get data from Edje data collection (defined in .edj).

        Data collection is defined inside an Edje file as::

           collections {
              group {
                 name: "a_group";
                 data {
                    item: "key1" "value1";
                    item: "key2" "value2";
                 }
              }
           }

        .. attention:: this differs from Edje.data! Edje.data is a
            Python specific utility provided as a dictionary. This function
            returns data stored on the Edje (.edj), stored inside a
            *data* section inside the *group* that defines this object.

        :type: string

        """
        if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
        return _ctouni(edje_object_data_get(self.obj,
                            <const char *>key if key is not None else NULL))

    def file_set(self, file, group):
        """Set the file (.edj) and the group to load the Edje object from.

        :param string file: the name of the file to load
        :param string group: the name of the group inside the edj to load

        :raise EdjeLoadError: if error occurred during load.

        """
        if isinstance(file, unicode): file = PyUnicode_AsUTF8String(file)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        if edje_object_file_set(self.obj,
                <const char *>file if file is not None else NULL,
                <const char *>group if group is not None else NULL) == 0:
            raise EdjeLoadError(edje_object_load_error_get(self.obj), file, group)

    def file_get(self):
        """Get the file and group used to load the object.

        :return: the tuple (file, group)
        :rtype: tuple of str

        """
        cdef:
            const char *file
            const char *group
        edje_object_file_get(self.obj, &file, &group)
        return (_ctouni(file), _ctouni(group))

    def load_error_get(self):
        """:rtype: int"""
        return edje_object_load_error_get(self.obj)

    def play_get(self):
        """:rtype: bool"""
        return bool(edje_object_play_get(self.obj))

    def play_set(self, int value):
        """Set the Edje to play or pause.

        :param value: True to play or False to pause
        :type value: int

        """
        edje_object_play_set(self.obj, value)

    property play:
        def __get__(self):
            return self.play_get()

        def __set__(self, int value):
            self.play_set(value)

    def animation_get(self):
        """:rtype: bool"""
        return bool(edje_object_animation_get(self.obj))

    def animation_set(self, int value):
        """Set animation state."""
        edje_object_animation_set(self.obj, value)

    property animation:
        def __get__(self):
            return self.animation_get()

        def __set__(self, int value):
            self.animation_set(value)

    def freeze(self):
        """This puts all changes on hold.

        Successive freezes will nest, requiring an equal number of thaws.

        :rtype: int
        """
        return edje_object_freeze(self.obj)

    def thaw(self):
        """Thaw (unfreeze) the object."""
        return edje_object_thaw(self.obj)

    def preload(self, int cancel):
        """Preload the images on the Edje Object in the background.

        This function requests the preload of all data images in the background.
        The work is queued before being processed (because there might be other
        pending requests of this type). It emits the signal "preload,done"
        when finished.

        :param cancel: *True* will add it the preloading work queue, *False*
                       will remove it (if it was issued before).
        :type cancel: bool
        :rtype: bool

        .. versionadded:: 1.8

        """
        return bool(edje_object_preload(self.obj, cancel))

    def color_class_set(self, color_class,
                        int r, int g, int b, int a,
                        int r2, int g2, int b2, int a2,
                        int r3, int g3, int b3, int a3):
        """Set color class.

        :param color_class: color class name
        :param r:
        :param g:
        :param b:
        :param a:
        :param r2:
        :param g2:
        :param b2:
        :param a2:
        :param r3:
        :param g3:
        :param b3:
        :param a3:

        """
        if isinstance(color_class, unicode):
            color_class = PyUnicode_AsUTF8String(color_class)
        edje_object_color_class_set(self.obj,
            <const char *>color_class if color_class is not None else NULL,
            r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)

    def color_class_get(self, color_class):
        """Get a specific color class.

        :param color_class: the name of the color class to query
        :return: the tuple (r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)
        :rtype: tuple of int

        """
        cdef int r, g, b, a
        cdef int r2, g2, b2, a2
        cdef int r3, g3, b3, a3
        if isinstance(color_class, unicode):
            color_class = PyUnicode_AsUTF8String(color_class)
        edje_object_color_class_get(self.obj,
            <const char *>color_class if color_class is not None else NULL,
            &r, &g, &b, &a, &r2, &g2, &b2, &a2, &r3, &g3, &b3, &a3)
        return (r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)

    def color_class_del(self, color_class):
        """Delete a specific color class."""
        if isinstance(color_class, unicode):
            color_class = PyUnicode_AsUTF8String(color_class)
        edje_object_color_class_del(self.obj,
            <const char *>color_class if color_class is not None else NULL)

    def color_class_clear(self):
        """ Clear all object color classes.

        :return: True on success, False otherwise
        :rtype: bool

        .. versionadded:: 1.17

        """
        return bool(edje_object_color_class_clear(self.obj))

    def text_class_set(self, text_class, font, int size):
        """Set text class.

        :param text_class: text class name
        :param font: the font name
        :param size: the font size
        """
        if isinstance(text_class, unicode):
            text_class = PyUnicode_AsUTF8String(text_class)
        if isinstance(font, unicode):
            font = PyUnicode_AsUTF8String(font)
        edje_object_text_class_set(self.obj,
            <const char *>text_class if text_class is not None else NULL,
            <const char *>font if font is not None else NULL,
            size)

    def text_class_get(self, text_class):
        """ Gets font and font size from edje text class.

        This function gets the font and the font size from the object
        text class.

        :param string text_class: The text class name to query

        :return: The font name and the font size
        :rtype: (font_name, font_size)

        .. versionadded:: 1.14

        """
        cdef:
            const char *font
            int size
        if isinstance(text_class, unicode):
            text_class = PyUnicode_AsUTF8String(text_class)
        edje_object_text_class_get(self.obj,
            <const char *>text_class if text_class is not None else NULL,
            &font, &size)
        return (_ctouni(font), size)

    def text_class_del(self, text_class):
        """Delete the object text class.

        This function deletes any values at the object level for the specified
        text class.

        Note: deleting the text class will revert it to the values defined by
        edje_text_class_set() or the text class defined in the theme file.

        :param string text_class: The text class name to be deleted

        .. versionadded:: 1.17

        """
        if isinstance(text_class, unicode):
            text_class = PyUnicode_AsUTF8String(text_class)
        edje_object_text_class_del(self.obj,
                <const char *>text_class if text_class is not None else NULL)

    def size_class_set(self, size_class, int minw, int minh, int maxw, int maxh):
        """Sets the object size class.

        This function sets the min and max values for an object level size
        class. This will make all edje parts in the specified object that have
        the specified size class update their min and max size with given
        values.

        :param str size_class: The size class name
        :param int minw: The min width
        :param int minh: The min height
        :param int maxw: The max width
        :param int maxh: The max height

        :return: True on success or False on error
        :rtype: bool

        .. versionadded:: 1.17

        """
        if isinstance(size_class, unicode):
            size_class = PyUnicode_AsUTF8String(size_class)
        return bool(edje_object_size_class_set(self.obj,
                    <const char *>size_class if size_class is not None else NULL,
                    minw, minh, maxw, maxh))

    def size_class_get(self, size_class):
        """Gets the object size class.

        This function gets the min and max values for an object level size
        class. These values will only be valid until the size class is changed
        or the edje object is deleted.

        :param str size_class: The size class name

        :return: (minw, minh, maxw, maxh)
        :rtype: 4 int's tuple

        .. versionadded:: 1.17

        """
        cdef int minw, minh, maxw, maxh

        if isinstance(size_class, unicode):
            size_class = PyUnicode_AsUTF8String(size_class)
        edje_object_size_class_get(self.obj,
            <const char *>size_class if size_class is not None else NULL,
            &minw, &minh, &maxw, &maxh)
        return (minw, minh, maxw, maxh)

    def size_class_del(self, size_class):
        """Delete the object size class.

        This function deletes any values at the object level for the specified
        object and size class.

        Note: Deleting the size class will revert it to the values defined by
        edje_size_class_set() or the size class defined in the theme file.

        :param str size_class: The size class name

        .. versionadded:: 1.17

        """
        if isinstance(size_class, unicode):
            size_class = PyUnicode_AsUTF8String(size_class)
        edje_object_size_class_del(self.obj,
            <const char *>size_class if size_class is not None else NULL)

    property scale:
        """The scaling factor for a given Edje object.

        :type: float

        .. versionadded:: 1.8

        """
        def __set__(self, double scale):
            edje_object_scale_set(self.obj, scale)

        def __get__(self):
            return edje_object_scale_get(self.obj)

    def scale_set(self, double scale):
        edje_object_scale_set(self.obj, scale)
    def scale_get(self):
        return edje_object_scale_get(self.obj)

    property base_scale:
        """ The base scale factor set in the edc collection.

        :type: float

        .. versionadded:: 1.12

        """
        def __get__(self):
            return edje_object_base_scale_get(self.obj)

    def base_scale_get(self):
        return edje_object_base_scale_get(self.obj)

    property mirrored:
        """The RTL orientation for this object.

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int rtl):
            edje_object_mirrored_set(self.obj, rtl)

        def __get__(self):
            return bool(edje_object_mirrored_get(self.obj))

    def mirrored_set(self, int rtl):
        edje_object_mirrored_set(self.obj, rtl)
    def mirrored_get(self):
        return bool(edje_object_mirrored_get(self.obj))

    def size_min_get(self):
        """:rtype: tuple of int"""
        cdef int w, h
        edje_object_size_min_get(self.obj, &w, &h)
        return (w, h)

    property size_min:
        def __get__(self):
            return self.size_min_get()

    def size_max_get(self):
        """:rtype: tuple of int"""
        cdef int w, h
        edje_object_size_max_get(self.obj, &w, &h)
        return (w, h)

    property size_max:
        def __get__(self):
            return self.size_max_get()

    def calc_force(self):
        """Force recalculation of parts state (geometry, position, ...)"""
        edje_object_calc_force(self.obj)

    def size_min_calc(self):
        """Request object to calculate minimum size."""
        cdef int w, h
        edje_object_size_min_calc(self.obj, &w, &h)
        return (w, h)

    def size_min_restricted_calc(self, minw, minh):
        """
        This call will trigger an internal recalculation of all parts of
        the object, in order to return its minimum required dimensions for
        width and height. The user might choose to *impose* those minimum sizes,
        making the resulting calculation to get values equal or bigger than
        minw and minh, for width and height, respectively.

        :note: At the end of this call, the object won't be automatically
               resized to new dimensions, but just return the calculated
               sizes. The caller is the one up to change its geometry or not.

        :warning: Be advised that invisible parts in the object obj will be
                  taken into account in this calculation.

        .. versionadded:: 1.8

        """
        cdef int w, h
        edje_object_size_min_restricted_calc(self.obj, &w, &h, minw, minh)
        return (w, h)

    def parts_extends_calc(self):
        """Calculate the geometry of the region, relative to a given Edje
        object's area, *occupied by all parts in the object*

        :return: (x, y, w, h)
        :rtype: tuple of 4 ints

        """
        cdef int x, y, w, h
        edje_object_parts_extends_calc(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    property update_hints:
        """ Edje will automatically update the size hints on itself.

        By default edje doesn't set size hints on itself. With this property
        set to *True* it will do so. Be carefully, it cost a lot to
        trigger this feature as it will recalc the object every time it make
        sense to be sure that's its minimal size hint is always accurate.

        :type: bool

        .. versionadded:: 1.8

        """
        def __get__(self):
            return bool(edje_object_update_hints_get(self.obj))

        def __set__(self, update):
            edje_object_update_hints_set(self.obj, update)

    def update_hints_get(self):
        return bool(edje_object_update_hints_get(self.obj))
    def update_hints_set(self, update):
        edje_object_update_hints_set(self.obj, update)

    def part_exists(self, part):
        """:rtype: bool"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_exists(self.obj,
                        <const char *>part if part is not None else NULL))

    def part_object_get(self, part):
        """Get the efl.evas.Object that represents this part.

        .. warning::
            You should never modify the state of the returned object (with
            Edje.move() or Edje.hide() for example), but you can safely
            query info about its current state (with Edje.visible_get() or
            Edje.color_get() for example).

        """
        cdef Evas_Object *obj
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        obj = <Evas_Object*>edje_object_part_object_get(self.obj,
                            <const char *>part if part is not None else NULL)
        return object_from_instance(obj)

    def part_geometry_get(self, part):
        """:rtype: tuple of int"""
        cdef int x, y, w, h
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_geometry_get(self.obj,
                            <const char *>part if part is not None else NULL,
                            &x, &y, &w, &h)
        return (x, y, w, h)

    def part_size_get(self, part):
        """:rtype: tuple of int"""
        cdef int w, h
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_geometry_get(self.obj,
            <const char *>part if part is not None else NULL,
            NULL, NULL, &w, &h)
        return (w, h)

    def part_pos_get(self, part):
        """:rtype: tuple of int"""
        cdef int x, y
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_geometry_get(self.obj,
            <const char *>part if part is not None else NULL,
            &x, &y, NULL, NULL)
        return (x, y)

    def text_change_cb_set(self, func, *args, **kargs):
        """Set function to callback on text changes.

        :param func:
            The function to call when text change
            Expected signature::

                function(object, part, *args, **kargs)

        """
        if func is None:
            self._text_change_cb = None
            edje_object_text_change_cb_set(self.obj, NULL, NULL)
        elif callable(func):
            self._text_change_cb = (func, args, kargs)
            edje_object_text_change_cb_set(self.obj, text_change_cb, <void*>self)
        else:
            raise TypeError("func must be callable or None")

    def part_text_set(self, part, text):
        """Set the text of a given part.

        :param part: name of the text part to edit
        :param text: the new text to set

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        edje_object_part_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>text if text is not None else NULL)

    def part_text_get(self, part):
        """Get the text of a given part.

        :return: the text of part
        :rtype: str

        """
        cdef const char *s
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(edje_object_part_text_get(self.obj,
                        <const char *>part if part is not None else NULL))

    def part_text_select_all(self, part):
        """Select all the text of the given TEXT or TEXTBLOCK part"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_text_select_all(self.obj,
            <const char *>part if part is not None else NULL)

    def part_text_select_none(self, part):
        """Deselect all the text of the given TEXT or TEXTBLOCK part"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_text_select_none(self.obj,
            <const char *>part if part is not None else NULL)

    def part_text_unescaped_set(self, part, text_to_escape):
        """Automatically escapes text if using TEXTBLOCK.

        Similar to part_text_set(), but if it is a textblock contents
        will be escaped automatically so it is displayed without any
        formatting.

        :see: part_text_set()
        :see: part_text_unescaped_get()
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text_to_escape, unicode):
            text_to_escape = PyUnicode_AsUTF8String(text_to_escape)
        edje_object_part_text_unescaped_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>text_to_escape if text_to_escape is not None else NULL)

    def part_text_unescaped_get(self, part):
        """Automatically removes escape from text if using TEXTBLOCK.

        Similar to part_text_get(), but if it is a textblock contents
        will be unescaped automatically.

        :see: part_text_get()
        :see: part_text_unescaped_set()
        """
        cdef char *s
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        s = edje_object_part_text_unescaped_get(self.obj,
                <const char *>part if part is not None else NULL)
        if s == NULL:
            return None
        else:
            str = _touni(s)
            libc.stdlib.free(s)
            return str

    def part_text_input_hint_set(self, part, input_hints):
        """ Sets the input hint which allows input methods to fine-tune
        their behavior.

        :param part: the part name
        :type part: str
        :param input_hints: the hints to set
        :type input_hints: Edje_Input_Hints

        .. versionadded:: 1.12

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_text_input_hint_set(self.obj,
                            <const char *>part if part is not None else NULL,
                            input_hints)

    def part_text_input_hint_get(self, part):
        """ Gets the value of input hint.

        :param part: the part name
        :type part: str

        .. versionadded:: 1.12

        """

        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return edje_object_part_text_input_hint_get(self.obj,
                            <const char *>part if part is not None else NULL)

    def part_swallow(self, part, Object obj):
        """Swallows an object into the edje

        Swallows the object into the edje part so that all geometry changes
        for the part affect the swallowed object. (e.g. resize, move, show,
        raise/lower, etc.).

        If an object has already been swallowed into this part, then it will
        first be unswallowed before the new object is swallowed.

        :param part: the name of the SWALLOW part
        :type part: str
        :param obj: the efl.evas.Object to swallow inside part
        :type obj: efl.evas.Object

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_swallow(self.obj,
            <const char *>part if part is not None else NULL, obj.obj)

    def part_unswallow(self, Object obj):
        """Unswallow the given object from the edje"""
        edje_object_part_unswallow(self.obj, obj.obj)

    def part_swallow_get(self, part):
        """:rtype: efl.evas.Object"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(edje_object_part_swallow_get(
                    self.obj, <const char *>part if part is not None else NULL))

    def part_external_object_get(self, part):
        """:rtype: efl.evas.Object"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(edje_object_part_external_object_get(
                    self.obj, <const char *>part if part is not None else NULL))

    def part_external_param_set(self, part, param, value):
        """Set a parameter of the external part.

        :param part: EXTERNAL part to set parameter.
        :param param: EXTERNAL parameter name.
        :param value: value to set, type is guessed from it, so must
               be of types bool, int, float or str.
        :rtype: bool
        """
        cdef Edje_External_Param p
        cdef const char *c_part
        cdef const char *c_param

        if isinstance(part, unicode):
            str1 = PyUnicode_AsUTF8String(part)
            c_part = str1
        elif isinstance(part, str):
            c_part = part
        else:
            raise TypeError("part must be str or unicode, found %s" %
                             type(part).__name__)

        if isinstance(param, unicode):
            str2 = PyUnicode_AsUTF8String(param)
            c_param = str2
        elif isinstance(param, str):
            c_param = param
        else:
            raise TypeError("param must be str or unicode, found %s" %
                             type(param).__name__)

        p.name = c_param
        if isinstance(value, bool): # bool is int, so keep it before!
            p.type = enums.EDJE_EXTERNAL_PARAM_TYPE_BOOL
            p.i = value
        elif isinstance(value, int):
            p.type = enums.EDJE_EXTERNAL_PARAM_TYPE_INT
            p.i = value
        elif isinstance(value, float):
            p.type = enums.EDJE_EXTERNAL_PARAM_TYPE_DOUBLE
            p.d = value
        elif isinstance(value, (str, unicode)):
            # may be STRING or CHOICE
            p.type = edje_object_part_external_param_type_get(
                        self.obj, c_part, c_param)
            if isinstance(value, unicode):
                value = PyUnicode_AsUTF8String(value)
            p.s = value
        else:
            raise TypeError("unsupported type %s" % type(value).__name__)

        return bool(edje_object_part_external_param_set(self.obj, c_part, &p))

    def part_external_param_get(self, part, param):
        """Get a parameter of the external part.

        :param part: EXTERNAL part to set parameter.
        :param param: EXTERNAL parameter name.

        :return: *None* for errors, other values depending on the parameter type.
        """
        cdef Edje_External_Param p
        cdef const char *c_part
        cdef const char *c_param

        if isinstance(part, unicode):
            str1 = PyUnicode_AsUTF8String(part)
            c_part = str1
        elif isinstance(part, str):
            c_part = part
        else:
            raise TypeError("part must be str or unicode, found %s" %
                             type(part).__name__)

        if isinstance(param, unicode):
            str2 = PyUnicode_AsUTF8String(param)
            c_param = str2
        elif isinstance(param, str):
            c_param = param
        else:
            raise TypeError("param must be str or unicode, found %s" %
                             type(param).__name__)

        p.name = c_param
        p.type = edje_object_part_external_param_type_get(self.obj, c_part, c_param)
        if p.type >= <int>enums.EDJE_EXTERNAL_PARAM_TYPE_MAX:
            return None

        if not edje_object_part_external_param_get(self.obj, c_part, &p):
            return None
        if p.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_BOOL:
            return bool(p.i)
        elif p.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_INT:
            return p.i
        elif p.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_DOUBLE:
            return p.d
        elif p.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_STRING or \
             p.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_CHOICE:
            return _ctouni(p.s)

    def part_box_append(self, part, Object obj):
        """Adds an item to a BOX part.

        Appends an item to the BOX edje part, where some box's properties
        inherited. Like the color properties has some nice effect on the
        box's childrens.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to append
        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_append(self.obj,
                     <const char *>part if part is not None else NULL, obj.obj))

    def part_box_prepend(self, part, Object obj):
        """Prepend an item to a BOX part.

        Prepends an item to the BOX edje part, where some box's properties
        inherited. Like the color properties has some nice effect on the
        box's childrens.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to append
        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_prepend(self.obj,
                     <const char *>part if part is not None else NULL, obj.obj))

    def part_box_insert_at(self, part, Object obj,
                           unsigned int pos):
        """Inserts an item at the given position in a BOX part.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to append
        :param pos: the position to append the object
        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_insert_at(self.obj,
            <const char *>part if part is not None else NULL, obj.obj, pos))

    def part_box_insert_before(self, part, Object obj, Object reference):
        """Inserts an item in a BOX part before the reference object.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to append
        :param reference: the efl.evas.Object used as reference
        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_insert_before(self.obj,
                        <const char *>part if part is not None else NULL,
                        obj.obj, reference.obj))

    def part_box_insert_after(self, part, Object obj, Object reference):
        """Inserts an item in a BOX part after the reference object.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to append
        :param reference: the efl.evas.Object used as reference
        :rtype: bool

        .. versionadded:: 1.18

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_insert_after(self.obj,
                        <const char *>part if part is not None else NULL,
                        obj.obj, reference.obj))

    def part_box_remove(self, part, Object obj):
        """Removes the object given from a BOX part.

        Returns the object removed, or *None* if it wasn't found or is
        internal to Edje.

        :param part: the name of the BOX part
        :param obj: the efl.evas.Object to remove
        :return: the removed object
        :rtype: efl.evas.Object or *None*

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(edje_object_part_box_remove(self.obj,
                    <const char *>part if part is not None else NULL, obj.obj))

    def part_box_remove_at(self, part, unsigned int pos):
        """Removes the object at the given position in a BOX part.

        Returns the object removed, or None nothing was found at the
        given position, or if the object was internal to Edje.

        :param part: the name of the BOX part
        :param pos: the position to remove from
        :return: the removed object
        :rtype: efl.evas.Object or None
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(edje_object_part_box_remove_at(self.obj,
                        <const char *>part if part is not None else NULL, pos))

    def part_box_remove_all(self, part, int clear):
        """Removes all objects from a BOX part.

        :param part: the name of the BOX part to remove from.
        :param clear: if 1, it will delete the objects it removes.

        Note: this function doesn't remove items created from the theme.

        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_box_remove_all(self.obj,
                     <const char *>part if part is not None else NULL, clear))

    def part_table_pack(self, part, Object child, short col, short row, short colspan, short rowspan):
        """Pack an object inside a TABLE part.

        :param part: name of the TABLE part to pack in.
        :param child: efl.evas.Object to pack into the table.
        :param col:
        :param row:
        :param colspan:
        :param rowspan:

        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_table_pack(self.obj,
                        <const char *>part if part is not None else NULL,
                        child.obj, col, row, colspan, rowspan))

    def part_table_unpack(self, part, Object child):
        """Remove an object from a TABLE part.

        :param part: the name of the TABLE part to remove from.
        :param child: the efl.evas.Object to remove.

        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_table_unpack(self.obj,
                        <const char *>part if part is not None else NULL,
                        child.obj))

    def part_table_col_row_size_get(self, part):
        """Returns the size in columns/rows of the TABLE part.

        :param part: the anme of the TABLE part to get the size of.
        :return: the tuple (cols, rows)
        :rtype: tuple of int
        """
        cdef int c, r
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_table_col_row_size_get(self.obj,
            <const char *>part if part is not None else NULL, &c, &r)
        return (c, r)

    def part_table_clear(self, part, int clear):
        """Clears a TABLE part.

        :param part: the name of the TABLE part to clear all its elements from.
        :param clear: Delete objects when removed from the table.

        .. note:: This function will not remove the elements defined by the theme.

        :rtype: bool
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return bool(edje_object_part_table_clear(self.obj,
                     <const char *>part if part is not None else NULL, clear))

    def part_table_child_get(self, part, int row, int column):
        """Retrieve a child from a table.

        :param part: the name of the TABLE part to get child from.
        :param row: row index of the child.
        :param column: column index of the child.

        :return: the object ath the given position
        :rtype: efl.evas.Object
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(edje_object_part_table_child_get(self.obj,
                 <const char *>part if part is not None else NULL, row, column))

    def part_state_get(self, part):
        """:rtype: (name, value)"""
        cdef double sv
        cdef const char *sn
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        sn = edje_object_part_state_get(self.obj,
                 <const char *>part if part is not None else NULL, &sv)
        return (_ctouni(sn), sv)

    def part_drag_dir_get(self, part):
        """:rtype: int"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return edje_object_part_drag_dir_get(self.obj,
                    <const char *>part if part is not None else NULL)

    def part_drag_value_set(self, part, double dx, double dy):
        """Set the drag value of part
        :param dx:
        :param dy:
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_value_set(self.obj,
            <const char *>part if part is not None else NULL, dx, dy)

    def part_drag_value_get(self, part):
        """:rtype: tuple of float"""
        cdef double dx, dy
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_value_get(self.obj,
            <const char *>part if part is not None else NULL, &dx, &dy)
        return (dx, dy)

    def part_drag_size_set(self, part, double dw, double dh):
        """Set the drag size of part
        :param dw:
        :param dh:
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_size_set(self.obj,
            <const char *>part if part is not None else NULL, dw, dh)

    def part_drag_size_get(self, part):
        """:rtype: tuple of float"""
        cdef double dw, dh
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_size_get(self.obj,
            <const char *>part if part is not None else NULL, &dw, &dh)
        return (dw, dh)

    def part_drag_step_set(self, part, double dx, double dy):
        """Set the drag step of part
        :param dx:
        :param dy:
        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_step_set(self.obj,
            <const char *>part if part is not None else NULL, dx, dy)

    def part_drag_step_get(self, part):
        """:rtype: tuple of float"""
        cdef double dx, dy
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_step_get(self.obj,
            <const char *>part if part is not None else NULL, &dx, &dy)
        return (dx, dy)

    def part_drag_step(self, part, double dx, double dy):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_step(self.obj,
            <const char *>part if part is not None else NULL, dx, dy)

    def part_drag_page_set(self, part, double dx, double dy):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_page_set(self.obj,
            <const char *>part if part is not None else NULL, dx, dy)

    def part_drag_page_get(self, part):
        """:rtype: tuple of float"""
        cdef double dx, dy
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_page_get(self.obj,
            <const char *>part if part is not None else NULL, &dx, &dy)
        return (dx, dy)

    def part_drag_page(self, part, double dx, double dy):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        edje_object_part_drag_page(self.obj,
            <const char *>part if part is not None else NULL, dx, dy)

    cdef void message_send_int(self, int id, int data):
        cdef Edje_Message_Int m
        m.val = data
        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_INT, id, <void*>&m)

    cdef void message_send_float(self, int id, float data):
        cdef Edje_Message_Float m
        m.val = data
        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_FLOAT, id, <void*>&m)

    cdef void message_send_str(self, int id, data):
        cdef Edje_Message_String m
        if isinstance(data, unicode): data = PyUnicode_AsUTF8String(data)
        m.str = <char *>data if data is not None else NULL
        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING, id, <void*>&m)

    cdef void message_send_str_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_String_Set *m

        count = len(data)
        m = <Edje_Message_String_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Set) + (count - 1) * sizeof(char *))

        m.count = count
        i = 0
        for s in data:
            m.str[i] = s
            i += 1

        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_str_int(self, int id, s, int i):
        cdef Edje_Message_String_Int m
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        m.str = <char *>s if s is not None else NULL
        m.val = i
        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING_INT, id,
                                 <void*>&m)

    cdef void message_send_str_float(self, int id, s, float f):
        cdef Edje_Message_String_Float m
        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        m.str = <char *>s if s is not None else NULL
        m.val = f
        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING_FLOAT, id,
                                 <void*>&m)

    cdef void message_send_str_int_set(self, int id, s, data):
        cdef int count, i
        cdef Edje_Message_String_Int_Set *m

        count = len(data)
        m = <Edje_Message_String_Int_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Int_Set) + (count - 1) * sizeof(int))

        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        m.str = <char *>s if s is not None else NULL
        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i += 1

        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING_INT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_str_float_set(self, int id, s, data):
        cdef int count, i
        cdef Edje_Message_String_Float_Set *m

        count = len(data)
        m = <Edje_Message_String_Float_Set*>PyMem_Malloc(
            sizeof(Edje_Message_String_Float_Set) +
            (count - 1) * sizeof(double))

        if isinstance(s, unicode): s = PyUnicode_AsUTF8String(s)
        m.str = <char *>s if s is not None else NULL
        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i += 1

        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_STRING_FLOAT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_int_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_Int_Set *m

        count = len(data)
        m = <Edje_Message_Int_Set*>PyMem_Malloc(
            sizeof(Edje_Message_Int_Set) + (count - 1) * sizeof(int))

        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i += 1

        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_INT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef void message_send_float_set(self, int id, data):
        cdef int count, i
        cdef Edje_Message_Float_Set *m

        count = len(data)
        m = <Edje_Message_Float_Set*>PyMem_Malloc(
            sizeof(Edje_Message_Float_Set) + (count - 1) * sizeof(double))

        m.count = count
        i = 0
        for f in data:
            m.val[i] = f
            i += 1

        edje_object_message_send(self.obj, enums.EDJE_MESSAGE_FLOAT_SET, id,
                                 <void*>m)
        PyMem_Free(m)

    cdef message_send_set(self, int id, data):
        second_item = data[1]
        item_type = type(second_item)
        for e in data[2:]:
            if type(e) != item_type:
                raise TypeError("every element of data should be the "
                                "same type '%s'" % item_type.__name__)
        head = data[0]
        if isinstance(head, (int, long)):
            self.message_send_int_set(id, data)
        elif isinstance(head, float):
            self.message_send_float_set(id, data)
        elif isinstance(head, str):
            if issubclass(item_type, str):
                self.message_send_str_set(id, data)
            elif item_type == int or item_type == long:
                if len(data) == 2:
                    self.message_send_str_int(id, head, second_item)
                else:
                    self.message_send_str_int_set(id, head, data[2:])
            elif item_type == float:
                if len(data) == 2:
                    self.message_send_str_float(id, head, second_item)
                else:
                    self.message_send_str_float_set(id, head, data[2:])

    def message_send(self, int id, data):
        """Send message with given id and data.

        Data should be pure-python types that will be converted to
        the Message subclass that better fits it. Supported are:
        - long, int, float, str
        - list of long, int, float, str
        - str and one of long, int, float
        - str and a list of one of long, int, float

        Messages sent will **NOT** be available at Python-side (ie:
        message_handler_set()), but just at Embryo-side.

        :raise TypeError: if data has no supported EdjeMessage counterpart.
        """
        if isinstance(data, (long, int)):
            self.message_send_int(id, data)
        elif isinstance(data, float):
            self.message_send_float(id, data)
        elif isinstance(data, str):
            self.message_send_str(id, data)
        elif isinstance(data, (tuple, list)):
            if len(data) < 1:
                return
            if len(data) < 2:
                self.message_send(id, data[0])
                return

            if not isinstance(data[0], (long, int, float, str)):
                raise TypeError("invalid message list type '%s'" %
                                type(data[0]).__name__)

            self.message_send_set(id, data)
        else:
            raise TypeError("invalid message type '%s'" % type(data).__name__)

    def message_handler_set(self, func, *args, **kargs):
        """Set the handler of messages coming from Embryo.

        Signature::

            function(object, message, *args, **kargs)

        .. note:: this just handle messages sent from Embryo.

        :raise TypeError: if func is not callable or None.
        """
        if func is None:
            self._message_handler_cb = None
            edje_object_message_handler_set(self.obj, NULL, NULL)
        elif callable(func):
            self._message_handler_cb = (func, args, kargs)
            edje_object_message_handler_set(self.obj, message_handler_cb,
                                           <void*>self)
        else:
            raise TypeError("func must be callable or None")

    def message_signal_process(self):
        """Manually iterate message signal system."""
        edje_object_message_signal_process(self.obj)

    def signal_callback_add(self, emission, source, func,
                            *args, **kargs):
        """Add callback to given signal (emission, source).

        Signature::

            function(object, emission, source, *args, **kargs)

        :param emission:
            the emission to listen, may be or contain '*' to match multiple.
        :param source:
            the emission's source to listen, may be or contain '*' to match
            multiple.
        :param func:
            the callable to use. Will get any further arguments you gave to
            signal_callback_add().

        :raise TypeError: if func is not callable.
        """
        if not callable(func):
            raise TypeError("func must be callable")

        d = self._signal_callbacks.setdefault(emission, {})
        lst = d.setdefault(source, [])
        if not lst:
            if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
            if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
            edje_object_signal_callback_add(self.obj,
                <const char *>emission if emission is not None else NULL,
                <const char *>source if source is not None else NULL,
                signal_cb, <void*>lst)
        lst.append((func, args, kargs))

    def signal_callback_del(self, emission, source, func):
        """Remove the callable associated with given emission and source."""
        try:
            d = self._signal_callbacks[emission]
            lst = d[source]
        except KeyError:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        i = -1
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break
        else:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        lst.pop(i)
        if lst:
            return
        d.pop(source)
        if not d:
            self._signal_callbacks.pop(emission)
        if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        edje_object_signal_callback_del(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL,
            signal_cb)

    def signal_emit(self, emission, source):
        """Emit signal with ``emission`` and ``source``"""
        if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        edje_object_signal_emit(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL)


# decorators
def on_signal(emission, source):
    def decorator(func):
        if not hasattr(func, "__decorated_callbacks__"):
            func.__decorated_callbacks__ = list()
        func.__decorated_callbacks__.append(("signal_callback_add", emission, source, func))
        return func
    return decorator

def message_handler(func):
    if not hasattr(func, "__decorated_callbacks__"):
        func.__decorated_callbacks__ = list()
    func.__decorated_callbacks__.append(("message_handler_set", func))
    return func

def on_text_change(func):
    if not hasattr(func, "__decorated_callbacks__"):
        func.__decorated_callbacks__ = list()
    func.__decorated_callbacks__.append(("text_change_cb_set", func))
    return func


_object_mapping_register("Edje_Object", Edje)
