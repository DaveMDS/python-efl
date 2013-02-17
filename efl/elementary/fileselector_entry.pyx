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
#

"""

.. rubric:: Fileselector modes

.. data:: ELM_FILESELECTOR_LIST

    Layout as a list

.. data:: ELM_FILESELECTOR_GRID

    Layout as a grid

"""

include "widget_header.pxi"
include "callbacks.pxi"

from object cimport Object

cimport enums

ELM_FILESELECTOR_LIST = enums.ELM_FILESELECTOR_LIST
ELM_FILESELECTOR_GRID = enums.ELM_FILESELECTOR_GRID

cdef class FileselectorEntry(Object):

    """

    This is an entry made to be filled with or display a file
    system path string.

    Besides the entry itself, the widget has a :py:class:`FileselectorButton`
    on its side, which will raise an internal :py:class:`Fileselector`,
    when clicked, for path selection aided by file system navigation.

    This file selector may appear in an Elementary window or in an
    inner window. When a file is chosen from it, the (inner) window
    is closed and the selected file's path string is exposed both as
    a smart event and as the new text on the entry.

    This widget encapsulates operations on its internal file
    selector on its own API. There is less control over its file
    selector than that one would have instantiating one directly.

    Smart callbacks one can register to:

    - ``"changed"`` - The text within the entry was changed
    - ``"activated"`` - The entry has had editing finished and
      changes are to be "committed"
    - ``"press"`` - The entry has been clicked
    - ``"longpressed"`` - The entry has been clicked (and held) for a
      couple seconds
    - ``"clicked"`` - The entry has been clicked
    - ``"clicked,double"`` - The entry has been double clicked
    - ``"focused"`` - The entry has received focus
    - ``"unfocused"`` - The entry has lost focus
    - ``"selection,paste"`` - A paste action has occurred on the
      entry
    - ``"selection,copy"`` - A copy action has occurred on the entry
    - ``"selection,cut"`` - A cut action has occurred on the entry
    - ``"unpressed"`` - The file selector entry's button was released
      after being pressed.
    - ``"file,chosen"`` - The user has selected a path via the file
      selector entry's internal file selector, whose string
      comes as the ``event_info`` data.

    Default text parts of the fileselector_button widget that you can use for
    are:

    - "default" - Label of the fileselector_button

    Default content parts of the fileselector_entry widget that you can use for
    are:

    - "button icon" - Button icon of the fileselector_entry

    """

    cdef object _cbs

    def __init__(self, evasObject parent):
        self._set_obj(elm_fileselector_entry_add(parent.obj))


        self._cbs = {}

    property window_title:
        """The title for a given file selector entry widget's window

        This is the window's title, when the file selector pops
        out after a click on the entry's button. Those windows have the
        default (unlocalized) value of ``"Select a file"`` as titles.

        .. note:: It will only take any effect if the file selector
            entry widget is **not** under "inwin mode".

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_fileselector_entry_window_title_get(self.obj))

        def __set__(self, title):
            elm_fileselector_entry_window_title_set(self.obj, _cfruni(title))

    def window_title_set(self, title):
        elm_fileselector_entry_window_title_set(self.obj, _cfruni(title))
    def window_title_get(self):
        return _ctouni(elm_fileselector_entry_window_title_get(self.obj))

    property window_size:
        """The size of a given file selector entry widget's window,
        holding the file selector itself.

        .. note:: it will only take any effect if the file selector entry
            widget is **not** under "inwin mode". The default size for the
            window (when applicable) is 400x400 pixels.

        :type: tuple of Evas_Coords (int)

        """
        def __get__(self):
            cdef Evas_Coord w, h
            elm_fileselector_entry_window_size_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_fileselector_entry_window_size_set(self.obj, w, h)

    def window_size_set(self, width, height):
        elm_fileselector_entry_window_size_set(self.obj, width, height)
    def window_size_get(self):
        cdef Evas_Coord w, h
        elm_fileselector_entry_window_size_get(self.obj, &w, &h)
        return (w, h)

    property path:
        """The initial file system path and the entry's path string for
        a given file selector entry widget

        It must be a **directory** path, which will have the contents
        displayed initially in the file selector's view. The default initial
        path is the ``"HOME"`` environment variable's value.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_fileselector_entry_path_get(self.obj))

        def __set__(self, path):
            elm_fileselector_entry_path_set(self.obj, _cfruni(path))

    def path_set(self, path):
        elm_fileselector_entry_path_set(self.obj, _cfruni(path))
    def path_get(self):
        return _ctouni(elm_fileselector_entry_path_get(self.obj))

    property expandable:
        """Enable/disable a tree view in the given file selector entry
        widget's internal file selector

        This has the same effect as :py:attr:`Fileselector.expandable`,
        but now applied to a file selector entry's internal file
        selector.

        .. note:: There's no way to put a file selector entry's internal
            file selector in "grid mode", as one may do with "pure" file
            selectors.

        :type: bool

        """
        def __get__(self):
            return bool(elm_fileselector_entry_expandable_get(self.obj))

        def __set__(self, expand):
            elm_fileselector_entry_expandable_set(self.obj, expand)

    def expandable_set(self, expand):
        elm_fileselector_entry_expandable_set(self.obj, expand)
    def expandable_get(self):
        return bool(elm_fileselector_entry_expandable_get(self.obj))

    property folder_only:
        """Whether a given file selector entry widget's internal file
        selector is to display folders only or the directory contents,
        as well.

        This has the same effect as :py:attr:`Fileselector.folder_only`,
        but now applied to a file selector entry's internal file
        selector.

        :type: bool

        """
        def __get__(self):
            return bool(elm_fileselector_entry_folder_only_get(self.obj))

        def __set__(self, folder_only):
            elm_fileselector_entry_folder_only_set(self.obj, folder_only)

    def folder_only_set(self, folder_only):
        elm_fileselector_entry_folder_only_set(self.obj, folder_only)
    def folder_only_get(self):
        return bool(elm_fileselector_entry_folder_only_get(self.obj))

    property is_save:
        """Enable/disable the file name entry box where the user can type
        in a name for a file, in a given file selector entry widget's
        internal file selector.

        This has the same effect as :py:attr:`Fileselector.is_save`,
        but now applied to a file selector entry's internal file
        selector.

        :type: bool

        """
        def __get__(self):
            return bool(elm_fileselector_entry_is_save_get(self.obj))

        def __set__(self, is_save):
            elm_fileselector_entry_is_save_set(self.obj, is_save)

    def is_save_set(self, is_save):
        elm_fileselector_entry_is_save_set(self.obj, is_save)
    def is_save_get(self):
        return bool(elm_fileselector_entry_is_save_get(self.obj))

    property inwin_mode:
        """Whether a given file selector entry widget's internal file
        selector will raise an Elementary "inner window", instead of a
        dedicated Elementary window. By default, it won't.

        .. seealso:: :py:class:`InnerWindow` for more information on inner
            windows

        :type: bool

        """
        def __get__(self):
            return bool(elm_fileselector_entry_inwin_mode_get(self.obj))

        def __set__(self, inwin_mode):
            elm_fileselector_entry_inwin_mode_set(self.obj, inwin_mode)

    def inwin_mode_set(self, inwin_mode):
        elm_fileselector_entry_inwin_mode_set(self.obj, inwin_mode)
    def inwin_mode_get(self):
        return bool(elm_fileselector_entry_inwin_mode_get(self.obj))

    property selected:
        """The initial file system path for a given file selector entry
        widget

        It must be a **directory** path, which will have the contents
        displayed initially in the file selector's view. The default initial
        path is the ``"HOME"`` environment variable's value.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_fileselector_entry_selected_get(self.obj))

        def __set__(self, path):
            elm_fileselector_entry_selected_set(self.obj, _cfruni(path))

    def selected_set(self, path):
        elm_fileselector_entry_selected_set(self.obj, _cfruni(path))
    def selected_get(self):
        return _ctouni(elm_fileselector_entry_selected_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """The text within the entry was changed."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_activated_add(self, func, *args, **kwargs):
        """The entry has had editing finished and changes are to be committed."""
        self._callback_add("activated", func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del("activated", func)

    def callback_press_add(self, func, *args, **kwargs):
        """The entry has been clicked."""
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """The entry has been clicked (and held) for a couple seconds."""
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        """The entry has been clicked."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        """The entry has been double clicked."""
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """The entry has received focus."""
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """The entry has lost focus."""
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

    def callback_selection_paste_add(self, func, *args, **kwargs):
        """A paste action has occurred on the entry."""
        self._callback_add("selection,paste", func, *args, **kwargs)

    def callback_selection_paste_del(self, func):
        self._callback_del("selection,paste", func)

    def callback_selection_copy_add(self, func, *args, **kwargs):
        """A copy action has occurred on the entry."""
        self._callback_add("selection,copy", func, *args, **kwargs)

    def callback_selection_copy_del(self, func):
        self._callback_del("selection,copy", func)

    def callback_selection_cut_add(self, func, *args, **kwargs):
        """A cut action has occurred on the entry."""
        self._callback_add("selection,cut", func, *args, **kwargs)

    def callback_selection_cut_del(self, func):
        self._callback_del("selection,cut", func)

    def callback_unpressed_add(self, func, *args, **kwargs):
        """The file selector entry's button was released after being pressed."""
        self._callback_add("unpressed", func, *args, **kwargs)

    def callback_unpressed_del(self, func):
        self._callback_del("unpressed", func)

    def callback_file_chosen_add(self, func, *args, **kwargs):
        """The user has selected a path via the file selector entry's internal
        file selector, whose string comes as the ``event_info`` data.

        """
        self._callback_add_full("file,chosen", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_file_chosen_del(self, func):
        self._callback_del_full("file,chosen", _cb_string_conv, func)


_object_mapping_register("elm_fileselector_entry", FileselectorEntry)
