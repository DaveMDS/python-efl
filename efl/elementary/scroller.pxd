from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord
from enums cimport Elm_Scroller_Policy
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_scroller_add(Evas_Object *parent)
    void                     elm_scroller_custom_widget_base_theme_set(Evas_Object *obj, const_char *widget, const_char *base)
    void                     elm_scroller_content_min_limit(Evas_Object *obj, Eina_Bool w, Eina_Bool h)
    void                     elm_scroller_region_show(Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void                     elm_scroller_policy_set(Evas_Object *obj, Elm_Scroller_Policy policy_h, Elm_Scroller_Policy policy_v)
    void                     elm_scroller_policy_get(Evas_Object *obj, Elm_Scroller_Policy *policy_h, Elm_Scroller_Policy *policy_v)
    void                     elm_scroller_region_get(Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)
    void                     elm_scroller_child_size_get(Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                     elm_scroller_bounce_set(Evas_Object *obj, Eina_Bool h_bounce, Eina_Bool v_bounce)
    void                     elm_scroller_bounce_get(Evas_Object *obj, Eina_Bool *h_bounce, Eina_Bool *v_bounce)
    void                     elm_scroller_page_relative_set(Evas_Object *obj, double h_pagerel, double v_pagerel)
    void                     elm_scroller_page_relative_get(Evas_Object *obj, double *h_pagerel, double *v_pagerel)
    void                     elm_scroller_page_size_set(Evas_Object *obj, Evas_Coord h_pagesize, Evas_Coord v_pagesize)
    void                     elm_scroller_current_page_get(Evas_Object *obj, int *h_pagenumber, int *v_pagenumber)
    void                     elm_scroller_last_page_get(Evas_Object *obj, int *h_pagenumber, int *v_pagenumber)
    void                     elm_scroller_page_show(Evas_Object *obj, int h_pagenumber, int v_pagenumber)
    void                     elm_scroller_page_bring_in(Evas_Object *obj, int h_pagenumber, int v_pagenumber)
    void                     elm_scroller_region_bring_in(Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void                     elm_scroller_propagate_events_set(Evas_Object *obj, Eina_Bool propagation)
    Eina_Bool                elm_scroller_propagate_events_get(Evas_Object *obj)
    void                     elm_scroller_gravity_set(Evas_Object *obj, double x, double y)
    void                     elm_scroller_gravity_get(Evas_Object *obj, double *x, double *y)

