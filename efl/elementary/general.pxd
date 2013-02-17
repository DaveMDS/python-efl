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
#

from efl.evas cimport Eina_List, Eina_Bool, const_Eina_List
from efl.evas cimport Eina_Rectangle, Eina_Compare_Cb
from efl.evas cimport Evas_Object, const_Evas_Object
from efl.evas cimport Evas_Coord
from efl.evas cimport Evas_Callback_Type, Evas_Smart_Cb
from efl.evas cimport Evas_Font_Size
from efl.evas cimport Evas_Load_Error
from efl.evas cimport Evas_Event_Flags
from enums cimport Elm_Policy, Elm_Policy_Quit

cdef extern from *:
    ctypedef char* const_char_ptr "const char *"
    ctypedef void const_void "const void"

cdef extern from "stdlib.h":
    void free(void *ptr)

cdef extern from "string.h":
    void *memcpy(void *dst, void *src, int n)
    char *strdup(char *str)

cdef extern from "time.h":
    struct tm:
        int tm_sec
        int tm_min
        int tm_hour
        int tm_mday
        int tm_mon
        int tm_year
        int tm_wday
        int tm_yday
        int tm_isdst

        long int tm_gmtoff
        const_char_ptr tm_zone

cdef extern from "Python.h":
    ctypedef struct PyTypeObject:
        PyTypeObject *ob_type

cdef extern from "Ecore.h":
    ctypedef void (*Ecore_Cb)(void *data)

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const_char_ptr emission, const_char_ptr source)

cdef extern from "Elementary.h":

    # types & structs

    #colors
    ctypedef struct Elm_Color_RGBA:
        unsigned int r
        unsigned int g
        unsigned int b
        unsigned int a

    ctypedef struct _Elm_Custom_Palette:
        const_char_ptr palette_name
        Eina_List *color_list

    #event
    ctypedef Eina_Bool       (*Elm_Event_Cb)                (void *data, Evas_Object *obj, Evas_Object *src, Evas_Callback_Type t, void *event_info)

    #font
    ctypedef struct Elm_Font_Overlay:
        const_char_ptr text_class
        const_char_ptr font
        Evas_Font_Size size

    #text
    ctypedef struct Elm_Text_Class:
        const_char_ptr name
        const_char_ptr desc

    #tooltip
    ctypedef Evas_Object    *(*Elm_Tooltip_Content_Cb)      (void *data, Evas_Object *obj, Evas_Object *tooltip)
    ctypedef Evas_Object    *(*Elm_Tooltip_Item_Content_Cb) (void *data, Evas_Object *obj, Evas_Object *tooltip, void *item)


    # General
    void                     elm_init(int argc, char** argv)
    void                     elm_shutdown()
    void                     elm_run() nogil
    void                     elm_exit()

    # General - Quicklaunch (XXX: Only used by macros?)
    void                     elm_quicklaunch_init(int argc, char **argv)
    void                     elm_quicklaunch_sub_init(int argc, char **argv)
    void                     elm_quicklaunch_sub_shutdown()
    void                     elm_quicklaunch_shutdown()
    void                     elm_quicklaunch_seed()
    Eina_Bool                elm_quicklaunch_prepare(int argc, char **argv)
    Eina_Bool                elm_quicklaunch_fork(int argc, char **argv, char *cwd, void (*postfork_func) (void *data), void *postfork_data)
    void                     elm_quicklaunch_cleanup()
    int                      elm_quicklaunch_fallback(int argc, char **argv)
    char                    *elm_quicklaunch_exe_path_get(char *exe)

    # General - Policy
    Eina_Bool                elm_policy_set(unsigned int policy, int value)
    int                      elm_policy_get(unsigned int policy)

    # General - Language    (py3: TODO)
    void                     elm_language_set(const_char_ptr lang)

    # Finger
    void                     elm_coords_finger_size_adjust(int times_w, Evas_Coord *w, int times_h, Evas_Coord *h)

#cdef int PY_REFCOUNT(object o)
#cdef _METHOD_DEPRECATED(self, replacement=*, message=*)
#cdef inline unicode _touni(char* s)
#cdef inline unicode _ctouni(const_char_ptr s)
#cdef inline char* _fruni(s)
#cdef inline const_char_ptr _cfruni(s)
