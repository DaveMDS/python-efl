from efl.evas cimport Eina_Bool

cdef extern from "Elementary.h":
    Eina_Bool                elm_need_efreet()
    Eina_Bool                elm_need_systray()
    Eina_Bool                elm_need_sys_notify()
    Eina_Bool                elm_need_eldbus()
    Eina_Bool                elm_need_elocation()
    Eina_Bool                elm_need_ethumb()
    Eina_Bool                elm_need_web()
