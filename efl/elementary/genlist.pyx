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

"""

.. rubric:: Genlist item types

.. data:: ELM_GENLIST_ITEM_NONE

    Simple item

.. data:: ELM_GENLIST_ITEM_TREE

    The item may be expanded and have child items

.. data:: ELM_GENLIST_ITEM_GROUP

    An index item of a group of items


.. rubric:: Genlist items' field types

.. data:: ELM_GENLIST_ITEM_FIELD_ALL

    Match all fields

.. data:: ELM_GENLIST_ITEM_FIELD_TEXT

    Match text fields

.. data:: ELM_GENLIST_ITEM_FIELD_CONTENT

    Match content fields

.. data:: ELM_GENLIST_ITEM_FIELD_STATE

    Match state fields


.. rubric:: Genlist items' scroll-to types

.. data:: ELM_GENLIST_ITEM_SCROLLTO_NONE

    No scroll to

.. data:: ELM_GENLIST_ITEM_SCROLLTO_IN

    Scroll to the nearest viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_TOP

    Scroll to the top of viewport

.. data:: ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

    Scroll to the middle of viewport


.. rubric:: List sizing

.. data:: ELM_LIST_COMPRESS

    The list won't set any of its size hints to inform how a possible container
    should resize it.

    Then, if it's not created as a "resize object", it might end with zeroed
    dimensions. The list will respect the container's geometry and, if any of
    its items won't fit into its transverse axis, one won't be able to scroll it
    in that direction.

.. data:: ELM_LIST_SCROLL

    Default value.

    This is the same as ELM_LIST_COMPRESS, with the exception that if any of
    its items won't fit into its transverse axis, one will be able to scroll
    it in that direction.

.. data:: ELM_LIST_LIMIT

    Sets a minimum size hint on the list object, so that containers may
    respect it (and resize itself to fit the child properly).

    More specifically, a minimum size hint will be set for its transverse
    axis, so that the largest item in that direction fits well. This is
    naturally bound by the list object's maximum size hints, set externally.

.. data:: ELM_LIST_EXPAND

    Besides setting a minimum size on the transverse axis, just like on
    ELM_LIST_LIMIT, the list will set a minimum size on the longitudinal
    axis, trying to reserve space to all its children to be visible at a time.

    This is naturally bound by the list object's maximum size hints, set
    externally.


.. rubric:: Selection modes

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Default select mode

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    Always select mode

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    No select mode

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


.. rubric:: Scrollbar visibility

.. data:: ELM_SCROLLER_POLICY_AUTO

    Show scrollbars as needed

.. data:: ELM_SCROLLER_POLICY_ON

    Always show scrollbars

.. data:: ELM_SCROLLER_POLICY_OFF

    Never show scrollbars


"""

include "widget_header.pxi"
include "tooltips.pxi"
from object_item cimport    ObjectItem, \
                            _object_item_to_python, \
                            elm_object_item_widget_get, \
                            _object_item_from_python, \
                            _object_item_list_to_python, \
                            elm_object_item_data_get
from object_item import _cb_object_item_conv
from general cimport strdup
from efl.evas cimport eina_list_remove_list
from scroller cimport *
cimport enums

import traceback
import logging

ELM_GENLIST_ITEM_NONE = enums.ELM_GENLIST_ITEM_NONE
ELM_GENLIST_ITEM_TREE = enums.ELM_GENLIST_ITEM_TREE
ELM_GENLIST_ITEM_GROUP = enums.ELM_GENLIST_ITEM_GROUP
ELM_GENLIST_ITEM_MAX = enums.ELM_GENLIST_ITEM_MAX

ELM_GENLIST_ITEM_FIELD_ALL = enums.ELM_GENLIST_ITEM_FIELD_ALL
ELM_GENLIST_ITEM_FIELD_TEXT = enums.ELM_GENLIST_ITEM_FIELD_TEXT
ELM_GENLIST_ITEM_FIELD_CONTENT = enums.ELM_GENLIST_ITEM_FIELD_CONTENT
ELM_GENLIST_ITEM_FIELD_STATE = enums.ELM_GENLIST_ITEM_FIELD_STATE

ELM_GENLIST_ITEM_SCROLLTO_NONE = enums.ELM_GENLIST_ITEM_SCROLLTO_NONE
ELM_GENLIST_ITEM_SCROLLTO_IN = enums.ELM_GENLIST_ITEM_SCROLLTO_IN
ELM_GENLIST_ITEM_SCROLLTO_TOP = enums.ELM_GENLIST_ITEM_SCROLLTO_TOP
ELM_GENLIST_ITEM_SCROLLTO_MIDDLE = enums.ELM_GENLIST_ITEM_SCROLLTO_MIDDLE

ELM_LIST_COMPRESS = enums.ELM_LIST_COMPRESS
ELM_LIST_SCROLL = enums.ELM_LIST_SCROLL
ELM_LIST_LIMIT = enums.ELM_LIST_LIMIT
ELM_LIST_EXPAND = enums.ELM_LIST_EXPAND

ELM_OBJECT_SELECT_MODE_DEFAULT = enums.ELM_OBJECT_SELECT_MODE_DEFAULT
ELM_OBJECT_SELECT_MODE_ALWAYS = enums.ELM_OBJECT_SELECT_MODE_ALWAYS
ELM_OBJECT_SELECT_MODE_NONE = enums.ELM_OBJECT_SELECT_MODE_NONE
ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY = enums.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
ELM_OBJECT_SELECT_MODE_MAX = enums.ELM_OBJECT_SELECT_MODE_MAX

ELM_SCROLLER_POLICY_AUTO = enums.ELM_SCROLLER_POLICY_AUTO
ELM_SCROLLER_POLICY_ON = enums.ELM_SCROLLER_POLICY_ON
ELM_SCROLLER_POLICY_OFF = enums.ELM_SCROLLER_POLICY_OFF

cdef _py_elm_genlist_item_call(func, Evas_Object *obj, const_char *part, args) with gil:
    try:
        o = object_from_instance(obj)
        return func(o, _ctouni(part), args)
    except Exception as e:
        traceback.print_exc()
        return None

cdef char *_py_elm_genlist_item_text_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef GenlistItemClass itc = params[0]

    func = itc._text_get_func
    if func is None:
        return NULL

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        return strdup(_fruni(ret))
    else:
        return NULL

cdef Evas_Object *_py_elm_genlist_item_content_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef evasObject icon
    cdef GenlistItemClass itc = params[0]

    func = itc._content_get_func
    if func is None:
        return NULL

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        try:
            icon = ret
            return icon.obj
        except Exception as e:
            traceback.print_exc()
            return NULL
    else:
        return NULL

cdef Eina_Bool _py_elm_genlist_item_state_get(void *data, Evas_Object *obj, const_char *part) with gil:
    cdef GenlistItem item = <object>data
    cdef object params = item.params
    cdef GenlistItemClass itc = params[0]

    func = itc._state_get_func
    if func is None:
        return False

    ret = _py_elm_genlist_item_call(func, obj, part, params[1])
    if ret is not None:
        return bool(ret)
    else:
        return False

cdef void _py_elm_genlist_object_item_del(void *data, Evas_Object *obj) with gil:
    cdef GenlistItem item = <object>data
    cdef object params
    cdef GenlistItemClass itc

    if item is None:
        return

    params = item.params
    itc = params[0]

    func = itc._del_func
    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, params[1])
        except Exception as e:
            traceback.print_exc()
    item._unset_obj()
    Py_DECREF(item)

cdef void _py_elm_genlist_item_func(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef GenlistItem item = <object>data
    cdef object func = item.params[2]

    if func is not None:
        try:
            o = object_from_instance(obj)
            func(item, o, item.params[1])
        except Exception as e:
            traceback.print_exc()

class GenlistItemsCount(int):
    def __new__(cls, Object obj, int count):
        return int.__new__(cls, count)

    def __init__(self, Object obj, int count):
        self.obj = obj

    def __call__(self):
        #_METHOD_DEPRECATED(self.obj, None, "Use items_count instead")
        return self.obj._items_count()

cdef class GenlistItemClass(object):
    """

    Defines the behavior of each list item.

    This class should be created and handled to the Genlist itself.

    It may be subclassed, in this case the methods :py:func:`text_get()`,
    :py:func:`content_get()`, :py:func:`state_get()` and ``delete()`` will
    be used.

    It may also be instantiated directly, given getters to override as
    constructor parameters.

    """
    cdef Elm_Genlist_Item_Class obj
    cdef readonly object _item_style
    cdef readonly object _text_get_func
    cdef readonly object _content_get_func
    cdef readonly object _state_get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self._item_style = "default"
        self._text_get_func = None
        self._content_get_func = None
        self._state_get_func = None
        self._del_func = None

        self.obj.item_style = NULL
        self.obj.func.text_get = _py_elm_genlist_item_text_get
        self.obj.func.content_get = _py_elm_genlist_item_content_get
        self.obj.func.state_get = _py_elm_genlist_item_state_get
        self.obj.func.del_ = _py_elm_genlist_object_item_del

    def __init__(self, item_style=None, text_get_func=None,
                 content_get_func=None, state_get_func=None, del_func=None):
        """GenlistItemClass constructor.

        :param item_style: the string that defines the genlist item
            theme to be used. The corresponding edje group will
            have this as suffix.

        :param text_get_func: if provided will override the
            behavior defined by :py:func:`text_get()` in this class. Its
            purpose is to return the label string to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> str``

        :param content_get_func: if provided will override the behavior
            defined by :py:func:`content_get()` in this class. Its purpose is
            to return the icon object to be used (swalloed) by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> obj``

        :param state_get_func: if provided will override the
            behavior defined by :py:func:`state_get()` in this class. Its
            purpose is to return the boolean state to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> bool``

        :param del_func: if provided will override the behavior
            defined by ``delete()`` in this class. Its purpose is to be
            called when row is deleted, thus finalizing resouces
            and similar. This function should have the signature:
            ``func(obj, part, item_data) -> str``

        .. note:: In all these signatures, 'obj' means Genlist and
            'item_data' is the value given to Genlist item append/prepend
            methods, it should represent your row model as you want.
        """
        if item_style:
            self._item_style = item_style

        if text_get_func and not callable(text_get_func):
            raise TypeError("text_get_func is not callable!")
        elif text_get_func:
            self._text_get_func = text_get_func
        else:
            self._text_get_func = self.text_get

        if content_get_func and not callable(content_get_func):
            raise TypeError("content_get_func is not callable!")
        elif content_get_func:
            self._content_get_func = content_get_func
        else:
            self._content_get_func = self.content_get

        if state_get_func and not callable(state_get_func):
            raise TypeError("state_get_func is not callable!")
        elif state_get_func:
            self._state_get_func = state_get_func
        else:
            self._state_get_func = self.state_get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

        self.obj.item_style = _fruni(self._item_style)

    def __str__(self):
        return ("%s(item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Genlist_Item_Class=%#x, "
                "item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                <unsigned long><void *>self,
                PY_REFCOUNT(self),
                <unsigned long>&self.obj,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    property item_style:
        """The style of this item class."""
        def __get__(self):
            return self._item_style

    def text_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its label.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: label to be used.
        :rtype: str or None
        """
        return None

    def content_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its icon.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

    def state_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its state.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: state to be used.
        :rtype: bool or None
        """
        return False

cdef class GenlistItem(ObjectItem):

    """

    An item for the :py:class:`Genlist` widget.

    """

    cdef Elm_Genlist_Item_Class *item_class
    cdef Elm_Object_Item *parent_item
    cdef int flags
    cdef Evas_Smart_Cb cb

    def __cinit__(self):
        self.item_class = NULL
        self.parent_item = NULL
        self.flags = 0
        self.cb = NULL

    def __init__(   self,
                    GenlistItemClass item_class not None,
                    #TODO: item data separate from data?
                    GenlistItem parent_item=None,
                    int flags=ELM_GENLIST_ITEM_NONE,
                    func=None, *args):
        """Create a new GenlistItem.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param parent_item: if this is a tree child, then the
            parent item must be given here, otherwise it may be
            None. The parent must have the flag
            ``ELM_GENLIST_ITEM_SUBITEMS`` set.
        :param flags: defines special behavior of this item:

            - ELM_GENLIST_ITEM_NONE = 0
            - ELM_GENLIST_ITEM_SUBITEMS = 1
            - ELM_GENLIST_ITEM_GROUP = 2

        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        """

        self.item_class = &item_class.obj

        self.parent_item = _object_item_from_python(parent_item) if parent_item is not None else NULL

        self.flags = flags

        if func is not None:
            if not callable(func):
                raise TypeError("func is not None or callable")
            self.cb = _py_elm_genlist_item_func

        if len(args) == 1:
            args = args[0]

        self.params = (item_class, args, func)

    cdef int _set_obj(self, Elm_Object_Item *item, params=None) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef void _unset_obj(self):
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL

    def __str__(self):
        return "%s(item_class=%s, func=%s, item_data=%s)" % \
               (self.__class__.__name__,
                self.params[0].__class__.__name__,
                self.params[2],
                self.params[1])

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)") % \
               (self.__class__.__name__,
                <unsigned long><void*>self,
                PY_REFCOUNT(self),
                <unsigned long>self.item,
                self.params[0].__class__.__name__,
                self.params[2],
                self.params[1])

    def append_to(self, Genlist genlist):
        """append_to(Genlist genlist)

        Append a new item (add as last row) to this genlist.

        :param genlist: The Genlist upon which this item is to be appended.
        :type genlist: :py:class:`Genlist`

        """
        cdef Elm_Object_Item *item

        item = elm_genlist_item_append( genlist.obj,
                                        self.item_class,
                                        <void*>self,
                                        self.parent_item,
                                        <Elm_Genlist_Item_Type>self.flags,
                                        self.cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def prepend_to(self, Genlist genlist):
        """prepend_to(Genlist genlist)

        Prepend a new item (add as first row) to this Genlist.

        :param genlist: The Genlist upon which this item is to be prepended.
        :type genlist: :py:class:`Genlist`

        """
        cdef Elm_Object_Item *item

        item = elm_genlist_item_prepend(genlist.obj,
                                        self.item_class,
                                        <void*>self,
                                        self.parent_item,
                                        <Elm_Genlist_Item_Type>self.flags,
                                        self.cb,
                                        <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def insert_before(self, GenlistItem before_item=None):
        """insert_before(GenlistItem before_item=None)

        Insert a new item (row) before another item in this genlist.

        :param before_item: a reference item to use, the new item
            will be inserted before it.

        """
        cdef Genlist genlist
        cdef Elm_Object_Item *item, *before

        genlist = before_item.widget
        before = _object_item_from_python(before_item)

        item = elm_genlist_item_insert_before(  genlist.obj,
                                                self.item_class,
                                                <void*>self,
                                                self.parent_item,
                                                before,
                                                <Elm_Genlist_Item_Type>self.flags,
                                                self.cb,
                                                <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    def insert_after(self, GenlistItem after_item=None):
        """insert_after(GenlistItem after_item=None)

        Insert a new item (row) after another item in this genlist.

        :param after_item: a reference item to use, the new item
            will be inserted after it.

        """
        cdef Genlist genlist
        cdef Elm_Object_Item *item, *after

        genlist = after_item.widget
        after = _object_item_from_python(after_item)

        item = elm_genlist_item_insert_after(   genlist.obj,
                                                self.item_class,
                                                <void*>self,
                                                self.parent_item,
                                                after,
                                                <Elm_Genlist_Item_Type>self.flags,
                                                self.cb,
                                                <void*>self)

        if item != NULL:
            self._set_obj(item)
            return self
        else:
            Py_DECREF(self)
            return None

    #Elm_Object_Item         *elm_genlist_item_sorted_insert(self.obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Eina_Compare_Cb comp, Evas_Smart_Cb func, void *func_data)

    property data:
        """User data for the item."""
        def __get__(self):
            return self.params[1]

    def data_get(self):
        return self.params[1]

    property next:
        """This returns the item placed after the ``item``, on the container
        genlist.

        .. seealso:: :py:attr:`prev`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_genlist_item_next_get(self.item))

    property prev:
        """This returns the item placed before the ``item``, on the container
        genlist.

        .. seealso:: :py:attr:`next`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_genlist_item_prev_get(self.item))

    property selected:
        """This sets the selected state of an item. If multi selection is
        not enabled on the containing genlist and ``selected`` is ``True``,
        any other previously selected items will get unselected in favor of
        this new one.

        :type: bool

        """
        def __get__(self):
            return bool(elm_genlist_item_selected_get(self.item))

        def __set__(self, selected):
            elm_genlist_item_selected_set(self.item, bool(selected))

    def selected_set(self, selected):
        elm_genlist_item_selected_set(self.item, bool(selected))
    def selected_get(self):
        return bool(elm_genlist_item_selected_get(self.item))

    def show(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """show(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes genlist to jump to the item and show it (by
        jumping to that position), if it is not fully visible.

        .. seealso:: :py:func:`bring_in()`

        """
        elm_genlist_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """bring_in(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes genlist to jump to the item and show it (by
        animatedly scrolling), if it is not fully visible.
        This may use animation and take a some time to do so.

        .. seealso:: :py:func:`show()`

        """
        elm_genlist_item_bring_in(self.item, scrollto_type)

    def update(self):
        """update()

        This updates an item by calling all the item class functions again
        to get the contents, texts and states. Use this when the original
        item data has changed and the changes are desired to be reflected.

        Use elm_genlist_realized_items_update() to update all already realized
        items.

        .. seealso:: :py:func:`Genlist.realized_items_update()`

        """
        elm_genlist_item_update(self.item)

    #def item_class_update(self, Elm_Genlist_Item_Class itc):
        """This sets another class of the item, changing the way that it is
        displayed. After changing the item class, elm_genlist_item_update() is
        called on the item.

        """
        #elm_genlist_item_item_class_update(self.item, itc)

    #def item_class_get(self):
        """This returns the Genlist_Item_Class for the given item. It can be
        used to examine the function pointers and item_style.

        """
        #return elm_genlist_item_item_class_get(self.item)

    property index:
        """Get the index of the item. It is only valid once displayed.

        :type: int

        """
        def __get__(self):
            return elm_genlist_item_index_get(self.item)

    def index_get(self):
        return elm_genlist_item_index_get(self.item)

    def tooltip_text_set(self, text):
        """tooltip_text_set(unicode text)

        Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed.
        Internally, this method calls :py:func:`tooltip_content_cb_set`

        """
        elm_genlist_item_tooltip_text_set(self.item, _cfruni(text))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """tooltip_content_cb_set(func, *args, **kargs)

        Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. ``func(args,kargs)`` will
        be called every time that need show the tooltip and it should return
        a valid Evas_Object. This object is then managed fully by tooltip
        system and is deleted when the tooltip is gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, self, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_genlist_item_tooltip_content_cb_set(self.item,
                                                _tooltip_item_content_create,
                                                cbdata,
                                                _tooltip_item_data_del_cb)

    def tooltip_unset(self):
        """tooltip_unset()

        Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set`
        the internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but
        no freed.

        """
        elm_genlist_item_tooltip_unset(self.item)

    property tooltip_style:
        """Tooltips can have **alternate styles** to be displayed on,
        which are defined by the theme set on Elementary. This function
        works analogously as elm_object_tooltip_style_set(), but here
        applied only to genlist item objects. The default style for
        tooltips is ``"default"``.

        .. note:: before you set a style you should define a tooltip with
            elm_genlist_item_tooltip_content_cb_set() or
            elm_genlist_item_tooltip_text_set()

        :type: string

        """
        def __set__(self, style):
            elm_genlist_item_tooltip_style_set(self.item, _cfruni(style) if style is not None else NULL)

        def __get__(self):
            return _ctouni(elm_genlist_item_tooltip_style_get(self.item))

    def tooltip_style_set(self, style=None):
        elm_genlist_item_tooltip_style_set(self.item, _cfruni(style) if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_genlist_item_tooltip_style_get(self.item))

    property tooltip_window_mode:
        """This property allows a tooltip to expand beyond its parent window's canvas.
        It will instead be limited only by the size of the display.

        """
        def __set__(self, disable):
            #TODO: check rval
            elm_genlist_item_tooltip_window_mode_set(self.item, disable)

        def __get__(self):
            return bool(elm_genlist_item_tooltip_window_mode_get(self.item))

    def tooltip_window_mode_set(self, disable):
        return bool(elm_genlist_item_tooltip_window_mode_set(self.item, disable))
    def tooltip_window_mode_get(self):
        return bool(elm_genlist_item_tooltip_window_mode_get(self.item))

    property cursor:
        """Set the cursor that will be displayed when mouse is over the
        item. The item can have only one cursor set to it, so if
        this function is called twice for an item, the previous set
        will be unset.

        """
        def __set__(self, cursor):
            elm_genlist_item_cursor_set(self.item, _cfruni(cursor))

        def __get__(self):
            return _ctouni(elm_genlist_item_cursor_get(self.item))

        def __del__(self):
            elm_genlist_item_cursor_unset(self.item)

    def cursor_set(self, cursor):
        elm_genlist_item_cursor_set(self.item, _cfruni(cursor))
    def cursor_get(self):
        return _ctouni(elm_genlist_item_cursor_get(self.item))
    def cursor_unset(self):
        elm_genlist_item_cursor_unset(self.item)

    property cursor_style:
        """Sets a different style for this object cursor.

        .. note:: before you set a style you should define a cursor with
            elm_genlist_item_cursor_set()

        """
        def __set__(self, style):
            elm_genlist_item_cursor_style_set(self.item, _cfruni(style) if style is not None else NULL)

        def __get__(self):
            return _ctouni(elm_genlist_item_cursor_style_get(self.item))

    def cursor_style_set(self, style=None):
        if style:
            elm_genlist_item_cursor_style_set(self.item, _cfruni(style))
        else:
            elm_genlist_item_cursor_style_set(self.item, NULL)
    def cursor_style_get(self):
        return _ctouni(elm_genlist_item_cursor_style_get(self.item))

    property cursor_engine_only:
        """ Sets cursor engine only usage for this object.

        .. note:: before you set engine only usage you should define a
            cursor with elm_genlist_item_cursor_set()

        """
        def __set__(self, engine_only):
            elm_genlist_item_cursor_engine_only_set(self.item, bool(engine_only))

        def __get__(self):
            return elm_genlist_item_cursor_engine_only_get(self.item)

    def cursor_engine_only_set(self, engine_only):
        elm_genlist_item_cursor_engine_only_set(self.item, bool(engine_only))
    def cursor_engine_only_get(self):
        return elm_genlist_item_cursor_engine_only_get(self.item)

    property parent:
        """This returns the item that was specified as parent of the item
        on elm_genlist_item_append() and insertion related functions.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_parent_get(self.item))

    def parent_get(self):
        return _object_item_to_python(elm_genlist_item_parent_get(self.item))

    def subitems_clear(self):
        """subitems_clear()

        This removes all items that are children (and their descendants)
        of the item.

        """
        elm_genlist_item_subitems_clear(self.item)

    property expanded:
        """This function flags the item of type #ELM_GENLIST_ITEM_TREE as
        expanded or not.

        The theme will respond to this change visually, and a signal
        "expanded" or "contracted" will be sent from the genlist with a
        pointer to the item that has been expanded/contracted.

        Calling this function won't show or hide any child of this item (if
        it is a parent). You must manually delete and create them on the
        callbacks of the "expanded" or "contracted" signals.

        :type: bool

        """
        def __get__(self):
            return bool(elm_genlist_item_expanded_get(self.item))

        def __set__(self, expanded):
            elm_genlist_item_expanded_set(self.item, bool(expanded))

    def expanded_set(self, expanded):
        elm_genlist_item_expanded_set(self.item, bool(expanded))
    def expanded_get(self, ):
        return bool(elm_genlist_item_expanded_get(self.item))

    property expanded_depth:
        """Get the depth of expanded item.

        :type: int

        """
        def __get__(self):
            return elm_genlist_item_expanded_depth_get(self.item)

    def expanded_depth_get(self):
        return elm_genlist_item_expanded_depth_get(self.item)

    def all_contents_unset(self):
        """all_contents_unset() -> list

        This instructs genlist to release references to contents in the
        item, meaning that they will no longer be managed by genlist and are
        floating "orphans" that can be re-used elsewhere if the user wants to.

        """
        cdef Eina_List *lst
        elm_genlist_item_all_contents_unset(self.item, &lst)
        return _object_item_list_to_python(lst)

    def promote(self):
        """promote()

        Promote an item to the top of the list

        """
        elm_genlist_item_promote(self.item)

    def demote(self):
        """demote()

        Demote an item to the end of the list

        """
        elm_genlist_item_demote(self.item)

    def fields_update(self, parts, itf):
        """fields_update(unicode parts, itf)

        This updates an item's part by calling item's fetching functions again
        to get the contents, texts and states. Use this when the original
        item data has changed and the changes are desired to be reflected.
        Second parts argument is used for globbing to match '*', '?', and '.'
        It can be used at updating multi fields.

        Use elm_genlist_realized_items_update() to update an item's all
        property.

        .. seealso:: :py:func:`update()`

        """
        elm_genlist_item_fields_update(self.item, _cfruni(parts), itf)

    property decorate_mode:
        """A genlist mode is a different way of selecting an item. Once a
        mode is activated on an item, any other selected item is immediately
        unselected. This feature provides an easy way of implementing a new
        kind of animation for selecting an item, without having to entirely
        rewrite the item style theme. However, the elm_genlist_selected_*
        API can't be used to get what item is activate for a mode.

        The current item style will still be used, but applying a genlist
        mode to an item will select it using a different kind of animation.

        The current active item for a mode can be found by
        elm_genlist_decorated_item_get().

        The characteristics of genlist mode are:

        - Only one mode can be active at any time, and for only one item.
        - Genlist handles deactivating other items when one item is activated.
        - A mode is defined in the genlist theme (edc), and more modes can
          easily be added.
        - A mode style and the genlist item style are different things. They
          can be combined to provide a default style to the item, with some
          kind of animation for that item when the mode is activated.

        When a mode is activated on an item, a new view for that item is
        created. The theme of this mode defines the animation that will be
        used to transit the item from the old view to the new view. This
        second (new) view will be active for that item while the mode is
        active on the item, and will be destroyed after the mode is totally
        deactivated from that item.

        .. seealso:: :py:attr:`mode` :py:attr:`decorated_item`

        """
        def __set__(self, value):
            decorate_it_type, decorate_it_set = value
            elm_genlist_item_decorate_mode_set(self.item, _cfruni(decorate_it_type), decorate_it_set)

        def __get__(self):
            return _ctouni(elm_genlist_item_decorate_mode_get(self.item))

    def decorate_mode_set(self, decorate_it_type, decorate_it_set):
        elm_genlist_item_decorate_mode_set(self.item, _cfruni(decorate_it_type), decorate_it_set)
    def decorate_mode_get(self):
        return _ctouni(elm_genlist_item_decorate_mode_get(self.item))

    property type:
        """This function returns the item's type. Normally the item's type.
        If it failed, return value is ELM_GENLIST_ITEM_MAX

        """
        def __get__(self):
            cdef Elm_Genlist_Item_Type ittype = elm_genlist_item_type_get(self.item)
            return <Elm_Genlist_Item_Type>ittype

    def type_get(self):
        cdef Elm_Genlist_Item_Type ittype = elm_genlist_item_type_get(self.item)
        return <Elm_Genlist_Item_Type>ittype

    property flip:
        """The flip state of a given genlist item. Flip mode overrides
        current item object. It can be used for on-the-fly item replace.
        Flip mode can be used with/without decorate mode.

        :type: bool

        """
        def __set__(self, flip):
            elm_genlist_item_flip_set(self.item, flip)

        def __get__(self):
            return bool(elm_genlist_item_flip_get(self.item))

    def flip_set(self, flip):
        elm_genlist_item_flip_set(self.item, flip)
    def flip_get(self):
        return bool(elm_genlist_item_flip_get(self.item))

    property select_mode:
        """Item's select mode. Possible values are:

        - ELM_OBJECT_SELECT_MODE_DEFAULT : The item will only call their
            selection func and callback when first becoming selected. Any
            further clicks will do nothing, unless you set always select mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS : This means that, even if selected,
             every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability to
            select the item entirely and they will neither appear selected
            nor call selected callback functions.
        - ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY : This will apply
            no-finger-size rule with ELM_OBJECT_SELECT_MODE_NONE.
            No-finger-size rule makes an item can be smaller than lower
            limit. Clickable objects should be bigger than human touch point
            device (your finger) for some touch or small screen devices. So
            it is enabled, the item can be shrink than predefined
            finger-size value. And the item will be updated.

        """
        def __set__(self, mode):
            elm_genlist_item_select_mode_set(self.item, mode)

        def __get__(self):
            return elm_genlist_item_select_mode_get(self.item)

    def select_mode_set(self, mode):
        elm_genlist_item_select_mode_set(self.item, mode)
    def select_mode_get(self):
        return elm_genlist_item_select_mode_get(self.item)

cdef class Genlist(Object):

    """

    This widget aims to have more expansive list than the simple list in
    Elementary that could have more flexible items and allow many more
    entries while still being fast and low on memory usage. At the same time
    it was also made to be able to do tree structures. But the price to pay
    is more complexity when it comes to usage. If all you want is a simple
    list with icons and a single text, use the normal
    :py:class:`elementary.list.List` object.

    Genlist has a fairly large API, mostly because it's relatively complex,
    trying to be both expansive, powerful and efficient. First we will begin
    an overview on the theory behind genlist.

    .. rubric:: Genlist item classes - creating items

    In order to have the ability to add and delete items on the fly, genlist
    implements a class (callback) system where the application provides a
    structure with information about that type of item (genlist may contain
    multiple different items with different classes, states and styles).
    Genlist will call the functions in this struct (methods) when an item is
    "realized" (i.e., created dynamically, while the user is scrolling the
    grid). All objects will simply be deleted when no longer needed with
    evas_object_del(). The #Elm_Genlist_Item_Class structure contains the
    following members:

    - ``item_style`` - This is a constant string and simply defines the name
      of the item style. It **must** be specified and the default should be
      ``"default".``
    - ``decorate_item_style`` - This is a constant string and simply defines
      the name of the decorate mode item style. It is used to specify
      decorate mode item style. It can be used when you call
      elm_genlist_item_decorate_mode_set().
    - ``decorate_all_item_style`` - This is a constant string and simply
      defines the name of the decorate all item style. It is used to specify
      decorate all item style. It can be used to set selection, checking and
      deletion mode. This is used when you call
      elm_genlist_decorate_mode_set().
    - ``func`` - A struct with pointers to functions that will be called when
      an item is going to be actually created. All of them receive a ``data``
      parameter that will point to the same data passed to
      elm_genlist_item_append() and related item creation functions, and an
      ``obj`` parameter that points to the genlist object itself.

    The function pointers inside ``func`` are ``text_get,`` ``content_get,``
    ``state_get`` and ``del.`` The 3 first functions also receive a ``part``
    parameter described below. A brief description of these functions follows:

    - ``text_get`` - The ``part`` parameter is the name string of one of the
      existing text parts in the Edje group implementing the item's theme.
      This function **must** return a strdup'()ed string, as the caller will
      free() it when done. See #Elm_Genlist_Item_Text_Get_Cb.
    - ``content_get`` - The ``part`` parameter is the name string of one of the
      existing (content) swallow parts in the Edje group implementing the
      item's theme. It must return ``None``, when no content is desired, or
      a valid object handle, otherwise.  The object will be deleted by the
      genlist on its deletion or when the item is "unrealized". See
      #Elm_Genlist_Item_Content_Get_Cb.
    - ``func.state_get`` - The ``part`` parameter is the name string of one of
      the state parts in the Edje group implementing the item's theme. Return
      ``False`` for false/off or ``True`` for true/on. Genlists will
      emit a signal to its theming Edje object with ``"elm,state,xxx,active"``
      and ``"elm"`` as "emission" and "source" arguments, respectively, when
      the state is true (the default is false), where ``xxx`` is the name of
      the (state) part.  See #Elm_Genlist_Item_State_Get_Cb.
    - ``func.del`` - This is intended for use when genlist items are deleted,
      so any data attached to the item (e.g. its data parameter on creation)
      can be deleted. See #Elm_Genlist_Item_Del_Cb.

    Available item styles:

    - default
    - default_style - The text part is a textblock
    - double_label
    - icon_top_text_bottom
    - group_index

    - one_icon - Only 1 icon (left) @since 1.1
    - end_icon - Only 1 icon (at end/right) @since 1.1
    - no_icon - No icon (at end/right) @since 1.1

    .. rubric:: Structure of items

    An item in a genlist can have 0 or more texts (they can be regular text
    or textblock Evas objects - that's up to the style to determine), 0 or
    more contents (which are simply objects swallowed into the genlist item's
    theming Edje object) and 0 or more **boolean states**, which have the
    behavior left to the user to define. The Edje part names for each of
    these properties will be looked up, in the theme file for the genlist,
    under the Edje (string) data items named ``"labels",`` ``"contents"``
    and ``"states",`` respectively. For each of those properties, if more
    than one part is provided, they must have names listed separated by
    spaces in the data fields. For the default genlist item theme, we have
    **one** text part (``"elm.text"),`` **two** content parts
    (``"elm.swallow.icon"`` and ``"elm.swallow.end")`` and **no** state parts.

    A genlist item may be at one of several styles. Elementary provides one
    by default - "default", but this can be extended by system or application
    custom themes/overlays/extensions (see @ref Theme "themes" for more
    details).

    .. rubric:: Editing and Navigating

    Items can be added by several calls. All of them return a @ref
    Elm_Object_Item handle that is an internal member inside the genlist.
    They all take a data parameter that is meant to be used for a handle to
    the applications internal data (eg. the struct with the original item
    data). The parent parameter is the parent genlist item this belongs to if
    it is a tree or an indexed group, and None if there is no parent. The
    flags can be a bitmask of #ELM_GENLIST_ITEM_NONE, #ELM_GENLIST_ITEM_TREE
    and #ELM_GENLIST_ITEM_GROUP. If #ELM_GENLIST_ITEM_TREE is set then this
    item is displayed as an item that is able to expand and have child items.
    If #ELM_GENLIST_ITEM_GROUP is set then this item is group index item that
    is displayed at the top until the next group comes. The func parameter is
    a convenience callback that is called when the item is selected and the
    data parameter will be the func_data parameter, ``obj`` be the genlist
    object and event_info will be the genlist item.

    elm_genlist_item_append() adds an item to the end of the list, or if
    there is a parent, to the end of all the child items of the parent.
    elm_genlist_item_prepend() is the same but adds to the beginning of
    the list or children list. elm_genlist_item_insert_before() inserts at
    item before another item and elm_genlist_item_insert_after() inserts after
    the indicated item.

    The application can clear the list with elm_genlist_clear() which deletes
    all the items in the list and elm_object_item_del() will delete a specific
    item. elm_genlist_item_subitems_clear() will clear all items that are
    children of the indicated parent item.

    To help inspect list items you can jump to the item at the top of the list
    with elm_genlist_first_item_get() which will return the item pointer, and
    similarly elm_genlist_last_item_get() gets the item at the end of the list.
    elm_genlist_item_next_get() and elm_genlist_item_prev_get() get the next
    and previous items respectively relative to the indicated item. Using
    these calls you can walk the entire item list/tree. Note that as a tree
    the items are flattened in the list, so elm_genlist_item_parent_get() will
    let you know which item is the parent (and thus know how to skip them if
    wanted).

    .. rubric:: Multi-selection

    If the application wants multiple items to be able to be selected,
    elm_genlist_multi_select_set() can enable this. If the list is
    single-selection only (the default), then elm_genlist_selected_item_get()
    will return the selected item, if any, or None if none is selected. If the
    list is multi-select then elm_genlist_selected_items_get() will return a
    list (that is only valid as long as no items are modified (added, deleted,
    selected or unselected)).

    .. rubric:: Usage hints

    There are also convenience functions. elm_object_item_widget_get() will
    return the genlist object the item belongs to. elm_genlist_item_show()
    will make the scroller scroll to show that specific item so its visible.
    elm_object_item_data_get() returns the data pointer set by the item
    creation functions.

    If an item changes (state of boolean changes, text or contents change),
    then use elm_genlist_item_update() to have genlist update the item with
    the new state. Genlist will re-realize the item and thus call the functions
    in the _Elm_Genlist_Item_Class for that item.

    To programmatically (un)select an item use elm_genlist_item_selected_set().
    To get its selected state use elm_genlist_item_selected_get(). Similarly
    to expand/contract an item and get its expanded state, use
    elm_genlist_item_expanded_set() and elm_genlist_item_expanded_get(). And
    again to make an item disabled (unable to be selected and appear
    differently) use elm_object_item_disabled_set() to set this and
    elm_object_item_disabled_get() to get the disabled state.

    In general to indicate how the genlist should expand items horizontally to
    fill the list area, use elm_genlist_mode_set(). Valid modes are
    ELM_LIST_LIMIT, ELM_LIST_COMPRESS and ELM_LIST_SCROLL. The default is
    ELM_LIST_SCROLL. This mode means that if items are too wide to fit, the
    scroller will scroll horizontally. Otherwise items are expanded to
    fill the width of the viewport of the scroller. If it is
    ELM_LIST_LIMIT, items will be expanded to the viewport width
    if larger than the item, but genlist widget with is
    limited to the largest item. D not use ELM_LIST_LIMIT mode with homogenous
    mode turned on. ELM_LIST_COMPRESS can be combined with a different style
    that uses edjes' ellipsis feature (cutting text off like this: "tex...").

    Items will only call their selection func and callback when first becoming
    selected. Any further clicks will do nothing, unless you enable always
    select with elm_genlist_select_mode_set() as ELM_OBJECT_SELECT_MODE_ALWAYS.
    This means even if selected, every click will make the selected callbacks
    be called. elm_genlist_select_mode_set() as ELM_OBJECT_SELECT_MODE_NONE will
    turn off the ability to select items entirely and they will neither
    appear selected nor call selected callback functions.

    Remember that you can create new styles and add your own theme augmentation
    per application with elm_theme_extension_add(). If you absolutely must
    have a specific style that overrides any theme the user or system sets up
    you can use elm_theme_overlay_add() to add such a file.

    .. rubric:: Implementation

    Evas tracks every object you create. Every time it processes an event
    (mouse move, down, up etc.) it needs to walk through objects and find out
    what event that affects. Even worse every time it renders display updates,
    in order to just calculate what to re-draw, it needs to walk through many
    many many objects. Thus, the more objects you keep active, the more
    overhead Evas has in just doing its work. It is advisable to keep your
    active objects to the minimum working set you need. Also remember that
    object creation and deletion carries an overhead, so there is a
    middle-ground, which is not easily determined. But don't keep massive lists
    of objects you can't see or use. Genlist does this with list objects. It
    creates and destroys them dynamically as you scroll around. It groups them
    into blocks so it can determine the visibility etc. of a whole block at
    once as opposed to having to walk the whole list. This 2-level list allows
    for very large numbers of items to be in the list (tests have used up to
    2,000,000 items). Also genlist employs a queue for adding items. As items
    may be different sizes, every item added needs to be calculated as to its
    size and thus this presents a lot of overhead on populating the list, this
    genlist employs a queue. Any item added is queued and spooled off over
    time, actually appearing some time later, so if your list has many members
    you may find it takes a while for them to all appear, with your process
    consuming a lot of CPU while it is busy spooling.

    Genlist also implements a tree structure, but it does so with callbacks to
    the application, with the application filling in tree structures when
    requested (allowing for efficient building of a very deep tree that could
    even be used for file-management). See the above smart signal callbacks for
    details.

    .. rubric:: Genlist smart events

    Signals that you can add callbacks for are:

    - ``"activated"`` - The user has double-clicked or pressed
      (enter|return|spacebar) on an item. The ``event_info`` parameter is the
      item that was activated.
    - ``"clicked,double"`` - The user has double-clicked an item.  The
      ``event_info`` parameter is the item that was double-clicked.
    - ``"selected"`` - This is called when a user has made an item selected.
      The event_info parameter is the genlist item that was selected.
    - ``"unselected"`` - This is called when a user has made an item
      unselected. The event_info parameter is the genlist item that was
      unselected.
    - ``"expanded"`` - This is called when elm_genlist_item_expanded_set() is
      called and the item is now meant to be expanded. The event_info
      parameter is the genlist item that was indicated to expand.  It is the
      job of this callback to then fill in the child items.
    - ``"contracted"`` - This is called when elm_genlist_item_expanded_set() is
      called and the item is now meant to be contracted. The event_info
      parameter is the genlist item that was indicated to contract. It is the
      job of this callback to then delete the child items.
    - ``"expand,request"`` - This is called when a user has indicated they want
      to expand a tree branch item. The callback should decide if the item can
      expand (has any children) and then call elm_genlist_item_expanded_set()
      appropriately to set the state. The event_info parameter is the genlist
      item that was indicated to expand.
    - ``"contract,request"`` - This is called when a user has indicated they
      want to contract a tree branch item. The callback should decide if the
      item can contract (has any children) and then call
      elm_genlist_item_expanded_set() appropriately to set the state. The
      event_info parameter is the genlist item that was indicated to contract.
    - ``"realized"`` - This is called when the item in the list is created as a
      real evas object. event_info parameter is the genlist item that was
      created.
    - ``"unrealized"`` - This is called just before an item is unrealized.
      After this call content objects provided will be deleted and the item
      object itself delete or be put into a floating cache.
    - ``"drag,start,up"`` - This is called when the item in the list has been
      dragged (not scrolled) up.
    - ``"drag,start,down"`` - This is called when the item in the list has been
      dragged (not scrolled) down.
    - ``"drag,start,left"`` - This is called when the item in the list has been
      dragged (not scrolled) left.
    - ``"drag,start,right"`` - This is called when the item in the list has
      been dragged (not scrolled) right.
    - ``"drag,stop"`` - This is called when the item in the list has stopped
      being dragged.
    - ``"drag"`` - This is called when the item in the list is being dragged.
    - ``"longpressed"`` - This is called when the item is pressed for a certain
      amount of time. By default it's 1 second. The event_info parameter is the
      longpressed genlist item.
    - ``"scroll,anim,start"`` - This is called when scrolling animation has
      started.
    - ``"scroll,anim,stop"`` - This is called when scrolling animation has
      stopped.
    - ``"scroll,drag,start"`` - This is called when dragging the content has
      started.
    - ``"scroll,drag,stop"`` - This is called when dragging the content has
      stopped.
    - ``"edge,top"`` - This is called when the genlist is scrolled until
      the top edge.
    - ``"edge,bottom"`` - This is called when the genlist is scrolled
      until the bottom edge.
    - ``"edge,left"`` - This is called when the genlist is scrolled
      until the left edge.
    - ``"edge,right"`` - This is called when the genlist is scrolled
      until the right edge.
    - ``"multi,swipe,left"`` - This is called when the genlist is multi-touch
      swiped left.
    - ``"multi,swipe,right"`` - This is called when the genlist is multi-touch
      swiped right.
    - ``"multi,swipe,up"`` - This is called when the genlist is multi-touch
      swiped up.
    - ``"multi,swipe,down"`` - This is called when the genlist is multi-touch
      swiped down.
    - ``"multi,pinch,out"`` - This is called when the genlist is multi-touch
      pinched out.
    - ``multi,pinch,in"`` - This is called when the genlist is multi-touch
      pinched in.
    - ``"swipe"`` - This is called when the genlist is swiped.
    - ``"moved"`` - This is called when a genlist item is moved in reorder mode.
    - ``"moved,after"`` - This is called when a genlist item is moved after
      another item in reorder mode. The event_info parameter is the reordered
      item. To get the relative previous item, use elm_genlist_item_prev_get().
      This signal is called along with "moved" signal.
    - ``"moved,before"`` - This is called when a genlist item is moved before
      another item in reorder mode. The event_info parameter is the reordered
      item. To get the relative previous item, use elm_genlist_item_next_get().
      This signal is called along with "moved" signal.
    - ``"language,changed"`` - This is called when the program's language is
      changed.
    - ``"tree,effect,finished"`` - This is called when a genlist tree effect
      is finished.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_genlist_add(parent.obj))

    def clear(self):
        """clear()

        Remove all items from a given genlist widget.

        """
        elm_genlist_clear(self.obj)

    property multi_select:
        """This enables (``True``) or disables (``False``) multi-selection in
        the list. This allows more than 1 item to be selected. To retrieve
        the list of selected items, use elm_genlist_selected_items_get().

        :type: bool

        """
        def __set__(self, multi):
            elm_genlist_multi_select_set(self.obj, bool(multi))

        def __get__(self):
            return bool(elm_genlist_multi_select_get(self.obj))

    def multi_select_set(self, multi):
        elm_genlist_multi_select_set(self.obj, bool(multi))
    def multi_select_get(self):
        return bool(elm_genlist_multi_select_get(self.obj))

    property mode:
        """This sets the mode used for sizing items horizontally. Valid modes
        are #ELM_LIST_LIMIT, #ELM_LIST_SCROLL, and #ELM_LIST_COMPRESS. The
        default is ELM_LIST_SCROLL. This mode means that if items are too
        wide to fit, the scroller will scroll horizontally. Otherwise items
        are expanded to fill the width of the viewport of the scroller. If
        it is ELM_LIST_LIMIT, items will be expanded to the viewport width
        and limited to that size. If it is ELM_LIST_COMPRESS, the item width
        will be fixed (restricted to a minimum of) to the list width when
        calculating its size in order to allow the height to be calculated
        based on it. This allows, for instance, text block to wrap lines if
        the Edje part is configured with "text.min: 0 1".

        .. note:: ELM_LIST_COMPRESS will make list resize slower as it will
            have to recalculate every item height again whenever the list
            width changes!
        .. note:: Homogeneous mode is for that all items in the genlist same
            width/height. With ELM_LIST_COMPRESS, it makes genlist items to
            fast initializing. However there's no sub-objects in genlist
            which can be on the flying resizable (such as TEXTBLOCK). If
            then, some dynamic resizable objects in genlist would not
            diplayed properly.

        """
        def __set__(self, mode):
            elm_genlist_mode_set(self.obj, mode)

        def __get__(self):
            return elm_genlist_mode_get(self.obj)

    def mode_set(self, mode):
        elm_genlist_mode_set(self.obj, mode)
    def mode_get(self):
        return elm_genlist_mode_get(self.obj)

    property bounce:
        """This will enable or disable the scroller bouncing effect for the
        genlist. See elm_scroller_bounce_set() for details.

        :type: tuple of bools

        """
        def __set__(self, value):
            h_bounce, v_bounce = value
            elm_scroller_bounce_set(self.obj, bool(h_bounce), bool(v_bounce))

        def __get__(self):
            cdef Eina_Bool h_bounce, v_bounce
            elm_scroller_bounce_get(self.obj, &h_bounce, &v_bounce)
            return (h_bounce, v_bounce)

    def bounce_set(self, h_bounce, v_bounce):
        elm_scroller_bounce_set(self.obj, bool(h_bounce), bool(v_bounce))
    def bounce_get(self):
        cdef Eina_Bool h_bounce, v_bounce
        elm_scroller_bounce_get(self.obj, &h_bounce, &v_bounce)
        return (h_bounce, v_bounce)

    def item_append(self,
                    GenlistItemClass item_class not None,
                    item_data,
                    GenlistItem parent_item=None,
                    int flags=ELM_GENLIST_ITEM_NONE,
                    func=None):
        return GenlistItem(item_class, parent_item, flags, func, item_data).append_to(self)

    def item_prepend(   self,
                        GenlistItemClass item_class not None,
                        item_data,
                        GenlistItem parent_item=None,
                        int flags=ELM_GENLIST_ITEM_NONE,
                        func=None):
        return GenlistItem(item_class, parent_item, flags, func, item_data).prepend_to(self)

    def item_insert_before( self,
                            GenlistItemClass item_class not None,
                            item_data,
                            #API XXX: parent
                            GenlistItem before_item=None,
                            int flags=ELM_GENLIST_ITEM_NONE,
                            func=None
                            #API XXX: *args, **kwargs
                            ):
        return GenlistItem(item_class, None, flags, func, item_data).insert_before(before_item)

    def item_insert_after(  self,
                            GenlistItemClass item_class not None,
                            item_data,
                            #API XXX: parent
                            GenlistItem after_item=None,
                            int flags=ELM_GENLIST_ITEM_NONE,
                            func=None
                            #API XXX: *args, **kwargs
                            ):
        return GenlistItem(item_class, None, flags, func, item_data).insert_after(after_item)

    #Elm_Object_Item         *elm_genlist_item_sorted_insert(self.obj, Elm_Genlist_Item_Class *itc, void *data, Elm_Object_Item *parent, Elm_Genlist_Item_Type flags, Eina_Compare_Cb comp, Evas_Smart_Cb func, void *func_data)

    property selected_item:
        """This gets the selected item in the list (if multi-selection is
        enabled, only the item that was first selected in the list is
        returned - which is not very useful, so see
        elm_genlist_selected_items_get() for when multi-selection is used).

        If no item is selected, None is returned.

        .. seealso:: :py:attr:`selected_items`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_genlist_selected_item_get(self.obj))

    property selected_items:
        """It returns a list of the selected items. This list pointer is
        only valid so long as the selection doesn't change (no items are
        selected or unselected, or unselected implicitly by deletion). The
        list contains genlist items pointers. The order of the items in this
        list is the order which they were selected, i.e. the first item in
        this list is the first item that was selected, and so on.

        .. note:: If not in multi-select mode, consider using function
            elm_genlist_selected_item_get() instead.

        .. seealso:: :py:attr:`multi_select` :py:attr:`selected_item`

        :type: tuple of :py:class:`GenlistItem`

        """
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_genlist_selected_items_get(self.obj)))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_genlist_selected_items_get(self.obj))

    property realized_items:
        """This returns a list of the realized items in the genlist. The list
        contains genlist item pointers. The list must be freed by the
        caller when done with eina_list_free(). The item pointers in the
        list are only valid so long as those items are not deleted or the
        genlist is not deleted.

        .. seealso:: :py:func:`realized_items_update()`

        :type: tuple of :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_genlist_realized_items_get(self.obj))

    def realized_items_get(self):
        return _object_item_list_to_python(elm_genlist_realized_items_get(self.obj))

    property first_item:
        """This returns the first item in the list.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    property last_item:
        """This returns the last item in the list.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_genlist_last_item_get(self.obj))

    property scroller_policy:
        """This sets the scrollbar visibility policy for the given genlist
        scroller. #ELM_SCROLLER_POLICY_AUTO means the scrollbar is made
        visible if it is needed, and otherwise kept hidden.
        #ELM_SCROLLER_POLICY_ON turns it on all the time, and
        #ELM_SCROLLER_POLICY_OFF always keeps it off. This applies
        respectively for the horizontal and vertical scrollbars. Default is
        #ELM_SCROLLER_POLICY_AUTO

        :type: Elm_Scroller_Policy

        """
        def __set__(self, value):
            policy_h, policy_v = value
            elm_scroller_policy_set(self.obj, policy_h, policy_v)

        def __get__(self):
            cdef Elm_Scroller_Policy policy_h, policy_v
            elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
            return (policy_h, policy_v)

    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    def realized_items_update(self):
        """realized_items_update()

        This updates all realized items by calling all the item class
        functions again to get the contents, texts and states. Use this when
        the original item data has changed and the changes are desired to be
        reflected.

        To update just one item, use elm_genlist_item_update().

        .. seealso:: :py:attr:`realized_items` :py:func:`item_update()`

        """
        elm_genlist_realized_items_update(self.obj)

    def _items_count(self):
        return elm_genlist_items_count(self.obj)

    property items_count:
        """Return how many items are currently in a list

        :type: int

        """
        def __get__(self):
            count = elm_genlist_items_count(self.obj)
            return GenlistItemsCount(self, count)

    property homogeneous:
        """This will enable the homogeneous mode where items are of the same
        height and width so that genlist may do the lazy-loading at its
        maximum (which increases the performance for scrolling the list).

        .. seealso:: :py:attr:`mode`

        :type: bool

        """
        def __set__(self, homogeneous):
            elm_genlist_homogeneous_set(self.obj, bool(homogeneous))

        def __get__(self):
            return bool(elm_genlist_homogeneous_get(self.obj))

    def homogeneous_set(self, homogeneous):
        elm_genlist_homogeneous_set(self.obj, bool(homogeneous))
    def homogeneous_get(self):
        return bool(elm_genlist_homogeneous_get(self.obj))

    property block_count:
        """This will configure the block count to tune to the target with
        particular performance matrix.

        A block of objects will be used to reduce the number of operations
        due to many objects in the screen. It can determine the visibility,
        or if the object has changed, it theme needs to be updated, etc.
        doing this kind of calculation to the entire block, instead of per
        object.

        The default value for the block count is enough for most lists, so
        unless you know you will have a lot of objects visible in the screen
        at the same time, don't try to change this.

        """
        def __set__(self, int n):
            elm_genlist_block_count_set(self.obj, n)

        def __get__(self):
            return elm_genlist_block_count_get(self.obj)

    def block_count_set(self, int n):
        elm_genlist_block_count_set(self.obj, n)
    def block_count_get(self):
        return elm_genlist_block_count_get(self.obj)

    property longpress_timeout:
        """This option will change how long it takes to send an event
        "longpressed" after the mouse down signal is sent to the list. If
        this event occurs, no "clicked" event will be sent.

        .. warning:: If you set the longpress timeout value with this API,
            your genlist will not be affected by the longpress value of
            elementary config value later.

        """
        def __set__(self, timeout):
            elm_genlist_longpress_timeout_set(self.obj, timeout)

        def __get__(self):
            return elm_genlist_longpress_timeout_get(self.obj)

    def longpress_timeout_set(self, timeout):
        elm_genlist_longpress_timeout_set(self.obj, timeout)
    def longpress_timeout_get(self):
        return elm_genlist_longpress_timeout_get(self.obj)

    def at_xy_item_get(self, int x, int y):
        """at_xy_item_get(int x, int y) -> GenlistItem

        Get the item that is at the x, y canvas coords.

        :param x: The input x coordinate
        :param y: The input y coordinate
        :param posret: The position relative to the item returned here
        :return: The item at the coordinates or None if none

        This returns the item at the given coordinates (which are canvas
        relative, not object-relative). If an item is at that coordinate,
        that item handle is returned, and if ``posret`` is not None, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the upper portion of that item (-1), on the
        middle section (0) or on the lower part (1). If None is returned as
        an item (no item found there), then posret may indicate -1 or 1
        based if the coordinate is above or below all items respectively in
        the genlist.

        """
        return _object_item_to_python(elm_genlist_at_xy_item_get(self.obj, x, y, NULL))

    property decorated_item:
        """This function returns the item that was activated with a mode, by
        the function elm_genlist_item_decorate_mode_set().

        .. seealso:: :py:attr:`GenlistItem.decorate_mode` :py:attr:`mode`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_decorated_item_get(self.obj))

    def decorated_item_get(self):
        return _object_item_to_python(elm_genlist_decorated_item_get(self.obj))

    property reorder_mode:
        """Reorder mode.

        :type: bool

        """
        def __set__(self, reorder_mode):
            elm_genlist_reorder_mode_set(self.obj, reorder_mode)

        def __get__(self):
            return bool(elm_genlist_reorder_mode_get(self.obj))

    def reorder_mode_set(self, reorder_mode):
        elm_genlist_reorder_mode_set(self.obj, reorder_mode)
    def reorder_mode_get(self):
        return bool(elm_genlist_reorder_mode_get(self.obj))

    property decorate_mode:
        """Genlist decorate mode for all items.

        :type: bool

        """
        def __set__(self, decorated):
            elm_genlist_decorate_mode_set(self.obj, decorated)

        def __get__(self):
            return bool(elm_genlist_decorate_mode_get(self.obj))

    def decorate_mode_set(self, decorated):
        elm_genlist_decorate_mode_set(self.obj, decorated)
    def decorate_mode_get(self):
        return bool(elm_genlist_decorate_mode_get(self.obj))

    property tree_effect_enabled:
        """Genlist tree effect.

        :type: bool

        """
        def __set__(self, enabled):
            elm_genlist_tree_effect_enabled_set(self.obj, enabled)

        def __get__(self):
            return bool(elm_genlist_tree_effect_enabled_get(self.obj))

    def tree_effect_enabled_set(self, enabled):
        elm_genlist_tree_effect_enabled_set(self.obj, enabled)
    def tree_effect_enabled_get(self):
        return bool(elm_genlist_tree_effect_enabled_get(self.obj))

    property highlight_mode:
        """Whether the item will, or will not highlighted on selection. The
        selected and clicked callback functions will still be called.

        Highlight is enabled by default.

        :type: bool

        """
        def __set__(self, highlight):
            elm_genlist_highlight_mode_set(self.obj, highlight)

        def __get__(self):
            return bool(elm_genlist_highlight_mode_get(self.obj))

    def highlight_mode_set(self, highlight):
        elm_genlist_highlight_mode_set(self.obj, highlight)
    def highlight_mode_get(self):
        return bool(elm_genlist_highlight_mode_get(self.obj))

    property select_mode:
        """Selection mode of the Genlist widget.

        - ELM_OBJECT_SELECT_MODE_DEFAULT : Items will only call their
            selection func and callback when first becoming selected. Any
            further clicks will do nothing, unless you set always select mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS :  This means that, even if selected,
            every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability to
            select items entirely and they will neither appear selected nor
            call selected callback functions.

        :type: Elm_Object_Select_Mode

        """
        def __set__(self, mode):
            elm_genlist_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_genlist_select_mode_get(self.obj)

    def select_mode_set(self, mode):
        elm_genlist_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_genlist_select_mode_get(self.obj)

    def callback_activated_add(self, func, *args, **kwargs):
        self._callback_add_full("activated", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated",  _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double",  _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected",  _cb_object_item_conv, func)

    def callback_expanded_add(self, func, *args, **kwargs):
        self._callback_add_full("expanded", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_expanded_del(self, func):
        self._callback_del_full("expanded",  _cb_object_item_conv, func)

    def callback_contracted_add(self, func, *args, **kwargs):
        self._callback_add_full("contracted", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_contracted_del(self, func):
        self._callback_del_full("contracted",  _cb_object_item_conv, func)

    def callback_expand_request_add(self, func, *args, **kwargs):
        self._callback_add_full("expand,request", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_expand_request_del(self, func):
        self._callback_del_full("expand,request",  _cb_object_item_conv, func)

    def callback_contract_request_add(self, func, *args, **kwargs):
        self._callback_add_full("contract,request", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_contract_request_del(self, func):
        self._callback_del_full("contract,request",  _cb_object_item_conv, func)

    def callback_realized_add(self, func, *args, **kwargs):
        self._callback_add_full("realized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_realized_del(self, func):
        self._callback_del_full("realized",  _cb_object_item_conv, func)

    def callback_unrealized_add(self, func, *args, **kwargs):
        self._callback_add_full("unrealized", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_unrealized_del(self, func):
        self._callback_del_full("unrealized",  _cb_object_item_conv, func)

    def callback_drag_start_up_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,up", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_up_del(self, func):
        self._callback_del_full("drag,start,up",  _cb_object_item_conv, func)

    def callback_drag_start_down_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,down", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_down_del(self, func):
        self._callback_del_full("drag,start,down",  _cb_object_item_conv, func)

    def callback_drag_start_left_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,left", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_left_del(self, func):
        self._callback_del_full("drag,start,left",  _cb_object_item_conv, func)

    def callback_drag_start_right_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,right", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_start_right_del(self, func):
        self._callback_del_full("drag,start,right",  _cb_object_item_conv, func)

    def callback_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,stop", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_stop_del(self, func):
        self._callback_del_full("drag,stop",  _cb_object_item_conv, func)

    def callback_drag_add(self, func, *args, **kwargs):
        self._callback_add_full("drag", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_drag_del(self, func):
        self._callback_del_full("drag",  _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add_full("longpressed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,start", func, *args, **kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,anim,stop", func, *args, **kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,start", func, *args, **kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add("scroll,drag,stop", func, *args, **kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        self._callback_add("edge,top", func, *args, **kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top", func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        self._callback_add("edge,bottom", func, *args, **kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom", func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        self._callback_add("edge,left", func, *args, **kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left", func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        self._callback_add("edge,right", func, *args, **kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right", func)

    def callback_multi_swipe_left_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,left", func, *args, **kwargs)

    def callback_multi_swipe_left_del(self, func):
        self._callback_del("multi,swipe,left", func)

    def callback_multi_swipe_right_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,right", func, *args, **kwargs)

    def callback_multi_swipe_right_del(self, func):
        self._callback_del("multi,swipe,right", func)

    def callback_multi_swipe_up_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,up", func, *args, **kwargs)

    def callback_multi_swipe_up_del(self, func):
        self._callback_del("multi,swipe,up", func)

    def callback_multi_swipe_down_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,down", func, *args, **kwargs)

    def callback_multi_swipe_down_del(self, func):
        self._callback_del("multi,swipe,down", func)

    def callback_multi_pinch_out_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,out", func, *args, **kwargs)

    def callback_multi_pinch_out_del(self, func):
        self._callback_del("multi,pinch,out", func)

    def callback_multi_pinch_in_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,in", func, *args, **kwargs)

    def callback_multi_pinch_in_del(self, func):
        self._callback_del("multi,pinch,in", func)

    def callback_swipe_add(self, func, *args, **kwargs):
        self._callback_add("swipe", func, *args, **kwargs)

    def callback_swipe_del(self, func):
        self._callback_del("swipe", func)

    def callback_moved_add(self, func, *args, **kwargs):
        self._callback_add_full("moved", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_del(self, func):
        self._callback_del_full("moved",  _cb_object_item_conv, func)

    def callback_moved_after_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,after", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_after_del(self, func):
        self._callback_del_full("moved,after",  _cb_object_item_conv, func)

    def callback_moved_before_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,before", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_moved_before_del(self, func):
        self._callback_del_full("moved,before",  _cb_object_item_conv, func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)

    def callback_tree_effect_finished_add(self, func, *args, **kwargs):
        self._callback_add("tree,effect,finished", func, *args, **kwargs)

    def callback_tree_effect_finished_del(self, func):
        self._callback_del("tree,effect,finished", func)


_object_mapping_register("elm_genlist", Genlist)
