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

from cpython cimport PyMem_Malloc
from libc.stdint cimport uintptr_t

cdef uintptr_t _smart_object_class_new(name) except 0:
    cdef Evas_Smart_Class *cls_def
    cdef Evas_Smart *cls

    cls_def = <Evas_Smart_Class*>PyMem_Malloc(sizeof(Evas_Smart_Class))
    if cls_def == NULL:
        return 0

    if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)

    #_smart_classes.append(<uintptr_t>cls_def)
    cls_def.name = name
    cls_def.version = EVAS_SMART_CLASS_VERSION
    cls_def.add = NULL # use python constructor
    cls_def.delete = _smart_object_delete
    cls_def.move = _smart_object_move
    cls_def.resize = _smart_object_resize
    cls_def.show = _smart_object_show
    cls_def.hide = _smart_object_hide
    cls_def.color_set = _smart_object_color_set
    cls_def.clip_set = _smart_object_clip_set
    cls_def.clip_unset = _smart_object_clip_unset
    cls_def.calculate = _smart_object_calculate
    cls_def.member_add = _smart_object_member_add
    cls_def.member_del = _smart_object_member_del
    cls_def.parent = NULL
    cls_def.callbacks = NULL
    cls_def.interfaces = NULL
    cls_def.data = NULL

    cls = evas_smart_class_new(cls_def);
    return <uintptr_t>cls

#class EvasSmartObjectMeta(EvasObjectMeta):
class EvasSmartObjectMeta(type):
    def __init__(cls, name, bases, dict_):
        #EvasObjectMeta.__init__(cls, name, bases, dict_)
        type.__init__(cls, name, bases, dict_)
        cls._setup_smart_class()

    def _setup_smart_class(cls):
        if "__evas_smart_class__" in cls.__dict__:
            return

        cdef uintptr_t addr
        addr = _smart_object_class_new(cls.__name__)
        cls.__evas_smart_class__ = addr

from cpython cimport PyObject, PyTypeObject, Py_INCREF

cdef void _install_metaclass(meta, cls):
    #Py_INCREF(meta)
    cdef PyObject *o = <PyObject *>cls
    o.ob_type = <PyTypeObject *>meta
