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
#

from efl.evas cimport Eina_List, Eina_Bool
from efl.evas cimport Evas_Object, Evas_Font_Size, Evas_Coord
from efl.evas cimport Evas_Callback_Type


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
        const char *tm_zone

cdef extern from "Ecore.h":
    ctypedef void (*Ecore_Cb)(void *data)

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const char *emission, const char *source)

cdef extern from "Elementary.h":

    #define
    cpdef enum:
        ELM_EVENT_SYS_NOTIFY_NOTIFICATION_CLOSED
        ELM_EVENT_SYS_NOTIFY_ACTION_INVOKED

    #enums
    cpdef enum Elm_Policy:
        ELM_POLICY_QUIT
        ELM_POLICY_EXIT
        ELM_POLICY_THROTTLE
        ELM_POLICY_LAST
    ctypedef enum Elm_Policy:
        pass

    cpdef enum Elm_Policy_Quit:
        ELM_POLICY_QUIT_NONE
        ELM_POLICY_QUIT_LAST_WINDOW_CLOSED
    ctypedef enum Elm_Policy_Quit:
        pass

    cpdef enum Elm_Policy_Exit:
        ELM_POLICY_EXIT_NONE
        ELM_POLICY_EXIT_WINDOWS_DEL
    ctypedef enum Elm_Policy_Exit:
        pass

    cpdef enum Elm_Policy_Throttle:
        ELM_POLICY_THROTTLE_CONFIG
        ELM_POLICY_THROTTLE_HIDDEN_ALWAYS
        ELM_POLICY_THROTTLE_NEVER
    ctypedef enum Elm_Policy_Throttle:
        pass

    cpdef enum Elm_Sys_Notify_Closed_Reason:
        ELM_SYS_NOTIFY_CLOSED_EXPIRED
        ELM_SYS_NOTIFY_CLOSED_DISMISSED
        ELM_SYS_NOTIFY_CLOSED_REQUESTED
        ELM_SYS_NOTIFY_CLOSED_UNDEFINED
    ctypedef enum Elm_Sys_Notify_Closed_Reason:
        pass

    cpdef enum Elm_Sys_Notify_Urgency:
        ELM_SYS_NOTIFY_URGENCY_LOW
        ELM_SYS_NOTIFY_URGENCY_NORMAL
        ELM_SYS_NOTIFY_URGENCY_CRITICAL
    ctypedef enum Elm_Sys_Notify_Urgency:
        pass

    cpdef enum Elm_Glob_Match_Flags:
        ELM_GLOB_MATCH_NO_ESCAPE
        ELM_GLOB_MATCH_PATH
        ELM_GLOB_MATCH_PERIOD
        ELM_GLOB_MATCH_NOCASE
    ctypedef enum Elm_Glob_Match_Flags:
        pass

    cpdef enum Elm_Process_State:
        ELM_PROCESS_STATE_FOREGROUND
        ELM_PROCESS_STATE_BACKGROUND
    ctypedef enum Elm_Process_State:
        pass

    #colors
    ctypedef struct Elm_Color_RGBA:
        unsigned int r
        unsigned int g
        unsigned int b
        unsigned int a

    ctypedef struct _Elm_Custom_Palette:
        const char *palette_name
        Eina_List *color_list

    #event
    ctypedef Eina_Bool      (*Elm_Event_Cb)                 (void *data, Evas_Object *obj, Evas_Object *src, Evas_Callback_Type t, void *event_info)

    #font
    ctypedef struct Elm_Font_Overlay:
        const char *text_class
        const char *font
        Evas_Font_Size size

    #text
    ctypedef struct Elm_Text_Class:
        const char *name
        const char *desc

    ctypedef struct Elm_Font_Properties:
        const char *name
        Eina_List  *styles

    #tooltip
    ctypedef Evas_Object *  (*Elm_Tooltip_Content_Cb)       (void *data, Evas_Object *obj, Evas_Object *tooltip)
    ctypedef Evas_Object *  (*Elm_Tooltip_Item_Content_Cb)  (void *data, Evas_Object *obj, Evas_Object *tooltip, void *item)

    # General
    int                     elm_init(int argc, char** argv)
    int                     elm_shutdown()
    void                    elm_run() nogil
    void                    elm_exit()
    Elm_Process_State       elm_process_state_get()

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
    void                    elm_language_set(const char *lang)

    # Cache
    void                    elm_cache_all_flush()

    # Finger
    void                    elm_coords_finger_size_adjust(int times_w, Evas_Coord *w, int times_h, Evas_Coord *h)

    # Font (elm_font.h)
    Elm_Font_Properties *   elm_font_properties_get(const char *font)
    void                    elm_font_properties_free(Elm_Font_Properties *efp)
    char *                  elm_font_fontconfig_name_get(const char *name, const char *style)
    void                    elm_font_fontconfig_name_free(char *name)
    # TODO: Eina_Hash *             elm_font_available_hash_add(Eina_List *list)
    # TODO: void                    elm_font_available_hash_del(Eina_Hash *hash)

    # Debug
    void elm_object_tree_dump(const Evas_Object *top)
    void elm_object_tree_dot_dump(const Evas_Object *top, const char *file)

    # sys_notify.h
    ctypedef void (*Elm_Sys_Notify_Send_Cb)(void *data, unsigned int id)

    ctypedef struct Elm_Sys_Notify_Notification_Closed:
        unsigned int id # ID of the notification.
        Elm_Sys_Notify_Closed_Reason reason # The Reason the notification was closed.

    ctypedef struct Elm_Sys_Notify_Action_Invoked:
        unsigned int id # ID of the notification.
        char *action_key # The key of the action invoked. These match the keys sent over in the list of actions.

    void      elm_sys_notify_close(unsigned int id)
    void      elm_sys_notify_send(  unsigned int replaces_id,
                                    const char *icon,
                                    const char *summary,
                                    const char *body,
                                    Elm_Sys_Notify_Urgency urgency,
                                    int timeout,
                                    Elm_Sys_Notify_Send_Cb cb,
                                    const void *cb_data)


cdef int PY_EFL_ELM_LOG_DOMAIN
