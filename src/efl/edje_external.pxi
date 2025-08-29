# Copyright (C) 2007-2022 various contributors (see AUTHORS)
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

from efl.eina cimport Eina_Hash_Tuple, eina_iterator_next, eina_iterator_free
from efl.evas cimport Canvas

cdef class ExternalParam:
    property name:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            return self.obj.name

    property type:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            return self.obj.type

    property i:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            return self.obj.i

    property d:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            return self.obj.d

    property s:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            if self.obj.s != NULL:
                return self.obj.s

    property b:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            return bool(self.obj.i)

    property value:
        def __get__(self):
            if self.obj == NULL:
                raise ValueError("Object uninitialized")
            if self.obj.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_INT:
                return self.obj.i
            elif self.obj.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_DOUBLE:
                return self.obj.d
            elif self.obj.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_STRING or \
                    self.obj.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_CHOICE:
                if self.obj.s != NULL:
                    return self.obj.s
            elif self.obj.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_BOOL:
                return bool(self.obj.i)


cdef ExternalParam ExternalParam_from_ptr(Edje_External_Param *param):
    cdef ExternalParam p
    p = ExternalParam()
    p.obj = param
    return p


cdef class ExternalParamInfo:
    property name:
        def __get__(self):
            if self.obj.name:
                return self.obj.name
            return "(unknown)"

    property translated_name:
        def __get__(self):
            cdef const char *t
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.name
            t = self._external_type_obj.translate(self._external_type_obj.data,
                                                  self.obj.name)
            if t == NULL:
                return self.name
            return t

    property type:
        def __get__(self):
            return self.obj.type

    def validate(self, value):
        return True

    cdef _set_external_type(self, t):
        cdef ExternalType ext_type
        self.external_type = t
        if isinstance(t, ExternalType):
            ext_type = t
            self._external_type_obj = ext_type._obj


cdef class ExternalParamInfoInt(ExternalParamInfo):
    property default:
        def __get__(self):
            if self.obj.info.i.default == EDJE_EXTERNAL_INT_UNSET:
                return None
            return self.obj.info.i.default

    property min:
        def __get__(self):
            if self.obj.info.i.min == EDJE_EXTERNAL_INT_UNSET:
                return None
            return self.obj.info.i.min

    property max:
        def __get__(self):
            if self.obj.info.i.max == EDJE_EXTERNAL_INT_UNSET:
                return None
            return self.obj.info.i.max

    property step:
        def __get__(self):
            if self.obj.info.i.step == EDJE_EXTERNAL_INT_UNSET:
                return None
            return self.obj.info.i.step

    def validate(self, value):
        min = self.min
        max = self.max
        if min is not None and value < min:
            return False
        if max is not None and value > max:
            return False
        return True


cdef class ExternalParamInfoDouble(ExternalParamInfo):
    property default:
        def __get__(self):
            if self.obj.info.d.default == EDJE_EXTERNAL_DOUBLE_UNSET:
                return None
            return self.obj.info.d.default

    property min:
        def __get__(self):
            if self.obj.info.d.min == EDJE_EXTERNAL_DOUBLE_UNSET:
                return None
            return self.obj.info.d.min

    property max:
        def __get__(self):
            if self.obj.info.d.max == EDJE_EXTERNAL_DOUBLE_UNSET:
                return None
            return self.obj.info.d.max

    property step:
        def __get__(self):
            if self.obj.info.d.step == EDJE_EXTERNAL_DOUBLE_UNSET:
                return None
            return self.obj.info.d.step

    def validate(self, value):
        min = self.min
        max = self.max
        if min is not None and value < min:
            return False
        if max is not None and value > max:
            return False
        return True


cdef class ExternalParamInfoString(ExternalParamInfo):
    property default:
        def __get__(self):
            if self.obj.info.s.default == NULL:
                return None
            return self.obj.info.s.default

    property translated_default:
        def __get__(self):
            cdef const char *t
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.default
            t = self._external_type_obj.translate(self._external_type_obj.data,
                                                  self.obj.info.s.default)
            if t == NULL:
                return self.default
            return t

    property accept_format:
        def __get__(self):
            if self.obj.info.s.accept_fmt == NULL:
                return None
            return self.obj.info.s.accept_fmt

    property deny_format:
        def __get__(self):
            if self.obj.info.s.deny_fmt == NULL:
                return None
            return self.obj.info.s.deny_fmt


cdef class ExternalParamInfoBool(ExternalParamInfo):
    property default:
        def __get__(self):
            return bool(self.obj.info.b.default)

    property false_string:
        def __get__(self):
            if self.obj.info.b.false_str == NULL:
                return None
            return self.obj.info.b.false_str

    property translated_false_string:
        def __get__(self):
            cdef const char *t
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.false_string
            t = self._external_type_obj.translate(self._external_type_obj.data,
                                                  self.obj.info.b.false_str)
            if t == NULL:
                return self.false_string
            return t

    property true_string:
        def __get__(self):
            if self.obj.info.b.true_str == NULL:
                return None
            return self.obj.info.b.true_str

    property translated_true_string:
        def __get__(self):
            cdef const char *t
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.true_string
            t = self._external_type_obj.translate(self._external_type_obj.data,
                                                  self.obj.info.b.true_str)
            if t == NULL:
                return self.true_string
            return t


cdef class ExternalParamInfoChoice(ExternalParamInfo):
    property default:
        def __get__(self):
            if self.obj.info.c.default == NULL:
                return None
            return self.obj.info.c.default

    property translated_default:
        def __get__(self):
            cdef const char *t
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.default
            t = self._external_type_obj.translate(self._external_type_obj.data,
                                                  self.obj.info.c.default)
            if t == NULL:
                return self.default
            return t

    property choices:
        def __get__(self):
            cdef int i

            if self.obj.info.c.choices == NULL:
                return None

            i = 0
            lst = []
            while self.obj.info.c.choices[i] != NULL:
                lst.append(self.obj.info.c.choices[i])
                i += 1
            return lst

    property translated_choices:
        def __get__(self):
            cdef const char *trans
            if self._external_type_obj == NULL or \
               self._external_type_obj.translate == NULL:
                return self.choices

            orig = self.choices
            ret = []
            for choice in orig:
                trans = self._external_type_obj.translate(
                            self._external_type_obj.data, choice)
                ret.append(trans or choice)
            return ret


cdef ExternalParamInfo ExternalParamInfo_from_ptr(type, Edje_External_Param_Info *ptr):
    cdef ExternalParamInfo p
    if ptr.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_INT:
        p = ExternalParamInfoInt()
    elif ptr.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_DOUBLE:
        p = ExternalParamInfoDouble()
    elif ptr.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_STRING:
        p = ExternalParamInfoString()
    elif ptr.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_BOOL:
        p = ExternalParamInfoBool()
    elif ptr.type == <int>enums.EDJE_EXTERNAL_PARAM_TYPE_CHOICE:
        p = ExternalParamInfoChoice()
    else:
        msg = "Don't know how to convert parameter %s of type %s" % \
              (ptr.name, edje_external_param_type_str(ptr.type))
        warnings.warn(msg, Warning)
        return None
    p.obj = ptr
    p._set_external_type(type)
    return p

def external_param_info_get(char *type_name):
    cdef const Edje_External_Type *ext_type
    cdef ExternalType t

    warnings.warn("Use ExternalType.parameters_info_get() instead!",
                  DeprecationWarning)

    ext_type = edje_external_type_get(type_name)
    if ext_type == NULL:
        return tuple()

    t = ExternalType()
    t._name = type_name
    t._obj = ext_type
    return t.parameters_info_get()


cdef class ExternalType:
    property name:
        def __get__(self):
            return self._name

    property module:
        def __get__(self):
            if self._obj.module == NULL:
                return None
            return self._obj.module

    property module_name:
        def __get__(self):
            if self._obj.module_name == NULL:
                return None
            return self._obj.module_name

    def label_get(self):
        cdef const char *l
        if self._obj.label_get == NULL:
            return None
        l = self._obj.label_get(self._obj.data)
        if l == NULL:
            return None
        ret = l
        return ret

    def description_get(self):
        cdef const char *l
        if self._obj.description_get == NULL:
            return None
        l = self._obj.description_get(self._obj.data)
        if l == NULL:
            return None
        ret = l
        return ret

    def translate(self, char *text):
        """Used to translate text originated from this module.

        Usually this is only required for static text, like the
        parameters. label_get() and description_get() may not require
        it. Note that ExternalParamInfo provides translated_* versions
        of its worth translating strings!

        It will always return a string, on errors the parameter text
        is returned untranslated.
        """
        cdef const char *l
        if self._obj.translate == NULL:
            return text
        l = self._obj.translate(self._obj.data, text)
        if l == NULL:
            return text
        return l

    def icon_add(self, Canvas canvas not None):
        cdef Evas_Object *icon
        if self._obj.icon_add == NULL:
            return None
        icon = self._obj.icon_add(self._obj.data, canvas.obj)
        if icon == NULL:
            return None
        return object_from_instance(icon)

    def preview_add(self, Canvas canvas not None):
        cdef Evas_Object *preview
        if self._obj.preview_add == NULL:
            return None
        preview = self._obj.preview_add(self._obj.data, canvas.obj)
        if preview == NULL:
            return None
        return object_from_instance(preview)

    def parameters_info_get(self):
        cdef Edje_External_Param_Info *params
        cdef int i

        if self._parameters_info:
            return self._parameters_info

        lst = []
        params = self._obj.parameters_info
        if params == NULL:
            self._parameters_info = tuple()

        i = 0
        while params[i].name != NULL:
            lst.append(ExternalParamInfo_from_ptr(self, &params[i]))
            i += 1
        self._parameters_info = tuple(lst)
        return self._parameters_info

    property parameters_info:
        def __get__(self):
            return self.parameters_info_get()


cdef class ExternalIterator:
    cdef Eina_Iterator *obj

    def __init__(self):
        cdef Eina_Iterator *it
        it = edje_external_iterator_get()
        self._set_obj(it)

    cdef _set_obj(self, Eina_Iterator *ptr):
        self.obj = ptr

    def __iter__(self):
        return self

    def __next__(self):
        cdef const Eina_Hash_Tuple *tuple
        cdef ExternalType t
        if eina_iterator_next(self.obj, <void **>&tuple):
            t = ExternalType()
            t._name = <char*>tuple.key
            t._obj = <const Edje_External_Type*>tuple.data
            return t
        else:
            raise StopIteration

    def __del__(self):
        if self.obj:
            eina_iterator_free(self.obj)

def external_type_get(char *type_name):
    """Gets the instance that represents an ExternalType of the given name."""
    cdef const Edje_External_Type *obj = edje_external_type_get(type_name)
    cdef ExternalType ret
    if obj == NULL:
        return None
    ret = ExternalType()
    ret._name = type_name
    ret._obj = obj
    return ret

