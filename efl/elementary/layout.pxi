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

include "layout_cdef.pxi"

cdef void layout_signal_callback(void *data, Evas_Object *obj,
                    const char *emission, const char *source) with gil:
    cdef Object self = object_from_instance(obj)
    lst = tuple(<object>data)
    for func, args, kargs in lst:
        try:
            func(self, _ctouni(emission), _ctouni(source), *args, **kargs)
        except Exception:
            traceback.print_exc()

cdef class LayoutClass(Object):
    """LayoutClass(...)

    This is the base class for the :class:`~efl.elementary.layout.Layout`
    widget and all the other widgets that inherit from it.

    """

    cdef dict _elm_layout_signal_cbs

    def __cinit__(self):
        self._elm_layout_signal_cbs = {}

    def content_set(self, swallow=None, evasObject content=None):
        """Set the layout content.

        Once the content object is set, a previously set one will be deleted.
        If you want to keep that old content object, use the
        :py:meth:`content_unset` function.

        .. note:: In an Edje theme, the part used as a content container is
            called *SWALLOW*. This is why the parameter name is called
            *swallow*, but it is expected to be a part name just like the
            second parameter of :py:meth:`box_append`.

        :param swallow: The swallow part name in the edje file
        :type swallow: string
        :param content: The child that will be added in this layout object
        :type content: :py:class:`~efl.evas.Object`

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the content fails.

        """
        if content is None:
            content = swallow
            swallow = None
        if isinstance(swallow, unicode): swallow = PyUnicode_AsUTF8String(swallow)
        if not elm_layout_content_set(self.obj,
            <const char *>swallow if swallow is not None else NULL,
            content.obj if content is not None else NULL):
            raise RuntimeError

    def content_get(self, swallow=None):
        """Get the child object in the given content part.

        :param swallow: The SWALLOW part to get its content
        :type swallow: string

        :return: The swallowed object or None if none or an error occurred

        """
        if isinstance(swallow, unicode): swallow = PyUnicode_AsUTF8String(swallow)
        return object_from_instance(elm_layout_content_get(self.obj,
            <const char *>swallow if swallow is not None else NULL))

    def content_unset(self, swallow=None):
        """Unset the layout content.

        Unparent and return the content object which was set for this part.

        :param swallow: The swallow part name in the edje file
        :type swallow: string
        :return: The content that was being used
        :rtype: :py:class:`~efl.evas.Object`

        """
        if isinstance(swallow, unicode): swallow = PyUnicode_AsUTF8String(swallow)
        return object_from_instance(elm_layout_content_unset(self.obj,
            <const char *>swallow if swallow is not None else NULL))

    def text_set(self, part=None, text=None):
        """Set the text of the given part

        :param part: The TEXT part where to set the text
        :type part: string
        :param text: The text to set
        :type text: string

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the text fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        if text is None:
            # In this case we're guessing the user wants the only arg used
            # as text
            text = part
            part = None
        if not elm_layout_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>text if text is not None else NULL):
            raise RuntimeError

    def text_get(self, part=None):
        """Get the text set in the given part

        :param part: The TEXT part to retrieve the text off
        :type part: string

        :return: The text set in ``part``
        :rtype: string

        """
        # With part=None it should do the same as elm_object_text_get
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_layout_text_get(self.obj,
            <const char *>part if part is not None else NULL))

    property file:
        """Set the file path and group of the edje file that will be used as
        layout.

        :type: tuple of string
        :raise RuntimeError: when setting the file fails

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the file fails

        .. versionchanged:: 1.14
            Property is now also readable

        """
        def __set__(self, value):
            filename, group = value
            if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            if not elm_layout_file_set(self.obj,
                <const char *>filename if filename is not None else NULL,
                <const char *>group if group is not None else NULL):
                    raise RuntimeError("Could not set file.")

        def __get__(self):
            cdef:
                const char *file
                const char *group
            elm_layout_file_get(self.obj, &file, &group)
            return (_ctouni(file), _ctouni(group))

    def file_set(self, filename, group = None):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        if not elm_layout_file_set(self.obj,
            <const char *>filename if filename is not None else NULL,
            <const char *>group if group is not None else NULL):
                raise RuntimeError("Could not set file.")
    def file_get(self):
        return self.file

    def freeze(self):
        """Freezes the Elementary layout object.

        This function puts all changes on hold. Successive freezes will
        nest, requiring an equal number of thaws.

        :return: The frozen state or 0 on Error

        :see: :py:func:`thaw`

        .. versionadded:: 1.8

        """
        return elm_layout_freeze(self.obj)

    def thaw(self):
        """Thaws the Elementary object.

        This function thaws the given Edje object and the Elementary sizing calc.

        :return: The frozen state or 0 if the object is not frozen or on error.

        .. note::
            If successive freezes were done, an equal number of
            thaws will be required.

        :see: :py:func:`freeze`

        .. versionadded:: 1.8

        """
        return elm_layout_thaw(self.obj)

    property theme:
        """Set the edje group class, group name and style from the elementary
        theme that will be used as layout.

        Note that ``style`` will be the new style too, as in setting
        :py:attr:`~efl.elementary.object.Object.style`.

        :type: tuple of strings
        :raise RuntimeError: when setting the theme fails

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the theme fails

        """
        def __set__(self, theme):
            clas, group, style = theme
            if isinstance(clas, unicode): clas = PyUnicode_AsUTF8String(clas)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            if not elm_layout_theme_set(self.obj,
                <const char *>clas if clas is not None else NULL,
                <const char *>group if group is not None else NULL,
                <const char *>style if style is not None else NULL):
                    raise RuntimeError("Could not set theme.")

    def theme_set(self, clas, group, style):
        if isinstance(clas, unicode): clas = PyUnicode_AsUTF8String(clas)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        if not elm_layout_theme_set(self.obj,
            <const char *>clas if clas is not None else NULL,
            <const char *>group if group is not None else NULL,
            <const char *>style if style is not None else NULL):
                raise RuntimeError("Could not set theme.")

    def signal_emit(self, emission, source):
        """Send a (Edje) signal to a given layout widget's underlying Edje
        object.

        This function sends a signal to the underlying Edje object. An Edje
        program on that Edje object's definition can respond to a signal by
        specifying matching 'signal' and 'source' fields.

        :param emission: The signal's name string
        :type emission: string
        :param source: The signal's source string
        :type source: string

        """
        if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        elm_layout_signal_emit(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL)

    def signal_callback_add(self, emission, source, func, *args, **kwargs):
        """Add a callback for a (Edje) signal emitted by a layout widget's
        underlying Edje object.

        This function connects a callback function to a signal emitted by
        the underlying Edje object. Globs are accepted in either the
        emission or source strings (see
        ``edje_object_signal_callback_add()``).

        :param emission: The signal's name string
        :type emission: string
        :param source: The signal's source string
        :type source: string
        :param func: The callback function to be executed when the signal is
            emitted.
        :type func: function

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        d = self._elm_layout_signal_cbs.setdefault(emission, {})
        lst = d.setdefault(source, [])
        if not lst:
            if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
            if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
            elm_layout_signal_callback_add(self.obj,
                <const char *>emission if emission is not None else NULL,
                <const char *>source if source is not None else NULL,
                layout_signal_callback, <void*>lst)
        lst.append((func, args, kwargs))

    def signal_callback_del(self, emission, source, func):
        """Remove a signal-triggered callback from a given layout widget.

        This function removes the **last** callback attached to a signal
        emitted by the underlying Edje object, with parameters *emission*,
        ``source`` and ``func`` matching exactly those passed to a previous
        call to :py:meth:`~efl.elementary.object.Object.signal_callback_add`.
        The data that was passed to this call will be returned.

        :param emission: The signal's name string
        :type emission: string
        :param source: The signal's source string
        :type source: string
        :param func: The callback function being executed when the signal
            was emitted.
        :type func: function

        """
        try:
            d = self._elm_layout_signal_cbs[emission]
            lst = d[source]
        except KeyError:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        i = -1
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break
        else:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        lst.pop(i)
        if lst:
            return
        d.pop(source)
        if not d:
            self._elm_layout_signal_cbs.pop(emission)
        if isinstance(emission, unicode): emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        elm_layout_signal_callback_del(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL,
            layout_signal_callback)

    def box_append(self, part, evasObject child):
        """Append child to layout box part.

        Once the object is appended, it will become child of the layout. Its
        lifetime will be bound to the layout, whenever the layout dies the
        child will be deleted automatically. One should use
        :py:meth:`box_remove()` to make this layout forget about the object.

        .. seealso::
            :py:meth:`box_prepend`
            :py:meth:`box_insert_before`
            :py:meth:`box_insert_at`
            :py:meth:`box_remove`

        :param part: the box part to which the object will be appended.
        :type part: string
        :param child: the child object to append to box.
        :type child: :py:class:`~efl.evas.Object`

        :raise RuntimeError: when adding the child fails

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_box_append(self.obj,
            <const char *>part if part is not None else NULL,
            child.obj):
                raise RuntimeError("Could not add to box")

    def box_prepend(self, part, evasObject child):
        """Prepend child to layout box part.

        Once the object is prepended, it will become child of the layout. Its
        lifetime will be bound to the layout, whenever the layout dies the
        child will be deleted automatically. One should use
        :py:meth:`box_remove` to make this layout forget about the object.

        .. seealso::
            :py:meth:`box_append`
            :py:meth:`box_insert_before`
            :py:meth:`box_insert_at`
            :py:meth:`box_remove`

        :param part: the box part to prepend.
        :type part: string
        :param child: the child object to prepend to box.
        :type child: :py:class:`~efl.evas.Object`

        :raise RuntimeError: when adding to box fails

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_box_prepend(self.obj,
            <const char *>part if part is not None else NULL,
            child.obj):
                raise RuntimeError("Could not add to box")

    def box_insert_before(self, part, evasObject child, evasObject reference):
        """Insert child to layout box part before a reference object.

        Once the object is inserted, it will become child of the layout. Its
        lifetime will be bound to the layout, whenever the layout dies the
        child will be deleted automatically. One should use
        :py:meth:`box_remove` to make this layout forget about the object.

        .. seealso::
            :py:meth:`box_append`
            :py:meth:`box_prepend`
            :py:meth:`box_insert_at`
            :py:meth:`box_remove`

        :param part: the box part to insert.
        :type part: string
        :param child: the child object to insert into box.
        :type child: :py:class:`~efl.evas.Object`
        :param reference: another reference object to insert before in box.
        :type reference: :py:class:`~efl.evas.Object`

        :raise RuntimeError: when inserting to box fails

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_box_insert_before(self.obj,
            <const char *>part if part is not None else NULL,
            child.obj, reference.obj):
                raise RuntimeError("Could not add to box")

    def box_insert_at(self, part, evasObject child, pos):
        """Insert child to layout box part at a given position.

        Once the object is inserted, it will become child of the layout. Its
        lifetime will be bound to the layout, whenever the layout dies the
        child will be deleted automatically. One should use
        :py:meth:`box_remove` to make this layout forget about the object.

        .. seealso::
            :py:meth:`box_append`
            :py:meth:`box_prepend`
            :py:meth:`box_insert_before`
            :py:meth:`box_remove`

        :param part: the box part to insert.
        :type part: string
        :param child: the child object to insert into box.
        :type child: :py:class:`~efl.evas.Object`
        :param pos: the numeric position >=0 to insert the child.
        :type pos: int

        :raise RuntimeError: when inserting to box fails

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_box_insert_at(self.obj,
            <const char *>part if part is not None else NULL,
            child.obj, pos):
                raise RuntimeError("Could not add to box")

    def box_remove(self, part, evasObject child):
        """Remove a child of the given part box.

        The object will be removed from the box part and its lifetime will
        not be handled by the layout anymore. This is equivalent to
        :py:meth:`~efl.elementary.object.Object.part_content_unset` for box.

        .. seealso::
            :py:meth:`box_append`
            :py:meth:`box_remove_all`

        :param part: The box part name to remove child.
        :type part: string
        :param child: The object to remove from box.
        :type child: :py:class:`~efl.evas.Object`

        :return: The object that was being used, or None if not found.
        :rtype: :py:class:`~efl.evas.Object`

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_layout_box_remove(self.obj,
            <const char *>part if part is not None else NULL,
            child.obj))

    def box_remove_all(self, part, clear):
        """Remove all children of the given part box.

        The objects will be removed from the box part and their lifetime will
        not be handled by the layout anymore. This is equivalent to
        :py:meth:`box_remove` for all box children.

        .. seealso::
            :py:meth:`box_append`
            :py:meth:`box_remove`

        :param part: The box part name to remove child.
        :type part: string
        :param clear: If True, then all objects will be deleted as
            well, otherwise they will just be removed and will be
            dangling on the canvas.
        :type clear: bool

        :raise RuntimeError: when removing all items fails

        .. versionchanged:: 1.8
            Raises RuntimeError if removing the children fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_box_remove_all(self.obj,
            <const char *>part if part is not None else NULL,
            clear):
                raise RuntimeError("Could not remove all items from box")

    def table_pack(self, part, evasObject child_obj, col, row, colspan, rowspan):
        """Insert child to layout table part.

        Once the object is inserted, it will become child of the table. Its
        lifetime will be bound to the layout, and whenever the layout dies the
        child will be deleted automatically. One should use
        :py:meth:`table_unpack` to make this layout forget about the object.

        If ``colspan`` or ``rowspan`` are bigger than 1, that object will occupy
        more space than a single cell.

        .. seealso::
            :py:meth:`table_unpack`
            :py:meth:`table_clear`

        :param part: the box part to pack child.
        :type part: string
        :param child_obj: the child object to pack into table.
        :type child_obj: :py:class:`~efl.evas.Object`
        :param col: the column to which the child should be added. (>= 0)
        :type col: int
        :param row: the row to which the child should be added. (>= 0)
        :type row: int
        :param colspan: how many columns should be used to store this object.
            (>= 1)
        :type colspan: int
        :param rowspan: how many rows should be used to store this object. (>= 1)
        :type rowspan: int

        :raise RuntimeError: when packing an item fails

        .. versionchanged:: 1.8
            Raises RuntimeError if adding the child fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_table_pack(self.obj,
            <const char *>part if part is not None else NULL,
            child_obj.obj, col, row, colspan, rowspan):
                raise RuntimeError("Could not pack an item to the table")

    def table_unpack(self, part, evasObject child_obj):
        """Unpack (remove) a child of the given part table.

        The object will be unpacked from the table part and its lifetime
        will not be handled by the layout anymore. This is equivalent to
        :py:meth:`~efl.elementary.object.Object.part_content_unset` for table.

        .. seealso::
            :py:meth:`table_pack`
            :py:meth:`table_clear`

        :param part: The table part name to remove child.
        :type part: string
        :param child_obj: The object to remove from table.
        :type child_obj: :py:class:`~efl.evas.Object`

        :return: The object that was being used, or None if not found.
        :rtype: :py:class:`~efl.evas.Object`

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_layout_table_unpack(self.obj,
            <const char *>part if part is not None else NULL,
            child_obj.obj))

    def table_clear(self, part, clear):
        """Remove all the child objects of the given part table.

        The objects will be removed from the table part and their lifetime will
        not be handled by the layout anymore. This is equivalent to
        :py:meth:`table_unpack` for all table children.

        .. seealso::
            :py:meth:`table_pack`
            :py:meth:`table_unpack`

        :param part: The table part name to remove child.
        :type part: string
        :param clear: If True, then all objects will be deleted as
            well, otherwise they will just be removed and will be
            dangling on the canvas.
        :type clear: bool

        :raise RuntimeError: when clearing the table fails

        .. versionchanged:: 1.8
            Raises RuntimeError if clearing the table fails

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if not elm_layout_table_clear(self.obj,
            <const char *>part if part is not None else NULL,
            clear):
                raise RuntimeError("Could not clear the table")

    property edje:
        """Get the edje layout

        This returns the edje object. It is not expected to be used to then
        swallow objects via
        :py:meth:`Edje.part_swallow <efl.edje.Edje.part_swallow>` for example.
        Use :py:meth:`~efl.elementary.object.Object.part_content_set` instead so
        child object handling and sizing is done properly.

        .. note:: This function should only be used if you really need to call
            some low level Edje function on this edje object. All the common
            stuff (setting text, emitting signals, hooking callbacks to
            signals, etc.) can be done with proper elementary functions.

        .. seealso::
            :py:meth:`signal_callback_add`
            :py:meth:`signal_emit`
            :py:meth:`~efl.elementary.object.Object.part_text_set`
            :py:meth:`box_append`
            :py:meth:`table_pack`
            :py:attr:`~efl.eo.Eo.data`

        :type: :py:class:`~efl.edje.Edje`

        """
        def __get__(self):
            return object_from_instance(elm_layout_edje_get(self.obj))

    def edje_get(self):
        return object_from_instance(elm_layout_edje_get(self.obj))

    def data_get(self, key):
        """Get the edje data from the given layout

        This function fetches data specified inside the edje theme of this
        layout. This function returns None if data is not found.

        In EDC this comes from a data block within the group block that it
        was loaded from. E.g::

            collections {
                group {
                    name: "a_group";
                    data {
                       item: "key1" "value1";
                       item: "key2" "value2";
                    }
                }
            }

        :param key: The data key
        :type key: string

        :return: The edje data string
        :rtype: string

        """
        if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
        return _ctouni(elm_layout_data_get(self.obj,
            <const char *>key if key is not None else NULL))

    def sizing_eval(self):
        """Eval sizing

        Manually forces a sizing re-evaluation. This is useful when the
        minimum size required by the edje theme of this layout has changed.
        The change on the minimum size required by the edje theme is not
        immediately reported to the elementary layout, so one needs to call
        this function in order to tell the widget (layout) that it needs to
        reevaluate its own size.

        The minimum size of the theme is calculated based on minimum size of
        parts, the size of elements inside containers like box and table,
        etc. All of this can change due to state changes, and that's when
        this function should be called.

        Also note that a standard signal of "size,eval" "elm" emitted from
        the edje object will cause this to happen too.

        """
        elm_layout_sizing_eval(self.obj)

    def part_cursor_set(self, part_name, cursor):
        """Sets a specific cursor for an edje part.

        :param part_name: a part from loaded edje group.
        :type part_name: string
        :param cursor: cursor name to use, see Elementary_Cursor.h
        :type cursor: string

        :raise RuntimeError: when setting the parts cursor fails

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the cursor fails

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
        if not elm_layout_part_cursor_set(self.obj,
            <const char *>part_name if part_name is not None else NULL,
            <const char *>cursor if cursor is not None else NULL):
                raise RuntimeError("Could not set cursor to part")

    def part_cursor_get(self, part_name):
        """Get the cursor to be shown when mouse is over an edje part

        :param part_name: a part from loaded edje group.
        :type part_name: string
        :return: the cursor name.
        :rtype: string

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        return _ctouni(elm_layout_part_cursor_get(self.obj,
            <const char *>part_name if part_name is not None else NULL))

    def part_cursor_unset(self, part_name):
        """Unsets a cursor previously set with :py:meth:`part_cursor_set`.

        :param part_name: a part from loaded edje group, that had a cursor set
            with :py:meth:`part_cursor_set`.
        :type part_name: string

        :raise RuntimeError: when unsetting the part cursor fails

        .. versionchanged:: 1.8
            Raises RuntimeError if unsetting the cursor fails

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        if not elm_layout_part_cursor_unset(self.obj,
            <const char *>part_name if part_name is not None else NULL):
                raise RuntimeError("Could not unset part cursor")

    def part_cursor_style_set(self, part_name, style):
        """Sets a specific cursor style for an edje part.

        :param part_name: a part from loaded edje group.
        :type part_name: string
        :param style: the theme style to use (default, transparent, ...)
        :type style: string

        :raise RuntimeError: when setting the part cursor style fails

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the cursor style fails

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        if not elm_layout_part_cursor_style_set(self.obj,
            <const char *>part_name if part_name is not None else NULL,
            <const char *>style if style is not None else NULL):
                raise RuntimeError("Could not set cursor style to part")

    def part_cursor_style_get(self, part_name):
        """Gets a specific cursor style for an edje part.

        :param part_name: a part from loaded edje group.
        :type part_name: string

        :return: the theme style in use, defaults to "default". If the
            object does not have a cursor set, then None is returned.
        :rtype: string

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        return _ctouni(elm_layout_part_cursor_style_get(self.obj,
            <const char *>part_name if part_name is not None else NULL))

    def part_cursor_engine_only_set(self, part_name, engine_only):
        """Sets if the cursor set should be searched on the theme or should use
        the provided by the engine, only.

        .. note:: Before you set if should look on theme you should define a
            cursor with :py:meth:`part_cursor_set`. By default it will only
            look for cursors provided by the engine.

        :param part_name: a part from loaded edje group.
        :type part_name: string
        :param engine_only: if cursors should be just provided by the engine (True)
            or should also search on widget's theme as well (False)
        :type engine_only: bool

        :return: True on success or False on failure, that may be
            part not exists or it did not had a cursor set.
        :rtype: bool

        :raise RuntimeError: when setting the engine_only setting fails,
            when part does not exist or has no cursor set.

        .. versionchanged:: 1.8
            Raises RuntimeError if setting the value fails

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        if not elm_layout_part_cursor_engine_only_set(self.obj,
            <const char *>part_name if part_name is not None else NULL,
            engine_only):
                raise RuntimeError("Could not set cursor engine_only to part")

    def part_cursor_engine_only_get(self, part_name):
        """Gets a specific cursor engine_only for an edje part.

        :param part_name: a part from loaded edje group.
        :type part_name: string

        :return: whenever the cursor is just provided by engine or also from theme.
        :rtype: bool

        """
        if isinstance(part_name, unicode): part_name = PyUnicode_AsUTF8String(part_name)
        return bool(elm_layout_part_cursor_engine_only_get(self.obj,
            <const char *>part_name if part_name is not None else NULL))

    property edje_object_can_access:
        """Set accessibility to all textblock(text) parts in the layout object

        Makes it possible for all textblock(text) parts in the layout to have
        accessibility.

        :raise RuntimeError: if accessibility cannot be set.

        .. versionadded:: 1.8

        """
        def __set__(self, can_access):
            if not elm_layout_edje_object_can_access_set(self.obj, can_access):
                raise RuntimeError("Could not set accessibility to layout textblock parts.")

        def __get__(self):
            return elm_layout_edje_object_can_access_get(self.obj)

    def edje_object_can_access_set(self, bint can_access):
        if not elm_layout_edje_object_can_access_set(self.obj, can_access):
            raise RuntimeError("Could not set accessibility to layout textblock parts.")

    def edje_object_can_access_get(self):
        return bool(elm_layout_edje_object_can_access_get(self.obj))

    def content_swallow_list_get(self):
        """Get the list of objects swallowed into the layout.

        :return: a list of swallowed objects.
        :rtype: list of objects.

        .. versionadded:: 1.9

        """
        cdef:
            Eina_List *l = elm_layout_content_swallow_list_get(self.obj)
            list ret = list()

        while l:
            ret.append(object_from_instance(<Evas_Object*>l.data))
            l = l.next
        eina_list_free(l)

        return ret

    property icon:
        """The icon object in a layout that follows the Elementary naming
        convention for its parts.

        :type: :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_layout_icon_get(self.obj))

        def __set__(self, evasObject icon):
            elm_layout_icon_set(self.obj, icon.obj if icon else NULL)

    def icon_set(self, evasObject icon):
        elm_layout_icon_set(self.obj, icon.obj if icon else NULL)
    def icon_get(self):
        return object_from_instance(elm_layout_icon_get(self.obj))

    property end:
        """The end object in a layout that follows the Elementary naming
        convention for its parts.

        :type: :py:class:`~efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_layout_end_get(self.obj))

        def __set__(self, evasObject end):
            elm_layout_end_set(self.obj, end.obj if end else NULL)

    def end_set(self, evasObject end):
        elm_layout_end_set(self.obj, end.obj if end else NULL)
    def end_get(self):
        return object_from_instance(elm_layout_end_get(self.obj))

    def callback_theme_changed_add(self, func, *args, **kwargs):
        """The theme was changed."""
        self._callback_add("theme,changed", func, args, kwargs)

    def callback_theme_changed_del(self, func):
        self._callback_del("theme,changed", func)



cdef class Layout(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Layout(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_layout_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)


_object_mapping_register("Elm_Layout", Layout)

