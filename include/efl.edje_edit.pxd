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

from efl.eina cimport Eina_Bool, Eina_List
from efl.evas cimport Evas_Event_Flags
from efl.evas cimport Evas_Object, Evas
from efl.edje cimport Edje_Part_Type, Edje_Text_Effect, Edje_Tween_Mode, \
    Edje_Action_Type

from efl.edje_edit.enums cimport Edje_Edit_Image_Comp

cdef extern from "Edje_Edit.h":
    ####################################################################
    # Structures
    #
    ctypedef struct Edje_Edit_Script_Error:
        const char *program_name
        int line
        const char *error_str

    ####################################################################
    # Engine
    #

    # general
    Evas_Object *edje_edit_object_add(Evas *e)
    void         edje_edit_string_free(const char *str)
    void         edje_edit_string_list_free(Eina_List *lst)

    const char  *edje_edit_compiler_get(Evas_Object *obj)
    Eina_Bool    edje_edit_save(Evas_Object *obj)
    Eina_Bool    edje_edit_save_all(Evas_Object *obj)
    void         edje_edit_print_internal_status(Evas_Object *obj)

    # group
    Eina_Bool  edje_edit_group_add(Evas_Object *obj, const char *name)
    Eina_Bool  edje_edit_group_del(Evas_Object *obj, const char *group_name)
    Eina_Bool  edje_edit_group_exist(Evas_Object *obj, const char *group)
    Eina_Bool  edje_edit_group_name_set(Evas_Object *obj, char *new_name)
    int        edje_edit_group_min_w_get(Evas_Object *obj)
    Eina_Bool  edje_edit_group_min_w_set(Evas_Object *obj, int w)
    int        edje_edit_group_min_h_get(Evas_Object *obj)
    Eina_Bool  edje_edit_group_min_h_set(Evas_Object *obj, int h)
    int        edje_edit_group_max_w_get(Evas_Object *obj)
    Eina_Bool  edje_edit_group_max_w_set(Evas_Object *obj, int w)
    int        edje_edit_group_max_h_get(Evas_Object *obj)
    Eina_Bool  edje_edit_group_max_h_set(Evas_Object *obj, int h)

    # data
    Eina_List  *edje_edit_data_list_get(Evas_Object *obj)
    Eina_Bool   edje_edit_data_add(Evas_Object *obj, const char *itemname, const char *value)
    Eina_Bool   edje_edit_data_del(Evas_Object *obj, const char *itemname)
    const char *edje_edit_data_value_get(Evas_Object * obj, const char *itemname)
    Eina_Bool   edje_edit_data_value_set(Evas_Object * obj, const char *itemname, const char *value)
    Eina_Bool   edje_edit_data_name_set(Evas_Object *obj, const char *itemname, const char *newname)

    Eina_List  *edje_edit_group_data_list_get(Evas_Object *obj)
    Eina_Bool   edje_edit_group_data_add(Evas_Object *obj, const char *itemname, const char *value)
    Eina_Bool   edje_edit_group_data_del(Evas_Object *obj, const char *itemname)
    const char *edje_edit_group_data_value_get(Evas_Object *obj, const char *itemname)
    Eina_Bool   edje_edit_group_data_value_set(Evas_Object *obj, const char *itemname, const char *value)
    Eina_Bool   edje_edit_group_data_name_set(Evas_Object *obj, const char *itemname, const char *newname)

    # text styles
    Eina_List  *edje_edit_styles_list_get(Evas_Object *obj)
    Eina_Bool   edje_edit_style_add(Evas_Object *obj, const char *style)
    Eina_Bool   edje_edit_style_del(Evas_Object *obj, const char *style)
    Eina_List  *edje_edit_style_tags_list_get(Evas_Object *obj, const char *style)
    const char *edje_edit_style_tag_value_get(Evas_Object *obj, const char *style, const char *tag)
    Eina_Bool   edje_edit_style_tag_value_set(Evas_Object *obj, const char *style, const char *tag, const char *new_value)
    Eina_Bool   edje_edit_style_tag_name_set(Evas_Object *obj, const char *style, const char *tag, const char *new_name)
    Eina_Bool   edje_edit_style_tag_add(Evas_Object *obj, const char *style, const char *tag_name)
    Eina_Bool   edje_edit_style_tag_del(Evas_Object *obj, const char *style, const char *tag)

    # fonts
    Eina_List *edje_edit_fonts_list_get(Evas_Object *obj)
    Eina_Bool  edje_edit_font_add(Evas_Object *obj, const char *path, const char *alias)
    Eina_Bool  edje_edit_font_del(Evas_Object *obj, const char *alias)

    # color classes
    Eina_List *edje_edit_color_classes_list_get(Evas_Object *obj)
    Eina_Bool  edje_edit_color_class_add(Evas_Object *obj, const char *name)
    Eina_Bool  edje_edit_color_class_del(Evas_Object *obj, const char *name)
    Eina_Bool  edje_edit_color_class_colors_get(Evas_Object *obj, const char *class_name, int *r, int *g, int *b, int *a, int *r2, int *g2, int *b2, int *a2, int *r3, int *g3, int *b3, int *a3)
    Eina_Bool  edje_edit_color_class_colors_set(Evas_Object *obj, const char *class_name, int r, int g, int b, int a, int r2, int g2, int b2, int a2, int r3, int g3, int b3, int a3)
    Eina_Bool  edje_edit_color_class_name_set(Evas_Object *obj, const char *name, const char *newname)

    # externals
    Eina_List *edje_edit_externals_list_get(Evas_Object *obj)
    Eina_Bool  edje_edit_external_add(Evas_Object *obj, const char *name)
    Eina_Bool  edje_edit_external_del(Evas_Object *obj, const char *name)

    # images
    Eina_List           *edje_edit_images_list_get(Evas_Object *obj)
    Eina_Bool            edje_edit_image_add(Evas_Object *obj, const char *path)
    Eina_Bool            edje_edit_image_del(Evas_Object *obj, const char *name)
    Eina_Bool            edje_edit_image_data_add(Evas_Object *obj, const char *name, int id)
    const char          *edje_edit_state_image_get(Evas_Object *obj, const char *part, const char *state, double value)
    Eina_Bool            edje_edit_state_image_set(Evas_Object *obj, const char *part, const char *state, double value, const char *image)
    int                  edje_edit_image_id_get(Evas_Object *obj, const char *image_name)
    Edje_Edit_Image_Comp edje_edit_image_compression_type_get(Evas_Object *obj, const char *image)
    int                  edje_edit_image_compression_rate_get(Evas_Object *obj, const char *image)
    void                 edje_edit_state_image_border_get(Evas_Object *obj, const char *part, const char *state, double value, int *l, int *r, int *t, int *b)
    Eina_Bool            edje_edit_state_image_border_set(Evas_Object *obj, const char *part, const char *state, double value, int l, int r, int t, int b)
    unsigned char        edje_edit_state_image_border_fill_get(Evas_Object *obj, const char *part, const char *state, double value)
    Eina_Bool            edje_edit_state_image_border_fill_set(Evas_Object *obj, const char *part, const char *state, double value, unsigned char fill)
    Eina_List           *edje_edit_state_tweens_list_get(Evas_Object *obj, const char *part, const char *state, double value)
    Eina_Bool            edje_edit_state_tween_add(Evas_Object *obj, const char *part, const char *state, double value, const char *tween)
    Eina_Bool            edje_edit_state_tween_del(Evas_Object *obj, const char *part, const char *state, double value, const char *tween)

    # part
    Eina_List       *edje_edit_parts_list_get(Evas_Object *obj)
    Eina_Bool        edje_edit_part_add(Evas_Object *obj, const char *name, Edje_Part_Type type)
    Eina_Bool        edje_edit_part_external_add(Evas_Object *obj, const char *name, const char *source)
    Eina_Bool        edje_edit_part_del(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_exist(Evas_Object *obj, const char *part)
    const char      *edje_edit_part_above_get(Evas_Object *obj, const char *part)
    const char      *edje_edit_part_below_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_restack_below(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_restack_above(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_name_set(Evas_Object *obj, const char  *part, const char  *new_name)
    Edje_Part_Type   edje_edit_part_type_get(Evas_Object *obj, const char *part)
    const char      *edje_edit_part_clip_to_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_clip_to_set(Evas_Object *obj, const char *part, const char *clip_to)
    const char      *edje_edit_part_source_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_source_set(Evas_Object *obj, const char *part, const char *source)
    Edje_Text_Effect edje_edit_part_effect_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_effect_set(Evas_Object *obj, const char *part, Edje_Text_Effect effect)
    const char      *edje_edit_part_selected_state_get(Evas_Object *obj, const char *part, double *value)
    Eina_Bool        edje_edit_part_selected_state_set(Evas_Object *obj, const char *part, const char *state, double value)
    Eina_Bool        edje_edit_part_mouse_events_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_mouse_events_set(Evas_Object *obj, const char *part, Eina_Bool mouse_events)
    Eina_Bool        edje_edit_part_repeat_events_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_repeat_events_set(Evas_Object *obj, const char *part, Eina_Bool repeat_events)
    Evas_Event_Flags edje_edit_part_ignore_flags_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_ignore_flags_set(Evas_Object *obj, const char *part, Evas_Event_Flags ignore_flags)
    Eina_Bool        edje_edit_part_scale_set(Evas_Object *obj, const char *part, Eina_Bool scale)
    Eina_Bool        edje_edit_part_scale_get(Evas_Object *obju, const char *part)
    int              edje_edit_part_drag_x_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_x_set(Evas_Object *obj, const char *part, int drag)
    int              edje_edit_part_drag_y_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_y_set(Evas_Object *obj, const char *part, int drag)
    int              edje_edit_part_drag_step_x_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_step_x_set(Evas_Object *obj, const char *part, int step)
    int              edje_edit_part_drag_step_y_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_step_y_set(Evas_Object *obj, const char *part, int step)
    int              edje_edit_part_drag_count_x_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_count_x_set(Evas_Object *obj, const char *part, int count)
    int              edje_edit_part_drag_count_y_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_count_y_set(Evas_Object *obj, const char *part, int count)
    const char      *edje_edit_part_drag_confine_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_confine_set(Evas_Object *obj, const char *part, const char *confine)
    const char      *edje_edit_part_drag_event_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_drag_event_set(Evas_Object *obj, const char *part, const char *event)
    const char      *edje_edit_part_api_name_get(Evas_Object *obj, const char *part)
    const char      *edje_edit_part_api_description_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_part_api_name_set(Evas_Object *obj, const char *part, const char *name)
    Eina_Bool        edje_edit_part_api_description_set(Evas_Object *obj, const char *part, const char *description)
    const char      *edje_edit_program_api_name_get(Evas_Object *obj, const char *part)
    const char      *edje_edit_program_api_description_get(Evas_Object *obj, const char *part)
    Eina_Bool        edje_edit_program_api_name_set(Evas_Object *obj, const char *part, const char *name)
    Eina_Bool        edje_edit_program_api_description_set(Evas_Object *obj, const char *part, const char *description)

    # State
    Eina_List    *edje_edit_part_states_list_get(Evas_Object *obj, char *part)
    int           edje_edit_state_name_set(Evas_Object *obj, char *part, char *state, double value, char *new_name, double new_value)
    Eina_Bool     edje_edit_state_add(Evas_Object *obj, char *part, char *name, double value)
    Eina_Bool     edje_edit_state_del(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_exist(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_copy(Evas_Object *obj, char *part, char *sfrom, double vfrom, char *sto, double vto)
    double        edje_edit_state_rel1_relative_x_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_rel1_relative_y_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_rel2_relative_x_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_rel2_relative_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_rel1_relative_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_rel1_relative_y_set(Evas_Object *obj, char *part, char *state, double value, double y)
    Eina_Bool     edje_edit_state_rel2_relative_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_rel2_relative_y_set(Evas_Object *obj, char *part, char *state, double value, double y)
    int           edje_edit_state_rel1_offset_x_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_rel1_offset_y_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_rel2_offset_x_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_rel2_offset_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_rel1_offset_x_set(Evas_Object *obj, char *part, char *state, double value, int x)
    Eina_Bool     edje_edit_state_rel1_offset_y_set(Evas_Object *obj, char *part, char *state, double value, int y)
    Eina_Bool     edje_edit_state_rel2_offset_x_set(Evas_Object *obj, char *part, char *state, double value, int x)
    Eina_Bool     edje_edit_state_rel2_offset_y_set(Evas_Object *obj, char *part, char *state, double value, int y)
    char         *edje_edit_state_rel1_to_x_get(Evas_Object *obj, char *part, char *state, double value)
    char         *edje_edit_state_rel1_to_y_get(Evas_Object *obj, char *part, char *state, double value)
    char         *edje_edit_state_rel2_to_x_get(Evas_Object *obj, char *part, char *state, double value)
    char         *edje_edit_state_rel2_to_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_rel1_to_x_set(Evas_Object *obj, char *part, char *state, double value, char *rel_to)
    Eina_Bool     edje_edit_state_rel1_to_y_set(Evas_Object *obj, char *part, char *state, double value, char *rel_to)
    Eina_Bool     edje_edit_state_rel2_to_x_set(Evas_Object *obj, char *part, char *state, double value, char *rel_to)
    Eina_Bool     edje_edit_state_rel2_to_y_set(Evas_Object *obj, char *part, char *state, double value, char *rel_to)
    void          edje_edit_state_color_get(Evas_Object *obj, char *part, char *state, double value, int *r, int *g, int *b, int *a)
    void          edje_edit_state_color2_get(Evas_Object *obj, char *part, char *state, double value, int *r, int *g, int *b, int *a)
    void          edje_edit_state_color3_get(Evas_Object *obj, char *part, char *state, double value, int *r, int *g, int *b, int *a)
    Eina_Bool     edje_edit_state_color_set(Evas_Object *obj, char *part, char *state, double value, int r, int g, int b, int a)
    Eina_Bool     edje_edit_state_color2_set(Evas_Object *obj, char *part, char *state, double value, int r, int g, int b, int a)
    Eina_Bool     edje_edit_state_color3_set(Evas_Object *obj, char *part, char *state, double value, int r, int g, int b, int a)
    double        edje_edit_state_align_x_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_align_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_align_x_set(Evas_Object *obj, char *part, char *state, double value, double align)
    Eina_Bool     edje_edit_state_align_y_set(Evas_Object *obj, char *part, char *state, double value, double align)
    int           edje_edit_state_min_w_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_min_w_set(Evas_Object *obj, char *part, char *state, double value, int min_w)
    int           edje_edit_state_min_h_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_min_h_set(Evas_Object *obj, char *part, char *state, double value, int min_h)
    int           edje_edit_state_max_w_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_max_w_set(Evas_Object *obj, char *part, char *state, double value, int max_w)
    int           edje_edit_state_max_h_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_max_h_set(Evas_Object *obj, char *part, char *state, double value, int max_h)
    double        edje_edit_state_aspect_min_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_aspect_max_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_aspect_min_set(Evas_Object *obj, char *part, char *state, double value, double aspect)
    Eina_Bool     edje_edit_state_aspect_max_set(Evas_Object *obj, char *part, char *state, double value, double aspect)
    unsigned char edje_edit_state_aspect_pref_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_aspect_pref_set(Evas_Object *obj, char *part, char *state, double value, unsigned char pref)
    double        edje_edit_state_fill_origin_relative_x_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_fill_origin_relative_y_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_fill_origin_offset_x_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_fill_origin_offset_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_fill_origin_relative_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_origin_relative_y_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_origin_offset_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_origin_offset_y_set(Evas_Object *obj, char *part, char *state, double value, double y)
    double        edje_edit_state_fill_size_relative_x_get(Evas_Object *obj, char *part, char *state, double value)
    double        edje_edit_state_fill_size_relative_y_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_fill_size_offset_x_get(Evas_Object *obj, char *part, char *state, double value)
    int           edje_edit_state_fill_size_offset_y_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_fill_size_relative_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_size_relative_y_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_size_offset_x_set(Evas_Object *obj, char *part, char *state, double value, double x)
    Eina_Bool     edje_edit_state_fill_size_offset_y_set(Evas_Object *obj, char *part, char *state, double value, double y)
    Eina_Bool     edje_edit_state_visible_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_visible_set(Evas_Object *obj, char *part, char *state, double value, Eina_Bool visible)
    char         *edje_edit_state_color_class_get(Evas_Object *obj, char *part, char *state, double value)
    Eina_Bool     edje_edit_state_color_class_set(Evas_Object *obj, char *part, char *state, double value, char *color_class)

#     Eina_List * edje_edit_state_external_params_list_get(Evas_Object *obj, char *part, char *state, double value)
#     Eina_Bool edje_edit_state_external_param_get(Evas_Object *obj, char *part, char *state, double value, char *param, edje.c_edje.Edje_External_Param_Type *type, void **val)
#     Eina_Bool edje_edit_state_external_param_int_get(Evas_Object *obj, char *part, char *state, double value, char *param, int *val)
#     Eina_Bool edje_edit_state_external_param_bool_get(Evas_Object *obj, char *part, char *state, double value, char *param, Eina_Bool *val)
#     Eina_Bool edje_edit_state_external_param_double_get(Evas_Object *obj, char *part, char *state, double value, char *param, double *val)
#     Eina_Bool edje_edit_state_external_param_string_get(Evas_Object *obj, char *part, char *state, double value, char *param, char **val)
#     Eina_Bool edje_edit_state_external_param_choice_get(Evas_Object *obj, char *part, char *state, double value, char *param, char **val)
#     edje.c_edje.Edje_External_Param_Type edje_object_part_external_param_type_get(Evas_Object *obj, char *part, char *param)
#     char *edje_external_param_type_str(edje.c_edje.Edje_External_Param_Type type)
#     Eina_Bool edje_edit_state_external_param_set(Evas_Object *obj, char *part, char *state, double value, char *param, edje.c_edje.Edje_External_Param_Type type, ...)
#     Eina_Bool edje_edit_state_external_param_int_set(Evas_Object *obj, char *part, char *state, double value, char *param, int val)
#     Eina_Bool edje_edit_state_external_param_bool_set(Evas_Object *obj, char *part, char *state, double value, char *param, Eina_Bool val)
#     Eina_Bool edje_edit_state_external_param_double_set(Evas_Object *obj, char *part, char *state, double value, char *param, double val)
#     Eina_Bool edje_edit_state_external_param_string_set(Evas_Object *obj, char *part, char *state, double value, char *param, char *val)
#     Eina_Bool edje_edit_state_external_param_choice_set(Evas_Object *obj, char *part, char *state, double value, char *param, char *val)


    # programs
    Eina_List       *edje_edit_programs_list_get(Evas_Object *obj)
    Eina_Bool        edje_edit_program_add(Evas_Object *obj, const char *name)
    Eina_Bool        edje_edit_program_del(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_exist(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_run(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_name_set(Evas_Object *obj, const char *prog, const char *new_name)
    const char      *edje_edit_program_source_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_source_set(Evas_Object *obj, const char *prog, const char *source)
    const char      *edje_edit_program_signal_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_signal_set(Evas_Object *obj, const char *prog, const char *signal)
    double           edje_edit_program_in_from_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_in_from_set(Evas_Object *obj, const char *prog, double seconds)
    double           edje_edit_program_in_range_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_in_range_set(Evas_Object *obj, const char *prog, double seconds)
    Edje_Action_Type edje_edit_program_action_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_action_set(Evas_Object *obj, const char *prog, Edje_Action_Type action)
    Eina_List       *edje_edit_program_targets_get(Evas_Object *, const char *prog)
    Eina_Bool        edje_edit_program_target_add(Evas_Object *obj, const char *prog, const char *target)
    Eina_Bool        edje_edit_program_target_del(Evas_Object *obj, const char *prog, const char *target)
    Eina_Bool        edje_edit_program_targets_clear(Evas_Object *obj, const char *prog)
    Eina_List       *edje_edit_program_afters_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_after_add(Evas_Object *obj, const char *prog, const char *after)
    Eina_Bool        edje_edit_program_after_del(Evas_Object *obj, const char *prog, const char *after)
    Eina_Bool        edje_edit_program_afters_clear(Evas_Object *obj, const char *prog)
    const char      *edje_edit_program_state_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_state_set(Evas_Object *obj, const char *prog, const char *state)
    double           edje_edit_program_value_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_value_set(Evas_Object *obj, const char *prog, double value)
    const char      *edje_edit_program_state2_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_state2_set(Evas_Object *obj, const char *prog, const char *state2)
    double           edje_edit_program_value2_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_value2_set(Evas_Object *obj, const char *prog, double value)
    Edje_Tween_Mode  edje_edit_program_transition_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_transition_set(Evas_Object *obj, const char *prog, Edje_Tween_Mode transition)
    double           edje_edit_program_transition_time_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_program_transition_time_set(Evas_Object *obj, const char *prog, double seconds)

    # scripts
    char*            edje_edit_script_get(Evas_Object *obj)
    Eina_Bool        edje_edit_script_set(Evas_Object *obj, const char *code)
    char*            edje_edit_script_program_get(Evas_Object *obj, const char *prog)
    Eina_Bool        edje_edit_script_program_set(Evas_Object *obj, const char *prog, const char *code)
    Eina_Bool        edje_edit_script_compile(Evas_Object *obj)
    const Eina_List *edje_edit_script_error_list_get(Evas_Object *obj)

