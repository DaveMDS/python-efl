from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord
from enums cimport Elm_Bg_Option
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_bg_add(Evas_Object *parent)
    Eina_Bool                elm_bg_file_set(Evas_Object *obj, const_char *file, const_char *group)
    void                     elm_bg_file_get(Evas_Object *obj, const_char **file, const_char **group)
    void                     elm_bg_option_set(Evas_Object *obj, Elm_Bg_Option option)
    Elm_Bg_Option            elm_bg_option_get(Evas_Object *obj)
    void                     elm_bg_color_set(Evas_Object *obj, int r, int g, int b)
    void                     elm_bg_color_get(Evas_Object *obj, int *r, int *g, int *b)
    void                     elm_bg_load_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
