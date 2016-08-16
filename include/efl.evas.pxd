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

from cpython cimport PyObject
from efl.eina cimport *
from efl.eo cimport Eo
from efl.c_eo cimport Eo as cEo, Eo_Class

from efl.evas.enums cimport Evas_Button_Flags, Evas_BiDi_Direction, \
    Evas_Callback_Type, Evas_Event_Flags, Evas_Touch_Point_State, \
    Evas_Font_Hinting_Flags, Evas_Colorspace, \
    Evas_Object_Table_Homogeneous_Mode, Evas_Aspect_Control, \
    Evas_Display_Mode, Evas_Load_Error, Evas_Alloc_Error, Evas_Fill_Spread, \
    Evas_Pixel_Import_Pixel_Format, Evas_Native_Surface_Type, Evas_Render_Op, \
    Evas_Border_Fill_Mode, Evas_Image_Scale_Hint, \
    Evas_Image_Animated_Loop_Hint, Evas_Image_Orient, \
    Evas_Engine_Render_Mode, Evas_Image_Content_Hint, Evas_Device_Class, \
    Evas_Object_Pointer_Mode, Evas_Text_Style_Type, Evas_Textblock_Text_Type, \
    Evas_Textblock_Cursor_Type, Evas_Textgrid_Palette, Evas_Textgrid_Font_Style

cdef extern from "Evas.h":

    ####################################################################
    # Basic Types
    #
    ctypedef int Evas_Coord
    ctypedef int Evas_Angle
    ctypedef int Evas_Font_Size
    ctypedef unsigned long long Evas_Modifier_Mask


    ####################################################################
    # Structures
    #
    ctypedef struct Evas_Point:
        int x
        int y

    ctypedef struct Evas_Coord_Point:
        Evas_Coord x
        Evas_Coord y

    ctypedef struct Evas_Coord_Size:
        Evas_Coord w
        Evas_Coord h

    ctypedef struct Evas_Coord_Rectangle:
        Evas_Coord x
        Evas_Coord y
        Evas_Coord w
        Evas_Coord h

    ctypedef struct Evas_Coord_Precision_Point:
        Evas_Coord x
        Evas_Coord y
        double xsub
        double ysub

    ctypedef struct Evas_Position:
        Evas_Point output
        Evas_Coord_Point canvas

    ctypedef struct Evas_Precision_Position:
        Evas_Point output
        Evas_Coord_Precision_Point canvas

    ctypedef struct Evas_Hash

    ctypedef cEo Evas
    ctypedef cEo Evas_Object
    ctypedef cEo Evas_Object_Smart

    ctypedef struct Evas_Modifier
    ctypedef struct Evas_Lock
    ctypedef struct Evas_Smart
    ctypedef struct Evas_Native_Surface
    ctypedef struct Evas_Textblock_Style
    ctypedef struct Evas_Textblock_Cursor

    ctypedef struct Evas_Smart_Cb_Description:
        const char *name
        const char *type

    ctypedef struct Evas_Smart_Interface

    ctypedef struct Evas_Smart_Class
    ctypedef struct Evas_Smart_Class:
        const char *name
        int version
        void (*add)(Evas_Object *o)
        void (*delete "del")(Evas_Object *o)
        void (*move)(Evas_Object *o, int x, int y)
        void (*resize)(Evas_Object *o, int w, int h)
        void (*show)(Evas_Object *o)
        void (*hide)(Evas_Object *o)
        void (*color_set)(Evas_Object *o, int r, int g, int b, int a)
        void (*clip_set)(Evas_Object *o, Evas_Object *clip)
        void (*clip_unset)(Evas_Object *o)
        void (*calculate)(Evas_Object *o)
        void (*member_add)(Evas_Object *o, Evas_Object *child)
        void (*member_del)(Evas_Object *o, Evas_Object *child)
        const Evas_Smart_Class *parent
        const Evas_Smart_Cb_Description *callbacks
        const Evas_Smart_Interface **interfaces
        const void *data

    ctypedef struct Evas_Device

    ctypedef struct Evas_Event_Mouse_In:
        int buttons
        Evas_Point output
        Evas_Coord_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Mouse_Out:
        int buttons
        Evas_Point output
        Evas_Coord_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Mouse_Down:
        int button
        Evas_Point output
        Evas_Coord_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        Evas_Button_Flags flags
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Mouse_Up:
        int button
        Evas_Point output
        Evas_Coord_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        Evas_Button_Flags flags
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Mouse_Move:
        int buttons
        Evas_Position cur
        Evas_Position prev
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev


    ctypedef struct Evas_Event_Multi_Down:
        int device
        double radius
        double radius_x
        double radius_y
        double pressure
        double angle
        Evas_Point output
        Evas_Coord_Precision_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        Evas_Button_Flags flags
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Multi_Up:
        int device
        double radius
        double radius_x
        double radius_y
        double pressure
        double angle
        Evas_Point output
        Evas_Coord_Precision_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        Evas_Button_Flags flags
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Multi_Move:
        double radius
        double radius_x
        double radius_y
        double pressure
        double angle
        Evas_Precision_Position cur
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Mouse_Wheel:
        int direction # 0 = default up/down wheel
        int z         # ...,-2,-1 = down, 1,2,... = up */
        Evas_Point output
        Evas_Coord_Point canvas
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Key_Down:
        char *keyname
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        const char *key
        const char *string
        const char *compose
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Key_Up:
        char *keyname
        void *data
        Evas_Modifier *modifiers
        Evas_Lock *locks
        const char *key
        const char *string
        const char *compose
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Event_Hold:
        int hold
        void *data
        unsigned int timestamp
        Evas_Event_Flags event_flags
        Evas_Device *dev

    ctypedef struct Evas_Object_Box_Option:
        Evas_Object *obj

    ctypedef struct Evas_Map


    ####################################################################
    # Other typedefs
    #
    ctypedef void (*Evas_Event_Cb)(void *data, Evas *e, void *event_info)
    ctypedef void (*Evas_Object_Event_Cb)(void *data, Evas *e, Evas_Object *obj, void *event_info)
    ctypedef void (*Evas_Smart_Cb)(void *data, Evas_Object *obj, void *event_info)

    ctypedef void *Evas_Object_Box_Data
    ctypedef void (*Evas_Object_Box_Layout)(Evas_Object *o, Evas_Object_Box_Data *priv, void *user_data)


    ####################################################################
    # Engine
    #
    int evas_init()
    int evas_shutdown()

    void              evas_font_path_global_clear()
    void              evas_font_path_global_append(const char *path)
    void              evas_font_path_global_prepend(const char *path)
    const Eina_List * evas_font_path_global_list()


    ####################################################################
    # Canvas
    #
    Evas *evas_new()
    void  evas_free(Evas *e)

    const Eo_Class *evas_class_get()

    int        evas_render_method_lookup(const char *name)
    Eina_List *evas_render_method_list()
    void       evas_render_method_list_free(Eina_List *list)
    void       evas_output_method_set(Evas *e, int render_method)
    int        evas_output_method_get(Evas *e)

    void *evas_engine_info_get(Evas *e)
    int   evas_engine_info_set(Evas *e, void *info)

    void       evas_output_size_set(Evas *e, int w, int h)
    void       evas_output_size_get(const Evas *e, int *w, int *h)
    void       evas_output_viewport_set(Evas *e, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void       evas_output_viewport_get(const Evas *e, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)
    Evas_Coord evas_coord_screen_x_to_world(const Evas *e, int x)
    Evas_Coord evas_coord_screen_y_to_world(const Evas *e, int y)
    int        evas_coord_world_x_to_screen(const Evas *e, Evas_Coord x)
    int        evas_coord_world_y_to_screen(const Evas *e, Evas_Coord y)

    void       evas_pointer_output_xy_get(const Evas *e, int *x, int *y)
    void       evas_pointer_canvas_xy_get(const Evas *e, Evas_Coord *x, Evas_Coord *y)
    int        evas_pointer_button_down_mask_get(const Evas *e)
    Eina_Bool  evas_pointer_inside_get(const Evas *e)

    Evas_Object *evas_object_top_at_xy_get(const Evas *e, Evas_Coord x, Evas_Coord y, Eina_Bool include_pass_events_objects, Eina_Bool include_hidden_objects)
    Evas_Object *evas_object_top_at_pointer_get(const Evas *e)
    Evas_Object *evas_object_top_in_rectangle_get(const Evas *e, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h, Eina_Bool include_pass_events_objects, Eina_Bool include_hidden_objects)

    Eina_List   *evas_objects_at_xy_get(const Evas *e, Evas_Coord x, Evas_Coord y, Eina_Bool include_pass_events_objects, Eina_Bool include_hidden_objects)
    Eina_List   *evas_objects_in_rectangle_get(const Evas *e, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h, Eina_Bool include_pass_events_objects, Eina_Bool include_hidden_objects)

    void       evas_damage_rectangle_add(Evas *e, int x, int y, int w, int h)
    void       evas_obscured_rectangle_add(Evas *e, int x, int y, int w, int h)
    void       evas_obscured_clear(Evas *e)
    Eina_List *evas_render_updates(Evas *e)
    void       evas_render_updates_free(Eina_List *updates)
    void       evas_render(Evas *e)
    void       evas_norender(Evas *e)
    void      *evas_data_attach_get(const Evas *e)
    void       evas_data_attach_set(Evas *e, void *data)

    Evas_Object *evas_focus_get(const Evas *e)

    Evas_Modifier *evas_key_modifier_get(Evas *e)
    Eina_Bool      evas_key_modifier_is_set(Evas_Modifier *m, const char *keyname)

    void evas_event_freeze(Evas *e)
    void evas_event_thaw(Evas *e)
    int  evas_event_freeze_get(const Evas *e)

    void evas_event_feed_mouse_down(Evas *e, int b, Evas_Button_Flags flags, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_up(Evas *e, int b, Evas_Button_Flags flags, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_cancel(Evas *e, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_wheel(Evas *e, int direction, int z, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_move(Evas *e, int x, int y, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_in(Evas *e, unsigned int timestamp, const void *data)
    void evas_event_feed_mouse_out(Evas *e, unsigned int timestamp, const void *data)
    void evas_event_feed_multi_down(Evas *e, int d, int x, int y, double rad, double radx, double rady, double pres, double ang, double fx, double fy, Evas_Button_Flags flags, unsigned int timestamp, const void *data)
    void evas_event_feed_multi_up(Evas *e, int d, int x, int y, double rad, double radx, double rady, double pres, double ang, double fx, double fy, Evas_Button_Flags flags, unsigned int timestamp, const void *data)
    void evas_event_feed_multi_move(Evas *e, int d, int x, int y, double rad, double radx, double rady, double pres, double ang, double fx, double fy, unsigned int timestamp, const void *data)
    void evas_event_feed_key_down(Evas *e, const char *keyname, const char *key, const char *string, const char *compose, unsigned int timestamp, const void *data)
    void evas_event_feed_key_up(Evas *e, const char *keyname, const char *key, const char *string, const char *compose, unsigned int timestamp, const void *data)
    void evas_event_feed_hold(Evas *e, int hold, unsigned int timestamp, const void *data)

    void             evas_font_path_clear(Evas *e)
    void             evas_font_path_append(Evas *e, const char *path)
    void             evas_font_path_prepend(Evas *e, const char *path)
    const Eina_List *evas_font_path_list(const Evas *e)

    void                    evas_font_hinting_set(Evas *e, Evas_Font_Hinting_Flags hinting)
    Evas_Font_Hinting_Flags evas_font_hinting_get(const Evas *e)
    Eina_Bool               evas_font_hinting_can_hint(const Evas *e, Evas_Font_Hinting_Flags hinting)

    void evas_font_cache_flush(Evas *e)
    void evas_font_cache_set(Evas *e, int size)
    int  evas_font_cache_get(const Evas *e)

    Eina_List *evas_font_available_list(const Evas *e)
    void       evas_font_available_list_free(Evas *e, Eina_List *available)

    void evas_image_cache_flush(Evas *e)
    void evas_image_cache_reload(Evas *e)
    void evas_image_cache_set(Evas *e, int size)
    int  evas_image_cache_get(const Evas *e)


    ####################################################################
    # Base Object
    #
    void  evas_object_del(Evas_Object *obj)
    Evas *evas_object_evas_get(const Evas_Object *obj)

    void  evas_object_data_set(Evas_Object *obj, const char *key, const void *data)
    void *evas_object_data_get(const Evas_Object *obj, const char *key)
    void *evas_object_data_del(Evas_Object *obj, const char *key)

    const char *evas_object_type_get(const Evas_Object *obj)

    void evas_object_layer_set(Evas_Object *obj, int l)
    int  evas_object_layer_get(const Evas_Object *obj)

    void         evas_object_raise(Evas_Object *obj)
    void         evas_object_lower(Evas_Object *obj)
    void         evas_object_stack_above(Evas_Object *obj, Evas_Object *above)
    void         evas_object_stack_below(Evas_Object *obj, Evas_Object *below)
    Evas_Object *evas_object_above_get(const Evas_Object *obj)
    Evas_Object *evas_object_below_get(const Evas_Object *obj)
    Evas_Object *evas_object_bottom_get(const Evas *e)
    Evas_Object *evas_object_top_get(const Evas *e)

    void evas_object_move(Evas_Object *obj, Evas_Coord x, Evas_Coord y)
    void evas_object_resize(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void evas_object_geometry_get(const Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)

    void evas_object_size_hint_min_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void evas_object_size_hint_min_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void evas_object_size_hint_max_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void evas_object_size_hint_max_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    Evas_Display_Mode evas_object_size_hint_display_mode_get(const Evas_Object *obj)
    void evas_object_size_hint_display_mode_set(Evas_Object *obj, Evas_Display_Mode dispmode)
    void evas_object_size_hint_request_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void evas_object_size_hint_request_set(Evas_Object *obj, Evas_Coord w, Evas_Coord h)
    void evas_object_size_hint_aspect_get(const Evas_Object *obj, Evas_Aspect_Control *aspect, Evas_Coord *w, Evas_Coord *h)
    void evas_object_size_hint_aspect_set(Evas_Object *obj, Evas_Aspect_Control aspect, Evas_Coord w, Evas_Coord h)
    void evas_object_size_hint_align_get(const Evas_Object *obj, double *x, double *y)
    void evas_object_size_hint_align_set(Evas_Object *obj, double x, double y)
    void evas_object_size_hint_fill_get(const Evas_Object *obj, double *x, double *y)
    void evas_object_size_hint_fill_set(Evas_Object *obj, double x, double y)
    void evas_object_size_hint_weight_get(const Evas_Object *obj, double *x, double *y)
    void evas_object_size_hint_weight_set(Evas_Object *obj, double x, double y)
    void evas_object_size_hint_expand_get(const Evas_Object *obj, double *x, double *y)
    void evas_object_size_hint_expand_set(Evas_Object *obj, double x, double y)
    void evas_object_size_hint_padding_get(const Evas_Object *obj, Evas_Coord *l, Evas_Coord *r, Evas_Coord *t, Evas_Coord *b)
    void evas_object_size_hint_padding_set(Evas_Object *obj, Evas_Coord l, Evas_Coord r, Evas_Coord t, Evas_Coord b)

    void      evas_object_show(Evas_Object *obj)
    void      evas_object_hide(Evas_Object *obj)
    Eina_Bool evas_object_visible_get(const Evas_Object *obj)

    void      evas_object_precise_is_inside_set(Evas_Object *obj, Eina_Bool precise)
    Eina_Bool evas_object_precise_is_inside_get(const Evas_Object *obj)

    void      evas_object_static_clip_set(Evas_Object *obj, Eina_Bool is_static_clip)
    Eina_Bool evas_object_static_clip_get(Evas_Object *obj)

    void           evas_object_render_op_set(Evas_Object *obj, Evas_Render_Op op)
    Evas_Render_Op evas_object_render_op_get(const Evas_Object *obj)

    void      evas_object_anti_alias_set(Evas_Object *obj, Eina_Bool antialias)
    Eina_Bool evas_object_anti_alias_get(const Evas_Object *obj)

    void   evas_object_scale_set(Evas_Object *obj, double scale)
    double evas_object_scale_get(const Evas_Object *obj)

    void evas_object_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void evas_object_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)

    void evas_color_argb_premul(int a, int *r, int *g, int *b)
    void evas_color_argb_unpremul(int a, int *r, int *g, int *b)

    void evas_color_hsv_to_rgb(float h, float s, float v, int *r, int *g, int *b)
    void evas_color_rgb_to_hsv(int r, int g, int b, float *h, float *s, float *v)

    void             evas_object_clip_set(Evas_Object *obj, Evas_Object *clip)
    Evas_Object     *evas_object_clip_get(const Evas_Object *obj)
    void             evas_object_clip_unset(Evas_Object *obj)
    const Eina_List *evas_object_clipees_get(const Evas_Object *obj)

    void         evas_object_name_set(Evas_Object *obj, const char *name)
    const char  *evas_object_name_get(const Evas_Object *obj)
    Evas_Object *evas_object_name_find(const Evas *e, const char *name)

    int evas_async_events_fd_get()
    int evas_async_events_process()

    void  evas_object_event_callback_add(Evas_Object *obj, Evas_Callback_Type type, Evas_Object_Event_Cb func, const void *data)
    void *evas_object_event_callback_del(Evas_Object *obj, Evas_Callback_Type type, Evas_Object_Event_Cb func)

    void  evas_event_callback_add(Evas *e, Evas_Callback_Type type, Evas_Event_Cb func, const void *data)
    void *evas_event_callback_del(Evas *e, Evas_Callback_Type type, Evas_Event_Cb func)

    void      evas_object_pass_events_set(Evas_Object *obj, Eina_Bool p)
    Eina_Bool evas_object_pass_events_get(const Evas_Object *obj)
    void      evas_object_repeat_events_set(Evas_Object *obj, Eina_Bool repeat)
    Eina_Bool evas_object_repeat_events_get(const Evas_Object *obj)
    void      evas_object_propagate_events_set(Evas_Object *obj, Eina_Bool prop)
    Eina_Bool evas_object_propagate_events_get(const Evas_Object *obj)
    void      evas_object_freeze_events_set(Evas_Object *obj, Eina_Bool freeze)
    Eina_Bool evas_object_freeze_events_get(const Evas_Object *obj)

    void                     evas_object_pointer_mode_set(Evas_Object *obj, Evas_Object_Pointer_Mode setting)
    Evas_Object_Pointer_Mode evas_object_pointer_mode_get(const Evas_Object *obj)

    void      evas_object_focus_set(Evas_Object *obj, Eina_Bool focus)
    Eina_Bool evas_object_focus_get(const Evas_Object *obj)

    Eina_Bool evas_object_key_grab(Evas_Object *obj, const char *keyname, Evas_Modifier_Mask modifiers, Evas_Modifier_Mask not_modifiers, Eina_Bool exclusive)
    void      evas_object_key_ungrab(Evas_Object *obj, const char *keyname, Evas_Modifier_Mask modifiers, Evas_Modifier_Mask not_modifiers)
    void      evas_object_is_frame_object_set(Evas_Object *obj, Eina_Bool is_frame)
    Eina_Bool evas_object_is_frame_object_get(Evas_Object *obj)

    void                 evas_object_paragraph_direction_set(Evas_Object *obj, Evas_BiDi_Direction direction)
    Evas_BiDi_Direction  evas_object_paragraph_direction_get(Evas_Object *obj)


    ####################################################################
    # Smart Object
    #
    void              evas_smart_free(Evas_Smart *s)
    Evas_Smart       *evas_smart_class_new(Evas_Smart_Class *sc)
    Evas_Smart_Class *evas_smart_class_get(Evas_Smart *s)
    const Eo_Class   *evas_object_smart_class_get()
    const Evas_Smart_Cb_Description **evas_smart_callbacks_descriptions_get(const Evas_Smart *s, unsigned int *count)
    const Evas_Smart_Cb_Description  *evas_smart_callback_description_find(const Evas_Smart *s, const char *name)

    void *evas_smart_data_get(Evas_Smart *s)

    Evas_Object   *evas_object_smart_add(Evas *e, Evas_Smart *s)
    void           evas_object_smart_member_add(Evas_Object *obj, Evas_Object *smart_obj)
    void           evas_object_smart_member_del(Evas_Object *obj)
    Evas_Object   *evas_object_smart_parent_get(const Evas_Object *obj)
    Eina_List     *evas_object_smart_members_get(const Evas_Object *obj)
    Evas_Smart    *evas_object_smart_smart_get(const Evas_Object *obj)
    void          *evas_object_smart_data_get(const Evas_Object *obj)
    void           evas_object_smart_data_set(Evas_Object *obj, void *data)
    void           evas_object_smart_callback_add(Evas_Object *obj, const char *event, Evas_Smart_Cb func, const void *data)
    void          *evas_object_smart_callback_del(Evas_Object *obj, const char *event, Evas_Smart_Cb func)
    void          *evas_object_smart_callback_del_full(Evas_Object *obj, const char *event, Evas_Smart_Cb func, const void *data)
    void           evas_object_smart_callback_call(Evas_Object *obj, const char *event, void *event_info)
    void           evas_object_smart_changed(Evas_Object *obj)
    void           evas_object_smart_need_recalculate_set(Evas_Object *obj, int value)
    int            evas_object_smart_need_recalculate_get(const Evas_Object *obj)
    void           evas_object_smart_calculate(Evas_Object *obj)
    void           evas_object_smart_move_children_relative(Evas_Object *obj, int dx, int dy)
    Eina_Iterator *evas_object_smart_iterator_new(const Evas_Object_Smart *obj)
    void           evas_object_smart_clipped_smart_set(Evas_Smart_Class *sc)
    Eina_Bool      evas_object_smart_callbacks_descriptions_set(Evas_Object_Smart *obj, const Evas_Smart_Cb_Description *descriptions)
    void           evas_object_smart_callbacks_descriptions_get(const Evas_Object_Smart *obj, const Evas_Smart_Cb_Description ***class_descriptions, unsigned int *class_count, const Evas_Smart_Cb_Description ***instance_descriptions, unsigned int *instance_count)
    void           evas_object_smart_callback_description_find(const Evas_Object_Smart *obj, const char *name, const Evas_Smart_Cb_Description **class_description, const Evas_Smart_Cb_Description **instance_description)


    ####################################################################
    # Rectangle Object
    #
    Evas_Object    *evas_object_rectangle_add(Evas *e)
    const Eo_Class *evas_object_rectangle_class_get()


    ####################################################################
    # Line Object
    #
    Evas_Object    *evas_object_line_add(Evas *e)
    void            evas_object_line_xy_set(Evas_Object *obj, Evas_Coord x1, Evas_Coord y1, Evas_Coord x2, Evas_Coord y2)
    void            evas_object_line_xy_get(const Evas_Object *obj, Evas_Coord *x1, Evas_Coord *y1, Evas_Coord *x2, Evas_Coord *y2)
    const Eo_Class *evas_object_line_class_get()


    ####################################################################
    # Image Object
    #
    Evas_Object        *evas_object_image_add(Evas *e)
    # TODO: Use this?: Evas_Object         *evas_object_image_filled_add(Evas *e)
    # TODO: void                evas_object_image_memfile_set(Evas_Object *obj, void *data, int size, char *format, char *key)
    # TODO: Is this needed?: const Eo_Class *evas_object_image_class_get()
    void                evas_object_image_file_set(Evas_Object *obj, const char *file, const char *key)
    void                evas_object_image_file_get(const Evas_Object *obj, const char **file, const char **key)
    void                evas_object_image_border_set(Evas_Object *obj, int l, int r, int t, int b)
    void                evas_object_image_border_get(const Evas_Object *obj, int *l, int *r, int *t, int *b)
    void                evas_object_image_border_center_fill_set(Evas_Object *obj, Eina_Bool fill)
    Eina_Bool           evas_object_image_border_center_fill_get(const Evas_Object *obj)
    void                evas_object_image_filled_set(Evas_Object *obj, Eina_Bool setting)
    Eina_Bool           evas_object_image_filled_get(const Evas_Object *obj)
    void                evas_object_image_border_scale_set(Evas_Object *obj, double scale)
    double              evas_object_image_border_scale_get(const Evas_Object *obj)
    void                evas_object_image_fill_set(Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h)
    void                evas_object_image_fill_get(const Evas_Object *obj, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)
    void                evas_object_image_fill_spread_set(Evas_Object *obj, Evas_Fill_Spread spread)
    Evas_Fill_Spread    evas_object_image_fill_spread_get(const Evas_Object *obj)
    void                evas_object_image_size_set(Evas_Object *obj, int w, int h)
    void                evas_object_image_size_get(const Evas_Object *obj, int *w, int *h)
    int                 evas_object_image_stride_get(const Evas_Object *obj)
    int                 evas_object_image_load_error_get(const Evas_Object *obj)
    void                evas_object_image_data_set(Evas_Object *obj, void *data)
    void               *evas_object_image_data_get(const Evas_Object *obj, Eina_Bool for_writing)
    # TODO: void                *evas_object_image_data_convert(Evas_Object *obj, Evas_Colorspace to_cspace)
    # TODO: void                evas_object_image_data_copy_set(Evas_Object *obj, void *data)
    void                evas_object_image_data_update_add(Evas_Object *obj, int x, int y, int w, int h)
    void                evas_object_image_alpha_set(Evas_Object *obj, Eina_Bool has_alpha)
    Eina_Bool           evas_object_image_alpha_get(const Evas_Object *obj)
    void                evas_object_image_smooth_scale_set(Evas_Object *obj, Eina_Bool smooth_scale)
    Eina_Bool           evas_object_image_smooth_scale_get(const Evas_Object *obj)
    void                evas_object_image_preload(Evas_Object *obj, Eina_Bool cancel)
    void                evas_object_image_reload(Evas_Object *obj)
    Eina_Bool           evas_object_image_save(const Evas_Object *obj, const char *file, const char *key, const char *flags)
    # TODO: Eina_Bool evas_object_image_pixels_import(Evas_Object *obj, Evas_Pixel_Import_Source *pixels)
    # TODO: void                evas_object_image_pixels_get_callback_set(Evas_Object *obj, void (*func) (void *data, Evas_Object *o), void *data)
    void                evas_object_image_pixels_dirty_set(Evas_Object *obj, Eina_Bool dirty)
    Eina_Bool           evas_object_image_pixels_dirty_get(const Evas_Object *obj)
    void                evas_object_image_load_dpi_set(Evas_Object *obj, double dpi)
    double              evas_object_image_load_dpi_get(const Evas_Object *obj)
    void                evas_object_image_load_size_set(Evas_Object *obj, int w, int h)
    void                evas_object_image_load_size_get(const Evas_Object *obj, int *w, int *h)
    void                evas_object_image_load_scale_down_set(Evas_Object *obj, int scale_down)
    int                 evas_object_image_load_scale_down_get(const Evas_Object *obj)
    void                evas_object_image_load_region_set(Evas_Object *obj, int x, int y, int w, int h)
    void                evas_object_image_load_region_get(const Evas_Object *obj, int *x, int *y, int *w, int *h)
    void                evas_object_image_load_orientation_set(Evas_Object *obj, Eina_Bool enable)
    Eina_Bool           evas_object_image_load_orientation_get(const Evas_Object *obj)
    void                evas_object_image_colorspace_set(Evas_Object *obj, Evas_Colorspace cspace)
    Evas_Colorspace     evas_object_image_colorspace_get(const Evas_Object *obj)
    Eina_Bool           evas_object_image_region_support_get(const Evas_Object *obj)
    # TODO: void                evas_object_image_native_surface_set(Evas_Object *obj, Evas_Native_Surface *surf)
    # TODO: Evas_Native_Surface *evas_object_image_native_surface_get(const Evas_Object *obj)
    # TODO: void                evas_object_image_video_surface_set(Evas_Object *obj, Evas_Video_Surface *surf)
    # TODO: const Evas_Video_Surface *evas_object_image_video_surface_get(const Evas_Object *obj)
    void                evas_object_image_scale_hint_set(Evas_Object *obj, Evas_Image_Scale_Hint hint)
    Evas_Image_Scale_Hint evas_object_image_scale_hint_get(const Evas_Object *obj)
    void                evas_object_image_content_hint_set(Evas_Object *obj, Evas_Image_Content_Hint hint)
    Evas_Image_Content_Hint evas_object_image_content_hint_get(const Evas_Object *obj)
    void                evas_object_image_alpha_mask_set(Evas_Object *obj, Eina_Bool ismask)
    Eina_Bool           evas_object_image_source_set(Evas_Object *obj, Evas_Object *src)
    Evas_Object        *evas_object_image_source_get(const Evas_Object *obj)
    Eina_Bool           evas_object_image_source_unset(Evas_Object *obj)
    void                evas_object_image_source_visible_set(Evas_Object *obj, Eina_Bool visible)
    Eina_Bool           evas_object_image_source_visible_get(const Evas_Object *obj)
    void                evas_object_image_source_events_set(Evas_Object *obj, Eina_Bool source)
    Eina_Bool           evas_object_image_source_events_get(const Evas_Object *obj)
    Eina_Bool           evas_object_image_extension_can_load_get(const char *file)
    Eina_Bool           evas_object_image_extension_can_load_fast_get(const char *file)
    Eina_Bool           evas_object_image_animated_get(const Evas_Object *obj)
    int                 evas_object_image_animated_frame_count_get(const Evas_Object *obj)
    Evas_Image_Animated_Loop_Hint evas_object_image_animated_loop_type_get(const Evas_Object *obj)
    int                 evas_object_image_animated_loop_count_get(const Evas_Object *obj)
    double              evas_object_image_animated_frame_duration_get(const Evas_Object *obj, int start_frame, int fram_num)
    void                evas_object_image_animated_frame_set(Evas_Object *obj, int frame_num)
    Evas_Image_Orient   evas_object_image_orient_get(Evas_Object *obj)
    void                evas_object_image_orient_set(Evas_Object *obj, Evas_Image_Orient orient)

    ####################################################################
    # Polygon Object
    #
    Evas_Object    *evas_object_polygon_add(Evas *e)
    const Eo_Class *evas_object_polygon_class_get()
    void            evas_object_polygon_point_add(Evas_Object *obj, Evas_Coord x, Evas_Coord y)
    void            evas_object_polygon_points_clear(Evas_Object *obj)


    ####################################################################
    # Text Object (py3:TODO)
    #
    Evas_Object         *evas_object_text_add(Evas *e)
    const Eo_Class      *evas_object_text_class_get()
    void                 evas_object_text_font_source_set(Evas_Object *obj, const char *font)
    const char          *evas_object_text_font_source_get(const Evas_Object *obj)
    void                 evas_object_text_font_set(Evas_Object *obj, const char *font, Evas_Font_Size size)
    void                 evas_object_text_font_get(const Evas_Object *obj, const char **font, Evas_Font_Size *size)
    void                 evas_object_text_text_set(Evas_Object *obj, const char *text)
    const char          *evas_object_text_text_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_ascent_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_descent_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_max_ascent_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_max_descent_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_horiz_advance_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_vert_advance_get(const Evas_Object *obj)
    Evas_Coord           evas_object_text_inset_get(const Evas_Object *obj)
    int                  evas_object_text_char_pos_get(const Evas_Object *obj, int pos, Evas_Coord *cx, Evas_Coord *cy, Evas_Coord *cw, Evas_Coord *ch)
    int                  evas_object_text_char_coords_get(const Evas_Object *obj, Evas_Coord x, Evas_Coord y, Evas_Coord *cx, Evas_Coord *cy, Evas_Coord *cw, Evas_Coord *ch)
    Evas_Text_Style_Type evas_object_text_style_get(const Evas_Object *obj)
    void                 evas_object_text_style_set(Evas_Object *obj, Evas_Text_Style_Type type)
    void                 evas_object_text_shadow_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                 evas_object_text_shadow_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)
    void                 evas_object_text_glow_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                 evas_object_text_glow_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)
    void                 evas_object_text_glow2_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                 evas_object_text_glow2_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)
    void                 evas_object_text_outline_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                 evas_object_text_outline_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)
    void                 evas_object_text_style_pad_get(const Evas_Object *obj, int *l, int *r, int *t, int *b)


    ####################################################################
    # Textblock Object (py3:TODO)
    #
    Evas_Object           *evas_object_textblock_add(Evas *e)
    const Eo_Class        *evas_object_textblock_class_get()
    Evas_Textblock_Style  *evas_textblock_style_new()
    void                   evas_textblock_style_free(Evas_Textblock_Style *ts)
    void                   evas_textblock_style_set(Evas_Textblock_Style *ts, const char *text)
    const char            *evas_textblock_style_get(const Evas_Textblock_Style *ts)
    void                   evas_object_textblock_style_set(Evas_Object *obj, Evas_Textblock_Style *ts)
    Evas_Textblock_Style  *evas_object_textblock_style_get(const Evas_Object *obj)
    void                   evas_object_textblock_replace_char_set(Evas_Object *obj, const char *ch)
    const char            *evas_object_textblock_replace_char_get(const Evas_Object *obj)
    const char            *evas_textblock_escape_string_get(const char *escape)
    const char            *evas_textblock_string_escape_get(const char *string, int *len_ret)
    void                   evas_object_textblock_text_markup_set(Evas_Object *obj, const char *text)
    void                   evas_object_textblock_text_markup_prepend(Evas_Textblock_Cursor *cur, const char *text)
    const char            *evas_object_textblock_text_markup_get(const Evas_Object *obj)
    Evas_Textblock_Cursor *evas_object_textblock_cursor_get(const Evas_Object *obj)
    Evas_Textblock_Cursor *evas_object_textblock_cursor_new(Evas_Object *obj)
    void                   evas_textblock_cursor_free(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_node_first(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_node_last(Evas_Textblock_Cursor *cur)
    Eina_Bool              evas_textblock_cursor_node_next(Evas_Textblock_Cursor *cur)
    Eina_Bool              evas_textblock_cursor_node_prev(Evas_Textblock_Cursor *cur)
    Eina_Bool              evas_textblock_cursor_char_next(Evas_Textblock_Cursor *cur)
    Eina_Bool              evas_textblock_cursor_char_prev(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_char_first(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_char_last(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_line_first(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_line_last(Evas_Textblock_Cursor *cur)
    int                    evas_textblock_cursor_pos_get(const Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_pos_set(Evas_Textblock_Cursor *cur, int pos)
    Eina_Bool              evas_textblock_cursor_line_set(Evas_Textblock_Cursor *cur, int line)
    int                    evas_textblock_cursor_compare(Evas_Textblock_Cursor *cur1, Evas_Textblock_Cursor *cur2)
    void                   evas_textblock_cursor_copy(Evas_Textblock_Cursor *cur, Evas_Textblock_Cursor *cur_dest)
    void                   evas_textblock_cursor_text_append(Evas_Textblock_Cursor *cur, const char *text)
    void                   evas_textblock_cursor_text_prepend(Evas_Textblock_Cursor *cur, const char *text)
    void                   evas_textblock_cursor_format_append(Evas_Textblock_Cursor *cur, const char *format)
    void                   evas_textblock_cursor_format_prepend(Evas_Textblock_Cursor *cur, const char *format)
    void                   evas_textblock_cursor_node_delete(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_char_delete(Evas_Textblock_Cursor *cur)
    void                   evas_textblock_cursor_range_delete(Evas_Textblock_Cursor *cur1, Evas_Textblock_Cursor *cur2)
    const char            *evas_textblock_cursor_node_text_get(const Evas_Textblock_Cursor *cur)
    int                    evas_textblock_cursor_node_text_length_get(const Evas_Textblock_Cursor *cur)
    const char            *evas_textblock_cursor_node_format_get(const Evas_Textblock_Cursor *cur)
    Eina_Bool              evas_textblock_cursor_node_format_is_visible_get(const Evas_Textblock_Cursor *cur)
    const char            *evas_textblock_cursor_range_text_get(const Evas_Textblock_Cursor *cur1, Evas_Textblock_Cursor *cur2, Evas_Textblock_Text_Type format)
    int                    evas_textblock_cursor_char_geometry_get(const Evas_Textblock_Cursor *cur, Evas_Coord *cx, Evas_Coord *cy, Evas_Coord *cw, Evas_Coord *ch)
    int                    evas_textblock_cursor_line_geometry_get(const Evas_Textblock_Cursor *cur, Evas_Coord *cx, Evas_Coord *cy, Evas_Coord *cw, Evas_Coord *ch)
    Eina_Bool              evas_textblock_cursor_char_coord_set(Evas_Textblock_Cursor *cur, Evas_Coord x, Evas_Coord y)
    int                    evas_textblock_cursor_line_coord_set(Evas_Textblock_Cursor *cur, Evas_Coord y)
    Eina_List             *evas_textblock_cursor_range_geometry_get(const Evas_Textblock_Cursor *cur1, Evas_Textblock_Cursor *cur2)
    Eina_Bool              evas_object_textblock_line_number_geometry_get(const Evas_Object *obj, int line, Evas_Coord *cx, Evas_Coord *cy, Evas_Coord *cw, Evas_Coord *ch)
    void                   evas_object_textblock_clear(Evas_Object *obj)
    void                   evas_object_textblock_size_formatted_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                   evas_object_textblock_size_native_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void                   evas_object_textblock_style_insets_get(const Evas_Object *obj, Evas_Coord *l, Evas_Coord *r, Evas_Coord *t, Evas_Coord *b)
    Eina_Bool              evas_object_textblock_obstacle_add(const Evas_Object *obj, Evas_Object *obstacle)
    Eina_Bool              evas_object_textblock_obstacle_del(const Evas_Object *obj, Evas_Object *obstacle)
    Eina_Bool              evas_object_textblock_obstacles_update(const Evas_Object *obj)


    ####################################################################
    # Box Object
    #
    Evas_Object *evas_object_box_add(Evas *e)
    Evas_Object *evas_object_box_add_to(Evas_Object *parent)
    # TODO: Is this needed?: const Eo_Class *evas_object_box_class_get()

    void evas_object_box_align_set(Evas_Object  *o, double horizontal, double vertical)
    void evas_object_box_align_get(const Evas_Object *o, double *horizontal, double *vertical)
    void evas_object_box_padding_set(Evas_Object *o, Evas_Coord horizontal, Evas_Coord vertical)
    void evas_object_box_padding_get(const Evas_Object *o, Evas_Coord *horizontal, Evas_Coord *vertical)

    Evas_Object_Box_Option *evas_object_box_append(Evas_Object *o, Evas_Object *child)
    Evas_Object_Box_Option *evas_object_box_prepend(Evas_Object *o, Evas_Object *child)
    Evas_Object_Box_Option *evas_object_box_insert_before(Evas_Object *o, Evas_Object *child, Evas_Object *reference)
    Evas_Object_Box_Option *evas_object_box_insert_after(Evas_Object *o, Evas_Object *child, Evas_Object *reference)
    Evas_Object_Box_Option *evas_object_box_insert_at(Evas_Object *o, Evas_Object *child, unsigned int pos)

    Eina_Bool evas_object_box_remove(Evas_Object *o, Evas_Object *child)
    Eina_Bool evas_object_box_remove_at(Evas_Object *o, unsigned int pos)
    Eina_Bool evas_object_box_remove_all(Evas_Object *o, Eina_Bool clear)

    void evas_object_box_layout_horizontal(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_vertical(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_homogeneous_vertical(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_homogeneous_horizontal(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_homogeneous_max_size_horizontal(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_homogeneous_max_size_vertical(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_flow_horizontal(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_flow_vertical(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)
    void evas_object_box_layout_stack(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)

    void elm_box_layout_transition(Evas_Object *o, Evas_Object_Box_Data *priv, void *data)


    ####################################################################
    # Evas Map
    #
    Evas_Map       *evas_map_new(int count)

    void            evas_object_map_enable_set(Evas_Object *obj, Eina_Bool enabled)
    Eina_Bool       evas_object_map_enable_get(const Evas_Object *obj)
    void            evas_object_map_set(Evas_Object *obj, const Evas_Map *map)
    const Evas_Map *evas_object_map_get(const Evas_Object *obj)

    void            evas_map_util_points_populate_from_object_full(Evas_Map *m, const Evas_Object *obj, Evas_Coord z)
    void            evas_map_util_points_populate_from_object(Evas_Map *m, const Evas_Object *obj)
    void            evas_map_util_points_populate_from_geometry(Evas_Map *m, Evas_Coord x, Evas_Coord y, Evas_Coord w, Evas_Coord h, Evas_Coord z)
    void            evas_map_util_points_color_set(Evas_Map *m, int r, int g, int b, int a)
    void            evas_map_util_rotate(Evas_Map *m, double degrees, Evas_Coord cx, Evas_Coord cy)
    void            evas_map_util_zoom(Evas_Map *m, double zoomx, double zoomy, Evas_Coord cx, Evas_Coord cy)
    void            evas_map_util_3d_rotate(Evas_Map *m, double dx, double dy, double dz, Evas_Coord cx, Evas_Coord cy, Evas_Coord cz)
    void            evas_map_util_quat_rotate(Evas_Map *m, double qx, double qy, double qz, double qw, double cx, double cy, double cz)
    void            evas_map_util_3d_lighting(Evas_Map *m, Evas_Coord lx, Evas_Coord ly, Evas_Coord lz, int lr, int lg, int lb, int ar, int ag, int ab)
    void            evas_map_util_3d_perspective(Evas_Map *m, Evas_Coord px, Evas_Coord py, Evas_Coord z0, Evas_Coord foc)
    Eina_Bool       evas_map_util_clockwise_get(Evas_Map *m)
    void            evas_map_util_object_move_sync_set(Evas_Map *m, Eina_Bool enabled)
    Eina_Bool       evas_map_util_object_move_sync_get(const Evas_Map *m)

    void            evas_map_smooth_set(Evas_Map *m, Eina_Bool enabled)
    Eina_Bool       evas_map_smooth_get(const Evas_Map *m)
    void            evas_map_alpha_set(Evas_Map *m, Eina_Bool enabled)
    Eina_Bool       evas_map_alpha_get(const Evas_Map *m)
    Evas_Map       *evas_map_dup(const Evas_Map *m)
    void            evas_map_free(Evas_Map *m)
    int             evas_map_count_get(const Evas_Map *m)
    void            evas_map_point_coord_set(Evas_Map *m, int idx, Evas_Coord x, Evas_Coord y, Evas_Coord z)
    void            evas_map_point_coord_get(const Evas_Map *m, int idx, Evas_Coord *x, Evas_Coord *y, Evas_Coord *z)
    void            evas_map_point_image_uv_set(Evas_Map *m, int idx, double u, double v)
    void            evas_map_point_image_uv_get(const Evas_Map *m, int idx, double *u, double *v)
    void            evas_map_point_color_set(Evas_Map *m, int idx, int r, int g, int b, int a)
    void            evas_map_point_color_get(const Evas_Map *m, int idx, int *r, int *g, int *b, int *a)


    ####################################################################
    # Textgrid
    #

    # The values that describes each cell.
    ctypedef struct Evas_Textgrid_Cell:
        Eina_Unicode   codepoint      # the UNICODE value of the character */
        unsigned char  fg             # the index of the palette for the foreground color */
        unsigned char  bg             # the index of the palette for the background color */
        unsigned short bold           # whether the character is bold */
        unsigned short italic         # whether the character is oblique */
        unsigned short underline      # whether the character is underlined */
        unsigned short strikethrough  # whether the character is strikethrough'ed */
        unsigned short fg_extended    # whether the extended palette is used for the foreground color */
        unsigned short bg_extended    # whether the extended palette is used for the background color */
        unsigned short double_width   # if the codepoint is merged with the following cell to the right visually (cells must be in pairs with 2nd cell being a duplicate in all ways except codepoint is 0) */

    Evas_Object *evas_object_textgrid_add(Evas *e)
    void         evas_object_textgrid_size_set(Evas_Object *obj, int w, int h)
    void         evas_object_textgrid_size_get(const Evas_Object *obj, int *w, int *h)
    void         evas_object_textgrid_font_source_set(Evas_Object *obj, const char *font_source)
    const char  *evas_object_textgrid_font_source_get(const Evas_Object *obj)
    void         evas_object_textgrid_font_set(Evas_Object *obj, const char *font_name, Evas_Font_Size font_size)
    void         evas_object_textgrid_font_get(const Evas_Object *obj, const char **font_name, Evas_Font_Size *font_size)
    void         evas_object_textgrid_cell_size_get(const Evas_Object *obj, Evas_Coord *w, Evas_Coord *h)
    void         evas_object_textgrid_palette_set(Evas_Object *obj, Evas_Textgrid_Palette pal, int idx, int r, int g, int b, int a)
    void         evas_object_textgrid_palette_get(const Evas_Object *obj, Evas_Textgrid_Palette pal, int idx, int *r, int *g, int *b, int *a)

    void                     evas_object_textgrid_supported_font_styles_set(Evas_Object *obj, Evas_Textgrid_Font_Style styles)
    Evas_Textgrid_Font_Style evas_object_textgrid_supported_font_styles_get(const Evas_Object *obj)

    void                evas_object_textgrid_cellrow_set(Evas_Object *obj, int y, const Evas_Textgrid_Cell *row)
    Evas_Textgrid_Cell *evas_object_textgrid_cellrow_get(const Evas_Object *obj, int y)
    void                evas_object_textgrid_update_add(Evas_Object *obj, int x, int y, int w, int h)

    ####################################################################
    # Table
    #

    Evas_Object                       *evas_object_table_add(Evas *evas)
    Evas_Object                       *evas_object_table_add_to(Evas_Object *parent)
    void                               evas_object_table_homogeneous_set(Evas_Object *o, Evas_Object_Table_Homogeneous_Mode homogeneous)
    Evas_Object_Table_Homogeneous_Mode evas_object_table_homogeneous_get(const Evas_Object *o)
    void                               evas_object_table_padding_set(Evas_Object *o, Evas_Coord horizontal, Evas_Coord vertical)
    void                               evas_object_table_padding_get(const Evas_Object *o, Evas_Coord *horizontal, Evas_Coord *vertical)
    void                               evas_object_table_align_set(Evas_Object *o, double horizontal, double vertical)
    void                               evas_object_table_align_get(const Evas_Object *o, double *horizontal, double *vertical)
    void                               evas_object_table_mirrored_set(Evas_Object *o, Eina_Bool mirrored)
    Eina_Bool                          evas_object_table_mirrored_get(const Evas_Object *o)
    Eina_Bool                          evas_object_table_pack_get(const Evas_Object *o, Evas_Object *child, unsigned short *col, unsigned short *row, unsigned short *colspan, unsigned short *rowspan)
    Eina_Bool                          evas_object_table_pack(Evas_Object *o, Evas_Object *child, unsigned short col, unsigned short row, unsigned short colspan, unsigned short rowspan)
    Eina_Bool                          evas_object_table_unpack(Evas_Object *o, Evas_Object *child)
    void                               evas_object_table_clear(Evas_Object *o, Eina_Bool clear)
    void                               evas_object_table_col_row_size_get(const Evas_Object *o, int *cols, int *rows)
    # TODO: Not needed?: Eina_Iterator                     *evas_object_table_iterator_new(const Evas_Object *o)
    # TODO: Not needed?: Eina_Accessor                     *evas_object_table_accessor_new(const Evas_Object *o)
    Eina_List                         *evas_object_table_children_get(const Evas_Object *o)
    Evas_Object                       *evas_object_table_child_get(const Evas_Object *o, unsigned short col, unsigned short row)

    ####################################################################
    # Grid
    #
    Evas_Object   *evas_object_grid_add(Evas *evas)
    Evas_Object   *evas_object_grid_add_to(Evas_Object *parent)
    void           evas_object_grid_size_set(Evas_Object *o, int w, int h)
    void           evas_object_grid_size_get(const Evas_Object *o, int *w, int *h)
    void           evas_object_grid_mirrored_set(Evas_Object *o, Eina_Bool mirrored)
    Eina_Bool      evas_object_grid_mirrored_get(const Evas_Object *o)
    Eina_Bool      evas_object_grid_pack(Evas_Object *o, Evas_Object *child, int x, int y, int w, int h)
    Eina_Bool      evas_object_grid_unpack(Evas_Object *o, Evas_Object *child)
    void           evas_object_grid_clear(Evas_Object *o, Eina_Bool clear)
    Eina_Bool      evas_object_grid_pack_get(const Evas_Object *o, Evas_Object *child, int *x, int *y, int *w, int *h)
    # TODO: Is this needed? Eina_Iterator *evas_object_grid_iterator_new(const Evas_Object *o)
    # TODO: Is this needed? Eina_Accessor *evas_object_grid_accessor_new(const Evas_Object *o)
    Eina_List     *evas_object_grid_children_get(const Evas_Object *o)


####################################################################
# Python classes
#
cdef class Rect:
    cdef public int x0, y0, x1, y1, cx, cy, _w, _h


cdef class Canvas(Eo):
    cdef list _event_callbacks


cdef class Map(object):
    cdef Evas_Map *map


cdef class Object(Eo):
    cdef list _event_callbacks
    cdef int _set_properties_from_keyword_args(self, dict) except 0

cdef class Rectangle(Object):
    pass


cdef class Line(Object):
    pass


cdef class Image(Object):
    pass


cdef class FilledImage(Image):
    pass


cdef class Polygon(Object):
    pass


cdef class Text(Object):
    pass


cdef class Textblock(Object):
    pass


# cdef extern from *:
#     ctypedef object(*Smart_Conv_Func)(void *)

cdef class Smart:
    cdef:
        Evas_Smart *cls
        const Evas_Smart_Class *cls_def

    @staticmethod
    cdef inline create(Evas_Smart *cls):
        cdef Smart ret = Smart.__new__(Smart)
        ret.cls = cls
        ret.cls_def = evas_smart_class_get(cls)
        return ret

cdef class SmartObject(Object):
    cdef:
        Smart _smart
        dict _smart_callback_specs
        int _set_obj(self, cEo *obj) except 0
        int _callback_add_full(self, event, object(*)(void*), func, tuple args, dict kargs) except 0
        int _callback_del_full(self, event, object(*)(void*), func) except 0
        int _callback_add(self, event, func, args, kargs) except 0
        int _callback_del(self, event, func) except 0


cdef class ClippedSmartObject(SmartObject):
    cdef readonly Rectangle clipper


cdef class EventPoint:
    cdef Evas_Point *obj

    cdef void _set_obj(self, Evas_Point *obj)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventCoordPoint:
    cdef Evas_Coord_Point *obj

    cdef void _set_obj(self, Evas_Coord_Point *obj)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventPrecisionPoint:
    cdef Evas_Coord_Precision_Point *obj

    cdef void _set_obj(self, Evas_Coord_Precision_Point *obj)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventPosition:
    cdef readonly EventPoint output
    cdef readonly EventCoordPoint canvas

    cdef void _set_objs(self, Evas_Point *output, Evas_Coord_Point *canvas)
    cdef void _unset_objs(self)


cdef class EventPrecisionPosition:
    cdef readonly EventPoint output
    cdef readonly EventPrecisionPoint canvas

    cdef void _set_objs(self, Evas_Point *output, Evas_Coord_Precision_Point *canvas)
    cdef void _unset_objs(self)


cdef class EventMouseIn:
    cdef Evas_Event_Mouse_In *obj
    cdef readonly EventPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMouseOut:
    cdef Evas_Event_Mouse_Out *obj
    cdef readonly EventPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMouseDown:
    cdef Evas_Event_Mouse_Down *obj
    cdef readonly EventPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMouseUp:
    cdef Evas_Event_Mouse_Up *obj
    cdef readonly EventPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMouseMove:
    cdef Evas_Event_Mouse_Move *obj
    cdef readonly EventPosition position
    cdef readonly EventPosition prev_position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMultiDown:
    cdef Evas_Event_Multi_Down *obj
    cdef readonly EventPrecisionPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMultiUp:
    cdef Evas_Event_Multi_Up *obj
    cdef readonly EventPrecisionPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMultiMove:
    cdef Evas_Event_Multi_Move *obj
    cdef readonly EventPrecisionPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventMouseWheel:
    cdef Evas_Event_Mouse_Wheel *obj
    cdef readonly EventPosition position

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventKeyDown:
    cdef Evas_Event_Key_Down *obj

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventKeyUp:
    cdef Evas_Event_Key_Up *obj

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0


cdef class EventHold:
    cdef Evas_Event_Hold *obj

    cdef void _set_obj(self, void *ptr)
    cdef void _unset_obj(self)
    cdef int _check_validity(self) except 0
