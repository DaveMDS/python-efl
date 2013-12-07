# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

cdef extern from "Ecore.h":
    enum:
        ECORE_EVENT_SIGNAL_USER
        ECORE_EVENT_SIGNAL_HUP
        ECORE_EVENT_SIGNAL_EXIT
        ECORE_EVENT_SIGNAL_POWER
        ECORE_EVENT_SIGNAL_REALTIME

    int ECORE_EXE_EVENT_ADD
    int ECORE_EXE_EVENT_DEL
    int ECORE_EXE_EVENT_DATA
    int ECORE_EXE_EVENT_ERROR

    enum:
        ECORE_CALLBACK_CANCEL
        ECORE_CALLBACK_RENEW

    enum:
        ECORE_CALLBACK_PASS_ON
        ECORE_CALLBACK_DONE

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
