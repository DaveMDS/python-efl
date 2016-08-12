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
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

include "toolbar_cdef.pxi"

cdef void _toolbar_item_state_callback(void *data, Evas_Object *obj, void *event_info) with gil:
    cdef ToolbarItemState state = <object>data
    cdef ToolbarItem item = ToolbarItem.__new__(ToolbarItem)
    item.item = <Elm_Object_Item *>event_info
    (callback, a, ka) = state.params
    try:
        o = object_from_instance(obj)
        callback(o, item, *a, **ka)
    except Exception:
        traceback.print_exc()

    # The C item will be freed unless this is done
    item.item = NULL

cdef class ToolbarItemState(object):
    """

    A state for a :py:class:`ToolbarItem`.

    """

    cdef Elm_Toolbar_Item_State *state
    cdef object params

    def __init__(self, ToolbarItem it, icon = None, label = None,
        callback = None, *args, **kwargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _toolbar_item_state_callback

        self.params = (callback, args, kwargs)

        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.state = elm_toolbar_item_state_add(it.item,
            <const char *>icon if icon is not None else NULL,
            <const char *>label if label is not None else NULL,
            cb, <void*>self)
        if self.state == NULL:
            Py_DECREF(self)

        Py_INCREF(self)

    def delete(self):
        self.state = NULL
        Py_DECREF(self)


cdef class ToolbarItem(ObjectItem):
    """

    An item for the toolbar.

    """

    cdef:
        object label
        object icon
        Evas_Smart_Cb cb

    def __init__(self, icon = None, label = None, callback = None,
        cb_data = None, *args, **kwargs):
        """

        If a function is passed as argument, it will be called every time
        this item is selected, i.e., the user clicks over an unselected item.
        If such function isn't needed, just passing ``None`` as ``func`` is
        enough. The same should be done for ``data``.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`Toolbar.icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        :param icon: A string with icon name or the absolute path of an
            image file.
        :type icon: string
        :param label: The label of the item.
        :type label: string
        :param callback: The function to call when the item is clicked.
        :type callback: function

        """
        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.icon = icon
        self.label = label
        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kwargs

    def append_to(self, Toolbar toolbar):
        """Append item to the toolbar.

        A new item will be created and appended to the toolbar, i.e., will
        be set as **last** item.

        Items created with this method can be deleted with
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`

        :seealso: :py:attr:`ToolbarItem.icon`

        :param toolbar: The toolbar this item should be appended to
        :type toolbar: :py:class:`Toolbar`
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_toolbar_item_append(toolbar.obj,
            <const char *>self.icon if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, Toolbar toolbar):
        """Prepend item to the toolbar.

        A new item will be created and prepended to the toolbar, i.e., will
        be set as **first** item.

        Items created with this method can be deleted with
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`

        :param toolbar: The toolbar this item should be prepended to
        :type toolbar: :py:class:`Toolbar`
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        cdef Elm_Object_Item *item
        cdef Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_toolbar_item_prepend(toolbar.obj,
            <const char *>self.icon if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, ToolbarItem after):
        """Insert a new item into the toolbar object after item ``after``.

        A new item will be created and added to the toolbar. Its position in
        this toolbar will be just after item ``after``.

        Items created with this method can be deleted with
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`

        :param after: The toolbar item to insert after.
        :type after: :py:class:`ToolbarItem`
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Object *toolbar = elm_object_item_widget_get(after.item)
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_toolbar_item_insert_after(toolbar,
            after.item,
            <const char *>self.icon if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, ToolbarItem before):
        """Insert a new item into the toolbar object before item ``before``.

        A new item will be created and added to the toolbar. Its position in
        this toolbar will be just before item ``before``.

        Items created with this method can be deleted with
        :py:meth:`~efl.elementary.object_item.ObjectItem.delete`

        :param before: The toolbar item to insert before.
        :type before: :py:class:`ToolbarItem`
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Object *toolbar = elm_object_item_widget_get(before.item)
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_toolbar_item_insert_before(toolbar,
            before.item,
            <const char *>self.icon if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property next:
        """Get the item after ``item`` in toolbar.

        .. note:: If it is the last item, ``None`` will be returned.

        .. seealso:: :py:meth:`ToolbarItem.append_to`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    property prev:
        """Get the item before ``item`` in toolbar.

        .. note:: If it is the first item, ``None`` will be returned.

        .. seealso:: :py:func:`ToolbarItem.prepend_to`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    property priority:
        """The priority of a toolbar item.

        This is used only when the toolbar shrink mode is set to
        :attr:`ELM_TOOLBAR_SHRINK_MENU` or :attr:`ELM_TOOLBAR_SHRINK_HIDE`.
        When space is less than required, items with low priority will be
        removed from the toolbar and added to a dynamically-created menu, while
        items with higher priority will remain on the toolbar, with the same
        order they were added.

        :type: int

        """
        def __get__(self):
            return elm_toolbar_item_priority_get(self.item)

        def __set__(self, priority):
            elm_toolbar_item_priority_set(self.item, priority)

    def priority_set(self, priority):
        elm_toolbar_item_priority_set(self.item, priority)
    def priority_get(self):
        return elm_toolbar_item_priority_get(self.item)

    property selected:
        """The selected state of an item.

        This reflects the selected state of the given item. ``True`` for
        selected, ``False`` for not selected.

        If a new item is selected the previously selected will be unselected.
        Previously selected item can be get with function
        :py:attr:`Toolbar.selected_item`.

        Selected items will be highlighted.

        .. seealso:: :py:attr:`Toolbar.selected_item`

        :type: bool

        """
        def __set__(self, selected):
            elm_toolbar_item_selected_set(self.item, selected)

        def __get__(self):
            return elm_toolbar_item_selected_get(self.item)

    def selected_get(self):
        return elm_toolbar_item_selected_get(self.item)
    def selected_set(self, selected):
        elm_toolbar_item_selected_set(self.item, selected)

    property icon:
        """The icon associated with the item.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`Toolbar.icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        .. seealso:: :py:attr:`Toolbar.icon_order_lookup`

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_toolbar_item_icon_get(self.item))

        def __set__(self, ic):
            if isinstance(ic, unicode): ic = PyUnicode_AsUTF8String(ic)
            elm_toolbar_item_icon_set(self.item,
                <const char *>ic if ic is not None else NULL)

    def icon_set(self, ic):
        if isinstance(ic, unicode): ic = PyUnicode_AsUTF8String(ic)
        elm_toolbar_item_icon_set(self.item,
            <const char *>ic if ic is not None else NULL)
    def icon_get(self):
        return _ctouni(elm_toolbar_item_icon_get(self.item))

    property object:
        """Get the object of item.

        :type: :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_toolbar_item_object_get(self.item))

    def object_get(self):
        return object_from_instance(elm_toolbar_item_object_get(self.item))

    property icon_object:
        """Get the icon object of item.

        .. seealso::
            :py:attr:`icon`,
            :py:attr:`icon_file`, or
            :py:attr:`icon_memfile` for details.

        :type: :py:class:`~efl.elementary.icon.Icon`

        """
        def __get__(self):
            return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    def icon_object_get(self):
        return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    # TODO:
    # def icon_memfile_set(self, img, size, format, key):
    #     """Set the icon associated with item to an image in a binary buffer.

    #     .. note:: The icon image set by this function can be changed
    #         by :py:attr:`icon`.

    #     :param img: The binary data that will be used as an image
    #     :param size: The size of binary data ``img``
    #     :type size: int
    #     :param format: Optional format of ``img`` to pass to the image loader
    #     :type format: string
    #     :param key: Optional key of ``img`` to pass to the image loader (eg.
    #         if ``img`` is an edje file)
    #     :type key: string

    #     :return: (``True`` = success, ``False`` = error)
    #     :rtype: bool

    #     """
    #     return bool(elm_toolbar_item_icon_memfile_set(self.item, img, size, format, key))

    property icon_file:
        """Set the icon associated with item to an image in a binary buffer.

        .. note:: The icon image set by this function can be changed
            by :py:attr:`icon`.

        :type: string or tuple of strings

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                file_name, key = value
            else:
                file_name = value
                key = None
            self.icon_file_set(file_name, key)

    def icon_file_set(self, file_name, key):
        if isinstance(file_name, unicode): file_name = PyUnicode_AsUTF8String(file_name)
        if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
        if not elm_toolbar_item_icon_file_set(self.item,
            <const char *>file_name if file_name is not None else NULL,
            <const char *>key if key is not None else NULL):
                raise RuntimeError("Could not set icon_file.")

    property separator:
        """Whether item is a separator or not.

        Items aren't set as separator by default.

        If set as separator it will display separator theme, so won't display
        icons or label.

        :type: bool

        """
        def __set__(self, separator):
            elm_toolbar_item_separator_set(self.item, separator)

        def __get__(self):
            return elm_toolbar_item_separator_get(self.item)

    def separator_set(self, separator):
        elm_toolbar_item_separator_set(self.item, separator)
    def separator_get(self):
        return elm_toolbar_item_separator_get(self.item)

    property menu:
        """

        This property has two diffent functionalities. The object you get from
        it is the :py:class:`~efl.elementary.menu.Menu` object used by this
        toolbar item, and setting it to True or False controls whether this item
        is a menu or not.

        If item wasn't set as menu item, getting the value of this property
        sets it to be that.

        Once it is set to be a menu, it can be manipulated through
        :py:attr:`Toolbar.menu_parent` and the
        :py:class:`~efl.elementary.menu.Menu` functions and properties.

        So, items to be displayed in this item's menu should be added with
        :py:func:`efl.elementary.menu.Menu.item_add()`.

        The following code exemplifies the most basic usage::

            tb = Toolbar(win)
            item = tb.item_append("refresh", "Menu")
            item.menu = True
            tb.menu_parent = win
            menu = item.menu
            menu.item_add(None, "edit-cut", "Cut")
            menu_item = menu.item_add(None, "edit-copy", "Copy")

        :type: bool

        """
        def __get__(self):
            import efl.elementary.menu  # XXX: Hack for class not being known
            return object_from_instance(elm_toolbar_item_menu_get(self.item))

        def __set__(self, menu):
            elm_toolbar_item_menu_set(self.item, menu)

    def menu_set(self, menu):
        elm_toolbar_item_menu_set(self.item, menu)
    def menu_get(self):
        import efl.elementary.menu  # XXX: Hack for class not being known
        return object_from_instance(elm_toolbar_item_menu_get(self.item))


    def state_add(self, icon=None, label=None, func=None, *args, **kwargs):
        return ToolbarItemState(self, icon, label, func, *args, **kwargs)

    def state_del(self, ToolbarItemState state):
        if not elm_toolbar_item_state_del(self.item, state.state):
            raise RuntimeError("Could not delete state.")

    property state:
        """An item state."""
        def __set__(self, ToolbarItemState state):
            if not elm_toolbar_item_state_set(self.item, state.state):
                raise RuntimeError("Could not set state")

        def __del__(self):
            elm_toolbar_item_state_unset(self.item)

        def __get__(self):
            cdef ToolbarItemState ret = ToolbarItemState.__new__(ToolbarItemState)
            ret.state = elm_toolbar_item_state_get(self.item)
            return ret if ret.state != NULL else None

    def state_set(self, ToolbarItemState state):
        if not elm_toolbar_item_state_set(self.item, state.state):
            raise RuntimeError("Could not set state")

    def state_unset(self):
        elm_toolbar_item_state_unset(self.item)

    def state_get(self):
        cdef ToolbarItemState ret = ToolbarItemState.__new__(ToolbarItemState)
        ret.state = elm_toolbar_item_state_get(self.item)
        return ret if ret.state != NULL else None

    def state_next(self):
        cdef ToolbarItemState ret = ToolbarItemState.__new__(ToolbarItemState)
        ret.state = elm_toolbar_item_state_next(self.item)
        return ret if ret.state != NULL else None

    def state_prev(self):
        cdef ToolbarItemState ret = ToolbarItemState.__new__(ToolbarItemState)
        ret.state = elm_toolbar_item_state_prev(self.item)
        return ret if ret.state != NULL else None

    def show(self, Elm_Toolbar_Item_Scrollto_Type scrollto_type):
        """Show this item, when the toolbar can be scrolled.

        :see: :py:func:`bring_in`

        .. versionadded:: 1.8

        """
        elm_toolbar_item_show(self.item, scrollto_type)

    def bring_in(self, Elm_Toolbar_Item_Scrollto_Type scrollto_type):
        """Show this item with scroll animation, when the toolbar can be scrolled.

        :see: :py:func:`show`

        .. versionadded:: 1.8

        """
        elm_toolbar_item_bring_in(self.item, scrollto_type)


cdef class Toolbar(LayoutClass):
    """

    This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Toolbar(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_toolbar_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property icon_size:
        """The icon size, in pixels, to be used by toolbar items.

        .. note:: Default value is ``32``. It reads value from elm config.

        :type: int

        """
        def __set__(self, icon_size):
            elm_toolbar_icon_size_set(self.obj, icon_size)

        def __get__(self):
            return elm_toolbar_icon_size_get(self.obj)

    def icon_size_set(self, icon_size):
        elm_toolbar_icon_size_set(self.obj, icon_size)
    def icon_size_get(self):
        return elm_toolbar_icon_size_get(self.obj)

    property icon_order_lookup:
        """Icon lookup order, for toolbar items' icons.

        Icons added before calling this function will not be affected.
        The default lookup order is :attr:`ELM_ICON_LOOKUP_THEME_FDO`.

        :type: :ref:`Elm_Icon_Lookup_Order`

        """
        def __set__(self, order):
            elm_toolbar_icon_order_lookup_set(self.obj, order)

        def __get__(self):
            return elm_toolbar_icon_order_lookup_get(self.obj)

    def icon_order_lookup_set(self, order):
        elm_toolbar_icon_order_lookup_set(self.obj, order)
    def icon_order_lookup_get(self):
        return elm_toolbar_icon_order_lookup_get(self.obj)

    def item_append(self, icon, label, callback = None, *args, **kargs):
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            ToolbarItem ret = ToolbarItem.__new__(ToolbarItem)

        if callback is not None and callable(callback):
            cb = _object_item_callback

        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)

        item = elm_toolbar_item_append(self.obj,
            <const char *>icon if icon is not None else NULL,
            <const char *>label if label is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = callback
            ret.args = args
            ret.kwargs = kargs
            return ret
        else:
            return None

    #TODO: def item_prepend(self, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_before(self, before, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_after(self, after, icon, label, callback = None, *args, **kargs):
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    property first_item:
        """Get the first item in the given toolbar widget's list of items.

        .. seealso:: :py:func:`ToolbarItem.append_to` :py:attr:`last_item`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    property last_item:
        """Get the last item in the given toolbar widget's list of items.

        .. seealso:: :py:func:`ToolbarItem.prepend_to` :py:attr:`first_item`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    def item_find_by_label(self, label):
        """Returns a toolbar item by its label.

        :param label: The label of the item to find.
        :type label: string
        :return: The toolbar item matching ``label`` or ``None`` on failure.
        :rtype: :py:class:`ToolbarItem`

        """
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        return _object_item_to_python(elm_toolbar_item_find_by_label(self.obj,
            <const char *>label if label is not None else NULL))

    property selected_item:
        """The selected item.

        The selected item can be unselected with :py:attr:`ToolbarItem.selected`.

        The selected item always will be highlighted on toolbar.

        .. seealso:: :py:attr:`selected_items`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_toolbar_selected_item_get(self.obj))

    property more_item:
        """Get the more item.

        The more item can be changed with
        :py:attr:`~efl.elementary.object_item.ObjectItem.text` and
        :py:attr:`~efl.elementary.object_item.ObjectItem.content`.

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    def more_item_get(self):
        return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    property shrink_mode:
        """The shrink state of toolbar.

        The toolbar won't scroll if :attr:`ELM_TOOLBAR_SHRINK_NONE`, but will
        enforce a minimum size so all the items will fit, won't scroll and
        won't show the items that don't fit if :attr:`ELM_TOOLBAR_SHRINK_HIDE`,
        will scroll if :attr:`ELM_TOOLBAR_SHRINK_SCROLL`, and will create a
        button to pop up excess elements with :attr:`ELM_TOOLBAR_SHRINK_MENU`.

        :type: :ref:`Elm_Toolbar_Shrink_Mode`

        """
        def __get__(self):
            return elm_toolbar_shrink_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_shrink_mode_set(self.obj, mode)

    def shrink_mode_set(self, mode):
        elm_toolbar_shrink_mode_set(self.obj, mode)
    def shrink_mode_get(self):
        return elm_toolbar_shrink_mode_get(self.obj)

    property transverse_expanded:
        """Item's transverse expansion.

        :type: bool

        This will expand the transverse length of the item according the
        transverse length of the toolbar. The default is what the transverse
        length of the item is set according its min value (this property is
        False).

        .. versionadded:: 1.8

        """
        def __set__(self, bint transverse_expanded):
            elm_toolbar_transverse_expanded_set(self.obj, transverse_expanded)

        def __get__(self):
            return bool(elm_toolbar_transverse_expanded_get(self.obj))

    def transverse_expanded_set(self, bint transverse_expanded):
        elm_toolbar_transverse_expanded_set(self.obj, transverse_expanded)

    def transverse_expanded_get(self):
        return bool(elm_toolbar_transverse_expanded_get(self.obj))

    property homogeneous:
        """Homogeneous mode.

        This will enable the homogeneous mode where items are of the same size.

        :type: bool

        """
        def __set__(self, homogeneous):
            elm_toolbar_homogeneous_set(self.obj, homogeneous)

        def __get__(self):
            return elm_toolbar_homogeneous_get(self.obj)

    def homogeneous_set(self, homogeneous):
        elm_toolbar_homogeneous_set(self.obj, homogeneous)
    def homogeneous_get(self):
        return elm_toolbar_homogeneous_get(self.obj)

    property menu_parent:
        """The parent object of the toolbar items' menus.

        Each item can be set as item menu, with :py:attr:`ToolbarItem.menu`.

        For more details about setting the parent for toolbar menus, see
        :py:attr:`~efl.elementary.menu.Menu.parent`.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_toolbar_menu_parent_get(self.obj))

        def __set__(self, evasObject parent):
            elm_toolbar_menu_parent_set(self.obj, parent.obj)

    def menu_parent_set(self, evasObject parent):
        elm_toolbar_menu_parent_set(self.obj, parent.obj)
    def menu_parent_get(self):
        return object_from_instance(elm_toolbar_menu_parent_get(self.obj))

    property align:
        """The alignment of the items.

        Alignment of toolbar items, from ``0.0`` to indicates to align
        left, to ``1.0``, to align to right. ``0.5`` centralize
        items.

        Centered items by default.

        :type: float

        """
        def __set__(self, align):
            elm_toolbar_align_set(self.obj, align)

        def __get__(self):
            return elm_toolbar_align_get(self.obj)

    def align_set(self, align):
        elm_toolbar_align_set(self.obj, align)
    def align_get(self):
        return elm_toolbar_align_get(self.obj)

    property horizontal:
        """A toolbar's orientation

        By default, a toolbar will be horizontal. Change this property to
        create a vertical toolbar.

        :type: bool

        """
        def __set__(self, horizontal):
            elm_toolbar_horizontal_set(self.obj, horizontal)

        def __get__(self):
            return elm_toolbar_horizontal_get(self.obj)

    def horizontal_set(self, horizontal):
        elm_toolbar_horizontal_set(self.obj, horizontal)
    def horizontal_get(self):
        return elm_toolbar_horizontal_get(self.obj)

    def items_count(self):
        """Get the number of items in a toolbar

        :return: The number of items in toolbar
        :rtype: int

        """
        return elm_toolbar_items_count(self.obj)

    property standard_priority:
        """The standard priority of visible items in a toolbar

        If the priority of the item is up to standard priority, it is shown
        in basic panel. The other items are located in more menu or panel.
        The more menu or panel can be shown when the more item is clicked.

        :type: int

        """
        def __set__(self, priority):
            elm_toolbar_standard_priority_set(self.obj, priority)
        def __get__(self):
            return elm_toolbar_standard_priority_get(self.obj)

    property select_mode:
        """The toolbar select mode.

        :type: :ref:`Elm_Object_Select_Mode`

        """
        def __get__(self):
            return elm_toolbar_select_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_select_mode_set(self.obj, mode)

    def select_mode_set(self, mode):
        elm_toolbar_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_toolbar_select_mode_get(self.obj)

    property reorder_mode:
        """Reorder mode

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint reorder_mode):
            elm_toolbar_reorder_mode_set(self.obj, reorder_mode)

        def __get__(self):
            return bool(elm_toolbar_reorder_mode_get(self.obj))

    def reorder_mode_set(self, bint reorder_mode):
        elm_toolbar_reorder_mode_set(self.obj, reorder_mode)

    def reorder_mode_get(self):
        return bool(elm_toolbar_reorder_mode_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        """When the user clicks on a toolbar item and becomes selected."""
        self._callback_add_full("clicked", _cb_object_item_conv, func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del_full("clicked", _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """When the toolbar is pressed for a certain amount of time."""
        self._callback_add_full("longpressed", _cb_object_item_conv, func, args, kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)

    def callback_item_focused_add(self, func, *args, **kwargs):
        """When the toolbar item has received focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,focused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_focused_del(self, func):
        self._callback_del_full("item,focused", _cb_object_item_conv, func)

    def callback_item_unfocused_add(self, func, *args, **kwargs):
        """When the toolbar item has lost focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,unfocused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_unfocused_del(self, func):
        self._callback_del_full("item,unfocused", _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        """When the toolbar item is selected.

        .. versionadded:: 1.11

        """
        self._callback_add_full("selected", _cb_object_item_conv, func, args, kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        """When the toolbar item is unselected.

        .. versionadded:: 1.11

        """
        self._callback_add_full("unselected", _cb_object_item_conv, func, args, kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected", _cb_object_item_conv, func)

    property scroller_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.scroller_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scroller_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

_object_mapping_register("Elm_Toolbar", Toolbar)
