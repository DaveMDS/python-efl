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

from efl.eina cimport Eina_Bool

cdef extern from "Eo.h":
    ####################################################################
    # Structures
    #
    ctypedef struct Eo

    ctypedef struct Eo_Class

    ctypedef struct Eo_Event_Description:
        const char *name
        const char *doc

    ctypedef unsigned int Eo_Op

    ctypedef Eo_Op EO_BASE_BASE_ID

    ####################################################################
    # Eo Events
    #
    cdef const Eo_Event_Description *EO_EV_DEL

    ####################################################################
    # Other typedefs
    #
    ctypedef Eina_Bool (*Eo_Event_Cb)(void *data, Eo *obj, const Eo_Event_Description *desc, void *event_info)

    ctypedef void (*eo_base_data_free_func)(void *)


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

    Eo_Op eo_wref_add(Eo *obj)

    Eina_Bool eo_do(Eo *obj, ...)
    Eina_Bool eo_class_do(Eo_Class *cls, ...)
    const Eo_Class *eo_base_class_get()

    Eo_Op eo_base_data_set(const char *key, const void *data, eo_base_data_free_func free_func)
    Eo_Op eo_base_data_get(const char *key, void **data)
    Eo_Op eo_base_data_del(const char *key)

    const Eo_Class *eo_class_get(const Eo *obj)
    const char *eo_class_name_get(const Eo_Class *klass)

    Eo_Op eo_parent_set(Eo *parent)
    Eo_Op eo_parent_get(Eo **parent)

    Eo_Op eo_event_callback_forwarder_add(const Eo_Event_Description *desc, Eo *new_obj)
    Eo_Op eo_event_callback_forwarder_del(const Eo_Event_Description *desc, Eo *new_obj)

    Eo_Op eo_event_freeze()
    Eo_Op eo_event_thaw()
    Eo_Op eo_event_freeze_get(int *fcount)

    Eo_Op eo_event_global_freeze()
    Eo_Op eo_event_global_thaw()
    Eo_Op eo_event_global_freeze_get(int *fcount)

    Eo_Op eo_event_callback_add(const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)
    Eo_Op eo_event_callback_del(const Eo_Event_Description *desc, Eo_Event_Cb cb, const void *data)
