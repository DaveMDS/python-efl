from efl.c_eo cimport Eo as cEo, Eo_Class, eo_add
from efl.eina cimport Eina_Rectangle, Eina_Compare_Cb, \
    eina_list_free, eina_list_append, eina_stringshare_del
from efl.evas cimport Eina_List, Eina_Bool, Evas_Object, Evas_Font_Size, \
    Evas_Coord, Evas_Callback_Type, Evas_Smart_Cb, Evas_Event_Flags, \
    Evas_Load_Error, Evas_Image_Orient, \
    evas_object_smart_callback_add
from efl.evas.enums cimport EVAS_EVENT_FLAG_NONE, EVAS_CALLBACK_KEY_DOWN, \
    EVAS_CALLBACK_KEY_UP, EVAS_CALLBACK_MOUSE_WHEEL

from efl.ecore cimport Ecore_Pos_Map

from efl.elementary.enums cimport Elm_Process_State, Elm_Sys_Notify_Urgency, \
    Elm_Policy, Elm_Policy_Quit, Elm_Policy_Exit, Elm_Policy_Throttle


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
    struct _Elm_Event_Policy_Changed:
        unsigned int policy # the policy identifier
        int          new_value # value the policy had before the change
        int          old_value # new value the policy got
    ctypedef _Elm_Event_Policy_Changed Elm_Event_Policy_Changed

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

    void      elm_sys_notify_close(unsigned int id)
    void      elm_sys_notify_send(  unsigned int replaces_id,
                                    const char *icon,
                                    const char *summary,
                                    const char *body,
                                    Elm_Sys_Notify_Urgency urgency,
                                    int timeout,
                                    Elm_Sys_Notify_Send_Cb cb,
                                    const void *cb_data)
