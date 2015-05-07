cdef extern from "Elementary.h":

    cpdef enum Elm_Icon_Lookup_Order:
        ELM_ICON_LOOKUP_FDO_THEME
        ELM_ICON_LOOKUP_THEME_FDO
        ELM_ICON_LOOKUP_FDO
        ELM_ICON_LOOKUP_THEME
    ctypedef enum Elm_Icon_Lookup_Order:
        pass

    cpdef enum Elm_Icon_Type:
        ELM_ICON_NONE
        ELM_ICON_FILE
        ELM_ICON_STANDARD
    ctypedef enum Elm_Icon_Type:
        pass


    Evas_Object *           elm_icon_add(Evas_Object *parent)
    void                    elm_icon_thumb_set(Evas_Object *obj, const char *file, const char *group)
    Eina_Bool               elm_icon_standard_set(Evas_Object *obj, const char *name)
    const char *            elm_icon_standard_get(const Evas_Object *obj)
    void                    elm_icon_order_lookup_set(Evas_Object *obj, Elm_Icon_Lookup_Order order)
    Elm_Icon_Lookup_Order   elm_icon_order_lookup_get(const Evas_Object *obj)

