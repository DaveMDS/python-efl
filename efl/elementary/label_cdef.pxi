from efl.elementary.enums cimport Elm_Wrap_Type, Elm_Label_Slide_Mode

cdef extern from "Elementary.h":
    Evas_Object          *elm_label_add(Evas_Object *parent)
    void                  elm_label_line_wrap_set(Evas_Object *obj, Elm_Wrap_Type wrap)
    Elm_Wrap_Type         elm_label_line_wrap_get(const Evas_Object *obj)
    void                  elm_label_wrap_width_set(Evas_Object *obj, Evas_Coord w)
    Evas_Coord            elm_label_wrap_width_get(const Evas_Object *obj)
    void                  elm_label_ellipsis_set(Evas_Object *obj, Eina_Bool ellipsis)
    Eina_Bool             elm_label_ellipsis_get(const Evas_Object *obj)
    void                  elm_label_slide_duration_set(Evas_Object *obj, double duration)
    double                elm_label_slide_duration_get(const Evas_Object *obj)
    void                  elm_label_slide_speed_set(Evas_Object *obj, double speed)
    double                elm_label_slide_speed_get(const Evas_Object *obj)
# TODO:    void                    elm_label_slide_area_limit_set(Evas_Object *obj, Eina_Bool limit)
    void                  elm_label_slide_mode_set(Evas_Object *obj, Elm_Label_Slide_Mode mode)
    Elm_Label_Slide_Mode  elm_label_slide_mode_get(const Evas_Object *obj)
    void                  elm_label_slide_go(Evas_Object *obj)
