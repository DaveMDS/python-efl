# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.


include "widget_header.pxi"
include "tooltips.pxi"

# cdef void _tooltip_item_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
#    Py_DECREF(<object>data)

from object cimport Object
import traceback

cdef class ObjectItem

def _cb_object_item_conv(long addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef Elm_Object_Item * _object_item_from_python(ObjectItem item) except NULL:
    if item is None or item.item is NULL:
        raise TypeError("Invalid item!")
    return item.item

cdef _object_item_to_python(Elm_Object_Item *it):
    cdef void *data
    cdef object item

    if it == NULL:
        return None

    data = elm_object_item_data_get(it)
    if data == NULL:
        return None

    item = <object>data
    return item

cdef _object_item_list_to_python(const_Eina_List *lst):
    cdef Elm_Object_Item *it
    ret = []
    ret_append = ret.append
    while lst:
        it = <Elm_Object_Item *>lst.data
        lst = lst.next
        o = _object_item_to_python(it)
        if o is not None:
            ret_append(o)
    return ret

cdef void _object_item_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    cdef ObjectItem d = <object>data
    d.item = NULL
    Py_DECREF(d)

cdef void _object_item_callback(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef ObjectItem item = <object>data
    (callback, a, ka) = item.params
    try:
        o = object_from_instance(obj)
        callback(o, item, *a, **ka)
    except Exception as e:
        traceback.print_exc()

cdef class ObjectItem(object):

    """

    A generic item for the widgets.

    """

    # Notes to bindings' developers:
    # ==============================
    #
    # After calling _set_obj, Elm_Object_Item's "data" contains the python item
    # instance pointer, and the attribute "item", that you see below, contains
    # a pointer to Elm_Object_Item.
    #
    # The variable params holds callback data, usually the tuple
    # (callback, args, kwargs). Note that some of the generic object item
    # functions expect this tuple. Use custom functions if you assign the
    # params differently.
    #
    # Gen type widgets MUST set the params BEFORE adding the item as the
    # items need their data immediately when adding them.

    def __dealloc__(self):
        if self.item != NULL:
            elm_object_item_del_cb_set(self.item, NULL)
            elm_object_item_del(self.item)
            self.item = NULL

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        elm_object_item_data_set(item, <void*>self)
        elm_object_item_del_cb_set(item, _object_item_del_cb)
        Py_INCREF(self)
        return 1

    property widget:
        """Get the widget object's handle which contains a given item

        .. note:: This returns the widget object itself that an item belongs to.
        .. note:: Every elm_object_item supports this API

        :type: :py:class:`elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_item_widget_get(self.item))

    def widget_get(self):
        return object_from_instance(elm_object_item_widget_get(self.item))

    def part_content_set(self, part, Object content not None):
        """part_content_set(unicode part, Object content)

        Set a content of an object item

        This sets a new object to an item as a content object. If any object
        was already set as a content object in the same part, previous
        object will be deleted automatically.

        .. note:: Elementary object items may have many contents

        :param part: The content part name to set (None for the default
            content)
        :param content: The new content of the object item

        """
        elm_object_item_part_content_set(self.item, _cfruni(part) if part is not None else NULL, content.obj)

    def part_content_get(self, part):
        """part_content_get(unicode part) -> Object

        Get a content of an object item

        .. note:: Elementary object items may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string
        :return: content of the object item or None for any error
        :rtype: :py:class:`evas.object.Object`

        """
        return object_from_instance(elm_object_item_part_content_get(self.item, _cfruni(part) if part is not None else NULL))

    def part_content_unset(self, part):
        """part_content_unset(unicode part)

        Unset a content of an object item

        .. note:: Elementary object items may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string

        """
        return object_from_instance(elm_object_item_part_content_unset(self.item, _cfruni(part) if part is not None else NULL))

    property content:
        """The default content part of this ObjectItem."""
        def __set__(self, evasObject content):
            elm_object_item_content_set(self.item, content.obj)

        def __get__(self):
            return object_from_instance(elm_object_item_content_get(self.item))

        def __del__(self):
            elm_object_item_content_unset(self.item)

    def content_set(self, Object content not None):
        elm_object_item_content_set(self.item, content.obj)
    def content_get(self):
        return object_from_instance(elm_object_item_content_get(self.item))
    def content_unset(self):
        return object_from_instance(elm_object_item_content_unset(self.item))

    def part_text_set(self, part, text):
        """part_text_set(unicode part, unicode text)

        Sets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_get()`

        :param part: part name to set the text.
        :type part: string
        :param text: text to set.
        :type text: string

        """
        elm_object_item_part_text_set(self.item, _cfruni(part) if part is not None else NULL, _cfruni(text))

    def part_text_get(self, part):
        """part_text_set(unicode part) -> unicode text

        Gets the text of a given part of this object.

        .. seealso:: text_get() and :py:func:`part_text_set()`

        :param part: part name to get the text.
        :type part: string
        :return: the text of a part or None if nothing was set.
        :rtype: string

        """
        return _ctouni(elm_object_item_part_text_get(self.item, _cfruni(part) if part is not None else NULL))

    property text:
        """The main text for this object.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_item_text_get(self.item))

        def __set__(self, text):
            elm_object_item_text_set(self.item, _cfruni(text))

    def text_set(self, text):
        elm_object_item_text_set(self.item, _cfruni(text))
    def text_get(self):
        return _ctouni(elm_object_item_text_get(self.item))

    property access_info:
        """Set the text to read out when in accessibility mode

        :type: string

        """
        def __set__(self, txt):
            elm_object_item_access_info_set(self.item, _cfruni(txt))

    def access_info_set(self, txt):
        elm_object_item_access_info_set(self.item, _cfruni(txt))

    property data:
        def __get__(self):
            callback, a, ka = self.params
            return (a, ka)

        def __set__(self, data):
            callback, a, ka = self.params
            args, kwargs = data
            self.params = tuple(callback, *args, **kwargs)

    def data_get(self):
        (callback, a, ka) = self.params
        return (a, ka)
    def data_set(self, *args, **kwargs):
        (callback, a, ka) = self.params
        self.params = tuple(callback, *args, **kwargs)

    def signal_emit(self, emission, source):
        """signal_emit(unicode emission, unicode source)

        Send a signal to the edje object of the widget item.

        This function sends a signal to the edje object of the obj item. An
        edje program can respond to a signal by specifying matching
        'signal' and 'source' fields.

        :param emission: The signal's name.
        :type emission: string
        :param source: The signal's source.
        :type source: string

        """
        elm_object_item_signal_emit(self.item, _cfruni(emission), _cfruni(source))

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

    #def delete_cb_set(self, del_cb):
        #elm_object_item_del_cb_set(self.item, del_cb)

    def delete(self):
        """delete()

        Delete this ObjectItem.

        """
        if self.item == NULL:
            raise ValueError("Object already deleted")
        elm_object_item_del(self.item)
        Py_DECREF(self)

    def tooltip_text_set(self, text):
        """tooltip_text_set(unicode text)

        Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed. Internally, this
        method calls :py:func:`tooltip_content_cb_set`

        """
        elm_object_item_tooltip_text_set(self.item, _cfruni(text))

    property tooltip_window_mode:
        def __set__(self, disable):
            #TODO: check rval
            elm_object_item_tooltip_window_mode_set(self.item, disable)

        def __get__(self):
            return bool(elm_object_item_tooltip_window_mode_get(self.item))

    def tooltip_window_mode_set(self, disable):
        return bool(elm_object_item_tooltip_window_mode_set(self.item, disable))
    def tooltip_window_mode_get(self):
        return bool(elm_object_item_tooltip_window_mode_get(self.item))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """tooltip_content_cb_set(func, *args, **kargs)

        Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. ``func(owner, tooltip,
        args, kargs)`` will be called every time that need show the tooltip
        and it should return a valid Evas_Object. This object is then
        managed fully by tooltip system and is deleted when the tooltip is
        gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.
        :type func: function

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_object_item_tooltip_content_cb_set(self.item, _tooltip_item_content_create,
                                          cbdata, _tooltip_item_data_del_cb)

    def tooltip_unset(self):
        """tooltip_unset()

        Unset tooltip from object

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
            elm_object_item_tooltip_style_set(self.item, _cfruni(style))

        def __get__(self):
            return _ctouni(elm_object_item_tooltip_style_get(self.item))

        def __del__(self):
            elm_object_item_tooltip_style_set(self.item, NULL)

    def tooltip_style_set(self, style=None):
        elm_object_item_tooltip_style_set(self.item, _cfruni(style) if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_object_item_tooltip_style_get(self.item))

    property cursor:
        """The cursor that will be displayed when mouse is over the object.
        The object can have only one cursor set to it, so if this function
        is called twice for an object, the previous set will be unset.

        """
        def __set__(self, cursor):
            elm_object_item_cursor_set(self.item, _cfruni(cursor))

        def __get__(self):
            return _ctouni(elm_object_item_cursor_get(self.item))

        def __del__(self):
            elm_object_item_cursor_unset(self.item)

    def cursor_set(self, char *cursor):
        elm_object_item_cursor_set(self.item, _cfruni(cursor))
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
            elm_object_item_cursor_style_set(self.item, _cfruni(style))

        def __get__(self):
            return _ctouni(elm_object_item_cursor_style_get(self.item))

        def __del__(self):
            elm_object_item_cursor_style_set(self.item, NULL)

    def cursor_style_set(self, style=None):
        elm_object_item_cursor_style_set(self.item, _cfruni(style) if style is not None else NULL)
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


_object_mapping_register("elm_object_item", ObjectItem)
