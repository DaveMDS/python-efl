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

.. image:: /images/fileselector-preview.png

Widget description
------------------

A file selector is a widget that allows a user to navigate through a
file system, reporting file selections back via its API.

It contains shortcut buttons for home directory (*~*) and to jump one
directory upwards (..), as well as cancel/ok buttons to confirm/cancel a
given selection. After either one of those two former actions, the file
selector will issue its ``"done"`` smart callback.

There's a text entry on it, too, showing the name of the current
selection. There's the possibility of making it editable, so it is
useful on file saving dialogs on applications, where one gives a file
name to save contents to, in a given directory in the system. This
custom file name will be reported on the ``"done"`` smart callback
(explained in sequence).

Finally, it has a view to display file system items into in two possible
forms:

- list
- grid

If Elementary is built with support of the Ethumb thumbnailing library,
the second form of view will display preview thumbnails of files which
it supports.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``activated`` - the user activated a file. This can happen by
    double-clicking or pressing Enter key. (**event_info** is a
    string with the activated file path)
- ``selected`` - the user has clicked on a file (when not in
    folders-only mode) or directory (when in folders-only mode)
- ``directory,open`` - the list has been populated with new
  content (*event_info* is the directory's path)
- ``done`` - the user has clicked on the "ok" or "cancel"
  buttons (*event_info* is the selection's path)

For text, elm_layout_text_set() will work here on:

- ``ok`` - OK button label if the ok button is set. (since 1.8)
- ``cancel`` - Cancel button label if the cancel button is set. (since 1.8)

Enumerations
------------

.. _Elm_Fileselector_Mode:

Fileselector modes
==================

.. data:: ELM_FILESELECTOR_LIST

    Layout as a list

.. data:: ELM_FILESELECTOR_GRID

    Layout as a grid

.. _Elm_Fileselector_Sort:

Fileselector sort method
========================

.. data:: ELM_FILESELECTOR_SORT_BY_FILENAME_ASC

    Sort by filename in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_FILENAME_DESC

    Sort by filename in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_TYPE_ASC

    Sort by file type in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_TYPE_DESC

    Sort by file type in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_SIZE_ASC

    Sort by file size in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_SIZE_DESC

    Sort by file size in descending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC

    Sort by file modification date in ascending order

    .. versionadded:: 1.9

.. data:: ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC

    Sort by file modification date in descending order

    .. versionadded:: 1.9

"""


from cpython cimport PyUnicode_AsUTF8String, Py_INCREF
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _ctouni, eina_list_strings_to_python_list
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

cimport enums

import traceback

ELM_FILESELECTOR_LIST = enums.ELM_FILESELECTOR_LIST
ELM_FILESELECTOR_GRID = enums.ELM_FILESELECTOR_GRID

ELM_FILESELECTOR_SORT_BY_FILENAME_ASC = enums.ELM_FILESELECTOR_SORT_BY_FILENAME_ASC
ELM_FILESELECTOR_SORT_BY_FILENAME_DESC = enums.ELM_FILESELECTOR_SORT_BY_FILENAME_DESC
ELM_FILESELECTOR_SORT_BY_TYPE_ASC = enums.ELM_FILESELECTOR_SORT_BY_TYPE_ASC
ELM_FILESELECTOR_SORT_BY_TYPE_DESC = enums.ELM_FILESELECTOR_SORT_BY_TYPE_DESC
ELM_FILESELECTOR_SORT_BY_SIZE_ASC = enums.ELM_FILESELECTOR_SORT_BY_SIZE_ASC
ELM_FILESELECTOR_SORT_BY_SIZE_DESC = enums.ELM_FILESELECTOR_SORT_BY_SIZE_DESC
ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC = enums.ELM_FILESELECTOR_SORT_BY_MODIFIED_ASC
ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC = enums.ELM_FILESELECTOR_SORT_BY_MODIFIED_DESC
ELM_FILESELECTOR_SORT_LAST = enums.ELM_FILESELECTOR_SORT_LAST

def _cb_string_conv(uintptr_t addr):
    cdef const_char *s = <const_char *>addr
    return _ctouni(s) if s is not NULL else None

cdef Eina_Bool py_elm_fileselector_custom_filter_cb(const_char *path, Eina_Bool is_dir, void *data) with gil:
    cb_func, cb_data = <object>data
    try:
        return cb_func(_ctouni(path), is_dir, cb_data)
    except:
        traceback.print_exc()
        return 0


cdef class Fileselector(LayoutClass):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_fileselector_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property is_save:
        """Enable/disable the file name entry box where the user can type
        in a name for a file, in a given file selector widget

        Having the entry editable is useful on file saving dialogs on
        applications, where one gives a file name to save contents to,
        in a given directory in the system. This custom file name will
        be reported on the ``"done"`` smart callback.

        :type: bool

        """
        def __get__(self):
            return elm_fileselector_is_save_get(self.obj)

        def __set__(self, is_save):
            elm_fileselector_is_save_set(self.obj, is_save)

    def is_save_set(self, is_save):
        elm_fileselector_is_save_set(self.obj, is_save)
    def is_save_get(self):
        return elm_fileselector_is_save_get(self.obj)

    property folder_only:
        """Enable/disable folder-only view for a given file selector widget

        If enabled, the widget's view will only display folder items,
        naturally.

        :type: bool

        """
        def __get__(self):
            return elm_fileselector_folder_only_get(self.obj)

        def __set__(self, folder_only):
            elm_fileselector_folder_only_set(self.obj, folder_only)

    def folder_only_set(self, folder_only):
        elm_fileselector_folder_only_set(self.obj, folder_only)
    def folder_only_get(self):
        return elm_fileselector_folder_only_get(self.obj)

    property buttons_ok_cancel:
        """Enable/disable the "ok" and "cancel" buttons on a given file
        selector widget

        .. note:: A file selector without those buttons will never emit the
            ``"done"`` smart event, and is only usable if one is just hooking
            to the other two events.

        :type: bool

        """
        def __get__(self):
            return elm_fileselector_buttons_ok_cancel_get(self.obj)

        def __set__(self, buttons):
            elm_fileselector_buttons_ok_cancel_set(self.obj, buttons)

    def buttons_ok_cancel_set(self, buttons):
        elm_fileselector_buttons_ok_cancel_set(self.obj, buttons)
    def buttons_ok_cancel_get(self):
        return elm_fileselector_buttons_ok_cancel_get(self.obj)

    property expandable:
        """Enable/disable a tree view in the given file selector widget,
        **if it's in** ``ELM_FILESELECTOR_LIST`` **mode**

        In a tree view, arrows are created on the sides of directories,
        allowing them to expand in place.

        .. note:: If it's in other mode, the changes made by this function
            will only be visible when one switches back to "list" mode.

        :type: bool

        """
        def __get__(self):
            return elm_fileselector_expandable_get(self.obj)

        def __set__(self, expand):
            elm_fileselector_expandable_set(self.obj, expand)

    def expandable_set(self, expand):
        elm_fileselector_expandable_set(self.obj, expand)
    def expandable_get(self):
        return elm_fileselector_expandable_get(self.obj)

    property path:
        """The **directory** that a given file selector widget will display
        contents from

        Setting this will change the **directory** displayed. It
        will also clear the text entry area on the object, which
        displays select files' names.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_fileselector_path_get(self.obj))

        def __set__(self, path):
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            elm_fileselector_path_set(self.obj,
                <const_char *>path if path is not None else NULL)

    def path_set(self, path):
        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        elm_fileselector_path_set(self.obj,
            <const_char *>path if path is not None else NULL)
    def path_get(self):
        return _ctouni(elm_fileselector_path_get(self.obj))

    property mode:
        """The mode in which a given file selector widget will display
        (layout) file system entries in its view

        .. note:: By using :py:attr:`expandable`, the user may
            trigger a tree view for that list.

        .. note:: If Elementary is built with support of the Ethumb
            thumbnailing library, the second form of view will display
            preview thumbnails of files which it supports. You must have
            elm_need_ethumb() called in your Elementary for thumbnailing to
            work, though.

        :seealso: :py:attr:`expandable`

        :type: :ref:`Elm_Fileselector_Mode`

        """
        def __get__(self):
            return elm_fileselector_mode_get(self.obj)

        def __set__(self, mode):
            elm_fileselector_mode_set(self.obj, mode)

    def mode_set(self, mode):
        elm_fileselector_mode_set(self.obj, mode)
    def mode_get(self):
        return elm_fileselector_mode_get(self.obj)

    property sort_method:
        """The way files are sorted in the fileselector.

        :type: :ref:`Elm_Fileselector_Sort`

        .. versionadded:: 1.9

        """
        def __get__(self):
            return elm_fileselector_sort_method_get(self.obj)

        def __set__(self, method):
            elm_fileselector_sort_method_set(self.obj, method)

    def sort_method_set(self, method):
        elm_fileselector_sort_method_set(self.obj, method)
    def sort_method_get(self):
        return elm_fileselector_sort_method_get(self.obj)

    property multi_select:
        """Multi-selection in the file selector widget.

        This enables (**True**) or disables (**False**) multi-selection in
        the list/grid of the file selector widget. This allows more than 1 item to
        be selected. To retrieve the list of selected paths, use
        :py:attr:`selected_paths`.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint multi):
            elm_fileselector_multi_select_set(self.obj, multi)

        def __get__(self):
            return bool(elm_fileselector_multi_select_get(self.obj))

    def multi_select_set(self, multi):
        elm_fileselector_multi_select_set(self.obj, multi)
    def multi_select_get(self):
        return bool(elm_fileselector_multi_select_get(self.obj))

    property selected:
        """The currently selected file/directory in the given file selector
        widget.

        :type: string
        :raise RuntimeError: when setting the selected file path fails

        """
        def __get__(self):
            return _ctouni(elm_fileselector_selected_get(self.obj))

        def __set__(self, path):
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            if not elm_fileselector_selected_set(self.obj,
                <const_char *>path if path is not None else NULL):
                    raise RuntimeError("Setting the selected path failed")

    def selected_set(self, path):
        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        if not elm_fileselector_selected_set(self.obj,
            <const_char *>path if path is not None else NULL):
                raise RuntimeError("Setting the selected path failed")
    def selected_get(self):
        return _ctouni(elm_fileselector_selected_get(self.obj))

    property selected_paths:
        """A list of selected paths in the file selector.

        It returns a list of the selected paths. This list is only valid
        so long as the selection doesn't change (no items are selected or
        unselected, or unselected implicitly by deletion). The list contains
        strings. The order of the items in this list is the order which
        they were selected, i.e. the first item in this list is the first item
        that was selected, and so on.

        .. note:: If not in multi-select mode, consider using
            :py:attr:`selected` instead.

        .. seealso::
            :py:attr:`multi_select`
            :py:attr:`selected`

        .. versionadded:: 1.8

        """
        def __get__(self):
            return eina_list_strings_to_python_list(
                elm_fileselector_selected_paths_get(self.obj))

    def mime_types_filter_append(self, list mime_types, filter_name=None):
        """mime_types_filter_append(list mime_types, str filter_name=None)

        Append mime types filter into filter list

        :param mime_types: mime types to be allowed.
        :type mime_types: list
        :param filter_name: The name to be displayed, ``mime_types`` will be displayed if None
        :type filter_name: string
        :raise RuntimeWarning: if setting mime_types failed

        .. note:: a sub type of mime can be asterisk(*)
        .. note:: mime type filter is only working with efreet now.
        .. note:: first added filter will be the default filter at the moment.

        :seealso: :py:func:`~efl.elementary.need.need_efreet`
        :seealso: :py:meth:`custom_filter_append`
        :seealso: :py:meth:`filters_clear`

        .. versionadded:: 1.8

        """
        mime_types_s = ",".join(mime_types)
        if isinstance(mime_types_s, unicode): mime_types_s = PyUnicode_AsUTF8String(mime_types_s)
        if isinstance(filter_name, unicode): filter_name = PyUnicode_AsUTF8String(filter_name)
        if not elm_fileselector_mime_types_filter_append(self.obj, mime_types_s,
            <const_char *>filter_name if filter_name is not None else NULL):
            raise RuntimeWarning

    def custom_filter_append(self, func, data=None, filter_name=None):
        """custom_filter_append(func, data=None, filter_name=None)

        Append custom filter into filter list.

        :param func: The function to call when manipulating files and directories.
        :type func: callable
        :param data: The data to be passed to the function.
        :param filter_name: The name to be displayed, "custom" will be displayed if None
        :type filter_name: string

        .. note:: filter  function signature is: func(path, is_dir, data)
        .. note:: first added filter will be the default filter at the moment.

        :seealso: :py:meth:`mime_types_filter_append`
        :seealso: :py:meth:`filters_clear`

        .. versionadded:: 1.9

        """
        cb_data = (func, data)
        # TODO: This is now a ref leak. It should be stored somewhere and
        #       deleted in the remove method.
        Py_INCREF(cb_data)

        if isinstance(filter_name, unicode): filter_name = PyUnicode_AsUTF8String(filter_name)
        elm_fileselector_custom_filter_append(self.obj,
            py_elm_fileselector_custom_filter_cb, <void *>cb_data,
            <const_char *>filter_name if filter_name is not None else NULL)

    def filters_clear(self):
        """

        Clear all filters registered

        .. note::

            If filter list is empty, file selector assume that all
            files are matched.

        :seealso: :py:meth:`mime_types_filter_append`

        .. versionadded:: 1.8

        """
        elm_fileselector_filters_clear(self.obj)

    property hidden_visible:
        """Visibility of hidden files/directories in the file selector widget.

        This enables (**True**) or disables (**False**) visibility of hidden
        files/directories in the list/grid of the file selector widget.

        Default is disabled.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint visible):
            elm_fileselector_hidden_visible_set(self.obj, visible)

        def __get__(self):
            return bool(elm_fileselector_hidden_visible_get(self.obj))

    def hidden_visible_set(self, bint visible):
        elm_fileselector_hidden_visible_set(self.obj, visible)
    def hidden_visible_get(self):
        return bool(elm_fileselector_hidden_visible_get(self.obj))

    property thumbnail_size:
        """ The size (in pixels) for the thumbnail images.

        :type: tuple (w, h)

        .. versionadded:: 1.9

        """
        def __set__(self, size):
            elm_fileselector_thumbnail_size_set(self.obj, size[0], size[1])

        def __get__(self):
            cdef Evas_Coord w, h
            elm_fileselector_thumbnail_size_get(self.obj, &w, &h)
            return (w, h)

    def thumbnail_size_set(self, w, h):
        elm_fileselector_thumbnail_size_set(self.obj, w, h)
    def thumbnail_size_get(self):
        cdef Evas_Coord w, h
        elm_fileselector_thumbnail_size_get(self.obj, &w, &h)
        return (w, h)

    def callback_activated_add(self, func, *args, **kwargs):
        """the user activated a file. This can happen by
        double-clicking or pressing Enter key. (**event_info** is a
        string with the activated file path)."""
        self._callback_add_full("activated", _cb_string_conv, func,
            *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated", _cb_string_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        """The user has clicked on a file (when not in folders-only mode) or
        directory (when in folders-only mode). Parameter ``event_info``
        contains the selected file or directory."""
        self._callback_add_full("selected", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_string_conv, func)

    #
    # FIXME: This seems to be a thing that the application should handle
    #
    #def callback_selected_invalid_add(self, func, *args, **kwargs):
        #"""The user has tried to access a path which does not exist."""
        #self._callback_add("selected,invalid", func, *args, **kwargs)

    #def callback_selected_invalid_del(self, func):
        #self._callback_del("selected,invalid", func)

    def callback_directory_open_add(self, func, *args, **kwargs):
        """The list has been populated with new content (*event_info* is
        the directory's path)."""
        self._callback_add_full("directory,open", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_directory_open_del(self, func):
        self._callback_del_full("directory,open", _cb_string_conv, func)

    def callback_done_add(self, func, *args, **kwargs):
        """The user has clicked on the "ok" or "cancel" buttons
        (*event_info* is a string with the selection's path)."""
        self._callback_add_full("done", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_done_del(self, func):
        self._callback_del_full("done", _cb_string_conv, func)


_object_mapping_register("Elm_Fileselector", Fileselector)
