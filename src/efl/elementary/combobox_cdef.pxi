cdef extern from "Elementary.h":

    ctypedef cEo Elm_Combobox

    Evas_Object *  elm_combobox_add(Evas_Object *parent)
    Eina_Bool      elm_combobox_expanded_get(const Elm_Combobox *obj)
    void           elm_combobox_hover_begin(Elm_Combobox *obj)
    void           elm_combobox_hover_end(Elm_Combobox *obj)

