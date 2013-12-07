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
#

from efl.evas cimport Eina_List, Eina_Bool, const_Eina_List
from efl.evas cimport Evas_Object, const_Evas_Object, Evas_Smart_Cb, \
    Evas_Font_Size, Evas_Coord
from efl.evas.enums cimport Evas_Callback_Type
#from efl.evas cimport Evas_Load_Error
#from efl.evas cimport Evas_Event_Flags
from enums cimport Elm_Policy, Elm_Policy_Quit
from libc.string cimport const_char, memcpy, strdup
from libc.stdlib cimport const_void, free

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
        const_char *tm_zone

cdef extern from "Ecore.h":
    ctypedef void (*Ecore_Cb)(void *data)

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const_char *emission, const_char *source)

cdef extern from "Elementary.h":
    #colors
    ctypedef struct Elm_Color_RGBA:
        unsigned int r
        unsigned int g
        unsigned int b
        unsigned int a

    ctypedef struct _Elm_Custom_Palette:
        const_char *palette_name
        Eina_List *color_list

    #event
    ctypedef Eina_Bool      (*Elm_Event_Cb)                 (void *data, Evas_Object *obj, Evas_Object *src, Evas_Callback_Type t, void *event_info)

    #font
    ctypedef struct Elm_Font_Overlay:
        const_char *text_class
        const_char *font
        Evas_Font_Size size

    #text
    ctypedef struct Elm_Text_Class:
        const_char *name
        const_char *desc

    ctypedef struct Elm_Font_Properties:
        const_char *name
        Eina_List  *styles

    #tooltip
    ctypedef Evas_Object *  (*Elm_Tooltip_Content_Cb)       (void *data, Evas_Object *obj, Evas_Object *tooltip)
    ctypedef Evas_Object *  (*Elm_Tooltip_Item_Content_Cb)  (void *data, Evas_Object *obj, Evas_Object *tooltip, void *item)

    # General
    int                     elm_init(int argc, char** argv)
    int                     elm_shutdown()
    void                    elm_run() nogil
    void                    elm_exit()

    # General - Quicklaunch (XXX: Only used by macros?)
    # void                     elm_quicklaunch_init(int argc, char **argv)
    # void                     elm_quicklaunch_sub_init(int argc, char **argv)
    # void                     elm_quicklaunch_sub_shutdown()
    # void                     elm_quicklaunch_shutdown()
    # void                     elm_quicklaunch_seed()
    # Eina_Bool                elm_quicklaunch_prepare(int argc, char **argv)
    # Eina_Bool                elm_quicklaunch_fork(int argc, char **argv, char *cwd, void (*postfork_func) (void *data), void *postfork_data)
    # void                     elm_quicklaunch_cleanup()
    # int                      elm_quicklaunch_fallback(int argc, char **argv)
    # char                    *elm_quicklaunch_exe_path_get(char *exe)

    # General - Policy
    Eina_Bool               elm_policy_set(unsigned int policy, int value)
    int                     elm_policy_get(unsigned int policy)

    # General - Language
    void                    elm_language_set(const_char *lang)

    # Cache
    void                    elm_cache_all_flush()

    # Finger
    void                    elm_coords_finger_size_adjust(int times_w, Evas_Coord *w, int times_h, Evas_Coord *h)

    # Font (elm_font.h)
    Elm_Font_Properties *   elm_font_properties_get(const_char *font)
    void                    elm_font_properties_free(Elm_Font_Properties *efp)
    char *                  elm_font_fontconfig_name_get(const_char *name, const_char *style)
    void                    elm_font_fontconfig_name_free(char *name)
    # TODO: Eina_Hash *             elm_font_available_hash_add(Eina_List *list)
    # TODO: void                    elm_font_available_hash_del(Eina_Hash *hash)

    # Debug
    void elm_object_tree_dump(const_Evas_Object *top)
    void elm_object_tree_dot_dump(const_Evas_Object *top, const_char *file)

cdef int PY_EFL_ELM_LOG_DOMAIN
