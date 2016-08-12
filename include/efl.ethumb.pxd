# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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


from efl.c_ethumb cimport Ethumb as cEthumb

cdef extern from "Ethumb.h":

    cpdef enum Ethumb_Thumb_Orientation:
        ETHUMB_THUMB_ORIENT_NONE
        ETHUMB_THUMB_ROTATE_90_CW
        ETHUMB_THUMB_ROTATE_180
        ETHUMB_THUMB_ROTATE_90_CCW
        ETHUMB_THUMB_FLIP_HORIZONTAL
        ETHUMB_THUMB_FLIP_VERTICAL
        ETHUMB_THUMB_FLIP_TRANSPOSE
        ETHUMB_THUMB_FLIP_TRANSVERSE
        ETHUMB_THUMB_ORIENT_ORIGINAL

    cpdef enum Ethumb_Thumb_FDO_Size:
        ETHUMB_THUMB_NORMAL
        ETHUMB_THUMB_LARGE

    cpdef enum Ethumb_Thumb_Format:
        ETHUMB_THUMB_FDO
        ETHUMB_THUMB_JPEG
        ETHUMB_THUMB_EET

    cpdef enum Ethumb_Thumb_Aspect:
        ETHUMB_THUMB_KEEP_ASPECT
        ETHUMB_THUMB_IGNORE_ASPECT
        ETHUMB_THUMB_CROP


cdef class Ethumb:
    cdef cEthumb *obj
