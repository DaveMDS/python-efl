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

from cpython cimport PyUnicode_AsUTF8String

from efl.eo cimport _object_mapping_register
from efl.utils.conversions cimport _touni
from efl.evas cimport Object as evasObject
from object cimport Object
from object_item cimport ObjectItem

ELM_ACCESS_TYPE = 0 # when reading out widget or item this is read first
ELM_ACCESS_INFO = 1 # next read is info - this is normally label
ELM_ACCESS_STATE = 2 # if there is a state (eg checkbox) then read state out
ELM_ACCESS_CONTEXT_INFO = 3 # to give contextual information


cdef char *access_info_cb(void *data, Evas_Object *obj):
    pass

cdef void access_activate_cb(void *data, Evas_Object *part_obj, Elm_Object_Item *item):
    pass

cdef class Accessible(Object):
    """

    An accessible object.

    Register evas object as an accessible object.

    :since: 1.8
        
    """

    def __init__(self, target, parent = None):
        """Accessible(...)

        :param target: The evas object to register as an accessible object.
        :param parent: The elementary object which is used for creating
            accessible object.

        """
        cdef:
            evasObject t, p
            ObjectItem i
        if isinstance(target, evasObject):
            t = target
            p = parent
            self._set_obj(elm_access_object_register(t.obj, p.obj))
        elif isinstance(target, ObjectItem):
            i = target
            self._set_obj(elm_object_item_access_register(i.item))
        else:
            raise TypeError("target is of unsupported type")

    def info_set(self, int type, text):
        """Set text to give information for specific type.

        :since: 1.8

        :param type: The type of content that will be read
        :param text: The text information that will be read

        :type:

        :see: elm_access_info_cb_set

        """
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_access_info_set(self.obj, type,
            <const char *>text if text is not None else NULL)

    def info_get(self, int type):
        """Get text to give information for specific type.

        :since: 1.8

        :param type: The type of content that will be read

        :see: elm_access_info_cb_set

        """
        return _touni(elm_access_info_get(self.obj, type))

    # def info_cb_set(self, int type, func, *args, **kwargs):
    #     """Set content callback to give information for specific type.

    #     :since: 1.8

    #     :param type: The type of content that will be read
    #     :param func: The function to be called when the content is read
    #     :param data: The data pointer to be passed to ``func``

    #     The type would be one of ELM_ACCESS_TYPE, ELM_ACCESS_INFO,
    #     ELM_ACCESS_STATE, ELM_ACCESS_CONTEXT_INFO.

    #     In the case of button widget, the content of ELM_ACCESS_TYPE would be
    #     "button". The label of button such as "ok", "cancel" is for ELM_ACCESS_INFO.
    #     If the button is disabled, content of ELM_ACCESS_STATE would be "disabled".
    #     And if there is contextual information, use ELM_ACCESS_CONTEXT_INFO.

    #     """
    #     if not callable(func):
    #         raise TypeError("func is not callable.")

    #     elm_access_info_cb_set(self.obj, type, access_info_cb, <const void *>self)

    # def activate_cb_set(self, func, *args, **kwargs):
    #     """Set activate callback to activate highlight object.

    #     :since: 1.8

    #     :param func: The function to be called when the activate gesture is detected
    #     :param data: The data pointer to be passed to ``func``

    #     """
    #     if not callable(func):
    #         raise TypeError("func is not callable.")

    #     elm_access_activate_cb_set(self.obj, access_activate_cb, <void *>self)

    def access_highlight_set(self):
        """Give the highlight to the object directly.

        :since: 1.8

        The object should be an elementary object or an access object.

        """
        elm_access_highlight_set(self.obj)

_object_mapping_register("Elm_Access", Accessible)
