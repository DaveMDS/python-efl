cdef extern from "Ecore_Input.h":
    ####################################################################
    # Enums
    #
    ctypedef enum Ecore_Event_Modifier: # this is not really an enum
        ECORE_EVENT_MODIFIER_SHIFT
        ECORE_EVENT_MODIFIER_CTRL
        ECORE_EVENT_MODIFIER_ALT
        ECORE_EVENT_MODIFIER_WIN
        ECORE_EVENT_MODIFIER_SCROLL
        ECORE_EVENT_MODIFIER_NUM
        ECORE_EVENT_MODIFIER_CAPS
        ECORE_EVENT_LOCK_SCROLL
        ECORE_EVENT_LOCK_NUM
        ECORE_EVENT_LOCK_CAPS
        ECORE_EVENT_LOCK_SHIFT
        ECORE_EVENT_MODIFIER_ALTGR
