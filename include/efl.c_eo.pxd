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


    ####################################################################
    # Structures
    #
    ctypedef struct Eo
    ctypedef Eo Eo_Base

    ctypedef struct Eo_Class

    ctypedef struct _Eo_Event_Description:
        const char *name # name of the event.
        Eina_Bool unfreezable # Eina_True if the event cannot be frozen.
        Eina_Bool legacy_is # Internal use: if is a legacy event.
    ctypedef _Eo_Event_Description Eo_Event_Description

    ctypedef struct _Eo_Event:
        Eo_Base *obj # The object the event was called on. */
        const Eo_Event_Description *desc # The event description. */
        void *event_info # Extra event information passed by the event caller. */
    ctypedef _Eo_Event Eo_Event


    ####################################################################
    # Eo Events
    #

    cdef const Eo_Event_Description *EO_EVENT_DEL


    ####################################################################
    # Other typedefs
    #
    ctypedef void (*Eo_Event_Cb)(void *data, const Eo_Event *event)

    ctypedef void (*eo_key_data_free_func)(void *)


    ####################################################################
    # Functions
    #
    int eo_init()
    int eo_shutdown()

    Eo *eo_add(const Eo_Class *klass, Eo *parent, ...)
    void eo_del(const Eo *obj)
    Eo *eo_ref(const Eo *obj)
    void eo_unref(const Eo *obj)
    int eo_ref_get(const Eo *obj)

    void eo_wref_add(Eo **wref)

    const Eo_Class *eo_base_class_get()

    void  eo_key_data_set(Eo *obj, const char *key, const void *data)
    void *eo_key_data_get(Eo *obj, const char *key)

    const Eo_Class *eo_class_get(const Eo *obj)
    const char *eo_class_name_get(const Eo_Class *klass)

    void eo_parent_set(Eo *obj, Eo *parent)
    Eo  *eo_parent_get(const Eo *obj)

    void eo_event_callback_stop(Eo *obj)
    void eo_event_callback_forwarder_add(Eo *obj, const Eo_Event_Description *desc, Eo *new_obj)
    void eo_event_callback_forwarder_del(Eo *obj, const Eo_Event_Description *desc, Eo *new_obj)

    void eo_event_freeze(Eo *obj)
    void eo_event_thaw(Eo *obj)
    int eo_event_freeze_count_get(const Eo *obj)

    void eo_event_global_freeze(Eo *obj)
    void eo_event_global_thaw(Eo *obj)
    int eo_event_global_freeze_count_get(const Eo *obj)

    Eina_Bool eo_event_callback_add(Eo *obj, const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)
    Eina_Bool eo_event_callback_del(Eo *obj, const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)

    Eina_Iterator * eo_children_iterator_new(Eo *obj)
