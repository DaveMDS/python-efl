# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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

"""
:mod:`systray` Module
##########################

.. versionadded:: 1.14


Enumerations
============

.. _Elm_Systray_Category:

Category of the Status Notifier Item.
-------------------------------------

.. data:: ELM_SYSTRAY_CATEGORY_APP_STATUS
    
    Indicators of application status

.. data:: ELM_SYSTRAY_CATEGORY_COMMUNICATIONS

    Communications apps

.. data:: ELM_SYSTRAY_CATEGORY_SYS_SERVICES

    System Service apps

.. data:: ELM_SYSTRAY_CATEGORY_HARDWARE

    Hardware indicators

.. data:: ELM_SYSTRAY_CATEGORY_OTHER

    Undefined category


.. _Elm_Systray_Status:

Application status information.
-------------------------------

.. data:: ELM_SYSTRAY_STATUS_PASSIVE

    Passive (normal)

.. data:: ELM_SYSTRAY_STATUS_ACTIVE

    Active

.. data:: ELM_SYSTRAY_STATUS_ATTENTION

    Needs Attention

Inheritance diagram
===================

.. inheritance-diagram:: efl.elementary.systray
    :parts: 2

"""

from cpython cimport PyUnicode_AsUTF8String, Py_INCREF

from efl.c_eo cimport eo_do, eo_do_ret, eo_add, Eo as cEo
from efl.eo cimport Eo, object_from_instance
from object cimport Object
from efl.ecore cimport Event, EventHandler, _event_mapping_register
from efl.utils.conversions cimport _ctouni


cdef class EventSystrayReady(Event):
    cdef int _set_obj(self, void *o) except 0:
        return 1

    def __repr__(self):
        return "<%s()>" % (self.__class__.__name__,)

_event_mapping_register(ELM_EVENT_SYSTRAY_READY, EventSystrayReady)


cdef class Systray(Object):

    """

    This is the class that actually implements the widget.

    """
    
    def __init__(self, Eo parent not None, *args, **kwargs):
        self._set_obj(eo_add(elm_systray_class_get(), parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property id:
        """The id of the Status Notifier Item.

        :type: string

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            eo_do(self.obj, elm_obj_systray_id_set(
                <const char *>value if value is not None else NULL
                )
            )

        def __get__(self):
            cdef const char *value = ""
            eo_do_ret(self.obj, value, elm_obj_systray_id_get())
            return _ctouni(value)

    def id_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        eo_do(self.obj, elm_obj_systray_id_set(
            <const char *>value if value is not None else NULL
            )
        )

    def id_get(self):
        cdef const char *value = ""
        eo_do_ret(self.obj, value, elm_obj_systray_id_get())
        return _ctouni(value)

    property category:
        """

        The category of the Status Notifier Item.

        :type: string

        """
        def __set__(self, Elm_Systray_Category value):
            eo_do(self.obj, elm_obj_systray_category_set(value))

        def __get__(self):
            cdef Elm_Systray_Category value = ELM_SYSTRAY_CATEGORY_APP_STATUS
            eo_do_ret(self.obj, value, elm_obj_systray_category_get())
            return <Elm_Systray_Category>value

    def category_set(self, Elm_Systray_Category value):
        eo_do(self.obj, elm_obj_systray_category_set(value))

    def category_get(self):
        cdef Elm_Systray_Category value = ELM_SYSTRAY_CATEGORY_APP_STATUS
        eo_do_ret(self.obj, value, elm_obj_systray_category_get())
        return value

    property icon_theme_path:
        """The path to the theme where the icons can be found.

        Set this value to "" to use the default path.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            eo_do(self.obj, elm_obj_systray_icon_theme_path_set(
                <const char *>value if value is not None else NULL
                )
            )

        def __get__(self):
            cdef const char *value = ""
            eo_do_ret(self.obj, value, elm_obj_systray_icon_theme_path_get())
            return _ctouni(value)

    def icon_theme_path_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        eo_do(self.obj, elm_obj_systray_icon_theme_path_set(
            <const char *>value if value is not None else NULL
            )
        )

    def icon_theme_path_get(self):
        cdef const char *value = ""
        eo_do_ret(self.obj, value, elm_obj_systray_icon_theme_path_get())
        return _ctouni(value)

    property menu:
        """The object path of the D-Bus Menu to be shown when the Status Notifier Item is activated by the user.

        :type: Eo
        """
        def __set__(self, Eo value):
            eo_do(self.obj, elm_obj_systray_menu_set(value.obj))

        def __get__(self):
            cdef cEo *value = NULL
            eo_do_ret(self.obj, value, elm_obj_systray_menu_get())
            return object_from_instance(value)

    def menu_set(self, Eo value):
        eo_do(self.obj, elm_obj_systray_menu_set(value.obj))

    def menu_get(self):
        cdef cEo *value = NULL
        eo_do_ret(self.obj, value, elm_obj_systray_menu_get())
        return object_from_instance(value)

    property att_icon_name:
        """The name of the attention icon to be used by the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            eo_do(self.obj, elm_obj_systray_att_icon_name_set(
                <const char *>value if value is not None else NULL
                )
            )

        def __get__(self):
            cdef const char *value = ""
            eo_do_ret(self.obj, value, elm_obj_systray_att_icon_name_get())
            return _ctouni(value)

    def att_icon_name_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        eo_do(self.obj, elm_obj_systray_att_icon_name_set(
            <const char *>value if value is not None else NULL
            )
        )

    def att_icon_name_get(self):
        cdef const char *value = ""
        eo_do_ret(self.obj, value, elm_obj_systray_att_icon_name_get())
        return _ctouni(value)

    property status:
        """The status of the Status Notifier Item.

        :type: Elm_Systray_Status
        """
        def __set__(self, Elm_Systray_Status value):
            eo_do(self.obj, elm_obj_systray_status_set(value))

        def __get__(self):
            cdef Elm_Systray_Status value = ELM_SYSTRAY_STATUS_PASSIVE
            eo_do_ret(self.obj, value, elm_obj_systray_status_get())
            return value

    def status_set(self, Elm_Systray_Status value):
        eo_do(self.obj, elm_obj_systray_status_set(value))

    def status_get(self):
        cdef Elm_Systray_Status value = ELM_SYSTRAY_STATUS_PASSIVE
        eo_do_ret(self.obj, value, elm_obj_systray_status_get())
        return value

    property icon_name:
        """The name of the icon to be used by the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            eo_do(self.obj, elm_obj_systray_icon_name_set(
                <const char *>value if value is not None else NULL
                )
            )

        def __get__(self):
            cdef const char *value = ""
            eo_do_ret(self.obj, value, elm_obj_systray_icon_name_get())
            return _ctouni(value)

    def icon_name_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        eo_do(self.obj, elm_obj_systray_icon_name_set(
            <const char *>value if value is not None else NULL
            )
        )

    def icon_name_get(self):
        cdef const char *value = ""
        eo_do_ret(self.obj, value, elm_obj_systray_icon_name_get())
        return _ctouni(value)

    property title:
        """The title of the Status Notifier Item.

        :type: string
        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            eo_do(self.obj, elm_obj_systray_title_set(
                <const char *>value if value is not None else NULL
                )
            )

        def __get__(self):
            cdef const char *value = ""
            eo_do_ret(self.obj, value, elm_obj_systray_title_get())
            return _ctouni(value)

    def title_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        eo_do(self.obj, elm_obj_systray_title_set(
            <const char *>value if value is not None else NULL
            )
        )

    def title_get(self):
        cdef const char *value = ""
        eo_do_ret(self.obj, value, elm_obj_systray_title_get())
        return _ctouni(value)

    def register(self):
        """Register this Status Notifier Item in the System Tray Watcher.

        This function should only be called after the event
        #ELM_EVENT_SYSTRAY_READY is emitted.

        """
        cdef Eina_Bool value = 0
        eo_do_ret(self.obj, value, elm_obj_systray_register())
        return value


def on_systray_ready(func, *args, **kwargs):
    """Use this to set a handler for the systray ready event."""
    return EventHandler(ELM_EVENT_SYSTRAY_READY, func, *args, **kwargs)
