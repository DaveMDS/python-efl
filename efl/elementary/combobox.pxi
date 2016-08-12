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

include "combobox_cdef.pxi"

cdef class _Combobox(Object):
    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_combobox_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property expanded:
        """ Returns whether the combobox is expanded or not.

        :type: bool (**readonly**)

        """
        def __get__(self):
            return bool(elm_combobox_expanded_get(self.obj))

    def expanded_get(self):
        return bool(elm_combobox_expanded_get(self.obj))

    def hover_begin(self):
        """ This triggers the combobox popup from code, the same as if the user
        had clicked the button.
        """
        elm_combobox_hover_begin(self.obj)

    def hover_end(self):
        """ This dismisses the combobox popup as if the user had clicked
        outside the hover.
        """
        elm_combobox_hover_end(self.obj)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """  The combobox hover has been dismissed """
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)

    def callback_expanded_add(self, func, *args, **kwargs):
        """ The combobox hover has been expanded """
        self._callback_add("expanded", func, args, kwargs)

    def callback_expanded_del(self, func):
        self._callback_del("expanded", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        """ The combobox button has been clicked """
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_item_selected_add(self, func, *args, **kwargs):
        """ An item has been selected """
        self._callback_add_full("item,selected", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_item_selected_del(self, func):
        self._callback_del_full("item,selected", _cb_object_item_conv, func)

    def callback_item_pressed_add(self, func, *args, **kwargs):
        """ An item has been pressed """
        self._callback_add_full("item,pressed", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_item_pressed_del(self, func):
        self._callback_del_full("item,pressed", _cb_object_item_conv, func)

    def callback_filter_done_add(self, func, *args, **kwargs):
        """ Item filtering is done """
        self._callback_add("filter,done", func, args, kwargs)

    def callback_filter_done_del(self, func):
        self._callback_del("filter,done", func)


class Combobox(_Combobox, Button, Entry, Genlist, Hover):
    """

    This is the class that actually implements the widget.

    .. warning::
        **THE COMBOBOX WIDGET IS BROKEN AND DEPRECATED, DO NOT USE IN ANY CASE !!**

        The behaviour and the API of the Combobox will change in future release.

        If you are already using this we really encourage you to switch
        to other widgets.

        We are really sorry about this breakage, but there is nothing we can do
        to avoid this :(

    .. versionadded:: 1.17

    .. versionchanged:: 1.18
        The combobox widget has been deprecated. Don't use it in ANY case.

    """
    def __init__(self, evasObject parent, *args, **kwargs):
        """Combobox(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        print("""
        **THE COMBOBOX IS BROKEN AND DEPRECATED, DO NOT USE IN ANY CASE !!**

        The behaviour and the API of the Combobox will change in future release.

        If you are already using this we really encourage you to switch
        to other widgets.

        We are really sorry about this breakage, but there is nothing we can do
        to avoid this :(
        """)
        _Combobox.__init__(self, parent, *args, **kwargs)



_object_mapping_register("Elm_Combobox", Combobox)
