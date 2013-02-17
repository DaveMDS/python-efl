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
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

"""

.. rubric:: Icon lookup modes

.. data:: ELM_ICON_LOOKUP_FDO_THEME

    freedesktop, theme

.. data:: ELM_ICON_LOOKUP_THEME_FDO

    theme, freedesktop

.. data:: ELM_ICON_LOOKUP_FDO

    freedesktop

.. data:: ELM_ICON_LOOKUP_THEME

    theme


.. rubric:: Selection modes

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Default select mode

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    Always select mode

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    No select mode

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


.. rubric:: Toolbar shrink modes

.. data:: ELM_TOOLBAR_SHRINK_NONE

    Set toolbar minimum size to fit all the items

.. data:: ELM_TOOLBAR_SHRINK_HIDE

    Hide exceeding items

.. data:: ELM_TOOLBAR_SHRINK_SCROLL

    Allow accessing exceeding items through a scroller

.. data:: ELM_TOOLBAR_SHRINK_MENU

    Inserts a button to pop up a menu with exceeding items

.. data:: ELM_TOOLBAR_SHRINK_EXPAND

    Expand all items according the size of the toolbar.

"""

include "widget_header.pxi"

from object cimport Object
from object_item cimport    _object_item_callback, \
                            _object_item_to_python
from menu cimport Menu

cimport enums

ELM_ICON_LOOKUP_FDO_THEME = enums.ELM_ICON_LOOKUP_FDO_THEME
ELM_ICON_LOOKUP_THEME_FDO = enums.ELM_ICON_LOOKUP_THEME_FDO
ELM_ICON_LOOKUP_FDO = enums.ELM_ICON_LOOKUP_FDO
ELM_ICON_LOOKUP_THEME = enums.ELM_ICON_LOOKUP_THEME

ELM_OBJECT_SELECT_MODE_DEFAULT = enums.ELM_OBJECT_SELECT_MODE_DEFAULT
ELM_OBJECT_SELECT_MODE_ALWAYS = enums.ELM_OBJECT_SELECT_MODE_ALWAYS
ELM_OBJECT_SELECT_MODE_NONE = enums.ELM_OBJECT_SELECT_MODE_NONE
ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY = enums.ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY
ELM_OBJECT_SELECT_MODE_MAX = enums.ELM_OBJECT_SELECT_MODE_MAX

ELM_TOOLBAR_SHRINK_NONE = enums.ELM_TOOLBAR_SHRINK_NONE
ELM_TOOLBAR_SHRINK_HIDE = enums.ELM_TOOLBAR_SHRINK_HIDE
ELM_TOOLBAR_SHRINK_SCROLL = enums.ELM_TOOLBAR_SHRINK_SCROLL
ELM_TOOLBAR_SHRINK_MENU = enums.ELM_TOOLBAR_SHRINK_MENU
ELM_TOOLBAR_SHRINK_EXPAND = enums.ELM_TOOLBAR_SHRINK_EXPAND
ELM_TOOLBAR_SHRINK_LAST = enums.ELM_TOOLBAR_SHRINK_LAST

cdef class ToolbarItemState(object):

    """A state for a :py:class:`ToolbarItem`."""

    cdef Elm_Toolbar_Item_State *obj
    cdef object params

    def __init__(self, ToolbarItem it, icon = None, label = None, callback = None, *args, **kwargs):
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kwargs)

        self.obj = elm_toolbar_item_state_add(it.item, _cfruni(icon), _cfruni(label), cb, <void*>self)
        if self.obj == NULL:
            Py_DECREF(self)

cdef class ToolbarItem(ObjectItem):

    """

    An item for the toolbar.

    """

    def __init__(self, evasObject toolbar, icon, label,
                 callback, *args, **kargs):
        cdef Evas_Object *ic = NULL
        cdef Evas_Smart_Cb cb = NULL

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _object_item_callback

        self.params = (callback, args, kargs)

        item = elm_toolbar_item_append(toolbar.obj, _cfruni(icon), _cfruni(label), cb, <void*>self)

        if item != NULL:
            self._set_obj(item)
        else:
            Py_DECREF(self)

    property next:
        """Get the item after ``item`` in toolbar.

        .. note:: If it is the last item, ``None`` will be returned.

        .. seealso:: :py:func:`Toolbar.item_append()`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_toolbar_item_next_get(self.item))

    property prev:
        """Get the item before ``item`` in toolbar.

        .. note:: If it is the first item, ``None`` will be returned.

        .. seealso:: :py:func:`Toolbar.item_prepend()`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_toolbar_item_prev_get(self.item))

    property priority:
        """The priority of a toolbar item.

        This is used only when the toolbar shrink mode is set to
        ELM_TOOLBAR_SHRINK_MENU or ELM_TOOLBAR_SHRINK_HIDE. When space is
        less than required, items with low priority will be removed from the
        toolbar and added to a dynamically-created menu, while items with
        higher priority will remain on the toolbar, with the same order they
        were added.

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

        .. seealso:: :py:attr:`Toolbar.selected_item_get()`

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
            elm_toolbar_item_icon_set(self.item, _cfruni(ic))

    def icon_set(self, ic):
        elm_toolbar_item_icon_set(self.item, _cfruni(ic))
    def icon_get(self):
        return _ctouni(elm_toolbar_item_icon_get(self.item))

    property object:
        """Get the object of item.

        :type: :py:class:`Object`

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

        :type: :py:class:`Icon`

        """
        def __get__(self):
            return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    def icon_object_get(self):
        return object_from_instance(elm_toolbar_item_icon_object_get(self.item))

    def icon_memfile_set(self, img, size, format, key):
        """Set the icon associated with item to an image in a binary buffer.

        .. note:: The icon image set by this function can be changed
            by :py:attr:`icon`.

        :param img: The binary data that will be used as an image
        :param size: The size of binary data ``img``
        :type size: int
        :param format: Optional format of ``img`` to pass to the image loader
        :type format: string
        :param key: Optional key of ``img`` to pass to the image loader (eg.
            if ``img`` is an edje file)
        :type key: string

        :return: (``True`` = success, ``False`` = error)
        :rtype: bool

        """
        return False
        #TODO: return bool(elm_toolbar_item_icon_memfile_set(self.item, img, size, format, key))

    property icon_file:
        """Set the icon associated with item to an image in a binary buffer.

        .. note:: The icon image set by this function can be changed
            by :py:attr:`icon`.

        :type: string or tuple of strings

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                file, key = value
            else:
                file = value
                key = None
            # TODO: check return status
            elm_toolbar_item_icon_file_set(self.item, _cfruni(file), _cfruni(key))

    def icon_file_set(self, file, key):
        return bool(elm_toolbar_item_icon_file_set(self.item, _cfruni(file), _cfruni(key)))

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
        """This property has two diffent functionalities. The object you get
        from it is the :py:class:`Menu` object used by this toolbar item,
        and setting it to True or False controls whether this item is a menu
        or not.

        If item wasn't set as menu item, getting the value of this property
        sets it to be that.

        Once it is set to be a menu, it can be manipulated through
        :py:attr:`Toolbar.menu_parent` and the :py:class:`Menu` functions
        and properties.

        So, items to be displayed in this item's menu should be added with
        :py:func:`Menu.item_add()`.

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
            cdef Evas_Object *menu
            menu = elm_toolbar_item_menu_get(self.item)
            if menu == NULL:
                return None
            else:
                return Menu(None, <object>menu)

        def __set__(self, menu):
            elm_toolbar_item_menu_set(self.item, menu)

    def menu_set(self, menu):
        elm_toolbar_item_menu_set(self.item, menu)
    def menu_get(self):
        cdef Evas_Object *menu
        menu = elm_toolbar_item_menu_get(self.item)
        if menu == NULL:
            return None
        else:
            return Menu(None, <object>menu)


    #TODO def state_add(self, icon, label, func, data):
        #return elm_toolbar_item_state_add(self.item, icon, label, func, data)

    #TODO def state_del(self, state):
        #return bool(elm_toolbar_item_state_del(self.item, state))

    #TODO def state_set(self, state):
        #return bool(elm_toolbar_item_state_set(self.item, state))

    #TODO def state_unset(self):
        #elm_toolbar_item_state_unset(self.item)

    #TODO def state_get(self):
        #return elm_toolbar_item_state_get(self.item)

    #TODO def state_next(self):
        #return elm_toolbar_item_state_next(self.item)

    #TODO def state_prev(self):
        #return elm_toolbar_item_state_prev(self.item)

cdef class Toolbar(Object):

    """

    A toolbar is a widget that displays a list of items inside a box. It
    can be scrollable, show a menu with items that don't fit to toolbar size
    or even crop them.

    Only one item can be selected at a time.

    Items can have multiple states, or show menus when selected by the user.

    Smart callbacks one can listen to:

    - "clicked" - when the user clicks on a toolbar item and becomes selected.
    - "longpressed" - when the toolbar is pressed for a certain amount of time.
    - "language,changed" - when the program language changes.

    Available styles for it:

    - ``"default"``
    - ``"transparent"`` - no background or shadow, just show the content

    Default text parts of the toolbar items that you can use for are:

    - "default" - label of the toolbar item

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_toolbar_add(parent.obj))

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
        The default lookup order is ELM_ICON_LOOKUP_THEME_FDO.

        :type: Elm_Icon_Lookup_Order

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
        """item_append(unicode icon, unicode label, callback = None, *args, **kargs) -> ToolbarItem

        Append item to the toolbar.

        A new item will be created and appended to the toolbar, i.e., will
        be set as **last** item.

        Items created with this method can be deleted with
        :py:func:`ObjectItem.delete()`.

        If a function is passed as argument, it will be called every time
        this item is selected, i.e., the user clicks over an unselected item.
        If such function isn't needed, just passing ``None`` as ``func`` is
        enough. The same should be done for ``data``.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        .. seealso:: :py:attr:`ToolbarItem.icon` :py:func:`ObjectItem.delete()`

        :param icon: A string with icon name or the absolute path of an
            image file.
        :type icon: string
        :param label: The label of the item.
        :type label: string
        :param callback: The function to call when the item is clicked.
        :type callback: function

        :return: The created item or ``None`` upon failure.
        :rtype: ToolbarItem

        """
        # Everything is done in the ToolbarItem class, because of wrapping the
        # C structures in python classes
        return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_prepend(self, icon, label, callback = None, *args, **kargs):
        """Prepend item to the toolbar.

        A new item will be created and prepended to the toolbar, i.e., will
        be set as **first** item.

        Items created with this method can be deleted with
        :py:func:`ObjectItem.delete()`.

        If a function is passed as argument, it will be called every time
        this item is selected, i.e., the user clicks over an unselected item.
        If such function isn't needed, just passing ``None`` as ``func`` is
        enough. The same should be done for ``data``.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        .. seealso:: :py:attr:`ToolbarItem.icon` :py:func:`ObjectItem.delete()`

        :param icon: A string with icon name or the absolute path of an
            image file.
        :type icon: string
        :param label: The label of the item.
        :type label: string
        :param func: The function to call when the item is clicked.
        :type func: function
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_before(self, before, icon, label, callback = None, *args, **kargs):
        """Insert a new item into the toolbar object before item ``before``.

        A new item will be created and added to the toolbar. Its position in
        this toolbar will be just before item ``before``.

        Items created with this method can be deleted with
        :py:func:`ObjectItem.delete()`.

        If a function is passed as argument, it will be called every time
        this item is selected, i.e., the user clicks over an unselected item.
        If such function isn't needed, just passing ``None`` as ``func`` is
        enough. The same should be done for ``data``.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        .. seealso:: :py:attr:`ToolbarItem.icon` :py:func:`ObjectItem.delete()`

        :param before: The toolbar item to insert before.
        :type before: :py:class:`ToolbarItem`
        :param icon: A string with icon name or the absolute path of an image file.
        :type icon: string
        :param label: The label of the item.
        :type label: string
        :param func: The function to call when the item is clicked.
        :type func: function
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    #TODO: def item_insert_after(self, after, icon, label, callback = None, *args, **kargs):
        """Insert a new item into the toolbar object after item ``after``.

        A new item will be created and added to the toolbar. Its position in
        this toolbar will be just after item ``after``.

        Items created with this method can be deleted with
        :py:func:`ObjectItem.delete()`.

        If a function is passed as argument, it will be called every time
        this item is selected, i.e., the user clicks over an unselected item.
        If such function isn't needed, just passing ``None`` as ``func`` is
        enough. The same should be done for ``data``.

        Toolbar will load icon image from fdo or current theme. This
        behavior can be set by :py:attr:`icon_order_lookup` function.
        If an absolute path is provided it will load it direct from a file.

        .. seealso:: :py:attr:`ToolbarItem.icon` :py:func:`ObjectItem.delete()`

        :param after: The toolbar item to insert after.
        :type after: :py:class:`ToolbarItem`
        :param icon: A string with icon name or the absolute path of an image file.
        :type icon: string
        :param label: The label of the item.
        :type label: string
        :param func: The function to call when the item is clicked.
        :type func: function
        :return: The created item or ``None`` upon failure.
        :rtype: :py:class:`ToolbarItem`

        """
        #return ToolbarItem(self, icon, label, callback, *args, **kargs)

    property first_item:
        """Get the first item in the given toolbar widget's list of items.

        .. seealso:: :py:func:`item_append()` :py:attr:`last_item`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_toolbar_first_item_get(self.obj))

    property last_item:
        """Get the last item in the given toolbar widget's list of items.

        .. seealso:: :py:func:`item_prepend()` :py:attr:`first_item`

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_toolbar_last_item_get(self.obj))

    def item_find_by_label(self, label):
        """item_find_by_label(unicode label) -> ToolbarItem

        Returns a toolbar item by its label.

        :param label: The label of the item to find.
        :type label: string
        :return: The toolbar item matching ``label`` or ``None`` on failure.
        :rtype: :py:class:`ToolbarItem`

        """
        return _object_item_to_python(elm_toolbar_item_find_by_label(self.obj, _cfruni(label)))

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

        The more item can be changed with function
        :py:attr:`ObjectItem.text` and :py:attr:`ObjectItem.content`.

        :type: :py:class:`ToolbarItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    def more_item_get(self):
        return _object_item_to_python(elm_toolbar_more_item_get(self.obj))

    property shrink_mode:
        """The shrink state of toolbar.

        The toolbar won't scroll if ELM_TOOLBAR_SHRINK_NONE, but will
        enforce a minimum size so all the items will fit, won't scroll and
        won't show the items that don't fit if ELM_TOOLBAR_SHRINK_HIDE, will
        scroll if ELM_TOOLBAR_SHRINK_SCROLL, and will create a button to pop
        up excess elements with ELM_TOOLBAR_SHRINK_MENU.

        :type: Elm_Toolbar_Shrink_Mode

        """
        def __get__(self):
            return elm_toolbar_shrink_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_shrink_mode_set(self.obj, mode)

    def shrink_mode_set(self, mode):
        elm_toolbar_shrink_mode_set(self.obj, mode)
    def shrink_mode_get(self):
        return elm_toolbar_shrink_mode_get(self.obj)

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
        :py:attr:`Menu.parent`.

        .. seealso::
            :py:attr:`Menu.parent` and
            :py:attr:`ToolbarItem.menu` for details.

        :type: :py:class:`Object`

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
        """items_count()

        Get the number of items in a toolbar

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

        The possible modes are:

        - ELM_OBJECT_SELECT_MODE_DEFAULT : Items will only call their
          selection func and callback when first becoming selected. Any
          further clicks will do nothing, unless you set always select
          mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS :  This means that, even if
          selected, every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability
          to select items entirely and they will neither appear selected
          nor call selected callback functions.

        :type: Elm_Object_Select_Mode

        """
        def __get__(self):
            return elm_toolbar_select_mode_get(self.obj)

        def __set__(self, mode):
            elm_toolbar_select_mode_set(self.obj, mode)

    def select_mode_set(self, mode):
        elm_toolbar_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_toolbar_select_mode_get(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        """When the user clicks on a toolbar item and becomes selected."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """When the toolbar is pressed for a certain amount of time."""
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """When the program language changes."""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)


_object_mapping_register("elm_toolbar", Toolbar)
