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

include "menu_cdef.pxi"

cdef class MenuItem(ObjectItem):
    """

    An item for the :class:`Menu` widget.

    """

    cdef:
        MenuItem parent
        bytes label, icon

    def __init__(self, MenuItem parent = None, label = None, icon = None,
        callback = None, cb_data = None, *args, **kargs):

        if callback is not None:
            if not callable(callback):
                raise TypeError("callback is not callable")

        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        self.parent = parent
        self.label = label
        self.icon = icon
        self.cb_func = callback
        self.cb_data = cb_data
        self.args = args
        self.kwargs = kargs

    def add_to(self, Menu menu not None):
        # TODO: document this
        cdef:
            Elm_Object_Item *item
            Elm_Object_Item *parent_obj = NULL
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _object_item_callback2

        item = elm_menu_item_add(menu.obj,
            self.parent.item if self.parent is not None else NULL,
            <const char *>self.icon if self.icon is not None else NULL,
            <const char *>self.label if self.label is not None else NULL,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property object:
        """Get the Evas_Object of an Elm_Object_Item

        .. warning:: Don't manipulate this object!

        :return: The edje object containing the swallowed content

        """
        def __get__(self):
            return object_from_instance(elm_menu_item_object_get(self.item))

    def object_get(self):
        return object_from_instance(elm_menu_item_object_get(self.item))

    property icon_name:
        """The standard icon name of a menu item

        Once this icon is set, any previously set icon will be deleted.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_menu_item_icon_name_get(self.item))

        def __set__(self, icon):
            if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
            elm_menu_item_icon_name_set(self.item,
                <const char *>icon if icon is not None else NULL)

    def icon_name_set(self, icon):
        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)
        elm_menu_item_icon_name_set(self.item,
            <const char *>icon if icon is not None else NULL)
    def icon_name_get(self):
        return _ctouni(elm_menu_item_icon_name_get(self.item))

    property selected:
        """The selected state of the item.

        :type: bool

        """
        def __get__(self):
            return elm_menu_item_selected_get(self.item)

        def __set__(self, selected):
            elm_menu_item_selected_set(self.item, selected)

    def selected_set(self, selected):
        elm_menu_item_selected_set(self.item, selected)
    def selected_get(self):
        return elm_menu_item_selected_get(self.item)

    property is_separator:
        """Returns whether the item is a separator.

        .. seealso:: :py:func:`Menu.item_separator_add()`

        :type: bool

        """
        def __get__(self):
            return False

    property subitems:
        """A list of item's subitems.

        :type: tuple of :py:class:`MenuItem`

        .. versionadded:: 1.8
            Calling del on this property clears the subitems

        """
        def __get__(self):
            return _object_item_list_to_python(elm_menu_item_subitems_get(self.item))

        def __del__(self):
            elm_menu_item_subitems_clear(self.item)

    def subitems_get(self):
        return _object_item_list_to_python(elm_menu_item_subitems_get(self.item))

    def subitems_clear(self):
        elm_menu_item_subitems_clear(self.item)

    property index:
        """Get the position of a menu item

        This function returns the index position of a menu item in a menu.
        For a sub-menu, this number is relative to the first item in the
        sub-menu.

        .. note:: Index values begin with 0

        :type: int

        """
        def __get__(self):
            return elm_menu_item_index_get(self.item)

    def index_get(self):
        return elm_menu_item_index_get(self.item)

    property next:
        """Get the next item in the menu.

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_menu_item_next_get(self.item))

    property prev:
        """Get the previous item in the menu.

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_menu_item_prev_get(self.item))

cdef class MenuSeparatorItem(ObjectItem):
    """

    A separator type menu item.

    """

    cdef MenuItem parent

    def __init__(self, MenuItem parent):
        self.parent = parent

    def add_to(self, Menu menu not None):
        # TODO: document this
        cdef Elm_Object_Item *item

        if self.cb_func is not None:
            cb = _object_item_callback

        item = elm_menu_item_separator_add(menu.obj,
            self.parent.item if self.parent is not None else NULL)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        return self

    property is_separator:
        """Returns whether the item is a separator.

        :type: bool

        """
        def __get__(self):
            return True

    def next_get(self):
        """Get the next item in the menu.

        :return: The item after it, or None
        :rtype: :py:class:`MenuItem`

        """
        return _object_item_to_python(elm_menu_item_next_get(self.item))

    property next:
        """Get the next item in the menu.

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_item_next_get(self.item))

    def prev_get(self):
        """Get the previous item in the menu.

        :return: The item before it, or None
        :rtype: :py:class:`MenuItem`

        """
        return _object_item_to_python(elm_menu_item_prev_get(self.item))

    property prev:
        """Get the previous item in the menu.

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_item_prev_get(self.item))

cdef class Menu(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Menu(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_menu_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property parent:
        """The parent for the given menu widget.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_menu_parent_get(self.obj))
        def __set__(self, evasObject parent):
            elm_menu_parent_set(self.obj, parent.obj)

    def parent_get(self):
        return object_from_instance(elm_menu_parent_get(self.obj))

    def move(self, x, y):
        """Move the menu to a new position

        Sets the top-left position of the menu to (``x``, ``y``).

        .. note:: ``x`` and ``y`` coordinates are relative to parent.

        :param x: The new position.
        :type x: Evas_Coord (int)
        :param y: The new position.
        :type y: Evas_Coord (int)

        """
        elm_menu_move(self.obj, x, y)

    def close(self):
        """Close a opened menu

        Hides the menu and all it's sub-menus.

        """
        elm_menu_close(self.obj)

    property items:
        """Returns a list of ``item``'s.

        :type: tuple of :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_menu_items_get(self.obj))

    def items_get(self):
        return _object_item_list_to_python(elm_menu_items_get(self.obj))

    def item_add(self, MenuItem parent = None, label = None,
        icon = None, callback = None, *args, **kwargs):
        """Add an item at the end of the given menu widget

        :param parent: The parent menu item (optional)
        :type parent: :py:class:`~efl.elementary.object.Object`
        :param string label: The label of the item.
        :param string icon: An icon display on the item. The icon will be destroyed
            by the menu.
        :param callback: Function called when the user select the item.
        :type callback: function

        :return: Returns the new item.
        :rtype: :py:class:`MenuItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            MenuItem ret = MenuItem.__new__(MenuItem)

        if callback is not None and callable(callback):
            cb = _object_item_callback

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        if isinstance(icon, unicode): icon = PyUnicode_AsUTF8String(icon)

        item = elm_menu_item_add(self.obj,
            parent.item if parent is not None else NULL,
            <const char *>icon if icon is not None else NULL,
            <const char *>label if label is not None else NULL,
            cb, <void*>ret)

        if item != NULL:
            ret._set_obj(item)
            ret.cb_func = callback
            ret.args = args
            ret.kwargs = kwargs
            return ret
        else:
            return None

    def item_separator_add(self, parent = None):
        """Add a separator item to menu under ``parent``.

        This item is a :py:class:`~efl.elementary.separator.Separator`.

        :param parent: The item to add the separator under
        :type parent: :py:class:`~efl.elementary.object.Object`
        :return: The created item or None on failure
        :rtype: :py:class:`MenuSeparatorItem`

        """
        return MenuSeparatorItem(parent).add_to(self)

    property selected_item:
        """The selected item in the menu

        .. seealso:: :py:attr:`MenuItem.selected`

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_menu_selected_item_get(self.obj))

    property last_item:
        """The last item in the menu

        :type: :py:class:`MenuItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_menu_last_item_get(self.obj))

    property first_item:
        """The first item in the menu

        :type: MenuItem

        """
        def __get__(self):
            return _object_item_to_python(elm_menu_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_menu_first_item_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        """The user clicked the empty space in the menu to dismiss."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """the user clicked the empty space in the menu to dismiss

        .. versionadded:: 1.8
        """
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)


_object_mapping_register("Elm_Menu", Menu)
