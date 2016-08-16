cdef extern from "Ecore.h":

    ####################################################################
    # Define  (this are not really correct, but works)
    #
    cdef enum:
        ECORE_EVENT_NONE
        ECORE_EVENT_SIGNAL_USER
        ECORE_EVENT_SIGNAL_HUP
        ECORE_EVENT_SIGNAL_EXIT
        ECORE_EVENT_SIGNAL_POWER
        ECORE_EVENT_SIGNAL_REALTIME
        ECORE_EVENT_MEMORY_STATE
        ECORE_EVENT_POWER_STATE
        ECORE_EVENT_LOCALE_CHANGED
        ECORE_EVENT_HOSTNAME_CHANGED
        ECORE_EVENT_SYSTEM_TIMEDATE_CHANGED
        ECORE_EVENT_COUNT

        ECORE_CALLBACK_CANCEL
        ECORE_CALLBACK_RENEW

        ECORE_CALLBACK_PASS_ON
        ECORE_CALLBACK_DONE

        ECORE_EXE_PRIORITY_INHERIT

    int ECORE_EXE_EVENT_ADD
    int ECORE_EXE_EVENT_DEL
    int ECORE_EXE_EVENT_DATA
    int ECORE_EXE_EVENT_ERROR

    ####################################################################
    # Enums
    #
    ctypedef enum Ecore_Fd_Handler_Flags:
        ECORE_FD_READ
        ECORE_FD_WRITE
        ECORE_FD_ERROR

    ctypedef enum Ecore_Exe_Flags:
        ECORE_EXE_NONE
        ECORE_EXE_PIPE_READ
        ECORE_EXE_PIPE_WRITE
        ECORE_EXE_PIPE_ERROR
        ECORE_EXE_PIPE_READ_LINE_BUFFERED
        ECORE_EXE_PIPE_ERROR_LINE_BUFFERED
        ECORE_EXE_PIPE_AUTO
        ECORE_EXE_RESPAWN
        ECORE_EXE_USE_SH
        ECORE_EXE_NOT_LEADER
        ECORE_EXE_TERM_WITH_PARENT

    ctypedef enum Ecore_Pos_Map:
        ECORE_POS_MAP_LINEAR
        ECORE_POS_MAP_ACCELERATE
        ECORE_POS_MAP_DECELERATE
        ECORE_POS_MAP_SINUSOIDAL
        ECORE_POS_MAP_ACCELERATE_FACTOR
        ECORE_POS_MAP_DECELERATE_FACTOR
        ECORE_POS_MAP_SINUSOIDAL_FACTOR
        ECORE_POS_MAP_DIVISOR_INTERP
        ECORE_POS_MAP_BOUNCE
        ECORE_POS_MAP_SPRING
        ECORE_POS_MAP_CUBIC_BEZIER

    ctypedef enum Ecore_Animator_Source:
        ECORE_ANIMATOR_SOURCE_TIMER
        ECORE_ANIMATOR_SOURCE_CUSTOM

    ctypedef enum Ecore_Poller_Type:
        ECORE_POLLER_CORE


cdef extern from "Ecore_File.h":
    ctypedef enum Ecore_File_Event:
        ECORE_FILE_EVENT_NONE
        ECORE_FILE_EVENT_CREATED_FILE
        ECORE_FILE_EVENT_CREATED_DIRECTORY
        ECORE_FILE_EVENT_DELETED_FILE
        ECORE_FILE_EVENT_DELETED_DIRECTORY
        ECORE_FILE_EVENT_DELETED_SELF
        ECORE_FILE_EVENT_MODIFIED
        ECORE_FILE_EVENT_CLOSED

    ctypedef enum Ecore_File_Progress_Return:
        ECORE_FILE_PROGRESS_CONTINUE
        ECORE_FILE_PROGRESS_ABORT
