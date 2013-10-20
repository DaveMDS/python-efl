from efl.evas cimport Evas_Object
from object_item cimport Elm_Object_Item
from enums cimport Elm_Colorselector_Mode
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object *           elm_colorselector_add(Evas_Object *parent)
    void                    elm_colorselector_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                    elm_colorselector_color_get(Evas_Object *obj, int *r, int *g, int *b, int *a)
    void                    elm_colorselector_mode_set(Evas_Object *obj, Elm_Colorselector_Mode mode)
    Elm_Colorselector_Mode  elm_colorselector_mode_get(Evas_Object *obj)
    void                    elm_colorselector_palette_item_color_get(Elm_Object_Item *it, int *r, int *g, int *b, int *a)
    void                    elm_colorselector_palette_item_color_set(Elm_Object_Item *it, int r, int g, int b, int a)
    Elm_Object_Item *       elm_colorselector_palette_color_add(Evas_Object *obj, int r, int g, int b, int a)
    void                    elm_colorselector_palette_clear(Evas_Object *obj)
    void                    elm_colorselector_palette_name_set(Evas_Object *obj, const_char *palette_name)
    const_char *            elm_colorselector_palette_name_get(Evas_Object *obj)
