# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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
#

"""

.. image:: /images/slideshow-preview.png

Widget description
------------------

This widget, as the name indicates, is a pre-made image
slideshow panel, with API functions acting on (child) image
items presentation. Between those actions, are:

- advance to next/previous image
- select the style of image transition animation
- set the exhibition time for each image
- start/stop the slideshow

The transition animations are defined in the widget's theme,
consequently new animations can be added without having to
update the widget's code.

Slideshow items
===============

For slideshow items, just like for :py:class:`~efl.elementary.genlist.Genlist`
ones, the user defines a **classes**, specifying functions that will be called
on the item's creation and deletion times.

The :py:class:`SlideshowItemClass` class contains the following
members:

- ``get`` - When an item is displayed, this function is
  called, and it's where one should create the item object, de
  facto. For example, the object can be a pure Evas image object
  or a :py:class:`~efl.elementary.photocam.Photocam` widget.

- ``delete`` - When an item is no more displayed, this function
  is called, where the user must delete any data associated to
  the item.

Slideshow caching
=================

The slideshow provides facilities to have items adjacent to the
one being displayed **already "realized"** (i.e. loaded) for
you, so that the system does not have to decode image data
anymore at the time it has to actually switch images on its
viewport. The user is able to set the numbers of items to be
cached **before** and **after** the current item, in the widget's
item list.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - when the slideshow switches its view to a new item.
  event_info parameter in callback contains the current visible item
- ``transition,end`` - when a slide transition ends. event_info
  parameter in callback contains the current visible item
- ``focused`` - When the slideshow has received focus. (since 1.8)
- ``unfocused`` - When the slideshow has lost focus. (since 1.8)

"""

from cpython cimport PyUnicode_AsUTF8String, Py_INCREF, Py_DECREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, object_from_instance, PY_REFCOUNT
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject
from efl.utils.conversions cimport eina_list_strings_to_python_list

from layout_class cimport LayoutClass

import traceback
from object_item cimport _object_item_to_python, _object_item_list_to_python

def _cb_object_item_conv(uintptr_t addr):
    cdef Elm_Object_Item *it = <Elm_Object_Item *>addr
    return _object_item_to_python(it)

cdef Evas_Object *_py_elm_slideshow_item_get(void *data, Evas_Object *obj) with gil:
    cdef SlideshowItem item = <object>data
    cdef evasObject icon
    cdef SlideshowItemClass itc = item.cls

    func = itc._get_func
    if func is None:
        return NULL

    try:
        o = object_from_instance(obj)
        ret = func(o, *item.args, **item.kwargs)
    except:
        traceback.print_exc()
        return NULL

    if ret is None:
        return NULL

    icon = ret
    return icon.obj

cdef void _py_elm_slideshow_item_del(void *data, Evas_Object *obj) with gil:
    cdef SlideshowItem item = <object>data
    cdef SlideshowItemClass itc = item.cls

    func = itc._del_func
    if func is not None:
        try:
            o = object_from_instance(obj)
            func(o, *item.args, **item.kwargs)
        except:
            traceback.print_exc()

    # XXX: SlideShow item handling is weird
    #item._unset_obj()
    #Py_DECREF(item)

cdef int _py_elm_slideshow_compare_func(const_void *data1, const_void *data2) with gil:
    cdef SlideshowItem item1    = <object>data1
    cdef SlideshowItem item2    = <object>data2
    cdef object func            = item1.compare_func

    if func is None:
        return 0

    ret = func(item1, item2)
    if ret is not None:
        try:
            return ret
        except:
            traceback.print_exc()
            return 0
    else:
        return 0

cdef class SlideshowItemClass (object):
    """

    Defines the behavior of each slideshow item.

    This class should be created and handled to the Slideshow itself.

    It may be subclassed, in this case the methods :py:func:`get()` and ``delete()``
    will be used.

    It may also be instantiated directly, given getters to override as
    constructor parameters.

    :param get_func: if provided will override the behavior
        defined by :py:func:`get()` in this class. Its purpose is
        to return the icon object to be used (swalloed) by a
        given part and row. This function should have the
        signature:
        ``func(obj, item_data) -> obj``

    :param del_func: if provided will override the behavior
        defined by ``delete()`` in this class. Its purpose is to be
        called when item is deleted, thus finalizing resources
        and similar. This function should have the signature:
        ``func(obj, item_data)``

    .. note:: In all these signatures, 'obj' means Slideshow and
        'item_data' is the value given to Slideshow item append/prepend
        methods, it should represent your item model as you want.

    """
    cdef Elm_Slideshow_Item_Class obj
    cdef readonly object _get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self.obj.func.get = _py_elm_slideshow_item_get
        self.obj.func.del_ = _py_elm_slideshow_item_del

    def __init__(self, get_func=None, del_func=None):
        if get_func and not callable(get_func):
            raise TypeError("get_func is not callable!")
        elif get_func:
            self._get_func = get_func
        else:
            self._get_func = self.get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Slideshow_Item_Class=%#x, "
                "get_func=%s, del_func=%s)>") % \
               (type(self).__name__,
                <uintptr_t><void *>self,
                PY_REFCOUNT(self),
                <uintptr_t>&self.obj,
                self._get_func,
                self._del_func)

    def get(self, evasObject obj, item_data):
        """To be called by Slideshow for each item to get its icon.

        :param obj: the Slideshow instance
        :param item_data: the value given to slideshow append/prepend.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

cdef class SlideshowItem(ObjectItem):

    """An item for Slideshow."""

    cdef:
        SlideshowItemClass cls
        object compare_func

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef void _unset_obj(self):
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL

    def __init__(self, SlideshowItemClass item_class not None, *args, **kwargs):
        self.cls = item_class
        self.args = args
        self.kwargs = kwargs

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, item_data=%r)>") % \
               (type(self).__name__,
                <uintptr_t><void*>self,
                PY_REFCOUNT(self),
                <uintptr_t>self.obj,
                type(self.cls).__name__,
                self.args)

    def add_to(self, Slideshow slideshow not None):
        """add_to(Slideshow slideshow) -> SlideshowItem

        Add (append) a new item in a given slideshow widget.

        Add a new item to ``obj's`` internal list of items, appending it.
        The item's class must contain the function really fetching the
        image object to show for this item, which could be an Evas image
        object or an Elementary photo, for example. The ``data``
        parameter is going to be passed to both class functions of the
        item.

        .. seealso::
            :py:class:`SlideshowItemClass`
            :py:meth:`sorted_insert`
            :py:attr:`~efl.elementary.object_item.ObjectItem.data`

        :param item_class: The item class for the item
        :type item_class: :py:class:`SlideshowItemClass`

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`SlideshowItem`

        """
        cdef Elm_Object_Item *item

        item = elm_slideshow_item_add(slideshow.obj, &self.cls.obj, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def sorted_insert(self, Slideshow slideshow not None, func not None):
        """sorted_insert(Slideshow slideshow, func) -> SlideshowItem

        Insert a new item into the given slideshow widget, using the ``func``
        function to sort items (by item handles).

        Add a new item to ``obj``'s internal list of items, in a position
        determined by the ``func`` comparing function. The item's class
        must contain the function really fetching the image object to
        show for this item, which could be an Evas image object or an
        Elementary photo, for example. The ``data`` parameter is going to
        be passed to both class functions of the item.

        The compare function compares data1 and data2. If data1 is 'less'
        than data2, -1 must be returned, if it is 'greater', 1 must be
        returned, and if they are equal, 0 must be returned.

        .. seealso::
            :py:class:`SlideshowItemClass`
            :py:meth:`add_to`

        :param itc: The item class for the item
        :param func: The comparing function to be used to sort slideshow
            items **by SlideshowItemClass item handles**
        :return: Returns The slideshow item handle, on success, or
            ``None``, on errors

        """
        cdef Elm_Object_Item *item
        cdef Eina_Compare_Cb compare

        if not callable(func):
            raise TypeError("func is not None or callable")

        self.compare_func = func
        compare = _py_elm_slideshow_compare_func

        item = elm_slideshow_item_sorted_insert(slideshow.obj, &self.cls.obj, \
            <void*>self, compare)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property object:
        """Get the real Evas object created to implement the view of a given
        slideshow item.

        This returns the actual Evas object used to implement the specified
        slideshow item's view. This may be ``None``, as it may not have been
        created or may have been deleted, at any time, by the slideshow.
        **Do not modify this object** (move, resize, show, hide, etc.), as
        the slideshow is controlling it. This function is for querying,
        emitting custom signals or hooking lower level callbacks for events
        on that object. Do not delete this object under any circumstances.

        .. seealso:: :py:attr:`~efl.elementary.object_item.ObjectItem.data`

        :type: :py:class:`Slideshow`

        """
        def __get__(self):
            return object_from_instance(elm_slideshow_item_object_get(self.item))

    def show(self):
        """show()

        Display a given slideshow widget's item, programmatically.

        The change between the current item and this item will use the
        transition the slideshow object is set to use.

        .. seealso:: :py:attr:`Slideshow.transition`

        """
        elm_slideshow_item_show(self.item)

cdef class Slideshow(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_slideshow_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def item_add(self, SlideshowItemClass item_class not None, *args, **kwargs):
        """item_add(SlideshowItemClass item_class, *args, **kwargs) -> SlideshowItem

        Add (append) a new item in a given slideshow widget.

        Add a new item to ``obj's`` internal list of items, appending it.
        The item's class must contain the function really fetching the
        image object to show for this item, which could be an Evas image
        object or an Elementary photo, for example. The ``data``
        parameter is going to be passed to both class functions of the
        item.

        .. seealso::
            :py:class:`SlideshowItemClass`
            :py:func:`item_sorted_insert()`
            :py:attr:`efl.elementary.object_item.ObjectItem.data`

        :param item_class: The item class for the item
        :type item_class: :py:class:`SlideshowItemClass`

        :return: A handle to the item added or ``None``, on errors
        :rtype: :py:class:`SlideshowItem`

        """
        return SlideshowItem(item_class, *args, **kwargs).add_to(self)

    def item_sorted_insert(self, SlideshowItemClass item_class not None,
                            func not None, *args, **kwargs):
        """item_sorted_insert(SlideshowItemClass item_class, func, *args, **kwargs) -> SlideshowItem

        Insert a new item into the given slideshow widget, using the ``func``
        function to sort items (by item handles).

        Add a new item to ``obj``'s internal list of items, in a position
        determined by the ``func`` comparing function. The item's class
        must contain the function really fetching the image object to
        show for this item, which could be an Evas image object or an
        Elementary photo, for example. The ``data`` parameter is going to
        be passed to both class functions of the item.

        The compare function compares data1 and data2. If data1 is 'less'
        than data2, -1 must be returned, if it is 'greater', 1 must be
        returned, and if they are equal, 0 must be returned.

        .. seealso::
            :py:class:`SlideshowItemClass`
            :py:func:`item_add()`

        :param itc: The item class for the item
        :param func: The comparing function to be used to sort slideshow
            items **by SlideshowItemClass item handles**
        :return: Returns The slideshow item handle, on success, or
            ``None``, on errors

        """
        return SlideshowItem(item_class, *args, **kwargs).sorted_insert(self, func)

    def next(self):
        """next()

        Slide to the **next** item, in a given slideshow widget

        The sliding animation the object is set to use will be the
        transition effect used, after this call is issued.

        .. note:: If the end of the slideshow's internal list of items is
            reached, it'll wrap around to the list's beginning, again.

        """
        elm_slideshow_next(self.obj)

    def previous(self):
        """previous()

        Slide to the **previous** item, in a given slideshow widget

        The sliding animation the object is set to use will be the
        transition effect used, after this call is issued.

        .. note:: If the beginning of the slideshow's internal list of items
            is reached, it'll wrap around to the list's end, again.

        """
        elm_slideshow_previous(self.obj)

    property transitions:
        """Returns the list of sliding transition/effect names available,
        for a given slideshow widget.

        The transitions, which come from the objects theme, must be an EDC
        data item named ``"transitions"`` on the theme file, with (prefix)
        names of EDC programs actually implementing them.

        The available transitions for slideshows on the default theme are:
            - ``"fade"`` - the current item fades out, while the new one
              fades in to the slideshow's viewport.
            - ``"black_fade"`` - the current item fades to black, and just
              then, the new item will fade in.
            - ``"horizontal"`` - the current item slides horizontally, until
              it gets out of the slideshow's viewport, while the new item
              comes from the left to take its place.
            - ``"vertical"`` - the current item slides vertically, until it
              gets out of the slideshow's viewport, while the new item comes
              from the bottom to take its place.
            - ``"square"`` - the new item starts to appear from the middle of
              the current one, but with a tiny size, growing until its
              target (full) size and covering the old one.

        .. seealso:: :py:attr:`transition`

        :type: tuple of strings

        """
        def __get__(self):
            return tuple(eina_list_strings_to_python_list(elm_slideshow_transitions_get(self.obj)))

    property transition:
        """The slide transition/effect in use for a given slideshow widget

        If ``transition`` is implemented in ``obj's`` theme (i.e., is
        contained in the list returned by :py:attr:`transitions`), this new sliding
        effect will be used on the widget.

        :type: string

        """
        def __set__(self, transition):
            if isinstance(transition, unicode): transition = PyUnicode_AsUTF8String(transition)
            elm_slideshow_transition_set(self.obj,
                <const_char *>transition if transition is not None else NULL)
        def __get__(self):
            return _ctouni(elm_slideshow_transition_get(self.obj))

    property timeout:
        """The interval between each image transition on a given
        slideshow widget, **and start the slideshow, itself**

        After setting this, the slideshow widget will start cycling its
        view, sequentially and automatically, with the images of the
        items it has. The time between each new image displayed is going
        to be ``timeout`` in **seconds**. If a different timeout was set
        previously and an slideshow was in progress, it will continue
        with the new time between transitions, after this call.

        .. note:: A value less than or equal to 0 on ``timeout`` will disable
            the widget's internal timer, thus halting any slideshow which
            could be happening on ``obj``.

        :type: float

        """
        def __set__(self, timeout):
            elm_slideshow_timeout_set(self.obj, timeout)
        def __get__(self):
            return elm_slideshow_timeout_get(self.obj)

    property loop:
        """If, after a slideshow is started, for a given slideshow
        widget, its items should be displayed cyclically or not.

        .. note:: The methods :py:func:`next()` and :py:func:`previous()`
            will **ignore** what is set by this property, i.e.,
            they'll **always** cycle through items. This affects only
            the "automatic" slideshow, as set by :py:attr:`timeout`.

        :type: bool

        """
        def __set__(self, loop):
            elm_slideshow_loop_set(self.obj, loop)
        def __get__(self):
            return bool(elm_slideshow_loop_get(self.obj))

    def clear(self):
        """clear()

        Remove all items from a given slideshow widget.

        This removes (and deletes) all items in the object, leaving it empty.

        .. seealso::

            :py:meth:`~efl.elementary.object_item.ObjectItem.delete`, to remove
            just one item.

        """
        elm_slideshow_clear(self.obj)

    property items:
        """Get the internal list of items in a given slideshow widget.

        This list is **not** to be modified in any way and must not be freed.
        Use the list members with functions like
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`,
        :py:attr:`~efl.elementary.object_item.ObjectItem.data`.

        .. warning::

            This list is only valid until ``obj`` object's internal items list
            is changed. It should be fetched again with another call to this
            function when changes happen.

        :type: tuple of :py:class:`SlideshowItem`

        """
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_slideshow_items_get(self.obj)))

    property current_item:
        """The currently displayed item, in a given slideshow widget

        :type: :py:class:`SlideshowItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_slideshow_item_current_get(self.obj))

    def nth_item_get(self, nth):
        """nth_item_get(int nth) -> SlideshowItem

        Get the the item, in a given slideshow widget, placed at position
        ``nth`` in its internal items list.

        :param nth: The number of the item to grab a handle to (0 being the
            first)
        :type nth: int

        :return: The item stored in ``obj`` at position ``nth`` or ``None``,
            if there's no item with that index (and on errors)
        :rtype: :py:class:`SlideshowItem`

        """
        return _object_item_to_python(elm_slideshow_item_nth_get(self.obj, nth))

    property layout:
        """The current slide layout in use for a given slideshow widget

        If ``layout`` is implemented in ``obj's`` theme (i.e., is contained
        in the list returned by elm_slideshow_layouts_get()), this new
        images layout will be used on the widget.

        :type: string

        """
        def __set__(self, layout):
            if isinstance(layout, unicode): layout = PyUnicode_AsUTF8String(layout)
            elm_slideshow_layout_set(self.obj,
                <const_char *>layout if layout is not None else NULL)
        def __get__(self):
            return _ctouni(elm_slideshow_layout_get(self.obj))

    property layouts:
        """Returns the list of **layout** names available, for a given
        slideshow widget.

        Slideshow layouts will change how the widget is to dispose each
        image item in its viewport, with regard to cropping, scaling,
        etc.

        The layouts, which come from the object theme, must be an EDC
        data item name ``"layouts"`` on the theme file, with (prefix)
        names of EDC programs actually implementing them.

        The available layouts for slideshows on the default theme are:
            - ``"fullscreen"`` - item images with original aspect, scaled to
              touch top and down slideshow borders or, if the image's height
              is not enough, left and right slideshow borders.
            - ``"not_fullscreen"`` - the same behavior as the ``"fullscreen"``
              one, but always leaving 10% of the slideshow's dimensions of
              distance between the item image's borders and the slideshow
              borders, for each axis.

        .. seealso:: :py:attr:`layout`

        :type: tuple of strings

        """
        def __get__(self):
            return tuple(eina_list_strings_to_python_list(elm_slideshow_layouts_get(self.obj)))

    property cache_before:
        """The number of items to cache, on a given slideshow widget,
        **before the current item**

        The default value for this property is ``2``.

        :type: int

        """
        def __set__(self, count):
            elm_slideshow_cache_before_set(self.obj, count)
        def __get__(self):
            return elm_slideshow_cache_before_get(self.obj)

    property cache_after:
        """The number of items to cache, on a given slideshow widget,
        **after the current item**

        The default value for this property is ``2``.

        :type: int

        """
        def __set__(self, count):
            elm_slideshow_cache_after_set(self.obj, count)
        def __get__(self):
            return elm_slideshow_cache_after_get(self.obj)

    property count:
        """Get the number of items stored in a given slideshow widget

        :type: int

        """
        def __get__(self):
            return elm_slideshow_count_get(self.obj)

    def callback_changed_add(self, func, *args, **kwargs):
        """When the slideshow switches its view to a new item. event_info
        parameter in callback contains the current visible item."""
        self._callback_add_full("changed", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del_full("changed", _cb_object_item_conv, func)

    def callback_transition_end_add(self, func, *args, **kwargs):
        """When a slide transition ends. event_info parameter in callback
        contains the current visible item."""
        self._callback_add_full("transition,end", _cb_object_item_conv,
                                func, *args, **kwargs)

    def callback_transition_end_del(self, func):
        self._callback_del_full("transition,end", _cb_object_item_conv, func)

    def callback_focused_add(self, func, *args, **kwargs):
        """When the slideshow has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """When the slideshow has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

_object_mapping_register("Elm_Slideshow", Slideshow)
