cdef extern from "Elementary.h":
    cpdef enum:
        ELM_ECORE_EVENT_ETHUMB_CONNECT
        ELM_EVENT_SYS_NOTIFY_NOTIFICATION_CLOSED
        ELM_EVENT_SYS_NOTIFY_ACTION_INVOKED
        ELM_EVENT_SYSTRAY_READY

    ctypedef struct Elm_Sys_Notify_Notification_Closed:
        unsigned int id # ID of the notification.
        Elm_Sys_Notify_Closed_Reason reason # The Reason the notification was closed.

    ctypedef struct Elm_Sys_Notify_Action_Invoked:
        unsigned int id # ID of the notification.
        char *action_key # The key of the action invoked. These match the keys sent over in the list of actions.

    cpdef enum Elm_Sys_Notify_Closed_Reason:
        ELM_SYS_NOTIFY_CLOSED_EXPIRED
        ELM_SYS_NOTIFY_CLOSED_DISMISSED
        ELM_SYS_NOTIFY_CLOSED_REQUESTED
        ELM_SYS_NOTIFY_CLOSED_UNDEFINED
    ctypedef enum Elm_Sys_Notify_Closed_Reason:
        pass


    Eina_Bool                elm_need_efreet()
    Eina_Bool                elm_need_systray()
    Eina_Bool                elm_need_sys_notify()
    Eina_Bool                elm_need_eldbus()
    Eina_Bool                elm_need_elocation()
    Eina_Bool                elm_need_ethumb()
    Eina_Bool                elm_need_web()
