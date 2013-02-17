from efl.evas cimport Eina_Bool, Evas_Object
from enums cimport Elm_Fileselector_Mode
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object *           elm_fileselector_add(Evas_Object *parent)
    void                    elm_fileselector_is_save_set(Evas_Object *obj, Eina_Bool is_save)
    Eina_Bool               elm_fileselector_is_save_get(Evas_Object *obj)
    void                    elm_fileselector_folder_only_set(Evas_Object *obj, Eina_Bool value)
    Eina_Bool               elm_fileselector_folder_only_get(Evas_Object *obj)
    void                    elm_fileselector_buttons_ok_cancel_set(Evas_Object *obj, Eina_Bool value)
    Eina_Bool               elm_fileselector_buttons_ok_cancel_get(Evas_Object *obj)
    void                    elm_fileselector_expandable_set(Evas_Object *obj, Eina_Bool value)
    Eina_Bool               elm_fileselector_expandable_get(Evas_Object *obj)
    void                    elm_fileselector_path_set(Evas_Object *obj, const_char *path)
    const_char *            elm_fileselector_path_get(Evas_Object *obj)
    Eina_Bool               elm_fileselector_selected_set(Evas_Object *obj, const_char *path)
    const_char *            elm_fileselector_selected_get(Evas_Object *obj)
    void                    elm_fileselector_mode_set(Evas_Object *obj, Elm_Fileselector_Mode mode)
    Elm_Fileselector_Mode   elm_fileselector_mode_get(Evas_Object *obj)

