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

from efl.eina cimport Eina_Bool, Eina_Iterator

cdef extern from "Eo.h":

    ####################################################################
    # Enums (not exported to python, only for internal use)
    #
    cdef enum:
        EO_BASE_SUB_ID_CONSTRUCTOR
        EO_BASE_SUB_ID_DESTRUCTOR
        EO_BASE_SUB_ID_PARENT_SET
        EO_BASE_SUB_ID_PARENT_GET
        EO_BASE_SUB_ID_CHILDREN_ITERATOR_NEW
        EO_BASE_SUB_ID_DATA_SET
        EO_BASE_SUB_ID_DATA_GET
        EO_BASE_SUB_ID_DATA_DEL
        EO_BASE_SUB_ID_WREF_ADD
        EO_BASE_SUB_ID_WREF_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_PRIORITY_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_ARRAY_PRIORITY_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_ARRAY_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_CALL
        EO_BASE_SUB_ID_EVENT_CALLBACK_FORWARDER_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_FORWARDER_DEL
        EO_BASE_SUB_ID_EVENT_FREEZE
        EO_BASE_SUB_ID_EVENT_THAW
        EO_BASE_SUB_ID_EVENT_FREEZE_GET
        EO_BASE_SUB_ID_EVENT_GLOBAL_FREEZE
        EO_BASE_SUB_ID_EVENT_GLOBAL_THAW
        EO_BASE_SUB_ID_EVENT_GLOBAL_FREEZE_GET
        EO_BASE_SUB_ID_DBG_INFO_GET
        EO_BASE_SUB_ID_LAST

    cdef enum:
        EO_CALLBACK_PRIORITY_BEFORE
        EO_CALLBACK_PRIORITY_DEFAULT
        EO_CALLBACK_PRIORITY_AFTER

    cdef enum:
        EO_CALLBACK_STOP
        EO_CALLBACK_CONTINUE

    ####################################################################
    # Structures
    #
    ctypedef struct Eo

    ctypedef struct Eo_Class

    ctypedef struct Eo_Event_Description:
        const char *name
        const char *doc
        Eina_Bool unfreezable


    ####################################################################
    # Eo Events
    #
    cdef const Eo_Event_Description *EO_EV_DEL


    ####################################################################
    # Other typedefs
    #
    ctypedef Eina_Bool (*Eo_Event_Cb)(void *data, Eo *obj, const Eo_Event_Description *desc, void *event_info)

    ctypedef void (*eo_key_data_free_func)(void *)


    ####################################################################
    # Functions
    #
    int eo_init()
    int eo_shutdown()

    Eo *eo_add(const Eo_Class *klass, Eo *parent, ...)
    Eo *eo_ref(const Eo *obj)
    void eo_unref(const Eo *obj)
    int eo_ref_get(const Eo *obj)
    void eo_del(const Eo *obj)

    void eo_wref_add(Eo **wref)

    void eo_do(Eo *obj, ...)
    void *eo_do_ret(Eo *obj, ...)
    const Eo_Class *eo_base_class_get()

    void  eo_key_data_set(const char *key, const void *data)
    void *eo_key_data_get(const char *key)
    void  eo_key_data_del(const char *key)

    const Eo_Class *eo_class_get(const Eo *obj)
    const char *eo_class_name_get(const Eo_Class *klass)

    void eo_parent_set(Eo *parent)
    Eo  *eo_parent_get()

    void eo_event_callback_forwarder_add(const Eo_Event_Description *desc, Eo *new_obj)
    void eo_event_callback_forwarder_del(const Eo_Event_Description *desc, Eo *new_obj)

    void eo_event_freeze()
    void eo_event_thaw()
    int eo_event_freeze_count_get()

    void eo_event_global_freeze()
    void eo_event_global_thaw()
    int eo_event_global_freeze_count_get()

    void eo_event_callback_add(const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)
    void eo_event_callback_del(const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)

    Eina_Iterator * eo_children_iterator_new()
