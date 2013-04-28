from efl.evas cimport Eina_Bool, Evas_Object, Evas_Coord, const_Evas_Object
from enums cimport Elm_Scroller_Policy, Elm_Scroller_Single_Direction
from libc.string cimport const_char
from object cimport Object

cdef extern from "Elementary.h":
    Evas_Object             *elm_scroller_add(Evas_Object *parent)
    void                     elm_scroller_custom_widget_base_theme_set(Evas_Object *obj, const_char *widget, const_char *base)
    void                     elm_scroller_content_min_limit(Evas_Object *obj, Eina_Bool w, Eina_Bool h)
    void                     elm_scroller_region_show(Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void                     elm_scroller_policy_set(Evas_Object *obj, Elm_Scroller_Policy policy_h, Elm_Scroller_Policy policy_v)
    void                     elm_scroller_policy_get(Evas_Object *obj, Elm_Scroller_Policy *policy_h, Elm_Scroller_Policy *policy_v)
    void                    elm_scroller_single_direction_set(Evas_Object *obj, Elm_Scroller_Single_Direction single_dir)
    Elm_Scroller_Single_Direction elm_scroller_single_direction_get(const_Evas_Object *obj)
    void                     elm_scroller_region_get(Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)
    void                     elm_scroller_child_size_get(Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                     elm_scroller_bounce_set(Evas_Object *obj, Eina_Bool h_bounce, Eina_Bool v_bounce)
    void                     elm_scroller_bounce_get(Evas_Object *obj, Eina_Bool *h_bounce, Eina_Bool *v_bounce)
    void                     elm_scroller_page_relative_set(Evas_Object *obj, double h_pagerel, double v_pagerel)
    void                     elm_scroller_page_relative_get(Evas_Object *obj, double *h_pagerel, double *v_pagerel)
    void                     elm_scroller_page_size_set(Evas_Object *obj, Evas_Coord h_pagesize, Evas_Coord v_pagesize)
    void                     elm_scroller_page_size_get(const_Evas_Object *obj, Evas_Coord *h_pagesize, Evas_Coord *v_pagesize)
    void                     elm_scroller_page_scroll_limit_set(const_Evas_Object *obj, Evas_Coord page_limit_h, Evas_Coord page_limit_v)
    void                     elm_scroller_page_scroll_limit_get(const_Evas_Object *obj, Evas_Coord *page_limit_h, Evas_Coord *page_limit_v)
    void                     elm_scroller_current_page_get(Evas_Object *obj, int *h_pagenumber, int *v_pagenumber)
    void                     elm_scroller_last_page_get(Evas_Object *obj, int *h_pagenumber, int *v_pagenumber)
    void                     elm_scroller_page_show(Evas_Object *obj, int h_pagenumber, int v_pagenumber)
    void                     elm_scroller_page_bring_in(Evas_Object *obj, int h_pagenumber, int v_pagenumber)
    void                     elm_scroller_region_bring_in(Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void                     elm_scroller_propagate_events_set(Evas_Object *obj, Eina_Bool propagation)
    Eina_Bool                elm_scroller_propagate_events_get(Evas_Object *obj)
    void                     elm_scroller_gravity_set(Evas_Object *obj, double x, double y)
    void                     elm_scroller_gravity_get(Evas_Object *obj, double *x, double *y)

cdef class ScrollableInterface(Object):
    cpdef single_direction_set(self, Elm_Scroller_Single_Direction single_dir)
    cpdef single_direction_get(self)
    cpdef page_size_set(self, h_pagesize, v_pagesize)
    cpdef page_size_get(self)
    cpdef page_scroll_limit_set(self, int page_limit_h, int page_limit_v)
    cpdef page_scroll_limit_get(self)
