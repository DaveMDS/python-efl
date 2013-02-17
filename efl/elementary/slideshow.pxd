from efl.evas cimport Eina_Bool, Eina_Compare_Cb, const_Eina_List, Evas_Object
from object_item cimport Elm_Object_Item, ObjectItem
from libc.string cimport const_char

cdef extern from *:
    ctypedef void const_void "const void"

cdef extern from "Elementary.h":

    ctypedef Evas_Object    *(*SlideshowItemGetFunc)        (void *data, Evas_Object *obj)
    ctypedef void            (*SlideshowItemDelFunc)        (void *data, Evas_Object *obj)

    ctypedef struct Elm_Slideshow_Item_Class_Func:
        SlideshowItemGetFunc get
        SlideshowItemDelFunc del_ "del"

    ctypedef struct Elm_Slideshow_Item_Class:
        Elm_Slideshow_Item_Class_Func func

    Evas_Object             *elm_slideshow_add(Evas_Object *parent)
    Elm_Object_Item         *elm_slideshow_item_add(Evas_Object *obj, Elm_Slideshow_Item_Class *itc, void *data)
    Elm_Object_Item         *elm_slideshow_item_sorted_insert(Evas_Object *obj, Elm_Slideshow_Item_Class *itc, void *data, Eina_Compare_Cb func)
    void                     elm_slideshow_item_show(Elm_Object_Item *it)
    void                     elm_slideshow_next(Evas_Object *obj)
    void                     elm_slideshow_previous(Evas_Object *obj)
    const_Eina_List         *elm_slideshow_transitions_get(Evas_Object *obj)
    void                     elm_slideshow_transition_set(Evas_Object *obj, const_char *transition)
    const_char *             elm_slideshow_transition_get(Evas_Object *obj)
    void                     elm_slideshow_timeout_set(Evas_Object *obj, double timeout)
    double                   elm_slideshow_timeout_get(Evas_Object *obj)
    void                     elm_slideshow_loop_set(Evas_Object *obj, Eina_Bool loop)
    Eina_Bool                elm_slideshow_loop_get(Evas_Object *obj)
    void                     elm_slideshow_clear(Evas_Object *obj)
    const_Eina_List         *elm_slideshow_items_get(Evas_Object *obj)
    Elm_Object_Item         *elm_slideshow_item_current_get(Evas_Object *obj)
    Evas_Object             *elm_slideshow_item_object_get(Elm_Object_Item *it)
    Elm_Object_Item         *elm_slideshow_item_nth_get(Evas_Object *obj, unsigned int nth)
    void                     elm_slideshow_layout_set(Evas_Object *obj, const_char *layout)
    const_char *             elm_slideshow_layout_get(Evas_Object *obj)
    const_Eina_List         *elm_slideshow_layouts_get(Evas_Object *obj)
    void                     elm_slideshow_cache_before_set(Evas_Object *obj, int count)
    int                      elm_slideshow_cache_before_get(Evas_Object *obj)
    void                     elm_slideshow_cache_after_set(Evas_Object *obj, int count)
    int                      elm_slideshow_cache_after_get(Evas_Object *obj)
    unsigned int             elm_slideshow_count_get(Evas_Object *obj)

