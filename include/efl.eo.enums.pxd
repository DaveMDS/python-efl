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

cdef extern from "Eo.h":
    enum:
        EO_BASE_SUB_ID_CONSTRUCTOR
        EO_BASE_SUB_ID_DESTRUCTOR
        EO_BASE_SUB_ID_PARENT_SET
        EO_BASE_SUB_ID_PARENT_GET
        EO_BASE_SUB_ID_CHILDREN_ITERATOR_NEW
        EO_BASE_SUB_ID_DATA_SET
        EO_BASE_SUB_ID_DATA_GET
        EO_BASE_SUB_ID_DATA_DEL
        EO_BASE_SUB_ID_WREF_ADD
        EO_BASE_SUB_ID_WREF_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_PRIORITY_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_ARRAY_PRIORITY_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_ARRAY_DEL
        EO_BASE_SUB_ID_EVENT_CALLBACK_CALL
        EO_BASE_SUB_ID_EVENT_CALLBACK_FORWARDER_ADD
        EO_BASE_SUB_ID_EVENT_CALLBACK_FORWARDER_DEL
        EO_BASE_SUB_ID_EVENT_FREEZE
        EO_BASE_SUB_ID_EVENT_THAW
        EO_BASE_SUB_ID_EVENT_FREEZE_GET
        EO_BASE_SUB_ID_EVENT_GLOBAL_FREEZE
        EO_BASE_SUB_ID_EVENT_GLOBAL_THAW
        EO_BASE_SUB_ID_EVENT_GLOBAL_FREEZE_GET
        EO_BASE_SUB_ID_DBG_INFO_GET
        EO_BASE_SUB_ID_LAST

    enum:
        EO_CALLBACK_PRIORITY_BEFORE
        EO_CALLBACK_PRIORITY_DEFAULT
        EO_CALLBACK_PRIORITY_AFTER

    enum:
        EO_CALLBACK_STOP
        EO_CALLBACK_CONTINUE
