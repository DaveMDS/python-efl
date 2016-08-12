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
#

include "fileselector_entry_cdef.pxi"

cdef class FileselectorEntry(LayoutClass):
    """

    This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """FileselectorEntry(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_fileselector_entry_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

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
            if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
            elm_fileselector_entry_window_title_set(self.obj,
                <const char *>title if title is not None else NULL)

    def window_title_set(self, title):
        if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
        elm_fileselector_entry_window_title_set(self.obj,
            <const char *>title if title is not None else NULL)
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

    property inwin_mode:
        """Whether a given file selector entry widget's internal file
        selector will raise an Elementary "inner window", instead of a
        dedicated Elementary window. By default, it won't.

        .. seealso::
            :py:class:`~efl.elementary.innerwindow.InnerWindow` for more
            information on inner windows

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


    property path:
        """

        :see: :py:attr:`~efl.elementary.fileselector.Fileselector.path`

        .. deprecated:: 1.9
            Combine with Fileselector class instead

        """
        def __get__(self):
            return self.path_get()

        def __set__(self, path):
            self.path_set(path)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def path_set(self, path):
        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        elm_fileselector_path_set(self.obj,
            <const char *>path if path is not None else NULL)
    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def path_get(self):
        return _ctouni(elm_fileselector_path_get(self.obj))

    property expandable:
        """

        :see: :py:attr:`~efl.elementary.fileselector.Fileselector.expandable`

        .. deprecated:: 1.9
            Combine with Fileselector class instead

        """
        def __get__(self):
            return self.expandable_get()

        def __set__(self, expand):
            self.expandable_set(expand)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def expandable_set(self, expand):
        elm_fileselector_expandable_set(self.obj, expand)
    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def expandable_get(self):
        return bool(elm_fileselector_expandable_get(self.obj))

    property folder_only:
        """

        :see: :py:attr:`~efl.elementary.fileselector.Fileselector.folder_only`

        .. deprecated:: 1.9
            Combine with Fileselector class instead

        """
        def __get__(self):
            return self.folder_only_get()

        def __set__(self, folder_only):
            self.folder_only_set(folder_only)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def folder_only_set(self, folder_only):
        elm_fileselector_folder_only_set(self.obj, folder_only)
    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def folder_only_get(self):
        return bool(elm_fileselector_folder_only_get(self.obj))

    property is_save:
        """

        :see: :py:attr:`~efl.elementary.fileselector.Fileselector.is_save`

        .. deprecated:: 1.9
            Combine with Fileselector class instead

        """
        def __get__(self):
            return self.is_save_get()

        def __set__(self, is_save):
            self.is_save_set(is_save)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def is_save_set(self, is_save):
        elm_fileselector_is_save_set(self.obj, is_save)
    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def is_save_get(self):
        return bool(elm_fileselector_is_save_get(self.obj))

    property selected:
        """

        :see: :py:attr:`~efl.elementary.fileselector.Fileselector.selected`

        .. deprecated:: 1.9
            Combine with Fileselector class instead

        """
        def __get__(self):
            return _ctouni(elm_fileselector_selected_get(self.obj))

        def __set__(self, path):
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            elm_fileselector_selected_set(self.obj,
                <const char *>path if path is not None else NULL)

    def selected_set(self, path):
        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        elm_fileselector_selected_set(self.obj,
            <const char *>path if path is not None else NULL)
    def selected_get(self):
        return _ctouni(elm_fileselector_selected_get(self.obj))

    def callback_changed_add(self, func, *args, **kwargs):
        """The text within the entry was changed."""
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def callback_activated_add(self, func, *args, **kwargs):
        """

        :see: :py:meth:`~efl.elementary.fileselector.Fileselector.callback_activated_add`

        """
        self._callback_add("activated", func, args, kwargs)

    @DEPRECATED("1.9", "Combine with Fileselector class instead")
    def callback_activated_del(self, func):
        self._callback_del("activated", func)

    def callback_press_add(self, func, *args, **kwargs):
        """The entry has been clicked."""
        self._callback_add("press", func, args, kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """The entry has been clicked (and held) for a couple seconds."""
        self._callback_add("longpressed", func, args, kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        """The entry has been clicked."""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        """The entry has been double clicked."""
        self._callback_add("clicked,double", func, args, kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_selection_paste_add(self, func, *args, **kwargs):
        """A paste action has occurred on the entry."""
        self._callback_add("selection,paste", func, args, kwargs)

    def callback_selection_paste_del(self, func):
        self._callback_del("selection,paste", func)

    def callback_selection_copy_add(self, func, *args, **kwargs):
        """A copy action has occurred on the entry."""
        self._callback_add("selection,copy", func, args, kwargs)

    def callback_selection_copy_del(self, func):
        self._callback_del("selection,copy", func)

    def callback_selection_cut_add(self, func, *args, **kwargs):
        """A cut action has occurred on the entry."""
        self._callback_add("selection,cut", func, args, kwargs)

    def callback_selection_cut_del(self, func):
        self._callback_del("selection,cut", func)

    def callback_unpressed_add(self, func, *args, **kwargs):
        """The file selector entry's button was released after being pressed."""
        self._callback_add("unpressed", func, args, kwargs)

    def callback_unpressed_del(self, func):
        self._callback_del("unpressed", func)

    def callback_file_chosen_add(self, func, *args, **kwargs):
        """The user has selected a path via the file selector entry's internal
        file selector, whose string comes as the ``event_info`` data.

        """
        self._callback_add_full("file,chosen", _cb_string_conv,
                                func, args, kwargs)

    def callback_file_chosen_del(self, func):
        self._callback_del_full("file,chosen", _cb_string_conv, func)


_object_mapping_register("Elm_Fileselector_Entry", FileselectorEntry)
