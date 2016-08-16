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

from efl.eina cimport Eina_Bool, Eina_List, Eina_Iterator
from efl.evas cimport Object, Evas_Object, Evas, Evas_Font_Size, Evas_Coord

from efl.edje.enums cimport Edje_Message_Type, Edje_Aspect_Control, \
    Edje_Drag_Dir, Edje_Load_Error, Edje_Part_Type, Edje_Text_Effect, \
    Edje_Action_Type, Edje_Tween_Mode, Edje_External_Param_Type, \
    Edje_Input_Hints

cdef extern from "Edje.h":
    ####################################################################
    # Define (these are not accessible from python atm)
    #
    cdef int EDJE_EXTERNAL_INT_UNSET
    cdef double EDJE_EXTERNAL_DOUBLE_UNSET
    cdef unsigned int EDJE_EXTERNAL_TYPE_ABI_VERSION


    ####################################################################
    # Structures
    #
    ctypedef struct Edje_Message_String:
        char *str

    ctypedef struct Edje_Message_Int:
        int val

    ctypedef struct Edje_Message_Float:
        double val

    ctypedef struct Edje_Message_String_Set:
        int count
        char *str[1]

    ctypedef struct Edje_Message_Int_Set:
        int count
        int val[1]

    ctypedef struct Edje_Message_Float_Set:
        int count
        double val[1]

    ctypedef struct Edje_Message_String_Int:
        char *str
        int val

    ctypedef struct Edje_Message_String_Float:
        char *str
        double val

    ctypedef struct Edje_Message_String_Int_Set:
        char *str
        int count
        int val[1]

    ctypedef struct Edje_Message_String_Float_Set:
        char *str
        int count
        double val[1]

    ctypedef struct Edje_External_Param:
        char *name
        Edje_External_Param_Type type
        int i
        double d
        char *s

    ctypedef struct aux_external_param_info_int:
        int default "def", min, max, step

    ctypedef struct aux_external_param_info_double:
        double default "def", min, max, step

    ctypedef struct aux_external_param_info_string:
        char *default "def"
        char *accept_fmt
        char *deny_fmt

    ctypedef struct aux_external_param_info_bool:
        unsigned int default "def"
        char *false_str
        char *true_str

    ctypedef struct aux_external_param_info_choice:
        char *default "def"
        char **choices

    ctypedef union aux_external_param_info:
        aux_external_param_info_int i
        aux_external_param_info_double d
        aux_external_param_info_string s
        aux_external_param_info_bool b
        aux_external_param_info_choice c

    ctypedef struct Edje_External_Param_Info:
        char *name
        Edje_External_Param_Type type
        aux_external_param_info info

    ctypedef struct Edje_External_Type:
        unsigned int abi_version
        char *module
        char *module_name
        Evas_Object *(*add)(void *data, Evas *evas, Evas_Object *parent, Eina_List *params,  char *part_name)
        void (*state_set)(void *data, Evas_Object *obj, void *from_params, void *to_params, float pos)
        void (*signal_emit)(void *data, Evas_Object *obj, char *emission, char *source)
        Eina_Bool (*param_set)(void *data, Evas_Object *obj, Edje_External_Param *param)
        Eina_Bool (*param_get)(void *data, Evas_Object *obj, Edje_External_Param *param)
        void *(*params_parse)(void *data, Evas_Object *obj, Eina_List *params)
        void (*params_free)(void *params)
        Evas_Object *(*icon_add)(void *data, Evas *e)
        Evas_Object *(*preview_add)(void *data, Evas *e)
        char *(*label_get)(void *data)
        char *(*description_get)(void *data)
        char *(*translate)(void *data, char *orig)
        Edje_External_Param_Info *parameters_info
        void *data


    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const char *emission, const char *source)

    ####################################################################
    # Engine
    #
    int edje_init()
    int edje_shutdown()

    void edje_frametime_set(double t)
    double edje_frametime_get()

    void edje_freeze()
    void edje_thaw()
    void edje_fontset_append_set(char *fonts)
    char *edje_fontset_append_get()

    Eina_List *edje_file_collection_list(char *file)
    void edje_file_collection_list_free(Eina_List *lst)
    int edje_file_group_exists(char *file, char *glob)
    char *edje_file_data_get(char *file, char *key)
    void edje_file_cache_set(int count)
    int edje_file_cache_get()
    void edje_file_cache_flush()
    void edje_collection_cache_set(int count)
    int edje_collection_cache_get()
    void edje_collection_cache_flush()

    void edje_color_class_set(char *color_class, int r, int g, int b, int a, int r2, int g2, int b2, int a2, int r3, int g3, int b3, int a3)
    void edje_color_class_get(char *color_class, int *r, int *g, int *b, int *a, int *r2, int *g2, int *b2, int *a2, int *r3, int *g3, int *b3, int *a3)
    void edje_color_class_del(char *color_class)
    Eina_List * edje_color_class_list()

    void edje_text_class_set(char *text_class, char *font, Evas_Font_Size size)
    Eina_Bool edje_text_class_get(const char *text_class, const char **font, Evas_Font_Size *size)
    void edje_text_class_del(char *text_class)
    Eina_List * edje_text_class_list()

    Eina_Bool edje_size_class_set(const char *size_class, Evas_Coord minw, Evas_Coord minh, Evas_Coord maxw, Evas_Coord maxh)
    Eina_Bool edje_size_class_get(const char *size_class, Evas_Coord *minw, Evas_Coord *minh, Evas_Coord *maxw, Evas_Coord *maxh)
    void edje_size_class_del(const char *size_class)
    Eina_List *edje_size_class_list()

    void edje_scale_set(double scale)
    double edje_scale_get()

    void edje_password_show_last_set(Eina_Bool password_show_last)
    void edje_password_show_last_timeout_set(double password_show_last_timeout)

    void edje_extern_object_min_size_set(Evas_Object *obj, Evas_Coord minw, Evas_Coord minh)
    void edje_extern_object_max_size_set(Evas_Object *obj, Evas_Coord maxw, Evas_Coord maxh)
    void edje_extern_object_aspect_set(Evas_Object *obj, Edje_Aspect_Control aspect, Evas_Coord aw, Evas_Coord ah)

    Evas_Object *edje_object_add(Evas *)

    char *edje_object_data_get(Evas_Object *obj, char *key)

    int edje_object_file_set(Evas_Object *obj, char *file, char *part)
    void edje_object_file_get(Evas_Object *obj, char **file, char **part)
    int edje_object_load_error_get(Evas_Object *obj)

    void edje_object_signal_callback_add(Evas_Object *obj, char *emission, char *source, void(*func)(void *data, Evas_Object *obj, char *emission, char *source), void *data)
    void *edje_object_signal_callback_del(Evas_Object *obj, char *emission, char *source, void(*func)(void *data, Evas_Object *obj, char *emission, char *source))
    void edje_object_signal_emit(Evas_Object *obj, char *emission, char *source)

    void edje_object_play_set(Evas_Object *obj, int play)
    int edje_object_play_get(Evas_Object *obj)
    void edje_object_animation_set(Evas_Object *obj, int on)
    int edje_object_animation_get(Evas_Object *obj)

    int edje_object_freeze(Evas_Object *obj)
    int edje_object_thaw(Evas_Object *obj)

    Eina_Bool edje_object_preload(Evas_Object *obj, Eina_Bool cancel)
    Eina_Bool edje_object_scale_set(Evas_Object *obj, double scale)
    double edje_object_scale_get(Evas_Object *obj)
    double edje_object_base_scale_get(Evas_Object *obj)

    void edje_object_mirrored_set(Evas_Object *obj, Eina_Bool rtl)
    Eina_Bool edje_object_mirrored_get(Evas_Object *obj)

    void edje_object_update_hints_set(Evas_Object *obj, Eina_Bool update)
    Eina_Bool edje_object_update_hints_get(Evas_Object *obj)

    void edje_object_color_class_set(Evas_Object *obj, char *color_class, int r, int g, int b, int a, int r2, int g2, int b2, int a2, int r3, int g3, int b3, int a3)
    void edje_object_color_class_get(Evas_Object *obj, char *color_class, int *r, int *g, int *b, int *a, int *r2, int *g2, int *b2, int *a2, int *r3, int *g3, int *b3, int *a3)
    void edje_object_color_class_del(Evas_Object *obj, char *color_class)
    Eina_Bool edje_object_color_class_clear(Evas_Object *obj)

    void edje_object_text_class_set(Evas_Object *obj, char *text_class, char *font, Evas_Font_Size size)
    Eina_Bool edje_object_text_class_get(Evas_Object *obj, const char *text_class, const char **font, Evas_Font_Size *size)
    void edje_object_text_class_del(Evas_Object *obj, const char *text_class)

    Eina_Bool edje_object_size_class_set(Evas_Object *obj, const char *size_class, int minw, int minh, int maxw, int maxh)
    Eina_Bool edje_object_size_class_get(Evas_Object *obj, const char *size_class, int *minw, int *minh, int *maxw, int *maxh)
    void      edje_object_size_class_del(Evas_Object *obj, const char *size_class)



    void edje_object_size_min_get(Evas_Object *obj, Evas_Coord *minw, Evas_Coord *minh)
    void edje_object_size_max_get(Evas_Object *obj, Evas_Coord *maxw, Evas_Coord *maxh)
    void edje_object_calc_force(Evas_Object *obj)
    void edje_object_size_min_calc(Evas_Object *obj, Evas_Coord *minw, Evas_Coord *minh)
    void edje_object_size_min_restricted_calc(Evas_Object *obj, Evas_Coord *minw, Evas_Coord *minh, Evas_Coord restrictedw, Evas_Coord restrictedh)
    Eina_Bool edje_object_parts_extends_calc(Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)

    int edje_object_part_exists(Evas_Object *obj, char *part)
    Evas_Object *edje_object_part_object_get(Evas_Object *obj, char *part)
    void edje_object_part_geometry_get(Evas_Object *obj, char *part, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)

    void edje_object_text_change_cb_set(Evas_Object *obj, void(*func)(void *data, Evas_Object *obj, char *part), void *data)
    void edje_object_part_text_set(Evas_Object *obj, char *part, char *text)
    char *edje_object_part_text_get(Evas_Object *obj, char *part)

    void edje_object_part_text_select_all(Evas_Object *obj, char *part)
    void edje_object_part_text_select_none(Evas_Object *obj, char *part)

    void edje_object_part_text_unescaped_set(Evas_Object *obj, char *part, char *text_to_escape)
    char *edje_object_part_text_unescaped_get(Evas_Object *obj, char *part)

    void edje_object_part_text_input_hint_set(Evas_Object *obj, char *part, Edje_Input_Hints input_hints)
    Edje_Input_Hints edje_object_part_text_input_hint_get(Evas_Object *obj, char *part)

    void edje_object_part_swallow(Evas_Object *obj, char *part, Evas_Object *obj_swallow)
    void edje_object_part_unswallow(Evas_Object *obj, Evas_Object *obj_swallow)
    Evas_Object *edje_object_part_swallow_get(Evas_Object *obj, char *part)

    Eina_Bool edje_object_part_box_append(Evas_Object *obj, char *part, Evas_Object *child)
    Eina_Bool edje_object_part_box_prepend(Evas_Object *obj, char *part, Evas_Object *child)
    Eina_Bool edje_object_part_box_insert_at(Evas_Object *obj, char *part, Evas_Object *child, unsigned int pos)
    Eina_Bool edje_object_part_box_insert_before(Evas_Object *obj, char *part, Evas_Object *child, const Evas_Object *reference)
    Eina_Bool edje_object_part_box_insert_after(Evas_Object *obj, char *part, Evas_Object *child, const Evas_Object *reference)
    Evas_Object *edje_object_part_box_remove(Evas_Object *obj, char *part, Evas_Object *child)
    Evas_Object *edje_object_part_box_remove_at(Evas_Object *obj, char *part, unsigned int pos)
    Eina_Bool edje_object_part_box_remove_all(Evas_Object *obj, char *part, int clear)

    Eina_Bool edje_object_part_table_pack(Evas_Object *obj, char *part, Evas_Object *child, unsigned short col, unsigned short row, unsigned short colspan, unsigned short rowspan)
    Eina_Bool edje_object_part_table_unpack(Evas_Object *obj, char *part, Evas_Object *child)
    Eina_Bool edje_object_part_table_col_row_size_get(Evas_Object *obj, char *part, int *cols, int *rows)
    Eina_Bool edje_object_part_table_clear(Evas_Object *obj, char *part, int clear)
    Evas_Object *edje_object_part_table_child_get(Evas_Object *obj, char *part, unsigned int col, unsigned int row)

    char *edje_object_part_state_get(Evas_Object *obj, char *part, double *val_ret)

    int edje_object_part_drag_dir_get(Evas_Object *obj, char *part)
    void edje_object_part_drag_value_set(Evas_Object *obj, char *part, double dx, double dy)
    void edje_object_part_drag_value_get(Evas_Object *obj, char *part, double *dx, double *dy)
    void edje_object_part_drag_size_set(Evas_Object *obj, char *part, double dw, double dh)
    void edje_object_part_drag_size_get(Evas_Object *obj, char *part, double *dw, double *dh)
    void edje_object_part_drag_step_set(Evas_Object *obj, char *part, double dx, double dy)
    void edje_object_part_drag_step_get(Evas_Object *obj, char *part, double *dx, double *dy)
    void edje_object_part_drag_page_set(Evas_Object *obj, char *part, double dx, double dy)
    void edje_object_part_drag_page_get(Evas_Object *obj, char *part, double *dx, double *dy)
    void edje_object_part_drag_step(Evas_Object *obj, char *part, double dx, double dy)
    void edje_object_part_drag_page(Evas_Object *obj, char *part, double dx, double dy)

    Evas_Object *edje_object_part_external_object_get(Evas_Object *obj, char *part)
    Eina_Bool edje_object_part_external_param_set(Evas_Object *obj, char *part, Edje_External_Param *param)
    Eina_Bool edje_object_part_external_param_get(Evas_Object *obj, char *part, Edje_External_Param *param)
    Edje_External_Param_Type edje_object_part_external_param_type_get(Evas_Object *obj, char *part, char *param)

    char *edje_external_param_type_str(Edje_External_Param_Type type)

    void edje_object_message_send(Evas_Object *obj, Edje_Message_Type type, int id, void *msg)
    void edje_object_message_handler_set(Evas_Object *obj, void(*func)(void *data, Evas_Object *obj, Edje_Message_Type type, int id, void *msg), void *data)
    void edje_object_message_signal_process(Evas_Object *obj)

    void edje_message_signal_process()

    unsigned int edje_external_type_abi_version_get()

    Eina_Iterator *edje_external_iterator_get()
    Edje_External_Param_Info *edje_external_param_info_get(char *type_name)
    Edje_External_Type *edje_external_type_get(char *type_name)

    Eina_Bool edje_module_load(char *name)
    Eina_List *edje_available_modules_get()


cdef class Message:
    cdef int _type
    cdef int _id


cdef class MessageSignal(Message):
    pass


cdef class MessageString(Message):
    cdef Edje_Message_String *obj


cdef class MessageInt(Message):
    cdef Edje_Message_Int *obj


cdef class MessageFloat(Message):
    cdef Edje_Message_Float *obj


cdef class MessageStringSet(Message):
    cdef Edje_Message_String_Set *obj


cdef class MessageIntSet(Message):
    cdef Edje_Message_Int_Set *obj


cdef class MessageFloatSet(Message):
    cdef Edje_Message_Float_Set *obj


cdef class MessageStringInt(Message):
    cdef Edje_Message_String_Int *obj


cdef class MessageStringFloat(Message):
    cdef Edje_Message_String_Float *obj


cdef class MessageStringIntSet(Message):
    cdef Edje_Message_String_Int_Set *obj


cdef class MessageStringFloatSet(Message):
    cdef Edje_Message_String_Float_Set *obj


cdef class ExternalParam:
    cdef Edje_External_Param *obj


cdef class ExternalParamInfo:
    cdef Edje_External_Param_Info *obj
    cdef readonly object external_type
    cdef const Edje_External_Type *_external_type_obj
    cdef _set_external_type(self, t)


cdef class ExternalParamInfoInt(ExternalParamInfo):
    pass


cdef class ExternalParamInfoDouble(ExternalParamInfo):
    pass


cdef class ExternalParamInfoString(ExternalParamInfo):
    pass


cdef class ExternalParamInfoBool(ExternalParamInfo):
    pass


cdef class ExternalParamInfoChoice(ExternalParamInfo):
    pass


cdef class ExternalType:
    cdef object _name
    cdef object _parameters_info
    cdef const Edje_External_Type *_obj


cdef class Edje(Object):
    cdef object _text_change_cb
    cdef object _message_handler_cb
    cdef object _signal_callbacks

    cdef void message_send_int(self, int id, int data)
    cdef void message_send_float(self, int id, float data)
    cdef void message_send_str(self, int id, data)
    cdef void message_send_str_set(self, int id, data)
    cdef void message_send_str_int(self, int id, s, int i)
    cdef void message_send_str_float(self, int id, s, float f)
    cdef void message_send_str_int_set(self, int id, s, data)
    cdef void message_send_str_float_set(self, int id, s, data)
    cdef void message_send_int_set(self, int id, data)
    cdef void message_send_float_set(self, int id, data)
    cdef message_send_set(self, int id, data)


cdef ExternalParam ExternalParam_from_ptr(Edje_External_Param *param)
