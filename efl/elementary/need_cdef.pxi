from efl.elementary.enums cimport Elm_Sys_Notify_Closed_Reason

cdef extern from "Elementary.h":
    ctypedef struct Elm_Sys_Notify_Notification_Closed:
        unsigned int id # ID of the notification.
        Elm_Sys_Notify_Closed_Reason reason # The Reason the notification was closed.

    ctypedef struct Elm_Sys_Notify_Action_Invoked:
        unsigned int id # ID of the notification.
        char *action_key # The key of the action invoked. These match the keys sent over in the list of actions.

    Eina_Bool                elm_need_efreet()
    Eina_Bool                elm_need_systray()
    Eina_Bool                elm_need_sys_notify()
    Eina_Bool                elm_need_eldbus()
    Eina_Bool                elm_need_elocation()
    Eina_Bool                elm_need_ethumb()
    Eina_Bool                elm_need_web()
