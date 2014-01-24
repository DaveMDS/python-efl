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
#

"""

Description
-----------

Elementary configuration is formed by a set options bounded to a
given profile, like theme, "finger size", etc.

These are functions with which one synchronizes changes made to those
values to the configuration storing files, de facto. You most probably
don't want to use the functions in this group unless you're writing an
elementary configuration manager.

Profiles
========

Profiles are pre-set options that affect the whole look-and-feel of
Elementary-based applications. There are, for example, profiles
aimed at desktop computer applications and others aimed at mobile,
touchscreen-based ones. You most probably don't want to use the
functions in this group unless you're writing an elementary
configuration manager.

Elementary Scrolling
====================

These set how scrollable views in Elementary widgets should behave on
user interaction.

Password show last
==================

Show last feature of password mode enables user to view the last input
entered for few seconds before masking it. These functions allow to set
this feature in password mode of entry widget and also allow to
manipulate the duration for which the input has to be visible.

Elementary Engine
=================

These are functions setting and querying which rendering engine
Elementary will use for drawing its windows' pixels.

The following are the available engines:

- "software_x11"
- "fb"
- "directfb"
- "software_16_x11"
- "software_8_x11"
- "xrender_x11"
- "opengl_x11"
- "software_gdi"
- "software_16_wince_gdi"
- "sdl"
- "software_16_sdl"
- "opengl_sdl"
- "buffer"
- "ews"
- "opengl_cocoa"
- "psl1ght"


Enumerations
------------

.. _Elm_Softcursor_Mode:

Elm_Softcursor_Mode
===================

.. data:: ELM_SOFTCURSOR_MODE_AUTO

    Auto-detect if a software cursor should be used (default)

.. data:: ELM_SOFTCURSOR_MODE_ON

    Always use a softcursor

.. data:: ELM_SOFTCURSOR_MODE_OFF

    Never use a softcursor

"""

from cpython cimport PyUnicode_AsUTF8String

from efl.utils.conversions cimport _ctouni, eina_list_strings_to_python_list

cimport enums

ELM_SOFTCURSOR_MODE_AUTO = enums.ELM_SOFTCURSOR_MODE_AUTO
ELM_SOFTCURSOR_MODE_ON = enums.ELM_SOFTCURSOR_MODE_ON
ELM_SOFTCURSOR_MODE_OFF = enums.ELM_SOFTCURSOR_MODE_OFF


cdef class Configuration(object):

    """The configuration class"""

    def save(self):
        """save()

        Save back Elementary's configuration, so that it will persist on
        future sessions.

        This function will take effect -- thus, do I/O -- immediately. Use
        it when you want to save all configuration changes at once. The
        current configuration set will get saved onto the current profile
        configuration file.

        :return: ``True``, when successful. ``False``, otherwise.
        :rtype: bool

        """
        return bool(elm_config_save())

    def reload(self):
        """reload()

        Reload Elementary's configuration, bounded to current selected
        profile.

        Useful when you want to force reloading of configuration values for
        a profile. If one removes user custom configuration directories,
        for example, it will force a reload with system values instead.

        :return: ``True``, when successful. ``False``, otherwise.
        :rtype: bool

        """
        elm_config_reload()

    def all_flush(self):
        """all_flush()

        Flush all config settings then apply those settings to all
        applications using elementary on the current display."""
        elm_config_all_flush()

    property profile:
        """Elementary's profile in use.

        The global profile that is applied to all Elementary applications.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_config_profile_get())
        def __set__(self, profile):
            if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
            elm_config_profile_set(<const_char *>profile if profile is not None else NULL)

    def profile_dir_get(self, profile, bint is_user):
        """profile_dir_get(unicode profile, bool is_user)

        Get an Elementary's profile directory path in the filesystem. One
        may want to fetch a system profile's dir or a user one (fetched
        inside $HOME).

        :param profile:  The profile's name
        :type profile: unicode
        :param is_user:  Whether to lookup for a user profile (``True``)
            or a system one (``False``)
        :type is_user: bool
        :return: The profile's directory path.
        :rtype: string

        """
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
        return _ctouni(elm_config_profile_dir_get(
            <const_char *>profile if profile is not None else NULL,
            is_user))

    property profile_list:
        """Get Elementary's list of available profiles.

        :type: tuple of strings

        """
        def __get__(self):
            cdef Eina_List *lst = elm_config_profile_list_get()
            ret = tuple(eina_list_strings_to_python_list(lst))
            elm_config_profile_list_free(lst)
            return ret

    property scroll_bounce_enabled:
        """Whether scrollers should bounce when they reach their
        viewport's edge during a scroll.

        :type: bool

        """
        def __get__(self):
            return bool(elm_config_scroll_bounce_enabled_get())
        def __set__(self, bint enabled):
            elm_config_scroll_bounce_enabled_set(enabled)

    property scroll_bounce_friction:
        """The amount of inertia a scroller will impose at bounce animations.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_bounce_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_bounce_friction_set(friction)

    property scroll_page_scroll_friction:
        """The amount of inertia a **paged** scroller will impose at page
        fitting animations.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_page_scroll_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_page_scroll_friction_set(friction)

    property scroll_bring_in_scroll_friction:
        """The amount of inertia a scroller will impose at region bring
        animations.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_bring_in_scroll_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_bring_in_scroll_friction_set(friction)

    property scroll_zoom_friction:
        """The amount of inertia scrollers will impose at animations
        triggered by Elementary widgets' zooming API.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_zoom_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_zoom_friction_set(friction)

    property scroll_thumbscroll_enabled:
        """Whether scrollers should be draggable from any point in their views.

        .. note:: This is the default behavior for touch screens, in general.
        .. note:: All other functions namespaced with "thumbscroll" will only
          have effect if this mode is enabled.

        :type: bool

        """
        def __get__(self):
            return bool(elm_config_scroll_thumbscroll_enabled_get())
        def __set__(self, bint enabled):
            elm_config_scroll_thumbscroll_enabled_set(enabled)

    property scroll_thumbscroll_threshold:
        """The number of pixels one should travel while dragging a
        scroller's view to actually trigger scrolling.

        One would use higher values for touch screens, in general, because
        of their inherent imprecision.

        :type: int

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_threshold_get()
        def __set__(self, int threshold):
            elm_config_scroll_thumbscroll_threshold_set(threshold)


    property scroll_thumbscroll_hold_threshold:
        """The number of pixels the range which can be scrolled,
        while the scroller is holded.

        :type: int

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_hold_threshold_get()
        def __set__(self, int threshold):
            elm_config_scroll_thumbscroll_hold_threshold_set(threshold)

    property scroll_thumbscroll_momentum_threshold:
        """The minimum speed of mouse cursor movement which will trigger list
        self scrolling animation after a mouse up event (pixels/second).

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_momentum_threshold_get()
        def __set__(self, double threshold):
            elm_config_scroll_thumbscroll_momentum_threshold_set(threshold)

    property scroll_thumbscroll_flick_distance_tolerance:
        """

        The number of pixels the maximum distance which can be flicked.
        If it is flicked more than this,
        the flick distance is same with maximum distance.

        :type: int

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_flick_distance_tolerance_get()
        def __set__(self, unsigned int distance):
            elm_config_scroll_thumbscroll_flick_distance_tolerance_set(distance)

    property scroll_thumbscroll_friction:
        """The amount of inertia a scroller will impose at self scrolling
        animations.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_thumbscroll_friction_set(friction)

    property scroll_thumbscroll_min_friction:
        """

        The min amount of inertia a scroller will impose at self scrolling
        animations.

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_min_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_thumbscroll_min_friction_set(friction)

    property scroll_thumbscroll_friction_standard:
        """

        The standard velocity of the scroller. The scroll animation time is
        same with thumbscroll friction, if the velocity is same with standard
        velocity.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_friction_standard_get()
        def __set__(self, double standard):
            elm_config_scroll_thumbscroll_friction_standard_set(standard)

    property scroll_thumbscroll_border_friction:
        """The amount of lag between your actual mouse cursor dragging
        movement and a scroller's view movement itself, while pushing it
        into bounce state manually.

        .. note:: parameter value will get bound to 0.0 - 1.0 interval, always

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_border_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_thumbscroll_border_friction_set(friction)

    property scroll_thumbscroll_sensitivity_friction:
        """The sensitivity amount which is be multiplied by the length of
        mouse dragging.

        ``0.1`` for minimum sensitivity, ``1.0`` for maximum sensitivity.
        ``0.25`` is proper.

        :type: float

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_sensitivity_friction_get()
        def __set__(self, double friction):
            elm_config_scroll_thumbscroll_sensitivity_friction_set(friction)


    property scroll_thumbscroll_acceleration_threshold:
        """The minimum speed of mouse cursor movement which will accelerate
        scrolling velocity after a mouse up event (pixels/second).

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_acceleration_threshold_get()
        def __set__(self, double threshold):
            elm_config_scroll_thumbscroll_acceleration_threshold_set(threshold)

    property scroll_thumbscroll_acceleration_time_limit:
        """The time limit for accelerating velocity.

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_acceleration_time_limit_get()
        def __set__(self, double time_limit):
            elm_config_scroll_thumbscroll_acceleration_time_limit_set(time_limit)

    property scroll_thumbscroll_acceleration_weight:
        """The weight for the acceleration.

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_acceleration_weight_get()
        def __set__(self, double weight):
            elm_config_scroll_thumbscroll_acceleration_weight_set(weight)

    property longpress_timeout:
        """The duration for occurring long press event.

        :type: float

        """
        def __get__(self):
            return elm_config_longpress_timeout_get()
        def __set__(self, double longpress_timeout):
            elm_config_longpress_timeout_set(longpress_timeout)

    property softcursor_mode:
        """The mode used for software provided mouse cursors inline in the window
        canvas.

        A software rendered cursor can be provided for rendering inline inside the
        canvas windows in the event the native display system does not provide one
        or the native oneis not wanted.

        :type: :ref:`Elm_Softcursor_Mode`

        .. versionadded:: 1.8

        """
        def __set__(self, Elm_Softcursor_Mode mode):
            elm_config_softcursor_mode_set(mode)
        def __get__(self):
            return elm_config_softcursor_mode_get()


    property tooltip_delay:
        """The duration after which tooltip will be shown.

        :type: float

        """
        def __get__(self):
            return elm_config_tooltip_delay_get()
        def __set__(self, double delay):
            elm_config_tooltip_delay_set(delay)

    property cursor_engine_only:
        """The globally configured exclusive usage of engine cursors.

        If True only engine cursors will be enabled, if False will look for
        them on theme before.

        :type: bool

        """
        def __get__(self):
            return elm_config_cursor_engine_only_get()
        def __set__(self, bint engine_only):
            elm_config_cursor_engine_only_set(engine_only)

    property scale:
        """The global scaling factor

        This gets the globally configured scaling factor that is applied to
        all objects.

        :type: float

        """
        def __get__(self):
            return elm_config_scale_get()
        def __set__(self, double scale):
            elm_config_scale_set(scale)

    property password_show_last:
        """The "show last" setting of password mode.

        :type: bool

        """
        def __get__(self):
            return elm_config_password_show_last_get()
        def __set__(self, bint password_show_last):
            elm_config_password_show_last_set(password_show_last)

    property password_show_last_timeout:
        """The timeout value for which the last input entered in password
        mode will be visible.

        :type: float

        """
        def __get__(self):
            return elm_config_password_show_last_timeout_get()
        def __set__(self, double password_show_last_timeout):
            elm_config_password_show_last_timeout_set(password_show_last_timeout)

    property engine:
        """Elementary's rendering engine in use.

        This gets the global rendering engine that is applied to all
        Elementary applications.

        Note that it will take effect only to Elementary windows created
        after this is set.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_config_engine_get())
        def __set__(self, engine):
            if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
            elm_config_engine_set(
                <const_char *>engine if engine is not None else NULL)

    property preferred_engine:
        """Get Elementary's preferred engine to use.

        This gets the global rendering engine that is applied to all
        Elementary applications and is PREFERRED by the application.

        Note that it will take effect only to Elementary windows created
        after this is called. This overrides the engine set by configuration
        at application startup. Note that it is a hint and may not be honored.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_config_preferred_engine_get())
        def __set__(self, engine):
            if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
            elm_config_preferred_engine_set(
                <const_char *>engine if engine is not None else NULL)

    property text_classes_list:
        """Get Elementary's list of supported text classes.

        :type: list of :ref:`Elm_Text_Class`

        """
        def __get__(self):
            cdef:
                Eina_List *lst
                Elm_Text_Class *data
                const_char *name
                const_char *desc

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
            # TODO: Free the list?

    property font_overlay_list:
        """Get Elementary's list of font overlays, set with
        :py:func:`font_overlay_set()`.

        For each text class, one can set a **font overlay** for it, overriding
        the default font properties for that class coming from the theme in
        use. There is no need to free this list.

        :type: list of :ref:`Elm_Font_Overlay`

        """
        def __get__(self):
            cdef:
                const_Eina_List *lst
                Elm_Font_Overlay *data
                const_char *text_class
                const_char *font
                Evas_Font_Size size

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
            # TODO: ElmFontOverlay class?

    def font_overlay_set(self, text_class, font, size):
        """font_overlay_set(unicode text_class, unicode font, int size)

        Set a font overlay for a given Elementary text class.

        *font* has to be in the format returned by
        :py:func:`efl.elementary.general.font_fontconfig_name_get`.

        .. seealso::

            :py:attr:`font_overlay_list`
            :py:func:`font_overlay_unset`
            :py:func:`efl.edje.Edje.text_class_set`

        :param text_class: Text class name
        :type text_class: string
        :param font:  Font name and style string
        :type font: string
        :param size:  Font size
        :type size: :ref:`Evas_Font_Size`

        """
        a1 = text_class
        a2 = font
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if isinstance(a2, unicode): a2 = PyUnicode_AsUTF8String(a2)
        elm_config_font_overlay_set(
            <const_char *>a1 if a1 is not None else NULL,
            <const_char *>a2 if a2 is not None else NULL,
            size)

    # TODO:
    # property access:
    #     """Access mode

    #     :type: bool

    #     .. note::

    #         Elementary objects may have information (e.g. label on the
    #         elm_button) to be read. This information is read by access module
    #         when an object receives EVAS_CALLBACK_MOUSE_IN event

    #     """
    #     def __get__(self):
    #         return bool(elm_config_access_get())
    #     def __set__(self, bint is_access):
    #         elm_config_access_set(is_access)

    property selection_unfocused_clear:
        """Whether selection should be cleared when entry widget is unfocused.

        :type: bool

        .. versionadded:: 1.8

        """
        def __get__(self):
            return bool(elm_config_selection_unfocused_clear_get())
        def __set__(self, bint enabled):
            elm_config_selection_unfocused_clear_set(enabled)

    def font_overlay_unset(self, text_class):
        """font_overlay_unset(unicode text_class)

        Unset a font overlay for a given Elementary text class.

        This will bring back text elements belonging to text class
        ``text_class`` back to their default font settings.

        :param text_class: Text class name
        :type text_class: string

        """
        a1 = text_class
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        elm_config_font_overlay_unset(
            <const_char *>a1 if a1 is not None else NULL)

    def font_overlay_apply(self):
        """font_overlay_apply()

        Apply the changes made with :py:func:`font_overlay_set()` and
        :py:func:`font_overlay_unset()` on the current Elementary window.

        This applies all font overlays set to all objects in the UI.

        """
        elm_config_font_overlay_apply()

    property finger_size:
        """The configured "finger size"

        This gets the globally configured finger size, **in pixels**

        :type: int

        """
        def __get__(self):
            return elm_config_finger_size_get()
        def __set__(self, int size):
            elm_config_finger_size_set(size)

    property cache_flush_interval:
        """The globally configured cache flush interval time, in ticks

        .. seealso:: :py:func:`efl.elementary.general.cache_all_flush`

        .. note:: The ``size`` must be greater than 0. if not, the cache flush
            will be ignored.

        :type: int

        """
        def __get__(self):
            return elm_config_cache_flush_interval_get()
        def __set__(self, int size):
            elm_config_cache_flush_interval_set(size)

    property cache_flush_enabled:
        """The configured cache flush enabled state

        This property reflects the globally configured cache flush state -
        if it is enabled or not. When cache flushing is enabled, elementary
        will regularly (see :py:attr:`cache_flush_interval`) flush
        caches and dump data out of memory and allow usage to re-seed caches
        and data in memory where it can do so. An idle application will thus
        minimize its memory usage as data will be freed from memory and not
        be re-loaded as it is idle and not rendering or doing anything
        graphically right now.

        .. seealso:: :py:func:`efl.elementary.general.cache_all_flush`

        :type: bool

        """
        def __get__(self):
            return bool(elm_config_cache_flush_enabled_get())
        def __set__(self, bint enabled):
            elm_config_cache_flush_enabled_set(enabled)

    property cache_font_cache_size:
        """The globally configured font cache size, in bytes.

        :type: int

        """
        def __get__(self):
            return elm_config_cache_font_cache_size_get()
        def __set__(self, int size):
            elm_config_cache_font_cache_size_set(size)

    property cache_image_cache_size:
        """The globally configured image cache size, in bytes

        :type: int

        """
        def __get__(self):
            return elm_config_cache_image_cache_size_get()
        def __set__(self, int size):
            elm_config_cache_image_cache_size_set(size)


    property cache_edje_file_cache_size:
        """The globally configured edje file cache size, in number of files.

        :type: int

        """
        def __get__(self):
            return elm_config_cache_edje_file_cache_size_get()
        def __set__(self, int size):
            elm_config_cache_edje_file_cache_size_set(size)

    property cache_edje_collection_cache_size:
        """The globally configured edje collections cache size, in number of
        collections.

        :type: int

        """
        def __get__(self):
            return elm_config_cache_edje_collection_cache_size_get()
        def __set__(self, int size):
            elm_config_cache_edje_collection_cache_size_set(size)

    property focus_highlight_enabled:
        """Whether the highlight on focused objects is enabled or not

        Note that it will take effect only to Elementary windows created after
        this is set.

        :type: bool

        """
        def __get__(self):
            return bool(elm_config_focus_highlight_enabled_get())
        def __set__(self, bint enable):
            elm_config_focus_highlight_enabled_set(enable)

    property focus_highlight_animate:
        """Whether the focus highlight, if enabled, will animate its switch
        from one object to the next

        Note that it will take effect only to Elementary windows created after
        this is set.

        .. seealso:: :py:class:`~efl.elementary.window.Window`

        :type: bool

        """
        def __get__(self):
            return bool(elm_config_focus_highlight_animate_get())
        def __set__(self, bint animate):
            elm_config_focus_highlight_animate_set(animate)

    property mirrored:
        """Get the system mirrored mode. This determines the default
        mirrored mode of widgets.

        type: bool

        """
        def __get__(self):
            return bool(elm_config_mirrored_get())
        def __set__(self, bint mirrored):
            elm_config_mirrored_set(mirrored)

    property clouseau_enabled:
        """

        Clouseau state. True if clouseau was tried to be run.

        :return: True if clouseau was tried to run, False otherwise

        .. versionadded:: 1.8

        """
        def __get__(self):
            return bool(elm_config_clouseau_enabled_get())
        def __set__(self, bint enabled):
            elm_config_clouseau_enabled_set(enabled)

    def indicator_service_get(self, int rotation):
        """indicator_service_get(int rotation) -> unicode

        Get the indicator service name according to the rotation degree.

        :param rotation: The rotation which is related with the indicator service name, in degrees (0-360),

        :return: The indicator service name according to the rotation degree.

        .. versionadded:: 1.8

        """
        return _ctouni(elm_config_indicator_service_get(rotation))

    property glayer_long_tap_start_timeout:
        """

        The duration for occurring long tap event of gesture layer.

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_glayer_long_tap_start_timeout_get()
        def __set__(self, double long_tap_timeout):
            elm_config_glayer_long_tap_start_timeout_set(long_tap_timeout)

    property glayer_double_tap_timeout:
        """

        Get the duration for occurring double tap event of gesture layer.

        :return: Timeout for double tap event of gesture layer.

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_config_glayer_double_tap_timeout_get()
        def __set__(self, double double_tap_timeout):
            elm_config_glayer_double_tap_timeout_set(double_tap_timeout)

#For compatibility
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
    if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
    elm_config_preferred_engine_set(
        <const_char *>engine if engine is not None else NULL)

def engine_get():
    return _ctouni(elm_config_engine_get())
def engine_set(engine):
    if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
    elm_config_engine_set(
        <const_char *>engine if engine is not None else NULL)

def scale_get():
    return elm_config_scale_get()
def scale_set(scale):
    elm_config_scale_set(scale)

def cursor_engine_only_get():
    return elm_config_cursor_engine_only_get()
def cursor_engine_only_set(engine_only):
    elm_config_cursor_engine_only_set(engine_only)

