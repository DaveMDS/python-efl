cdef extern from "Elementary.h":

    ctypedef cEo Elm_Systray

    cpdef enum:
        ELM_EVENT_SYSTRAY_READY

    cpdef enum _Elm_Systray_Category:
        ELM_SYSTRAY_CATEGORY_APP_STATUS
        ELM_SYSTRAY_CATEGORY_COMMUNICATIONS
        ELM_SYSTRAY_CATEGORY_SYS_SERVICES
        ELM_SYSTRAY_CATEGORY_HARDWARE
        ELM_SYSTRAY_CATEGORY_OTHER
    ctypedef _Elm_Systray_Category Elm_Systray_Category

    cpdef enum _Elm_Systray_Status:
        ELM_SYSTRAY_STATUS_PASSIVE
        ELM_SYSTRAY_STATUS_ACTIVE
        ELM_SYSTRAY_STATUS_ATTENTION
    ctypedef _Elm_Systray_Status Elm_Systray_Status

    const Eo_Class *elm_systray_class_get()

    void  elm_obj_systray_id_set(const char *id)
    const char * elm_obj_systray_id_get()
    void  elm_obj_systray_category_set(Elm_Systray_Category cat)
    Elm_Systray_Category  elm_obj_systray_category_get()
    void  elm_obj_systray_icon_theme_path_set(const char *icon_theme_path)
    const char * elm_obj_systray_icon_theme_path_get()
    void  elm_obj_systray_menu_set(const cEo *menu)
    const cEo * elm_obj_systray_menu_get()
    void  elm_obj_systray_att_icon_name_set(const char *att_icon_name)
    const char * elm_obj_systray_att_icon_name_get()
    void  elm_obj_systray_status_set(Elm_Systray_Status st)
    Elm_Systray_Status  elm_obj_systray_status_get()
    void  elm_obj_systray_icon_name_set(const char *icon_name)
    const char * elm_obj_systray_icon_name_get()
    void  elm_obj_systray_title_set(const char *title)
    const char * elm_obj_systray_title_get()
    Eina_Bool  elm_obj_systray_register()
