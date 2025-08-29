cdef extern from "Elementary.h":
    Evas_Object             *elm_win_inwin_add(Evas_Object *obj)
    void                     elm_win_inwin_activate(Evas_Object *obj)
    void                     elm_win_inwin_content_set(Evas_Object *obj, Evas_Object *content)
    Evas_Object             *elm_win_inwin_content_get(const Evas_Object *obj)
    Evas_Object             *elm_win_inwin_content_unset(Evas_Object *obj)
