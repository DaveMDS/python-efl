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

include "dayselector_cdef.pxi"

cdef class Dayselector(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Dayselector(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_dayselector_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def day_selected_set(self, day, selected):
        """Set the state of given Dayselector_Day.

        :param day: The day that the user want to set state.
        :type day: :ref:`Elm_Dayselector_Day`
        :param selected: state of the day. ``True`` is selected.
        :type selected: bool

        """
        elm_dayselector_day_selected_set(self.obj, day, selected)

    def day_selected_get(self, day):
        """Get the state of given Dayselector_Day.

        :param day: The day that the user want to know state.
        :type day: :ref:`Elm_Dayselector_Day`
        :return: ``True``, if the Day is selected
        :rtype: bool

        """
        return bool(elm_dayselector_day_selected_get(self.obj, day))

    property week_start:
        """The starting day of Dayselector.

        :type: :ref:`Elm_Dayselector_Day`

        """
        def __get__(self):
            return elm_dayselector_week_start_get(self.obj)
        def __set__(self, day):
            elm_dayselector_week_start_set(self.obj, day)

    property weekend_start:
        """The weekend starting day of Dayselector.

        :type: :ref:`Elm_Dayselector_Day`

        """
        def __get__(self):
            return elm_dayselector_weekend_start_get(self.obj)
        def __set__(self, day):
            elm_dayselector_weekend_start_set(self.obj, day)

    property weekend_length:
        """The weekend length of Dayselector.

        :type: int

        """
        def __get__(self):
            return elm_dayselector_weekend_length_get(self.obj)
        def __set__(self, length):
            elm_dayselector_weekend_length_set(self.obj, length)

    property weekdays_names:
        """

        Set weekdays names to be displayed by the Dayselector.

        :param weekdays: List of seven strings to be used as weekday names.

        .. warning:: It must have 7 elements, or it will access invalid memory.

        By default or if set to None, weekdays abbreviations get from system are
        displayed: E.g. for an en_US locale: "Sun, Mon, Tue, Wed, Thu, Fri, Sat"

        The first string should be related to Sunday, the second to Monday...

        The usage should be like this::

            dayselector.weekdays_names = ["Sunday", "Monday", "Tuesday",
                "Wednesday", "Thursday", "Friday", "Saturday"]

        :see: :py:attr:`weekend_start`

        .. versionadded:: 1.8

        """
        def __set__(self, list weekdays):
            # TODO: Add checks for list validity (len == 7 etc.)
            elm_dayselector_weekdays_names_set(self.obj,
                python_list_strings_to_array_of_strings(weekdays))

        def __get__(self):
            return eina_list_strings_to_python_list(
                elm_dayselector_weekdays_names_get(self.obj)
                )

    def callback_dayselector_changed_add(self, func, *args, **kwargs):
        """when the user changes the state of a day."""
        self._callback_add("dayselector,changed", func, args, kwargs)

    def callback_dayselector_changed_del(self, func):
        self._callback_del("dayselector,changed", func)


_object_mapping_register("Elm_Dayselector", Dayselector)
