# Copyright (c) 2008-2009 Simon Busch
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

# from efl.eo cimport object_from_instance
# from efl.evas cimport Evas
# from efl.evas cimport evas_object_evas_get
# from efl.evas cimport canvas_from_instance

cdef class Window(Object):

    def __init__(self, name, type):
        self._set_obj(elm_win_add(NULL, _cfruni(name), type))
#         self._add_obj(elm_obj_win_class_get(), NULL)

#         cdef Evas *e
#         e = evas_object_evas_get(self.obj)
#         canvas = Canvas_from_instance(e)
#         evasObject.__init__(self, canvas)

    def resize_object_add(self, evasObject subobj):
        elm_win_resize_object_add(self.obj, subobj.obj)

    def resize_object_del(self, evasObject subobj):
        elm_win_resize_object_del(self.obj, subobj.obj)

    def title_set(self, title):
        elm_win_title_set(self.obj, _cfruni(title))

    def title_get(self):
        return _ctouni(elm_win_title_get(self.obj))

    property title:
        def __get__(self):
            return _ctouni(elm_win_title_get(self.obj))
        def __set__(self, title):
            elm_win_title_set(self.obj, _cfruni(title))

    def icon_name_set(self, icon_name):
        elm_win_icon_name_set(self.obj, _cfruni(icon_name))

    def icon_name_get(self):
        return _ctouni(elm_win_icon_name_get(self.obj))

    property icon_name:
        def __get__(self):
            return _ctouni(elm_win_icon_name_get(self.obj))
        def __set__(self, icon_name):
            elm_win_icon_name_set(self.obj, _cfruni(icon_name))

    def role_set(self, role):
        elm_win_role_set(self.obj, _cfruni(role))

    def role_get(self):
        return _ctouni(elm_win_role_get(self.obj))

    property role:
        def __get__(self):
            return _ctouni(elm_win_role_get(self.obj))
        def __set__(self, role):
            elm_win_role_set(self.obj, _cfruni(role))

    def icon_object_set(self, evasObject icon):
        elm_win_icon_object_set(self.obj, icon.obj)

    def icon_object_get(self):
        return object_from_instance(elm_win_icon_object_get(self.obj))

    property icon_object:
        def __get__(self):
            return object_from_instance(elm_win_icon_object_get(self.obj))
        def __set__(self, evasObject icon):
            elm_win_icon_object_set(self.obj, icon.obj)

    def autodel_set(self, autodel):
        elm_win_autodel_set(self.obj, autodel)

    def autodel_get(self):
        return elm_win_autodel_get(self.obj)

    property autodel:
        def __get__(self):
            return elm_win_autodel_get(self.obj)
        def __set__(self, autodel):
            elm_win_autodel_set(self.obj, autodel)

    def activate(self):
        elm_win_activate(self.obj)

    def lower(self):
        elm_win_lower(self.obj)

    def _raise(self):
        elm_win_raise(self.obj)

    def center(self, h, v):
        elm_win_center(self.obj, h, v)

    def borderless_set(self, borderless):
        elm_win_borderless_set(self.obj, borderless)

    def borderless_get(self):
        return bool(elm_win_borderless_get(self.obj))

    property borderless:
        def __get__(self):
            return self.borderless_get()
        def __set__(self, borderless):
            self.borderless_set(borderless)

    def shaped_set(self,shaped):
        elm_win_shaped_set(self.obj, shaped)

    def shaped_get(self):
        return bool(elm_win_shaped_get(self.obj))

    property shaped:
        def __get__(self):
            return bool(elm_win_shaped_get(self.obj))
        def __set__(self, shaped):
            elm_win_shaped_set(self.obj, shaped)

    def alpha_set(self,alpha):
        elm_win_alpha_set(self.obj, alpha)

    def alpha_get(self):
        return bool(elm_win_alpha_get(self.obj))

    property alpha:
        def __get__(self):
            return bool(elm_win_alpha_get(self.obj))
        def __set__(self, alpha):
            elm_win_alpha_set(self.obj, alpha)

    def override_set(self, override):
        elm_win_override_set(self.obj, override)

    def override_get(self):
        return bool(elm_win_override_get(self.obj))

    property override:
        def __get__(self):
            return bool(elm_win_override_get(self.obj))
        def __set__(self, override):
            elm_win_override_set(self.obj, override)

    def fullscreen_set(self, fullscreen):
        elm_win_fullscreen_set(self.obj, fullscreen)

    def fullscreen_get(self):
        return bool(elm_win_fullscreen_get(self.obj))

    property fullscreen:
        def __get__(self):
            return bool(elm_win_fullscreen_get(self.obj))
        def __set__(self, fullscreen):
            elm_win_fullscreen_set(self.obj, fullscreen)

    def maximized_set(self, maximized):
        elm_win_maximized_set(self.obj, maximized)

    def maximized_get(self):
        return bool(elm_win_maximized_get(self.obj))

    property maximized:
        def __get__(self):
            return bool(elm_win_maximized_get(self.obj))
        def __set__(self, maximized):
            elm_win_maximized_set(self.obj, maximized)

    def iconified_set(self, iconified):
        elm_win_iconified_set(self.obj, iconified)

    def iconified_get(self):
        return bool(elm_win_iconified_get(self.obj))

    property iconified:
        def __get__(self):
            return bool(elm_win_iconified_get(self.obj))
        def __set__(self, iconified):
            elm_win_iconified_set(self.obj, iconified)

    def withdrawn_set(self, withdrawn):
        elm_win_withdrawn_set(self.obj, withdrawn)

    def withdrawn_get(self):
        return bool(elm_win_withdrawn_get(self.obj))

    property withdrawn:
        def __get__(self):
            return bool(elm_win_withdrawn_get(self.obj))
        def __set__(self, withdrawn):
            elm_win_withdrawn_set(self.obj, withdrawn)

    def urgent_set(self, urgent):
        elm_win_urgent_set(self.obj, urgent)

    def urgent_get(self):
        return bool(elm_win_urgent_get(self.obj))

    property urgent:
        def __get__(self):
            return bool(elm_win_urgent_get(self.obj))
        def __set__(self, urgent):
            elm_win_urgent_set(self.obj, urgent)

    def demand_attention_set(self, demand_attention):
        elm_win_demand_attention_set(self.obj, demand_attention)

    def demand_attention_get(self):
        return bool(elm_win_demand_attention_get(self.obj))

    property demand_attention:
        def __get__(self):
            return bool(elm_win_demand_attention_get(self.obj))
        def __set__(self, demand_attention):
            elm_win_demand_attention_set(self.obj, demand_attention)

    def modal_set(self, modal):
        elm_win_modal_set(self.obj, modal)

    def modal_get(self):
        return bool(elm_win_modal_get(self.obj))

    property modal:
        def __get__(self):
            return bool(elm_win_modal_get(self.obj))
        def __set__(self, modal):
            elm_win_modal_set(self.obj, modal)

    def aspect_set(self, aspect):
        elm_win_aspect_set(self.obj, aspect)

    def aspect_get(self):
        return elm_win_aspect_get(self.obj)

    property aspect:
        def __get__(self):
            return elm_win_aspect_get(self.obj)
        def __set__(self, aspect):
            elm_win_aspect_set(self.obj, aspect)

    property size_base:
        def __set__(self, value):
            w, h = value
            elm_win_size_base_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            elm_win_size_base_get(self.obj, &w, &h)
            return (w, h)

    property size_step:
        def __set__(self, value):
            w, h = value
            elm_win_size_step_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            elm_win_size_step_get(self.obj, &w, &h)
            return (w, h)

    def layer_set(self, layer):
        elm_win_layer_set(self.obj, layer)

    def layer_get(self):
        return elm_win_layer_get(self.obj)

    property layer:
        def __get__(self):
            return elm_win_layer_get(self.obj)
        def __set__(self, layer):
            elm_win_layer_set(self.obj, layer)

    def rotation_set(self, rotation):
        elm_win_rotation_set(self.obj, rotation)

    def rotation_get(self):
        return elm_win_rotation_get(self.obj)

    property rotation:
        def __get__(self):
            return elm_win_rotation_get(self.obj)
        def __set__(self, rotation):
            elm_win_rotation_set(self.obj, rotation)

    def rotation_with_resize_set(self, rotation):
        elm_win_rotation_set(self.obj, rotation)

    property rotation_with_resize:
        def __set__(self, rotation):
            elm_win_rotation_set(self.obj, rotation)

    def sticky_set(self, sticky):
        elm_win_sticky_set(self.obj, sticky)

    def sticky_get(self):
        return bool(elm_win_sticky_get(self.obj))

    property sticky:
        def __get__(self):
            return bool(elm_win_sticky_get(self.obj))
        def __set__(self, sticky):
            elm_win_sticky_set(self.obj, sticky)

    def conformant_set(self, conformant):
        elm_win_conformant_set(self.obj, conformant)

    def conformant_get(self):
        return bool(elm_win_conformant_get(self.obj))

    property conformant:
        def __get__(self):
            return bool(elm_win_conformant_get(self.obj))
        def __set__(self, conformant):
            elm_win_conformant_set(self.obj, conformant)

    def quickpanel_set(self, quickpanel):
        elm_win_quickpanel_set(self.obj, quickpanel)

    def quickpanel_get(self):
        return bool(elm_win_quickpanel_get(self.obj))

    property quickpanel:
        def __get__(self):
            return bool(elm_win_quickpanel_get(self.obj))
        def __set__(self, quickpanel):
            elm_win_quickpanel_set(self.obj, quickpanel)

    def quickpanel_priority_major_set(self, priority):
        elm_win_quickpanel_priority_major_set(self.obj, priority)

    def quickpanel_priority_major_get(self):
        return elm_win_quickpanel_priority_major_get(self.obj)

    property quickpanel_priority_major:
        def __get__(self):
            return elm_win_quickpanel_priority_major_get(self.obj)
        def __set__(self, priority):
            elm_win_quickpanel_priority_major_set(self.obj, priority)

    def quickpanel_priority_minor_set(self, priority):
        elm_win_quickpanel_priority_minor_set(self.obj, priority)

    def quickpanel_priority_minor_get(self):
        return elm_win_quickpanel_priority_minor_get(self.obj)

    property quickpanel_priority_minor:
        def __get__(self):
            return elm_win_quickpanel_priority_minor_get(self.obj)
        def __set__(self, priority):
            elm_win_quickpanel_priority_minor_set(self.obj, priority)

    def quickpanel_zone_set(self, zone):
        elm_win_quickpanel_zone_set(self.obj, zone)

    def quickpanel_zone_get(self):
        return elm_win_quickpanel_zone_get(self.obj)

    property quickpanel_zone:
        def __get__(self):
            return elm_win_quickpanel_zone_get(self.obj)
        def __set__(self, zone):
            elm_win_quickpanel_zone_set(self.obj, zone)

    def prop_focus_skip_set(self, skip):
        elm_win_prop_focus_skip_set(self.obj, skip)

    property focus_skip_set:
        def __set__(self, skip):
            elm_win_prop_focus_skip_set(self.obj, skip)

    def illume_command_send(self, command, *args, **kwargs):
        params = (args, kwargs)
        elm_win_illume_command_send(self.obj, command, params)

#     def inlined_image_object_get(self):
#         cdef evasImage img = evasImage()
#         cdef Evas_Object *obj = elm_win_inlined_image_object_get(self.obj)
#         img.obj = obj
#         return img

#     property inlined_image_object:
#         def __get__(self):
#             cdef evasImage img = evasImage()
#             cdef Evas_Object *obj = elm_win_inlined_image_object_get(self.obj)
#             img.obj = obj
#             return img

    def focus_get(self):
        return bool(elm_win_focus_get(self.obj))

    property focus:
        def __get__(self):
            return bool(elm_win_focus_get(self.obj))

    def screen_constrain_set(self, constrain):
        elm_win_screen_constrain_set(self.obj, constrain)

    def screen_constrain_get(self):
        return bool(elm_win_screen_constrain_get(self.obj))

    property screen_constrain:
        def __get__(self):
            return bool(elm_win_screen_constrain_get(self.obj))
        def __set__(self, constrain):
            elm_win_screen_constrain_set(self.obj, constrain)

    def screen_size_get(self):
        cdef int x, y, w, h
        elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    property screen_size:
        def __get__(self):
            cdef int x, y, w, h
            elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

    def focus_highlight_enabled_set(self, enabled):
        elm_win_focus_highlight_enabled_set(self.obj, enabled)

    def focus_highlight_enabled_get(self):
        return bool(elm_win_focus_highlight_enabled_get(self.obj))

    property focus_highlight_enabled:
        def __get__(self):
            return bool(elm_win_focus_highlight_enabled_get(self.obj))
        def __set__(self, enabled):
            elm_win_focus_highlight_enabled_set(self.obj, enabled)

    def focus_highlight_style_set(self, style):
        elm_win_focus_highlight_style_set(self.obj, _cfruni(style))

    def focus_highlight_style_get(self):
        return _ctouni(elm_win_focus_highlight_style_get(self.obj))

    property focus_highlight_style:
        def __get__(self):
            return _ctouni(elm_win_focus_highlight_style_get(self.obj))
        def __set__(self, style):
            elm_win_focus_highlight_style_set(self.obj, _cfruni(style))

    def keyboard_mode_set(self, mode):
        elm_win_keyboard_mode_set(self.obj, mode)

    def keyboard_mode_get(self):
        return elm_win_keyboard_mode_get(self.obj)

    property keyboard_mode:
        def __get__(self):
            return elm_win_keyboard_mode_get(self.obj)
        def __set__(self, mode):
            elm_win_keyboard_mode_set(self.obj, mode)

    def keyboard_win_set(self, is_keyboard):
        elm_win_keyboard_win_set(self.obj, is_keyboard)

    def keyboard_win_get(self):
        return bool(elm_win_keyboard_win_get(self.obj))

    property keyboard_win:
        def __get__(self):
            return bool(elm_win_keyboard_win_get(self.obj))
        def __set__(self, is_keyboard):
            elm_win_keyboard_win_set(self.obj, is_keyboard)

    def indicator_mode_set(self, mode):
        elm_win_indicator_mode_set(self.obj, mode)

    def indicator_mode_get(self):
        return elm_win_indicator_mode_get(self.obj)

    property indicator_mode:
        def __get__(self):
            return elm_win_indicator_mode_get(self.obj)
        def __set__(self, mode):
            elm_win_indicator_mode_set(self.obj, mode)

    def indicator_opacity_set(self, mode):
        elm_win_indicator_opacity_set(self.obj, mode)

    def indicator_opacity_get(self):
        return elm_win_indicator_opacity_get(self.obj)

    property indicator_opacity:
        def __get__(self):
            return elm_win_indicator_opacity_get(self.obj)
        def __set__(self, mode):
            elm_win_indicator_opacity_set(self.obj, mode)

    def screen_position_get(self):
        cdef int x, y
        elm_win_screen_position_get(self.obj, &x, &y)
        return (x, y)

    property screen_position:
        def __get__(self):
            cdef int x, y
            elm_win_screen_position_get(self.obj, &x, &y)
            return (x, y)

    def socket_listen(self, svcname, svcnum, svcsys):
        return bool(elm_win_socket_listen(self.obj, _cfruni(svcname), svcnum, svcsys))

    def xwindow_xid_get(self):
        cdef Ecore_X_Window xwin
        xwin = elm_win_xwindow_get(self.obj)
        return xwin

    property xwindow_xid:
        def __get__(self):
            cdef Ecore_X_Window xwin
            xwin = elm_win_xwindow_get(self.obj)
            return xwin

    def callback_delete_request_add(self, func, *args, **kwargs):
        self._callback_add("delete,request", func, *args, **kwargs)

    def callback_delete_request_del(self, func):
        self._callback_del("delete,request", func)

    def callback_focus_in_add(self, func, *args, **kwargs):
        self._callback_add("focus,in", func, *args, **kwargs)

    def callback_focus_in_del(self, func):
        self._callback_del("focus,in", func)

    def callback_focus_out_add(self, func, *args, **kwargs):
        self._callback_add("focus,out", func, *args, **kwargs)

    def callback_focus_out_del(self, func):
        self._callback_del("focus,out")

    def callback_moved_add(self, func, *args, **kwargs):
        self._callback_add("moved", func, *args, **kwargs)

    def callback_moved_del(self, func):
        self._callback_del("moved")

    def callback_withdrawn_add(self, func, *args, **kwargs):
        self._callback_add("withdrawn", func, *args, **kwargs)

    def callback_withdrawn_del(self, func):
        self._callback_del("withdrawn")

    def callback_iconified_add(self, func, *args, **kwargs):
        self._callback_add("iconified", func, *args, **kwargs)

    def callback_iconified_del(self, func):
        self._callback_del("iconified")

    def callback_normal_add(self, func, *args, **kwargs):
        self._callback_add("normal", func, *args, **kwargs)

    def callback_normal_del(self, func):
        self._callback_del("normal")

    def callback_stick_add(self, func, *args, **kwargs):
        self._callback_add("stick", func, *args, **kwargs)

    def callback_stick_del(self, func):
        self._callback_del("stick")

    def callback_unstick_add(self, func, *args, **kwargs):
        self._callback_add("unstick", func, *args, **kwargs)

    def callback_unstick_del(self, func):
        self._callback_del("unstick")

    def callback_fullscreen_add(self, func, *args, **kwargs):
        self._callback_add("fullscreen", func, *args, **kwargs)

    def callback_fullscreen_del(self, func):
        self._callback_del("fullscreen")

    def callback_unfullscreen_add(self, func, *args, **kwargs):
        self._callback_add("unfullscreen", func, *args, **kwargs)

    def callback_unfullscreen_del(self, func):
        self._callback_del("unfullscreen")

    def callback_maximized_add(self, func, *args, **kwargs):
        self._callback_add("maximized", func, *args, **kwargs)

    def callback_maximized_del(self, func):
        self._callback_del("maximized")

    def callback_unmaximized_add(self, func, *args, **kwargs):
        self._callback_add("unmaximized", func, *args, **kwargs)

    def callback_unmaximized_del(self, func):
        self._callback_del("unmaximized")

_object_mapping_register("elm_win", Window)


cdef class StandardWindow(Window):

    def __init__(self, name, title):
        self._set_obj(elm_win_util_standard_add(_cfruni(name), _cfruni(title)))


_object_mapping_register("elm_standardwin", StandardWindow)
