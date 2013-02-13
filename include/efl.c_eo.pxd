# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

from efl cimport *

cdef extern from "Eo.h":
    ####################################################################
    # Basic Types
    #


    ####################################################################
    # Enumerations
    #


    ####################################################################
    # Structures
    #
    ctypedef struct Eo
    ctypedef Eo const_Eo "const Eo"

    ctypedef struct Eo_Class
    ctypedef Eo_Class const_Eo_Class "const Eo_Class"

    ctypedef struct Eo_Event_Description:
        const_char_ptr name
        const_char_ptr doc

    ctypedef Eo_Event_Description const_Eo_Event_Description "const Eo_Event_Description"

    ####################################################################
    # Eo Events
    #
    cdef const_Eo_Event_Description *EO_EV_DEL

    ####################################################################
    # Other typedefs
    #
    ctypedef Eina_Bool (*Eo_Event_Cb)(void *data, Eo *obj, const_Eo_Event_Description *desc, void *event_info)

    ctypedef void (*eo_base_data_free_func)(void *)


    ####################################################################
    # Functions
    #
    int eo_init()
    int eo_shutdown()

    Eo *eo_add(const_Eo_Class *klass, Eo *parent, ...)
    Eo *eo_ref(const_Eo *obj)
    void eo_unref(const_Eo *obj)
    int eo_ref_get(const_Eo *obj)
    void eo_del(const_Eo *obj)

    void eo_wref_add(Eo *obj)

    Eina_Bool eo_do(Eo *obj, ...)
    void eo_base_data_set(const_char_ptr key, const_void *data, eo_base_data_free_func free_func)
    void eo_base_data_get(const_char_ptr key, void **data)
    void eo_base_data_del(const_char_ptr key)

    const_Eo_Class *eo_class_get(const_Eo *obj)
    const_char_ptr eo_class_name_get(const_Eo_Class *klass)

    Eo *eo_parent_get(const_Eo *obj)

    void eo_event_callback_add(const_Eo_Event_Description *desc, Eo_Event_Cb cb, const_void *data)
    void eo_event_callback_del(const_Eo_Event_Description *desc, Eo_Event_Cb cb, const_void *data)

