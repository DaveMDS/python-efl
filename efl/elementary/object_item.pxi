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

include "object_item_cdef.pxi"

cdef Evas_Object *_tooltip_item_content_create(void *data, Evas_Object *o, Evas_Object *t, void *it) with gil:
    cdef:
        Object ret, obj, tooltip
        ObjectItem item

    obj = object_from_instance(o)
    tooltip = object_from_instance(t)
    item = _object_item_to_python(<Elm_Object_Item *>it)
    (func, args, kargs) = <object>data
    ret = func(obj, item, tooltip, *args, **kargs)
    if not ret:
       return NULL
    return ret.obj

cdef void _tooltip_item_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
   Py_DECREF(<object>data)


cdef Elm_Object_Item * _object_item_from_python(ObjectItem item) except NULL:
    if item is None or item.item is NULL:
        raise TypeError("Invalid item!")
    return item.item

cdef _object_item_to_python(Elm_Object_Item *it):
    cdef:
        void *data
        ObjectItem item

    if it == NULL:
        return None

    data = elm_object_item_data_get(it)

    if data == NULL:
        # Create a dummy object item.
        EINA_LOG_DOM_WARN(PY_EFL_ELM_LOG_DOMAIN,
            "Creating an incomplete ObjectItem.", NULL)
        item = ObjectItem.__new__(ObjectItem)
        item._set_obj(it)
    else:
        item = <object>data

    return item

cdef _object_item_list_to_python(const Eina_List *lst):
    cdef Elm_Object_Item *it
    ret = []
    while lst:
        it = <Elm_Object_Item *>lst.data
        lst = lst.next
        o = _object_item_to_python(it)
        if o is not None:
            ret.append(o)
    return ret

cdef void _object_item_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    cdef ObjectItem d
    if data != NULL:
        d = <object>data
        d.item = NULL
        Py_DECREF(d)

cdef void _object_item_callback(void *data, Evas_Object *obj, void *event_info) with gil:
    # This should be used with old style items
    cdef ObjectItem item = <object>data
    try:
        o = object_from_instance(obj)
        item.cb_func(o, item, *item.args, **item.kwargs)
    except Exception:
        traceback.print_exc()

cdef void _object_item_callback2(void *data, Evas_Object *obj, void *event_info) with gil:
    # This should be used with new style items
    cdef ObjectItem item = <object>data
    try:
        o = object_from_instance(obj)
        item.cb_func(o, item, item.cb_data)
    except Exception:
        traceback.print_exc()

cdef class ObjectItem(object):
    """

    A generic item for the widgets. This is the base class for all the other
    widget items.

    .. py:attribute:: data

        :type: dict

        A dictionary object that holds user data.

    """

    cdef:
        Elm_Object_Item *item
        object cb_func
        object cb_data
        tuple args
        dict kwargs
        readonly dict data
        int _set_obj(self, Elm_Object_Item *item) except 0

    # Notes to bindings' developers:
    # ==============================
    #
    # After calling _set_obj, Elm_Object_Item's "data" contains the python item
    # instance pointer, and the attribute "item", that you see below, contains
    # a pointer to Elm_Object_Item.
    #

    def __cinit__(self):
        self.data = dict()

    def __dealloc__(self):
        if self.item != NULL:
            elm_object_item_del_cb_set(self.item, NULL)
            elm_object_item_del(self.item)
            self.item = NULL

    def __init__(self, *args, **kwargs):
        if type(self) is ObjectItem:
            raise TypeError("Must not instantiate ObjectItem, but subclasses")

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        elm_object_item_data_set(item, <void*>self)
        elm_object_item_del_cb_set(item, _object_item_del_cb)
        Py_INCREF(self)
        return 1

    def __repr__(self):
        return ("<%s object (ObjectItem) at %#x (obj=%#x, refcount=%d, widget=%s)>") % (
            type(self).__name__,
            <uintptr_t><void *>self,
            <uintptr_t>self.item,
            PY_REFCOUNT(self),
            repr(object_from_instance(elm_object_item_widget_get(self.item)))
            )

    cdef int _set_properties_from_keyword_args(self, dict kwargs) except 0:
        if not kwargs:
            return 1
        cdef list cls_list = dir(self)
        for k, v in kwargs.items():
            assert k in cls_list, "%s has no attribute with the name %s." % (self, k)
            setattr(self, k, v)
        return 1

    @DEPRECATED("1.8", "Use the data attribute (dict) instead.")
    def data_get(self):
        return (self.args, self.kwargs)

    @DEPRECATED("1.8", "Use the data attribute (dict) instead.")
    def data_set(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs

    property widget:
        """Get the widget object's handle which contains a given item

        .. note:: This returns the widget object itself that an item belongs to.
        .. note:: Every elm_object_item supports this API

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_item_widget_get(self.item))

    def widget_get(self):
        return object_from_instance(elm_object_item_widget_get(self.item))

    def part_content_set(self, part, evasObject content not None):
        """Set a content of an object item

        This sets a new object to an item as a content object. If any object
        was already set as a content object in the same part, previous
        object will be deleted automatically.

        .. note:: Elementary object items may have many contents

        :param part: The content part name to set (None for the default
            content)
        :param content: The new content of the object item

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        elm_object_item_part_content_set(self.item,
            <const char *>part if part is not None else NULL, content.obj)

    def part_content_get(self, part):
        """Get a content of an object item

        .. note:: Elementary object items may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string
        :return: content of the object item or None for any error
        :rtype: :py:class:`~efl.evas.Object`

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_object_item_part_content_get(self.item,
            <const char *>part if part is not None else NULL))

    def part_content_unset(self, part):
        """Unset a content of an object item

        .. note:: Elementary object items may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_object_item_part_content_unset(self.item,
            <const char *>part if part is not None else NULL))

    property content:
        """The default content part of this ObjectItem."""
        def __set__(self, evasObject content not None):
            elm_object_item_content_set(self.item, content.obj)

        def __get__(self):
            return object_from_instance(elm_object_item_content_get(self.item))

        def __del__(self):
            elm_object_item_content_unset(self.item)

    def content_set(self, evasObject content not None):
        elm_object_item_content_set(self.item, content.obj)
    def content_get(self):
        return object_from_instance(elm_object_item_content_get(self.item))
    def content_unset(self):
        return object_from_instance(elm_object_item_content_unset(self.item))

    def part_text_set(self, part, text):
        """Sets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_get()`

        :param part: part name to set the text.
        :type part: string
        :param text: text to set.
        :type text: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_item_part_text_set(self.item,
            <const char *>part if part is not None else NULL,
            <const char *>text if text is not None else NULL)

    def part_text_get(self, part):
        """Gets the text of a given part of this object.

        .. seealso:: text_get() and :py:func:`part_text_set()`

        :param part: part name to get the text.
        :type part: string
        :return: the text of a part or None if nothing was set.
        :rtype: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_object_item_part_text_get(self.item,
            <const char *>part if part is not None else NULL))

    def domain_translatable_part_text_set(self, part = None, domain = None, text = None):
        """Set the text for an object item's part, marking it as translatable.

        The string to set as ``text`` must be the original one. Do not pass the
        return of ``gettext()`` here. Elementary will translate the string
        internally and set it on the object item using
        elm_object_item_part_text_set(), also storing the original string so that it
        can be automatically translated when the language is changed with
        elm_language_set(). The ``domain`` will be stored along to find the
        translation in the correct catalog. It can be None, in which case it will use
        whatever domain was set by the application with ``textdomain()``. This is
        useful in case you are building a library on top of Elementary that will have
        its own translatable strings, that should not be mixed with those of programs
        using the library.

        :param part: The name of the part to set
        :param domain: The translation domain to use
        :param text: The original, non-translated text to set

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_item_domain_translatable_part_text_set(self.item,
            <const char *>part if part is not None else NULL,
            <const char *>domain if domain is not None else NULL,
            <const char *>text if text is not None else NULL)

    def translatable_part_text_get(self, part = None):
        """Gets the original string set as translatable for an object item.

        When setting translated strings, the function elm_object_item_part_text_get()
        will return the translation returned by ``gettext()``. To get the original
        string use this function.

        :param part: The name of the part that was set

        :return: The original, untranslated string

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_object_item_translatable_part_text_get(self.item,
            <const char *>part if part is not None else NULL))

    def domain_part_text_translatable_set(self, part not None, domain not None, bint translatable):
        """Mark the part text to be translatable or not.

        Once you mark the part text to be translatable, the text will be translated
        internally regardless of :py:func:`part_text_set` and
        :py:func:`domain_translatable_part_text_set`. In other case, if you set the
        Elementary policy that all text will be translatable in default, you can set
        the part text to not be translated by calling this API.

        :param part: The part name of the translatable text
        :param domain: The translation domain to use
        :param translatable: ``True``, the part text will be translated
            internally. ``False``, otherwise.

        :see: :py:func:`domain_translatable_part_text_set`
        :see: :py:func:`part_text_set`
        :see: :py:func:`efl.elementary.general.policy_set`

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        elm_object_item_domain_part_text_translatable_set(self.item,
            <const char *>part,
            <const char *>domain,
            translatable)

    property text:
        """The main text for this object.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_item_text_get(self.item))

        def __set__(self, text):
            if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
            elm_object_item_text_set(self.item,
                <const char *>text if text is not None else NULL)

    def text_set(self, text):
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_item_text_set(self.item,
            <const char *>text if text is not None else NULL)
    def text_get(self):
        return _ctouni(elm_object_item_text_get(self.item))

    # TODO: accessibility
    # property access_info:
    #     """Set the text to read out when in accessibility mode

    #     :type: string

    #     """
    #     def __set__(self, txt):
    #         if isinstance(txt, unicode): txt = PyUnicode_AsUTF8String(txt)
    #         elm_object_item_access_info_set(self.item,
    #             <const char *>txt if txt is not None else NULL)

    # def access_info_set(self, txt):
    #     if isinstance(txt, unicode): txt = PyUnicode_AsUTF8String(txt)
    #     elm_object_item_access_info_set(self.item,
    #         <const char *>txt if txt is not None else NULL)

    def signal_emit(self, emission, source):
        """Send a signal to the edje object of the widget item.

        This function sends a signal to the edje object of the obj item. An
        edje program can respond to a signal by specifying matching
        'signal' and 'source' fields.

        :param emission: The signal's name.
        :type emission: string
        :param source: The signal's source.
        :type source: string

        """
        if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        elm_object_item_signal_emit(self.item,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL)

    property disabled:
        """The disabled state of an widget item.

        Elementary object item can be **disabled**, in which state they won't
        receive input and, in general, will be themed differently from their
        normal state, usually greyed out. Useful for contexts where you
        don't want your users to interact with some of the parts of you
        interface.

        :type: bool

        """
        def __get__(self):
            return bool(elm_object_item_disabled_get(self.item))
        def __set__(self, disabled):
            elm_object_item_disabled_set(self.item, disabled)

    def disabled_set(self, disabled):
        elm_object_item_disabled_set(self.item, disabled)
    def disabled_get(self):
        return bool(elm_object_item_disabled_get(self.item))

    # TODO: ?
    #def delete_cb_set(self, del_cb):
        #elm_object_item_del_cb_set(self.item, del_cb)

    def delete(self):
        """Delete this ObjectItem."""
        if self.item == NULL:
            raise ValueError("Object already deleted")
        elm_object_item_del(self.item)
        Py_DECREF(self)

    def tooltip_text_set(self, text):
        """Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed. Internally, this
        method calls :py:func:`tooltip_content_cb_set`

        """
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_item_tooltip_text_set(self.item,
            <const char *>text if text is not None else NULL)

    property tooltip_window_mode:
        """Disables the size restrictions on an object's tooltip.

        If ``True`` allows the tooltip to expand beyond its parent window's
        canvas. It is instead limited only by the size of the display.

        :type: bool

        """
        def __set__(self, disable):
            if not elm_object_item_tooltip_window_mode_set(self.item, disable):
                raise RuntimeWarning("Could not set tooltip_window_mode.")

        def __get__(self):
            return bool(elm_object_item_tooltip_window_mode_get(self.item))

    def tooltip_window_mode_set(self, disable):
        if not elm_object_item_tooltip_window_mode_set(self.item, disable):
            raise RuntimeWarning("Could not set tooltip_window_mode.")

    def tooltip_window_mode_get(self):
        return bool(elm_object_item_tooltip_window_mode_get(self.item))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip, so
        any previews tooltip data is removed. ``func(owner, item, tooltip,
        args, kargs)`` will be called every time that need show the tooltip and
        it should return a valid Evas_Object. This object is then managed fully
        by tooltip system and is deleted when the tooltip is gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.
        :type func: function

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, args, kargs)
        Py_INCREF(data)
        # DECREF is in data_del_cb
        cbdata = <void *>data
        elm_object_item_tooltip_content_cb_set(self.item, _tooltip_item_content_create,
                                          cbdata, _tooltip_item_data_del_cb)

    def tooltip_unset(self):
        """Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set`
        the internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but
        no freed.

        """
        elm_object_item_tooltip_unset(self.item)

    property tooltip_style:
        """The style for this object tooltip.

        .. note:: before you set a style you should define a tooltip
            with :py:func:`tooltip_content_cb_set()`
            or :py:func:`tooltip_text_set()`

        """
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_item_tooltip_style_set(self.item,
                <const char *>style if style is not None else NULL)

        def __get__(self):
            return _ctouni(elm_object_item_tooltip_style_get(self.item))

        def __del__(self):
            self.tooltip_style_set(None)

    def tooltip_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_item_tooltip_style_set(self.item,
            <const char *>style if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_object_item_tooltip_style_get(self.item))

    property cursor:
        """The cursor that will be displayed when mouse is over the object.
        The object can have only one cursor set to it, so if this function
        is called twice for an object, the previous set will be unset.

        """
        def __set__(self, cursor):
            if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
            elm_object_item_cursor_set(self.item,
                <const char *>cursor if cursor is not None else NULL)

        def __get__(self):
            return _ctouni(elm_object_item_cursor_get(self.item))

        def __del__(self):
            elm_object_item_cursor_unset(self.item)

    def cursor_set(self, cursor):
        if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
        elm_object_item_cursor_set(self.item,
            <const char *>cursor if cursor is not None else NULL)
    def cursor_get(self):
        return _ctouni(elm_object_item_cursor_get(self.item))
    def cursor_unset(self):
        elm_object_item_cursor_unset(self.item)

    property cursor_style:
        """The style for this object cursor.

        .. note:: before you set a style you should define a cursor
            with :py:attr:`cursor`

        """
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_item_cursor_style_set(self.item,
                <const char *>style if style is not None else NULL)

        def __get__(self):
            return _ctouni(elm_object_item_cursor_style_get(self.item))

        def __del__(self):
            elm_object_item_cursor_style_set(self.item, NULL)

    def cursor_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_item_cursor_style_set(self.item,
            <const char *>style if style is not None else NULL)
    def cursor_style_get(self):
        return _ctouni(elm_object_item_cursor_style_get(self.item))

    property cursor_engine_only:
        """cursor_engine_only_set(engine_only)

        Sets cursor engine only usage for this object.

        .. note:: before you set a style you should define a cursor
            with :py:attr:`cursor`

        """
        def __set__(self, engine_only):
            elm_object_item_cursor_engine_only_set(self.item, bool(engine_only))

        def __get__(self):
            return elm_object_item_cursor_engine_only_get(self.item)

    def cursor_engine_only_set(self, engine_only):
        elm_object_item_cursor_engine_only_set(self.item, bool(engine_only))
    def cursor_engine_only_get(self):
        return elm_object_item_cursor_engine_only_get(self.item)

    property focus:
        """Whether the item is focused or not.

        .. versionadded:: 1.10

        """
        def __set__(self, focused):
            elm_object_item_focus_set(self.item, bool(focused))

        def __get__(self):
            return elm_object_item_focus_get(self.item)

    def focus_set(self, focused):
        elm_object_item_focus_set(self.item, bool(focused))
    def focus_get(self):
        return elm_object_item_focus_get(self.item)

    def focus_next_object_get(self, Elm_Focus_Direction direction):
        """Get next object which was set with specific focus direction.

        :param dir: Focus direction
        :type dir: :ref:`Elm_Focus_Direction`
        :return: Focus next object or None, if there is no focus next object.
        :rtype: :class:`Object`

        :see: :func:`focus_next_object_set`

        .. versionadded:: 1.16

        """
        return object_from_instance(
            elm_object_item_focus_next_object_get(self.item, direction)
            )

    def focus_next_object_set(self, evasObject next,
                               Elm_Focus_Direction direction):
        """Set next object with specific focus direction.

        When focus next object is set with specific focus direction, this object
        will be the first candidate when finding next focusable object. Focus
        next object can be registered with six directions that are previous,
        next, up, down, right, and left.

        :param next: Focus next object
        :type next: :class:`Object`
        :param dir: Focus direction
        :type dir: :ref:`Elm_Focus_Direction`

        :see: :py:func:`focus_next_object_get`

        .. versionadded:: 1.16

        """
        elm_object_item_focus_next_object_set(self.item, next.obj, direction)

    def focus_next_item_get(self, Elm_Focus_Direction direction):
        """Get next object item which was set with specific focus direction.

        :return: Focus next object item or ``None``, if there is no focus next
                 object item.
        :rtype: :class:`ObjectItem`

        .. versionadded:: 1.16

        """
        return _object_item_to_python(
                    elm_object_item_focus_next_item_get(self.item, direction))

    def focus_next_item_set(self, ObjectItem next,
                            Elm_Focus_Direction direction):
        """ Set next object item with specific focus direction.

        When focus next object item is set with specific focus direction, this
        object item will be the first candidate when finding next focusable
        object or item. If the focus next object item is set, it is preference
        to focus next object. Focus next object item can be registered with six
        directions that are previous, next, up, down, right, and left.

        :param next: Focus next object item
        :type next: :class:`ObjectItem`
        :param dir: Focus direction
        :type dir: :ref:`Elm_Focus_Direction`

        :see: :py:func:`focus_next_item_get`

        .. versionadded:: 1.16

        """
        elm_object_item_focus_next_item_set(self.item, next.item, direction)
        


    # TODO: Accessibility
    # def access_unregister(self):
    #     """Unregister accessible object of the object item.
    #     :since: 1.9

    #     """
    #     elm_object_item_access_unregister(self.item)

    # property access_object:
    #     """Get an accessible object of the object item.

    #     :since: 1.9

    #     :return: Accessible object of the object item or NULL for any error

    #     """
    #     def __get__(self):
    #         return object_from_instance(elm_object_item_access_object_get(self.item))

    # property access_order:
    #     """Access highlight order

    #     :since: 1.9

    #     :type: list of Objects

    #     """
    #     def __set__(self, list value):
    #         elm_object_item_access_order_set(self.item,
    #             python_list_objects_to_eina_list(value))

    #     def __get__(self):
    #         eina_list_objects_to_python_list(elm_object_item_access_order_get(self.item))

    #     def __del__(self):
    #         elm_object_item_access_order_unset(self.item)


    property track_object:
        """The track object of the item.

        .. note::

            This returns a rectangle object that represents the object items
            internal object. If you wish to, for example, get the geometry or
            visibility of the item you can use Evas API properties of the track
            object such as :py:attr:`~efl.evas.Object.geometry` or
            :py:attr:`~efl.evas.Object.visible`. Note that the widget items
            may, or may not, actually have an internal object so this API will
            return None if the tracking object doesn't exist. Additionally, the
            widget item is managed/controlled by the widget, which means the
            widget item may be changed (moved, resized even deleted) anytime by
            its own widget. Do not attempt to change the track object, and
            don't keep around a reference to the track object unless it's
            really required, instead get the track object at the moment you
            need to refer to it. Otherwise you need to add some callbacks to
            the track object to track its attributes' changes.

        .. warning::

            After use the track object, please call ``del item.track_object``
            to free the track object properly. **Don't call ``obj.delete()`` on
            the track object.**

        .. versionadded:: 1.10

        """
        def __get__(self):
            return object_from_instance(elm_object_item_track(self.item))

        def __del__(self):
            elm_object_item_untrack(self.item)

    def track(self):
        """Same as ``item.track_object``"""
        return object_from_instance(elm_object_item_track(self.item))

    def untrack(self):
        """Same as ``del item.track_object``"""
        elm_object_item_untrack(self.item)

    property track_count:
        """The track object reference count.

        .. note::

            This gets the reference count for the track object. Whenever you
            get the tracking object with :py:attr:`track_object` the reference
            count is increased by one. Likewise the reference count is
            decreased when you call ``del item.track_object``. Unless the
            reference count reaches zero the track object won't be deleted so
            please make sure to call ``del item.track_object`` as many times as
            getting :py:attr:`track_object`.

        .. versionadded:: 1.10

        """
        def __get__(self):
            return elm_object_item_track_get(self.item)

    def track_get(self):
        """Same as ``item.track_count``"""
        return elm_object_item_track_get(self.item)

    property style:
        """The style of an object item.

        :type: string

        .. versionadded:: 1.10

        """
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_item_style_set(self.item,
                <const char *>style if style is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_object_item_style_get(self.item))

    def style_set(self, style):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_item_style_set(self.item,
            <const char *>style if style is not None else NULL
            )

    def style_get(self):
        return _ctouni(elm_object_item_style_get(self.item))
