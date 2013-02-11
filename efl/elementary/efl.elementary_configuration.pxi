# Copyright 2012 Kai Huuhko <kai.huuhko@gmail.com>
#
# This file is part of python-elementary.
#
# python-elementary is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# python-elementary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with python-elementary.  If not, see <http://www.gnu.org/licenses/>.
#

cdef class Configuration(object):

    def save(self):
        return bool(elm_config_save())

    def reload(self):
        elm_config_reload()

    def all_flush(self):
        elm_config_all_flush()

    property profile:
        def __get__(self):
            return _ctouni(elm_config_profile_get())
        def __set__(self, profile):
            elm_config_profile_set(_cfruni(profile))

    def profile_dir_get(self, profile, is_user):
        return _ctouni(elm_config_profile_dir_get(_cfruni(profile), is_user))

    property profile_list:
        def __get__(self):
            cdef Eina_List *lst = elm_config_profile_list_get()
            return tuple(_strings_to_python(lst))

    property scroll_bounce_enabled:
        def __get__(self):
            return bool(elm_config_scroll_bounce_enabled_get())
        def __set__(self, enabled):
            elm_config_scroll_bounce_enabled_set(enabled)

    property scroll_bounce_friction:
        def __get__(self):
            return elm_config_scroll_bounce_friction_get()
        def __set__(self, friction):
            elm_config_scroll_bounce_friction_set(friction)

    property scroll_page_scroll_friction:
        def __get__(self):
            return elm_config_scroll_page_scroll_friction_get()
        def __set__(self, friction):
            elm_config_scroll_page_scroll_friction_set(friction)

    property scroll_bring_in_scroll_friction:
        def __get__(self):
            return elm_config_scroll_bring_in_scroll_friction_get()
        def __set__(self, friction):
            elm_config_scroll_bring_in_scroll_friction_set(friction)

    property scroll_zoom_friction:
        def __get__(self):
            return elm_config_scroll_zoom_friction_get()
        def __set__(self, friction):
            elm_config_scroll_zoom_friction_set(friction)

    property scroll_thumbscroll_enabled:
        def __get__(self):
            return bool(elm_config_scroll_thumbscroll_enabled_get())
        def __set__(self, enabled):
            elm_config_scroll_thumbscroll_enabled_set(enabled)

    property scroll_thumbscroll_threshold:
        def __get__(self):
            return elm_config_scroll_thumbscroll_threshold_get()
        def __set__(self, threshold):
            elm_config_scroll_thumbscroll_threshold_set(threshold)

    property scroll_thumbscroll_momentum_threshold:
        def __get__(self):
            return elm_config_scroll_thumbscroll_momentum_threshold_get()
        def __set__(self, threshold):
            elm_config_scroll_thumbscroll_momentum_threshold_set(threshold)

    property scroll_thumbscroll_friction:
        def __get__(self):
            return elm_config_scroll_thumbscroll_friction_get()
        def __set__(self, friction):
            elm_config_scroll_thumbscroll_friction_set(friction)

    property scroll_thumbscroll_border_friction:
        def __get__(self):
            return elm_config_scroll_thumbscroll_border_friction_get()
        def __set__(self, friction):
            elm_config_scroll_thumbscroll_border_friction_set(friction)

    property scroll_thumbscroll_sensitivity_friction:
        def __get__(self):
            return elm_config_scroll_thumbscroll_sensitivity_friction_get()
        def __set__(self, friction):
            elm_config_scroll_thumbscroll_sensitivity_friction_set(friction)


    property longpress_timeout:
        def __get__(self):
            return elm_config_longpress_timeout_get()
        def __set__(self, longpress_timeout):
            elm_config_longpress_timeout_set(longpress_timeout)

    property tooltip_delay:
        def __get__(self):
            return elm_config_tooltip_delay_get()
        def __set__(self, delay):
            elm_config_tooltip_delay_set(delay)

    property cursor_engine_only:
        def __get__(self):
            return elm_config_cursor_engine_only_get()
        def __set__(self, engine_only):
            elm_config_cursor_engine_only_set(engine_only)

    property scale:
        def __get__(self):
            return elm_config_scale_get()
        def __set__(self, scale):
            elm_config_scale_set(scale)

    property password_show_last:
        def __get__(self):
            return elm_config_password_show_last_get()
        def __set__(self, password_show_last):
            elm_config_password_show_last_set(password_show_last)

    property password_show_last_timeout:
        def __get__(self):
            return elm_config_password_show_last_timeout_get()
        def __set__(self, password_show_last_timeout):
            elm_config_password_show_last_timeout_set(password_show_last_timeout)

    property engine:
        def __get__(self):
            return _ctouni(elm_config_engine_get())
        def __set__(self, engine):
            elm_config_engine_set(_cfruni(engine))

    property preferred_engine:
        def __get__(self):
            return _ctouni(elm_config_preferred_engine_get())
        def __set__(self, engine):
            elm_config_preferred_engine_set(_cfruni(engine))

    property text_classes_list:
        def __get__(self):
            cdef Eina_List *lst
            cdef Elm_Text_Class *data
            cdef const_char_ptr name, desc
            ret = []
            lst = elm_config_text_classes_list_get()
            while lst:
                data = <Elm_Text_Class *>lst.data
                if data != NULL:
                    name = data.name
                    desc = data.desc
                    ret.append((_ctouni(name), _ctouni(desc)))
                lst = lst.next
            return ret

    property font_overlay_list:
        def __get__(self):
            cdef const_Eina_List *lst
            cdef Elm_Font_Overlay *data
            cdef const_char_ptr text_class, font
            cdef Evas_Font_Size size
            ret = []
            lst = elm_config_font_overlay_list_get()
            while lst:
                data = <Elm_Font_Overlay *>lst.data
                if data != NULL:
                    text_class = data.text_class
                    font = data.font
                    size = data.size
                    ret.append((_ctouni(text_class), _ctouni(font), size))
                lst = lst.next
            return ret

    def font_overlay_set(self, text_class, font, size):
        elm_config_font_overlay_set(_cfruni(text_class), _cfruni(font), size)

    def font_overlay_unset(self, text_class):
        elm_config_font_overlay_unset(_cfruni(text_class))

    def font_overlay_apply(self):
        elm_config_font_overlay_apply()

    property finger_size:
        def __get__(self):
            return elm_config_finger_size_get()
        def __set__(self, size):
            elm_config_finger_size_set(size)

    property cache_flush_interval:
        def __get__(self):
            return elm_config_cache_flush_interval_get()
        def __set__(self, size):
            elm_config_cache_flush_interval_set(size)

    property cache_flush_enabled:
        def __get__(self):
            return bool(elm_config_cache_flush_enabled_get())
        def __set__(self, enabled):
            elm_config_cache_flush_enabled_set(enabled)

    property cache_font_cache_size:
        def __get__(self):
            return elm_config_cache_font_cache_size_get()
        def __set__(self, size):
            elm_config_cache_font_cache_size_set(size)

    property cache_image_cache_size:
        def __get__(self):
            return elm_config_cache_image_cache_size_get()
        def __set__(self, size):
            elm_config_cache_image_cache_size_set(size)


    property cache_edje_file_cache_size:
        def __get__(self):
            return elm_config_cache_edje_file_cache_size_get()
        def __set__(self, size):
            elm_config_cache_edje_file_cache_size_set(size)

    property cache_edje_collection_cache_size:
        def __get__(self):
            return elm_config_cache_edje_collection_cache_size_get()
        def __set__(self, size):
            elm_config_cache_edje_collection_cache_size_set(size)

    property focus_highlight_enabled:
        def __get__(self):
            return bool(elm_config_focus_highlight_enabled_get())
        def __set__(self, enable):
            elm_config_focus_highlight_enabled_set(enable)

    property focus_highlight_animate:
        def __get__(self):
            return bool(elm_config_focus_highlight_animate_get())
        def __set__(self, animate):
            elm_config_focus_highlight_animate_set(animate)

    property mirrored:
        def __get__(self):
            return bool(elm_config_mirrored_get())
        def __set__(self, mirrored):
            elm_config_mirrored_set(mirrored)


def config_finger_size_get():
    return elm_config_finger_size_get()

def config_finger_size_set(size):
    elm_config_finger_size_set(size)

def config_tooltip_delay_get():
    return elm_config_tooltip_delay_get()

def config_tooltip_delay_set(delay):
    elm_config_tooltip_delay_set(delay)

def focus_highlight_enabled_get():
    return elm_config_focus_highlight_enabled_get()

def focus_highlight_enabled_set(enabled):
    elm_config_focus_highlight_enabled_set(enabled)

def focus_highlight_animate_get():
    return elm_config_focus_highlight_animate_get()

def focus_highlight_animate_set(animate):
    elm_config_focus_highlight_animate_set(animate)

def preferred_engine_get():
    return _ctouni(elm_config_preferred_engine_get())

def preferred_engine_set(engine):
    elm_config_preferred_engine_set(engine)

def engine_get():
    return _ctouni(elm_config_engine_get())

def engine_set(engine):
    elm_config_engine_set(_cfruni(engine))

def scale_get():
    return elm_config_scale_get()

def scale_set(scale):
    elm_config_scale_set(scale)

def cursor_engine_only_get():
    return elm_config_cursor_engine_only_get()

def cursor_engine_only_set(engine_only):
    elm_config_cursor_engine_only_set(engine_only)

