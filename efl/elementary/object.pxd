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

from cpython cimport PyObject, Py_INCREF, Py_DECREF
from efl.evas cimport Eina_Bool, Eina_List, const_Eina_List, \
    Evas_Object, const_Evas_Object, Evas_Smart_Cb, Evas_Coord
from efl.evas.enums cimport Evas_Callback_Type
from efl.evas cimport Object as evasObject
from efl.evas cimport Canvas as evasCanvas
from enums cimport Elm_Focus_Direction, Elm_Sel_Format, Elm_Sel_Type, \
    Elm_Xdnd_Action
from libc.string cimport const_char
from libc.stdlib cimport const_void

cdef extern from "Edje.h":
    ctypedef void (*Edje_Signal_Cb)(void *data, Evas_Object *obj, const_char *emission, const_char *source)

cdef extern from "Elementary.h":
    ctypedef struct Elm_Theme

    ctypedef struct Elm_Selection_Data:
        Evas_Coord       x, y
        Elm_Sel_Format   format
        void            *data
        size_t           len
        Elm_Xdnd_Action  action

    ctypedef Eina_Bool       (*Elm_Event_Cb)                (void *data, Evas_Object *obj, Evas_Object *src, Evas_Callback_Type t, void *event_info)
    ctypedef Evas_Object    *(*Elm_Tooltip_Content_Cb)      (void *data, Evas_Object *obj, Evas_Object *tooltip)
    ctypedef Evas_Object    *(*Elm_Tooltip_Item_Content_Cb) (void *data, Evas_Object *obj, Evas_Object *tooltip, void *item)

    ctypedef Eina_Bool       (*Elm_Drop_Cb)                 (void *data, Evas_Object *obj, Elm_Selection_Data *ev)
    ctypedef void            (*Elm_Selection_Loss_Cb)       (void *data, Elm_Sel_Type selection)
    ctypedef Evas_Object    *(*Elm_Drag_Icon_Create_Cb)     (void *data, Evas_Object *win, Evas_Coord *xoff, Evas_Coord *yoff)
    ctypedef void            (*Elm_Drag_State)              (void *data, Evas_Object *obj)
    ctypedef void            (*Elm_Drag_Accept)             (void *data, Evas_Object *obj, Eina_Bool doaccept)
    ctypedef void            (*Elm_Drag_Pos)                (void *data, Evas_Object *obj, Evas_Coord x, Evas_Coord y, Elm_Xdnd_Action action)

    # Object handling       (py3: DONE)
    void                    elm_object_part_text_set(Evas_Object *obj, const_char *part, const_char *label)
    void                    elm_object_text_set(Evas_Object *obj, const_char *label)
    const_char *            elm_object_part_text_get(Evas_Object *obj, const_char *part)
    const_char *            elm_object_text_get(Evas_Object *obj)
    void                    elm_object_part_content_set(Evas_Object *obj, const_char *part, Evas_Object *icon)
    void                    elm_object_content_set(Evas_Object *obj, Evas_Object *icon)
    Evas_Object            *elm_object_part_content_get(Evas_Object *obj, const_char *part)
    Evas_Object            *elm_object_content_get(Evas_Object *obj)
    Evas_Object            *elm_object_part_content_unset(Evas_Object *obj, const_char *part)
    Evas_Object            *elm_object_content_unset(Evas_Object *obj)
    void                    elm_object_access_info_set(Evas_Object *obj, const_char *txt)
    Evas_Object            *elm_object_name_find(Evas_Object *obj, const_char *name, int recurse)
    void                    elm_object_style_set(Evas_Object *obj, const_char *style)
    const_char *            elm_object_style_get(Evas_Object *obj)
    void                    elm_object_disabled_set(Evas_Object *obj, Eina_Bool disabled)
    Eina_Bool               elm_object_disabled_get(Evas_Object *obj)
    Eina_Bool               elm_object_widget_check(Evas_Object *obj)
    Evas_Object            *elm_object_parent_widget_get(Evas_Object *obj)
    Evas_Object            *elm_object_top_widget_get(Evas_Object *obj)
    const_char *            elm_object_widget_type_get(Evas_Object *obj)
    void                    elm_object_signal_emit(Evas_Object *obj, const_char *emission, const_char *source)
    void                    elm_object_signal_callback_add(Evas_Object *obj, const_char *emission, const_char *source, Edje_Signal_Cb func, void *data)
    void *                  elm_object_signal_callback_del(Evas_Object *obj, const_char *emission, const_char *source, Edje_Signal_Cb func)
    void                    elm_object_event_callback_add(Evas_Object *obj, Elm_Event_Cb func, const_void *data)
    void *                  elm_object_event_callback_del(Evas_Object *obj, Elm_Event_Cb func, const_void *data)
    void                    elm_object_orientation_mode_disabled_set(Evas_Object *obj, Eina_Bool disabled)
    Eina_Bool               elm_object_orientation_mode_disabled_get(const_Evas_Object *obj)

    # Object - Cursors (elm_cursor.h) (py3: DONE)
    void                    elm_object_cursor_set(Evas_Object *obj, const_char *cursor)
    const_char *            elm_object_cursor_get(Evas_Object *obj)
    void                    elm_object_cursor_unset(Evas_Object *obj)
    void                    elm_object_cursor_style_set(Evas_Object *obj, const_char *style)
    const_char *            elm_object_cursor_style_get(Evas_Object *obj)
    void                    elm_object_cursor_theme_search_enabled_set(Evas_Object *obj, Eina_Bool theme_search)
    Eina_Bool               elm_object_cursor_theme_search_enabled_get(Evas_Object *obj)

    # Object - Focus (elm_focus.h)
    Eina_Bool               elm_object_focus_get(Evas_Object *obj)
    void                    elm_object_focus_set(Evas_Object *obj, Eina_Bool focus)
    void                    elm_object_focus_allow_set(Evas_Object *obj, Eina_Bool enable)
    Eina_Bool               elm_object_focus_allow_get(Evas_Object *obj)
    void                    elm_object_focus_custom_chain_set(Evas_Object *obj, Eina_List *objs)
    void                    elm_object_focus_custom_chain_unset(Evas_Object *obj)
    const_Eina_List *       elm_object_focus_custom_chain_get(Evas_Object *obj)
    void                    elm_object_focus_custom_chain_append(Evas_Object *obj, Evas_Object *child, Evas_Object *relative_child)
    void                    elm_object_focus_custom_chain_prepend(Evas_Object *obj, Evas_Object *child, Evas_Object *relative_child)
    void                    elm_object_focus_next(Evas_Object *obj, Elm_Focus_Direction direction)
    Evas_Object *           elm_object_focus_next_object_get(const_Evas_Object *obj, Elm_Focus_Direction dir)
    void                    elm_object_focus_next_object_set(Evas_Object *obj, Evas_Object *next, Elm_Focus_Direction dir)
    Evas_Object *           elm_object_focused_object_get(const_Evas_Object *obj)
    void                    elm_object_tree_focus_allow_set(Evas_Object *obj, Eina_Bool focusable)
    Eina_Bool               elm_object_tree_focus_allow_get(Evas_Object *obj)
    Eina_Bool               elm_object_focus_highlight_style_set(Evas_Object *obj, const_char *style)
    const_char *            elm_object_focus_highlight_style_get(const_Evas_Object *obj)

    # Object - Mirroring (elm_mirroring.h)
    Eina_Bool               elm_object_mirrored_get(Evas_Object *obj)
    void                    elm_object_mirrored_set(Evas_Object *obj, Eina_Bool mirrored)
    Eina_Bool               elm_object_mirrored_automatic_get(Evas_Object *obj)
    void                    elm_object_mirrored_automatic_set(Evas_Object *obj, Eina_Bool automatic)

    # Object - Scaling (elm_scale.h)
    void                    elm_object_scale_set(Evas_Object *obj, double scale)
    double                  elm_object_scale_get(Evas_Object *obj)

    # Object - Scrollhints (elm_scroll.h)
    void                    elm_object_scroll_hold_push(Evas_Object *obj)
    void                    elm_object_scroll_hold_pop(Evas_Object *obj)
    int                     elm_object_scroll_hold_get(const_Evas_Object *obj)
    void                    elm_object_scroll_freeze_push(Evas_Object *obj)
    void                    elm_object_scroll_freeze_pop(Evas_Object *obj)
    int                     elm_object_scroll_freeze_get(const_Evas_Object *obj)
    void                    elm_object_scroll_lock_x_set(Evas_Object *obj, Eina_Bool lock)
    void                    elm_object_scroll_lock_y_set(Evas_Object *obj, Eina_Bool lock)
    Eina_Bool               elm_object_scroll_lock_x_get(Evas_Object *obj)
    Eina_Bool               elm_object_scroll_lock_y_get(Evas_Object *obj)

    # Object - Theme (elm_theme.h)
    void                    elm_object_theme_set(Evas_Object *obj, Elm_Theme *th)
    Elm_Theme *             elm_object_theme_get(Evas_Object *obj)

    # Object - Tooltips (elm_tooltip.h) (py3: DONE)
    void                    elm_object_tooltip_show(Evas_Object *obj)
    void                    elm_object_tooltip_hide(Evas_Object *obj)
    void                    elm_object_tooltip_text_set(Evas_Object *obj, const_char *text)
    void                    elm_object_tooltip_domain_translatable_text_set(Evas_Object *obj, const_char *domain, const_char *text)
    void                    elm_object_tooltip_translatable_text_set(Evas_Object *obj, const_char *text)
    void                    elm_object_tooltip_content_cb_set(Evas_Object *obj, Elm_Tooltip_Content_Cb func, void *data, Evas_Smart_Cb del_cb)
    void                    elm_object_tooltip_unset(Evas_Object *obj)
    void                    elm_object_tooltip_style_set(Evas_Object *obj, const_char *style)
    const_char *            elm_object_tooltip_style_get(Evas_Object *obj)
    Eina_Bool               elm_object_tooltip_window_mode_set(Evas_Object *obj, Eina_Bool disable)
    Eina_Bool               elm_object_tooltip_window_mode_get(Evas_Object *obj)
    void                    elm_object_tooltip_move_freeze_push(Evas_Object *obj)
    void                    elm_object_tooltip_move_freeze_pop(Evas_Object *obj)
    int                     elm_object_tooltip_move_freeze_get(const_Evas_Object *obj)

    # Object - Translatable text (elm_general.h) (py3: DONE)
    void                    elm_object_domain_translatable_part_text_set(Evas_Object *obj, const_char *part, const_char *domain, const_char *text)
    void                    elm_object_domain_translatable_text_set(Evas_Object *obj, const_char *domain, const_char *text)
    void                    elm_object_translatable_text_set(Evas_Object *obj, const_char *text)
    void                    elm_object_translatable_part_text_set(Evas_Object *obj, const_char *part, const_char *text)
    const_char *            elm_object_translatable_part_text_get(const_Evas_Object *obj, const_char *part)
    const_char *            elm_object_translatable_text_get(Evas_Object *obj)
    void                    elm_object_domain_part_text_translatable_set(Evas_Object *obj, const_char *part, const_char *domain, Eina_Bool translatable)
    void                    elm_object_part_text_translatable_set(Evas_Object *obj, const_char *part, Eina_Bool translatable)
    void                    elm_object_domain_text_translatable_set(Evas_Object *obj, const_char *domain, Eina_Bool translatable)

    # Access (elm_access.h)
    #TODO: Evas_Object *           elm_access_object_get(const_Evas_Object *obj)
    #TODO: void                    elm_access_highlight_set(Evas_Object* obj)
    #TODO: void                elm_access_object_unregister(Evas_Object *obj)


cdef class Canvas(evasCanvas):
    pass

cdef class Object(evasObject):
    cdef:
        dict _elmcallbacks
        list _elm_event_cbs, _elm_signal_cbs
        object cnp_drop_cb, cnp_drop_data
        object cnp_selection_loss_cb, cnp_selection_loss_data
