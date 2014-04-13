from efl.evas cimport Evas_Object

cdef extern from "Elementary.h":
    Evas_Object *   elm_layout_add(Evas_Object *parent)
