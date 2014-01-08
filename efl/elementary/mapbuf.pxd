from efl.evas cimport Eina_Bool, Evas_Object, const_Evas_Object

cdef extern from "Elementary.h":
    Evas_Object             *elm_mapbuf_add(Evas_Object *parent)
    void                     elm_mapbuf_enabled_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool                elm_mapbuf_enabled_get(const_Evas_Object *obj)
    void                     elm_mapbuf_smooth_set(Evas_Object *obj, Eina_Bool smooth)
    Eina_Bool                elm_mapbuf_smooth_get(const_Evas_Object *obj)
    void                     elm_mapbuf_alpha_set(Evas_Object *obj, Eina_Bool alpha)
    Eina_Bool                elm_mapbuf_alpha_get(const_Evas_Object *obj)
    void                     elm_mapbuf_auto_set(Evas_Object *obj, Eina_Bool on)
    Eina_Bool                elm_mapbuf_auto_get(const_Evas_Object *obj)
    void                     elm_mapbuf_point_color_get(Evas_Object *obj, int idx, int *r, int *g, int *b, int *a)
    void                     elm_mapbuf_point_color_set(Evas_Object *obj, int idx, int r, int g, int b, int a)
