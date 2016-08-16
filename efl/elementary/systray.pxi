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

include "systray_cdef.pxi"

cdef class Systray(Eo):

    """

    This is the class that actually implements the widget.

    """

    def __init__(self, Eo parent not None, *args, **kwargs):
        cdef cEo *obj = eo_add(elm_systray_class_get(), parent.obj)
        self._set_obj(obj)
        self._set_properties_from_keyword_args(kwargs)

    property id:
        """The id of the Status Notifier Item.

        :type: string

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            elm_obj_systray_id_set(
                self.obj, <const char *>value if value is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_obj_systray_id_get(self.obj))

    def id_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        elm_obj_systray_id_set(
            self.obj, <const char *>value if value is not None else NULL
            )

    def id_get(self):
        return _ctouni(elm_obj_systray_id_get(self.obj))

    property category:
        """

        The category of the Status Notifier Item.

        :type: :ref:`Elm_Systray_Category`

        """
        def __set__(self, Elm_Systray_Category value):
            elm_obj_systray_category_set(self.obj, value)

        def __get__(self):
            return <Elm_Systray_Category>elm_obj_systray_category_get(self.obj)

    def category_set(self, Elm_Systray_Category value):
        elm_obj_systray_category_set(self.obj, value)

    def category_get(self):
        return <Elm_Systray_Category>elm_obj_systray_category_get(self.obj)

    property icon_theme_path:
        """The path to the theme where the icons can be found.

        Set this value to "" to use the default path.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            elm_obj_systray_icon_theme_path_set(
                self.obj, <const char *>value if value is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_obj_systray_icon_theme_path_get(self.obj))

    def icon_theme_path_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        elm_obj_systray_icon_theme_path_set(
            self.obj, <const char *>value if value is not None else NULL
            )

    def icon_theme_path_get(self):
        return _ctouni(elm_obj_systray_icon_theme_path_get(self.obj))

    property menu:
        """The D-Bus Menu to be shown when the Status Notifier Item is activated by the user.

        :type: :class:`~efl.elementary.menu.Menu`
        """
        def __set__(self, Eo value):
            elm_obj_systray_menu_set(self.obj, value.obj)

        def __get__(self):
            return object_from_instance(elm_obj_systray_menu_get(self.obj))

    def menu_set(self, Eo value):
        elm_obj_systray_menu_set(self.obj, value.obj)

    def menu_get(self):
        return object_from_instance(elm_obj_systray_menu_get(self.obj))

    property att_icon_name:
        """The name of the attention icon to be used by the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            elm_obj_systray_att_icon_name_set(
                self.obj, <const char *>value if value is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_obj_systray_att_icon_name_get(self.obj))

    def att_icon_name_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        elm_obj_systray_att_icon_name_set(
            self.obj, <const char *>value if value is not None else NULL
            )

    def att_icon_name_get(self):
        return _ctouni(elm_obj_systray_att_icon_name_get(self.obj))

    property status:
        """The status of the Status Notifier Item.

        :type: :ref:`Elm_Systray_Status`
        """
        def __set__(self, Elm_Systray_Status value):
            elm_obj_systray_status_set(self.obj, value)

        def __get__(self):
            return elm_obj_systray_status_get(self.obj)

    def status_set(self, Elm_Systray_Status value):
        elm_obj_systray_status_set(self.obj, value)

    def status_get(self):
        return elm_obj_systray_status_get(self.obj)

    property icon_name:
        """The name of the icon to be used by the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            elm_obj_systray_icon_name_set(
                self.obj, <const char *>value if value is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_obj_systray_icon_name_get(self.obj))

    def icon_name_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        elm_obj_systray_icon_name_set(
            self.obj, <const char *>value if value is not None else NULL
            )

    def icon_name_get(self):
        return _ctouni(elm_obj_systray_icon_name_get(self.obj))

    property title:
        """The title of the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            elm_obj_systray_title_set(
                self.obj, <const char *>value if value is not None else NULL
                )

        def __get__(self):
            return _ctouni(elm_obj_systray_title_get(self.obj))

    def title_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        elm_obj_systray_title_set(
            self.obj, <const char *>value if value is not None else NULL
            )

    def title_get(self):
        return _ctouni(elm_obj_systray_title_get(self.obj))

    def register(self):
        """Register this Status Notifier Item in the System Tray Watcher.

        This function should only be called after the event
        ``ELM_EVENT_SYSTRAY_READY``, for which you can set a callback with
        :func:`on_systray_ready`, is emitted.

        """
        return elm_obj_systray_register(self.obj)


def on_systray_ready(func, *args, **kwargs):
    """Use this to set a handler for the systray ready event."""
    return EventHandler(enums.ELM_EVENT_SYSTRAY_READY, func, *args, **kwargs)
