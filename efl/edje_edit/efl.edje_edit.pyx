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

from libc.stdlib cimport free

from efl.eina cimport eina_stringshare_add, eina_stringshare_del, \
    eina_stringshare_replace
from efl.utils.conversions cimport _touni, _ctouni, \
    eina_list_strings_to_python_list
from efl.eo cimport _register_decorated_callbacks
from efl.evas cimport Canvas
from efl.edje cimport Edje_Part_Type, Edje, ExternalParam_from_ptr
from efl.edje import EDJE_PART_TYPE_EXTERNAL

cimport efl.edje_edit.enums as enums

EDJE_EDIT_IMAGE_COMP_RAW = enums.EDJE_EDIT_IMAGE_COMP_RAW
EDJE_EDIT_IMAGE_COMP_USER = enums.EDJE_EDIT_IMAGE_COMP_USER
EDJE_EDIT_IMAGE_COMP_COMP = enums.EDJE_EDIT_IMAGE_COMP_COMP
EDJE_EDIT_IMAGE_COMP_LOSSY = enums.EDJE_EDIT_IMAGE_COMP_LOSSY

cdef class EdjeEdit(Edje):

    def __init__(self, Canvas canvas not None, file=None, group=None, size=None,
        geometry=None, **kwargs):

        self._set_obj(edje_edit_object_add(canvas.obj))
        _register_decorated_callbacks(self)

        if file:
            self.file_set(file, group)

        self._set_properties_from_keyword_args(kwargs)

        if not size and not geometry:
            w, h = self.size_min_get()
            self.size_set(w, h)

    # General
    def compiler_get(self):
        cdef const char *s = edje_edit_compiler_get(self.obj)
        r = _ctouni(s)
        if s != NULL:
            edje_edit_string_free(s)
        return r

    def save(self):
        return bool(edje_edit_save(self.obj))

    def save_all(self):
        return bool(edje_edit_save_all(self.obj))

    def print_internal_status(self):
        edje_edit_print_internal_status(self.obj)

    # Group
    property current_group:
        def __get__(self):
            return Group(self)

    def group_add(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_group_add(self.obj,
                        <const char *>name if name is not None else NULL))

    def group_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_group_del(self.obj,
                        <const char *>name if name is not None else NULL))

    def group_exist(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_group_exist(self.obj,
                        <const char *>name if name is not None else NULL))

    # Data
    property data:
        def __get__(self):
            cdef:
                Eina_List *lst
                list ret
            lst = edje_edit_data_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def data_get(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        cdef const char *val = edje_edit_data_value_get(self.obj,
                               <const char *>name if name is not None else NULL)
        r = _ctouni(val)
        edje_edit_string_free(val)
        return r

    def data_set(self, name, value):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if isinstance(value, unicode): value = value.encode("UTF-8")

        return bool(edje_edit_data_value_set(self.obj,
                        <const char *>name if name is not None else NULL,
                        <const char *>value if value is not None else NULL))

    def data_add(self, name, value):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if isinstance(value, unicode): value = value.encode("UTF-8")
        return bool(edje_edit_data_add(self.obj,
                        <const char *>name if name is not None else NULL,
                        <const char *>value if value is not None else NULL))

    def data_rename(self, old, new):
        if isinstance(old, unicode): old = old.encode("UTF-8")
        if isinstance(new, unicode): new = new.encode("UTF-8")
        return bool(edje_edit_data_name_set(self.obj,
                        <const char *>old if old is not None else NULL,
                        <const char *>new if new is not None else NULL))

    def data_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_data_del(self.obj,
                        <const char *>name if name is not None else NULL))

    # Group Data
    property group_data:
        def __get__(self):
            cdef:
                Eina_List *lst
                list ret
            lst = edje_edit_group_data_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def group_data_get(self, name):
        cdef const char *val
        if isinstance(name, unicode): name = name.encode("UTF-8")
        val = edje_edit_group_data_value_get(self.obj,
                    <const char *>name if name is not None else NULL)
        r = _ctouni(val)
        edje_edit_string_free(val)
        return r

    def group_data_set(self, name, value):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if isinstance(value, unicode): value = value.encode("UTF-8")
        return bool(edje_edit_group_data_value_set(self.obj,
                        <const char *>name if name is not None else NULL,
                        <const char *>value if value is not None else NULL))

    def group_data_add(self, name, value):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if isinstance(value, unicode): value = value.encode("UTF-8")
        return bool(edje_edit_group_data_add(self.obj,
                        <const char *>name if name is not None else NULL,
                        <const char *>value if value is not None else NULL))

    def group_data_rename(self, old, new):
        if isinstance(old, unicode): old = old.encode("UTF-8")
        if isinstance(new, unicode): new = new.encode("UTF-8")
        return bool(edje_edit_group_data_name_set(self.obj,
                        <const char *>old if old is not None else NULL,
                        <const char *>new if new is not None else NULL))

    def group_data_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_group_data_del(self.obj,
                        <const char *>name if name is not None else NULL))

    # Text Style
    property text_styles:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_styles_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def text_style_get(self, name):
        return Text_Style(self, name)

    def text_style_add(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_style_add(self.obj,
                        <const char *>name if name is not None else NULL))

    def text_style_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        edje_edit_style_del(self.obj,
                            <const char *>name if name is not None else NULL)
        return True

    # Color Classes
    property color_classes:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_color_classes_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def color_class_get(self, name):
        return Color_Class(self, name)

    def color_class_add(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_color_class_add(self.obj,
                            <const char *>name if name is not None else NULL))

    def color_class_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_color_class_del(self.obj,
                            <const char *>name if name is not None else NULL))

    # Externals
    property externals:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_externals_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def external_add(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_external_add(self.obj,
                            <const char *>name if name is not None else NULL))

    def external_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_external_del(self.obj,
                            <const char *>name if name is not None else NULL))

    # Fonts
    property fonts:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_fonts_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def font_add(self, font, alias=None):
        if isinstance(font, unicode): font = font.encode("UTF-8")
        if isinstance(alias, unicode): alias = alias.encode("UTF-8")
        return bool(edje_edit_font_add(self.obj,
                        <const char *>font if font is not None else NULL,
                        <const char *>alias if alias is not None else NULL))

    def font_del(self, alias):
        if isinstance(alias, unicode): alias = alias.encode("UTF-8")
        return bool(edje_edit_font_del(self.obj,
                        <const char *>alias if alias is not None else NULL))

    # Parts
    property parts:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_parts_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def part_get(self, name):
        if self.part_exist(name):
            return Part(self, name)
        return None

    def part_add(self, name, int type, char *source=""):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if type != EDJE_PART_TYPE_EXTERNAL:
            return bool(edje_edit_part_add(self.obj,
                               <const char *>name if name is not None else NULL,
                               <Edje_Part_Type>type))
        else:
            return bool(edje_edit_part_external_add(self.obj, name, source))

    def part_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_part_del(self.obj,
                            <const char *>name if name is not None else NULL))

    def part_exist(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_part_exist(self.obj,
                            <const char *>name if name is not None else NULL))

    # Images
    property images:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_images_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def image_id_get(self, image):
        if isinstance(image, unicode): image = image.encode("UTF-8")
        return edje_edit_image_id_get(self.obj,
                    <const char *>image if image is not None else NULL)

    def image_add(self, path):
        if isinstance(path, unicode): path = path.encode("UTF-8")
        return bool(edje_edit_image_add(self.obj,
                    <const char *>path if path is not None else NULL))

    def image_del(self, image):
        if isinstance(image, unicode): image = image.encode("UTF-8")
        return bool(edje_edit_image_del(self.obj,
                    <const char *>image if image is not None else NULL))

    # Programs
    property programs:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_programs_list_get(self.obj)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def program_get(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        if self.program_exist(name):
            return Program(self, name)
        return None

    def program_add(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_program_add(self.obj,
                            <const char *>name if name is not None else NULL))

    def program_del(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_program_del(self.obj,
                            <const char *>name if name is not None else NULL))

    def program_exist(self, name):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_program_exist(self.obj,
                            <const char *>name if name is not None else NULL))

    # property error:
    #     def __get__(self):
    #         last_error = c_evas.eina_error_get()
    #         if last_error:
    #            return c_evas.eina_error_msg_get(last_error)
    #
    #         return None

    # Scripts
    property script:
        def __get__(self):
            cdef char *code
            code = edje_edit_script_get(self.obj)
            ret = _touni(code)
            free(code)
            return ret

        def __set__(self, code):
            if isinstance(code, unicode): code = code.encode("UTF-8")
            edje_edit_script_set(self.obj,
                            <char *>code if code is not None else NULL)

        def __del__(self):
            edje_edit_script_set(self.obj, NULL)

    def script_compile(self):
        return bool(edje_edit_script_compile(self.obj))

    property script_errors:
        def __get__(self):
            cdef const Eina_List *lst
            cdef Edje_Edit_Script_Error *se
            ret = []
            lst = edje_edit_script_error_list_get(self.obj)
            while lst:
                se = <Edje_Edit_Script_Error*>lst.data
                if se.program_name != NULL:
                    pr = se.program_name
                else:
                    pr = ''
                err = (pr, _ctouni(se.error_str))
                ret.append(err)
                lst = lst.next
            return ret


cdef class Text_Style(object):
    cdef EdjeEdit edje
    cdef const char *name

    def __init__(self, EdjeEdit e not None, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        self.edje = e
        self.name = eina_stringshare_add(name)

    def __dealloc__(self):
        eina_stringshare_del(self.name)

    property tags:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_style_tags_list_get(self.edje.obj, self.name)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def tag_get(self, name not None):
        return Text_Style_Tag(self, name)

    def tag_add(self, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        return bool(edje_edit_style_tag_add(self.edje.obj, self.name,
                                            <const char *>name))

    def tag_del(self, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        edje_edit_style_tag_del(self.edje.obj, self.name, <const char *>name)
        return True


cdef class Text_Style_Tag(object):
    cdef Text_Style text_style
    cdef const char *name

    def __init__(self, Text_Style text_style not None, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        self.text_style = text_style
        self.name = eina_stringshare_add(name)

    def __dealloc__(self):
        eina_stringshare_del(self.name)

    property name:
        def __get__(self):
            return _ctouni(self.name)

        def __set__(self, newname):
            self.rename(newname)

    def rename(self, newname not None):
        if isinstance(newname, unicode): newname = newname.encode("UTF-8")
        edje_edit_style_tag_name_set(self.text_style.edje.obj,
                        self.text_style.name, self.name,
                        <const char *>newname)
        eina_stringshare_replace(&self.name, <const char *>newname)
        return True

    property value:
        def __get__(self):
            cdef const char *val
            val =  edje_edit_style_tag_value_get(self.text_style.edje.obj,
                                                self.text_style.name, self.name)
            ret = _ctouni(val)
            edje_edit_string_free(val)
            return ret
        def __set__(self, value):
            if isinstance(value, unicode): value = value.encode("UTF-8")
            edje_edit_style_tag_value_set(self.text_style.edje.obj,
                            self.text_style.name, self.name,
                            <const char *>value if value is not None else NULL)



cdef class Color_Class(object):
    cdef EdjeEdit edje
    cdef const char *name

    def __init__(self, EdjeEdit e not None, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        self.edje = e
        self.name = eina_stringshare_add(name)

    def __dealloc__(self):
        eina_stringshare_del(self.name)

    property name:
        def __get__(self):
            return _ctouni(self.name)

        def __set__(self, newname):
            self.rename(newname)

    def rename(self, newname not None):
        cdef Eina_Bool ret
        if isinstance(newname, unicode): newname = newname.encode("UTF-8")
        ret = edje_edit_color_class_name_set(self.edje.obj, self.name,
                                             <const char *>newname)
        if ret == 0:
            return False
        eina_stringshare_replace(&self.name, <const char *>newname)
        return True

    def colors_get(self):
        cdef int r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3
        edje_edit_color_class_colors_get(self.edje.obj, self.name,
                        &r, &g, &b, &a, &r2, &g2, &b2, &a2, &r3, &g3, &b3, &a3)
        return ((r, g, b, a), (r2, g2, b2, a2), (r3, g3, b3, a3))

    def colors_set(self, int r, int g, int b, int a,
                         int r2, int g2, int b2, int a2,
                         int r3, int g3, int b3, int a3):
        edje_edit_color_class_colors_set(self.edje.obj, self.name,
                                    r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)


include "efl.edje_edit_group.pxi"
include "efl.edje_edit_part.pxi"
include "efl.edje_edit_part_state.pxi"
include "efl.edje_edit_program.pxi"

