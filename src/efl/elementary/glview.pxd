from efl.eina cimport Eina_Bool
from efl.evas cimport Evas_Object, Evas_Coord


cdef extern from "Elementary.h":

    cpdef enum Elm_GLView_Mode:
        ELM_GLVIEW_NONE
        ELM_GLVIEW_ALPHA
        ELM_GLVIEW_DEPTH
        ELM_GLVIEW_STENCIL
        ELM_GLVIEW_DIRECT
    ctypedef enum Elm_GLView_Mode:
        pass

    cpdef enum Elm_GLView_Resize_Policy:
        ELM_GLVIEW_RESIZE_POLICY_RECREATE
        ELM_GLVIEW_RESIZE_POLICY_SCALE
    ctypedef enum Elm_GLView_Resize_Policy:
        pass

    cpdef enum Elm_GLView_Render_Policy:
        ELM_GLVIEW_RENDER_POLICY_ON_DEMAND
        ELM_GLVIEW_RENDER_POLICY_ALWAYS
    ctypedef enum Elm_GLView_Render_Policy:
        pass


    ctypedef struct Evas_GL_API

    ctypedef void (*Elm_GLView_Func_Cb)(Evas_Object *obj)

    Evas_Object *elm_glview_add(Evas_Object *parent)
    Evas_GL_API *elm_glview_gl_api_get(const Evas_Object *obj)
    Eina_Bool    elm_glview_mode_set(Evas_Object *obj, Elm_GLView_Mode mode)
    Eina_Bool    elm_glview_resize_policy_set(Evas_Object *obj, Elm_GLView_Resize_Policy policy)
    Eina_Bool    elm_glview_render_policy_set(Evas_Object *obj, Elm_GLView_Render_Policy policy)
    void         elm_glview_size_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void         elm_glview_size_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void         elm_glview_init_func_set(Evas_Object *obj, Elm_GLView_Func_Cb func)
    void         elm_glview_del_func_set(Evas_Object *obj, Elm_GLView_Func_Cb func)
    void         elm_glview_resize_func_set(Evas_Object *obj, Elm_GLView_Func_Cb func)
    void         elm_glview_render_func_set(Evas_Object *obj, Elm_GLView_Func_Cb func)
    void         elm_glview_changed_set(Evas_Object *obj)
