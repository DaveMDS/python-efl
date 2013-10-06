# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
#

"""

Enumerations
------------

.. _Elm_Web_Window_Feature:

Web window features
===================

.. data:: ELM_WEB_WINDOW_FEATURE_TOOLBAR

    Toolbar

.. data:: ELM_WEB_WINDOW_FEATURE_STATUSBAR

    Status bar

.. data:: ELM_WEB_WINDOW_FEATURE_SCROLLBARS

    Scrollbars

.. data:: ELM_WEB_WINDOW_FEATURE_MENUBAR

    Menu bar

.. data:: ELM_WEB_WINDOW_FEATURE_LOCATIONBAR

    Location bar

.. data:: ELM_WEB_WINDOW_FEATURE_FULLSCREEN

    Fullscreen


.. _Elm_Web_Zoom_Mode:

Web zoom modes
==============

.. data:: ELM_WEB_ZOOM_MODE_MANUAL

    Zoom controlled normally by :py:attr:`zoom`

.. data:: ELM_WEB_ZOOM_MODE_AUTO_FIT

    Zoom until content fits in web object.

.. data:: ELM_WEB_ZOOM_MODE_AUTO_FILL

    Zoom until content fills web object.

"""

from efl.evas cimport Evas_Object, const_Evas_Object, \
    Object as evasObject
from efl.eo cimport object_from_instance, _object_mapping_register
from efl.utils.conversions cimport _ctouni, _touni

from object cimport Object

from efl.evas cimport Eina_Bool, Eina_List, Evas_Object, Evas_Coord
from enums cimport Elm_Web_Window_Feature_Flag, Elm_Web_Zoom_Mode
from libc.string cimport const_char

cdef extern from "Elementary.h":

    ctypedef struct Elm_Web_Frame_Load_Error:
        int code
        Eina_Bool is_cancellation
        const_char *domain
        const_char *description
        const_char *failing_url
        Evas_Object *frame

    ctypedef struct Elm_Web_Window_Features

    ctypedef Evas_Object    *(*Elm_Web_Window_Open)         (void *data, Evas_Object *obj, Eina_Bool js, Elm_Web_Window_Features *window_features)
    ctypedef Evas_Object    *(*Elm_Web_Dialog_Alert)        (void *data, Evas_Object *obj, const_char *message)
    ctypedef Evas_Object    *(*Elm_Web_Dialog_Confirm)      (void *data, Evas_Object *obj, const_char *message, Eina_Bool *ret)
    ctypedef Evas_Object    *(*Elm_Web_Dialog_Prompt)       (void *data, Evas_Object *obj, const_char *message, const_char *def_value, char **value, Eina_Bool *ret)
    ctypedef Evas_Object    *(*Elm_Web_Dialog_File_Selector)(void *data, Evas_Object *obj, Eina_Bool allows_multiple, Eina_List *accept_types, Eina_List **selected, Eina_Bool *ret)
    ctypedef void            (*Elm_Web_Console_Message)     (void *data, Evas_Object *obj, const_char *message, unsigned int line_number, const_char *source_id)

    Evas_Object             *elm_web_add(Evas_Object *parent)
    void                     elm_web_useragent_set(Evas_Object *obj, const_char *user_agent)
    const_char *             elm_web_useragent_get(Evas_Object *obj)
    Evas_Object             *elm_web_webkit_view_get(Evas_Object *obj)

    void                     elm_web_window_create_hook_set(Evas_Object *obj, Elm_Web_Window_Open func, void *data)
    void                     elm_web_dialog_alert_hook_set(Evas_Object *obj, Elm_Web_Dialog_Alert func, void *data)
    void                     elm_web_dialog_confirm_hook_set(Evas_Object *obj, Elm_Web_Dialog_Confirm func, void *data)
    void                     elm_web_dialog_prompt_hook_set(Evas_Object *obj, Elm_Web_Dialog_Prompt func, void *data)
    void                     elm_web_dialog_file_selector_hook_set(Evas_Object *obj, Elm_Web_Dialog_File_Selector func, void *data)
    void                     elm_web_console_message_hook_set(Evas_Object *obj, Elm_Web_Console_Message func, void *data)

    Eina_Bool                elm_web_tab_propagate_get(Evas_Object *obj)
    void                     elm_web_tab_propagate_set(Evas_Object *obj, Eina_Bool propagate)
    Eina_Bool                elm_web_uri_set(Evas_Object *obj,char *uri)
    const_char *             elm_web_uri_get(Evas_Object *obj)
    const_char *             elm_web_title_get(Evas_Object *obj)
    void                     elm_web_bg_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void                     elm_web_bg_color_get(Evas_Object *obj, int *r, int *g, int *b, int *a)

    char                    *elm_web_selection_get(Evas_Object *obj)
    void                     elm_web_popup_selected_set(Evas_Object *obj, int index)
    Eina_Bool                elm_web_popup_destroy(Evas_Object *obj)

    Eina_Bool                elm_web_text_search(Evas_Object *obj, const_char *string, Eina_Bool case_sensitive, Eina_Bool forward, Eina_Bool wrap)
    unsigned int             elm_web_text_matches_mark(Evas_Object *obj, const_char *string, Eina_Bool case_sensitive, Eina_Bool highlight, unsigned int limit)
    Eina_Bool                elm_web_text_matches_unmark_all(Evas_Object *obj)
    Eina_Bool                elm_web_text_matches_highlight_set(Evas_Object *obj, Eina_Bool highlight)
    Eina_Bool                elm_web_text_matches_highlight_get(Evas_Object *obj)

    double                   elm_web_load_progress_get(Evas_Object *obj)
    Eina_Bool                elm_web_stop(Evas_Object *obj)
    Eina_Bool                elm_web_reload(Evas_Object *obj)
    Eina_Bool                elm_web_reload_full(Evas_Object *obj)
    Eina_Bool                elm_web_back(Evas_Object *obj)
    Eina_Bool                elm_web_forward(Evas_Object *obj)
    Eina_Bool                elm_web_navigate(Evas_Object *obj, int steps)

    Eina_Bool                elm_web_back_possible_get(Evas_Object *obj)
    Eina_Bool                elm_web_forward_possible_get(Evas_Object *obj)
    Eina_Bool                elm_web_navigate_possible_get(Evas_Object *obj, int steps)
    Eina_Bool                elm_web_history_enabled_get(Evas_Object *obj)
    void                     elm_web_history_enabled_set(Evas_Object *obj, Eina_Bool enabled)

    void                     elm_web_zoom_set(Evas_Object *obj, double zoom)
    double                   elm_web_zoom_get(Evas_Object *obj)
    void                     elm_web_zoom_mode_set(Evas_Object *obj, Elm_Web_Zoom_Mode mode)
    Elm_Web_Zoom_Mode        elm_web_zoom_mode_get(Evas_Object *obj)

    void                     elm_web_region_show(Evas_Object *obj, int x, int y, int w, int h)
    void                     elm_web_region_bring_in(Evas_Object *obj, int x, int y, int w, int h)
    void                     elm_web_inwin_mode_set(Evas_Object *obj, Eina_Bool value)
    Eina_Bool                elm_web_inwin_mode_get(Evas_Object *obj)

    Eina_Bool                elm_web_window_features_property_get(Elm_Web_Window_Features *wf, Elm_Web_Window_Feature_Flag flag)
    void                     elm_web_window_features_region_get(Elm_Web_Window_Features *wf, Evas_Coord *x, Evas_Coord *y, Evas_Coord *w, Evas_Coord *h)


include "callback_conversions.pxi"
import traceback

cimport enums

ELM_WEB_WINDOW_FEATURE_TOOLBAR = enums.ELM_WEB_WINDOW_FEATURE_TOOLBAR
ELM_WEB_WINDOW_FEATURE_STATUSBAR = enums.ELM_WEB_WINDOW_FEATURE_STATUSBAR
ELM_WEB_WINDOW_FEATURE_SCROLLBARS = enums.ELM_WEB_WINDOW_FEATURE_SCROLLBARS
ELM_WEB_WINDOW_FEATURE_MENUBAR = enums.ELM_WEB_WINDOW_FEATURE_MENUBAR
ELM_WEB_WINDOW_FEATURE_LOCATIONBAR = enums.ELM_WEB_WINDOW_FEATURE_LOCATIONBAR
ELM_WEB_WINDOW_FEATURE_FULLSCREEN = enums.ELM_WEB_WINDOW_FEATURE_FULLSCREEN

ELM_WEB_ZOOM_MODE_MANUAL = enums.ELM_WEB_ZOOM_MODE_MANUAL
ELM_WEB_ZOOM_MODE_AUTO_FIT = enums.ELM_WEB_ZOOM_MODE_AUTO_FIT
ELM_WEB_ZOOM_MODE_AUTO_FILL = enums.ELM_WEB_ZOOM_MODE_AUTO_FILL

def _web_double_conv(long addr):
    cdef double *info = <double *>addr
    if info == NULL:
        return None
    return info[0]

def _web_load_frame_error_conv(long addr):
    cdef Elm_Web_Frame_Load_Error *err = <Elm_Web_Frame_Load_Error *>addr
    if err == NULL:
        return None
    ret = {
        "code": err.code,
        "is_cancellation": bool(err.is_cancellation),
        }
    ret["domain"] = _ctouni(err.domain) if err.domain else None
    ret["description"] = _ctouni(err.description) if err.description else None
    ret["failing_url"] = _ctouni(err.failing_url) if err.failing_url else None
    ret["frame"] = object_from_instance(err.frame) if err.frame else None

    return ret


def _web_link_hover_in_conv(long addr):
    cdef char **info = <char **>addr
    if info == NULL:
        url = title = None
    else:
        url = None if info[0] == NULL else info[0]
        title = None if info[1] == NULL else info[1]
    return (url, title)


cdef void _web_console_message_hook(void *data, Evas_Object *obj, const_char *message, unsigned int line_number, const_char *source_id) with gil:
    cdef Web self = <Web>data

    try:
        self._console_message_hook(self, _ctouni(message), line_number, _ctouni(source_id))
    except Exception, e:
        traceback.print_exc()


cdef class Web(Object):
    cdef object _console_message_hook

    def __init__(self,evasObject parent):
        self._set_obj(elm_web_add(parent.obj))

    # XXX TODO: complete all callbacks from elm_web.h
    def callback_uri_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("uri,changed", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_uri_changed_del(self, func):
        self._callback_del_full("uri,changed", _cb_string_conv, func)

    def callback_title_changed_add(self, func, *args, **kwargs):
        self._callback_add_full("title,changed", _cb_string_conv,
                                func, *args, **kwargs)

    def callback_title_changed_del(self, func):
        self._callback_del_full("title,changed", _cb_string_conv, func)

    def callback_link_hover_in_add(self, func, *args, **kwargs):
        self._callback_add_full("link,hover,in", _web_link_hover_in_conv,
                                func, *args, **kwargs)

    def callback_link_hover_in_del(self, func):
        self._callback_del_full("link,hover,in", _web_link_hover_in_conv, func)

    def callback_link_hover_out_add(self, func, *args, **kwargs):
        self._callback_add("link,hover,out", func, *args, **kwargs)

    def callback_link_hover_out_del(self, func):
        self._callback_del("link,hover,out", func)

    def callback_load_error_add(self, func, *args, **kwargs):
        self._callback_add_full("load,error", _web_load_frame_error_conv,
                                func, *args, **kwargs)

    def callback_load_error_del(self, func):
        self._callback_del_full("load,error", _web_load_frame_error_conv, func)

    def callback_load_finished_add(self, func, *args, **kwargs):
        self._callback_add_full("load,finished", _web_load_frame_error_conv,
                                func, *args, **kwargs)

    def callback_load_finished_del(self, func):
        self._callback_del_full("load,finished",
                                _web_load_frame_error_conv, func)

    def callback_load_progress_add(self, func, *args, **kwargs):
        self._callback_add_full("load,progress", _web_double_conv,
                                func, *args, **kwargs)

    def callback_load_progress_del(self, func):
        self._callback_del_full("load,progress", _web_double_conv, func)

    def callback_load_provisional_add(self, func, *args, **kwargs):
        self._callback_add("load,provisional", func, *args, **kwargs)

    def callback_load_provisional_del(self, func):
        self._callback_del("load,provisional", func)

    def callback_load_started_add(self, func, *args, **kwargs):
        self._callback_add("load,started", func, *args, **kwargs)

    def callback_load_started_del(self, func):
        self._callback_del("load,started", func)

    def history_enabled_get(self):
        return bool(elm_web_history_enabled_get(self.obj))

    def webkit_view_get(self):
        cdef Evas_Object *obj = elm_web_webkit_view_get(self.obj)
        return object_from_instance(obj)

    def uri_set(self, uri):
        return bool(elm_web_uri_set(self.obj, uri))

    def uri_get(self):
        return _ctouni(elm_web_uri_get(self.obj))

    property uri:
        def __get__(self):
            return self.uri_get()

        def __set__(self, value):
            self.uri_set(value)

    def useragent_get(self):
        return _ctouni(elm_web_useragent_get(self.obj))

    def zoom_get(self):
        return elm_web_zoom_get(self.obj)

    def zoom_mode_get(self):
        return elm_web_zoom_mode_get(self.obj)

    def back(self):
        return bool(elm_web_back(self.obj))

    def console_message_hook_set(self, func):
        self._console_message_hook = func
        if func:
            elm_web_console_message_hook_set(self.obj,
                                             _web_console_message_hook,
                                             <void *>self)
        else:
            elm_web_console_message_hook_set(self.obj, NULL, NULL)


_object_mapping_register("elm_web", Web)
