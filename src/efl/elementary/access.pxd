from efl.evas cimport Evas_Object
from object_item cimport Elm_Object_Item

cdef extern from "Elementary.h":
    ctypedef char *(*Elm_Access_Info_Cb)(void *data, Evas_Object *obj)
    ctypedef void (*Elm_Access_Activate_Cb)(void *data, Evas_Object *part_obj, Elm_Object_Item *item)

    Evas_Object *       elm_access_object_register(Evas_Object *obj, Evas_Object *parent)
    void                elm_access_info_set(Evas_Object *obj, int type, const char *text)
    char *              elm_access_info_get(const Evas_Object *obj, int type)
    # TODO: void                elm_access_info_cb_set(Evas_Object *obj, int type, Elm_Access_Info_Cb func, const void *data)
    # TODO: void                elm_access_activate_cb_set(Evas_Object *obj, Elm_Access_Activate_Cb func, void *data)
    void                    elm_access_highlight_set(Evas_Object* obj)

    Evas_Object *   elm_object_item_access_register(Elm_Object_Item *item)
