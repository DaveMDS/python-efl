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
#

include "configuration_cdef.pxi"

ELM_CONFIG_ICON_THEME_ELEMENTARY = "_Elementary_Icon_Theme"

cdef class Configuration(object):

    """The configuration class"""

    def save(self):
        """Save back Elementary's configuration, so that it will persist on
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
        """Reload Elementary's configuration, bounded to current selected
        profile.

        Useful when you want to force reloading of configuration values for
        a profile. If one removes user custom configuration directories,
        for example, it will force a reload with system values instead.

        :return: ``True``, when successful. ``False``, otherwise.
        :rtype: bool

        """
        elm_config_reload()

    def all_flush(self):
        """Flush all config settings then apply those settings to all
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
            elm_config_profile_set(<const char *>profile if profile is not None else NULL)

    def profile_dir_get(self, profile, bint is_user):
        """Get an Elementary's profile directory path in the filesystem. One
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
            <const char *>profile if profile is not None else NULL,
            is_user))

    property profile_list:
        """Get Elementary's list of available profiles.

        :type: tuple of strings (**readonly**)

        """
        def __get__(self):
            cdef Eina_List *lst = elm_config_profile_list_get()
            ret = tuple(eina_list_strings_to_python_list(lst))
            elm_config_profile_list_free(lst)
            return ret

    property profile_list_full:
        """Get Elementary's list of available profiles, including hidden ones.

        This gets a full list of profiles even with hidden names that should
        not be user-visible.

        :type: tuple of strings (**readonly**)

        .. versionadded:: 1.17

        """
        def __get__(self):
            cdef Eina_List *lst = elm_config_profile_list_full_get()
            ret = tuple(eina_list_strings_to_python_list(lst))
            elm_config_profile_list_free(lst)
            return ret

    def profile_exists(self, profile):
        """Check if a profile of the given name exists.

        :param str profile: Name of the pofile to search
        :return: ``True`` if the profile exists, or ``False`` if not
        :rtype: bool

        .. versionadded:: 1.17

        """
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
        return bool(elm_config_profile_exists(
                        <const char *>profile if profile is not None else NULL))

    def profile_derived_add(self, profile, derive_options):
        """Add a new profile of the given name to be derived from the current profile

        This creates a new profile of name ``profile`` that will be derived from
        the currently used profile using the modification commands encoded in
        the ``derive_options`` string.

        At this point it is not expected that anyone would generally use this
        API except if you are a destktop environment and so the user base of
        this API will be enlightenment itself.

        :param str profile: The new profile's name
        :param str derive_options: Derive options detailing how to modify

        .. versionadded:: 1.17

        """
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
        if isinstance(derive_options, unicode): derive_options = PyUnicode_AsUTF8String(derive_options)
    
        elm_config_profile_derived_add(
            <const char *>profile if profile is not None else NULL,
            <const char *>derive_options if derive_options is not None else NULL)

    def profile_derived_del(self, profile):
        """Deletes a profile that is derived from the current one

        This deletes a derived profile added by :func:`profile_derived_add`.
        This will delete the profile of the given name ``profile`` that is
        derived from the current profile.

        At this point it is not expected that anyone would generally use this
        API except if you are a destktop environment and so the user base of
        this API will be enlightenment itself.

        :param str profile: The profile's name that is to be deleted

        .. versionadded:: 1.17

        """
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
    
        elm_config_profile_derived_del(
            <const char *>profile if profile is not None else NULL)

    def profile_save(self, profile):
        """Take the current config and write it out to the named profile.

        This will take the current in-memory config and write it out to the
        named profile specified by ``profile``. This will not change profile
        for the application or make other processes switch profile.

        :param str profile: The profile's name

        .. versionadded:: 1.17

        """
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
    
        elm_config_profile_save(
            <const char *>profile if profile is not None else NULL)

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

    property scroll_accel_factor:
        """Scroll acceleration factor.
        
        Using a mouse wheel or touchpad to scroll will result in events
        being processed. If events occur quickly, the scroll amount will
        be multiplied by this value to accelerate the scrolling.
        Accepted value range from 0 to 10, where 0 means no accelleration
        and 10 means maximum acceleration.

        :type: float

        .. versionadded:: 1.18

        """
        def __get__(self):
            return elm_config_scroll_accel_factor_get()
        def __set__(self, double accel):
            elm_config_scroll_accel_factor_set(accel)

    property scroll_animation_disabled:
        """Disable scroller animations at all.

        This option disables timed animations during scrolling and forces
        scroll actions to be performed immediately.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_config_scroll_animation_disabled_get())
        def __set__(self, bint disabled):
            elm_config_scroll_animation_disabled_set(disabled)

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
        while the scroller is held.

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

    property scroll_thumbscroll_smooth_start:
        """The smooth start mode for scrolling with your finger.

        :type: bool

        .. versionadded:: 1.16

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_smooth_start_get()
        def __set__(self, bint enable):
            elm_config_scroll_thumbscroll_smooth_start_set(enable)

    property scroll_thumbscroll_smooth_amount:
        """The amount of smoothing to apply to scrolling.

        Scrolling with your finger can be smoothed out and the amount to smooth
        is determined by this parameter. 0.0 means to not smooth at all and
        1.0 is to smoth as much as possible.

        :type: float

        .. versionadded:: 1.16

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_smooth_amount_get()
        def __set__(self, double amount):
            elm_config_scroll_thumbscroll_smooth_amount_set(amount)

    property scroll_thumbscroll_smooth_time_window:
        """The time window to look back at for events for smoothing.

        Scrolling with your finger can be smoothed out and the window of time
        to look at is determined by this config. The value is in seconds and
        is from 0.0 to 1.0

        :type: float

        .. versionadded:: 1.16

        """
        def __get__(self):
            return elm_config_scroll_thumbscroll_smooth_time_window_get()
        def __set__(self, double amount):
            elm_config_scroll_thumbscroll_smooth_time_window_set(amount)

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

    property transition_duration_factor:
        """The transitions duration factor.

        This set the edje transition duration factor, it will affect the
        duration of edje animations.

        :type: float

        .. versionadded:: 1.15

        """
        def __get__(self):
            return elm_config_transition_duration_factor_get()
        def __set__(self, double delay):
            elm_config_transition_duration_factor_set(delay)

    property tooltip_delay:
        """The duration after which tooltip will be shown.

        :type: float

        """
        def __get__(self):
            return elm_config_tooltip_delay_get()
        def __set__(self, double delay):
            elm_config_tooltip_delay_set(delay)

    property popup_scrollable:
        """The popup scrollable flag

        If scrollable is ``True``, popup's contents is wrapped in a scroller
        container in order to popup shouldn't be larger than its parent.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_config_popup_scrollable_get())
        def __set__(self, bint scrollable):
            elm_config_popup_scrollable_set(scrollable)

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

        .. deprecated:: 1.13
            Use :attr:`accel_preference` instead.

        """
        def __get__(self):
            return _ctouni(elm_config_engine_get())
        def __set__(self, engine):
            if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
            elm_config_engine_set(
                <const char *>engine if engine is not None else NULL)

    property preferred_engine:
        """Get Elementary's preferred engine to use.

        This gets the global rendering engine that is applied to all
        Elementary applications and is PREFERRED by the application.

        Note that it will take effect only to Elementary windows created
        after this is called. This overrides the engine set by configuration
        at application startup. Note that it is a hint and may not be honored.

        :type: string

        .. deprecated:: 1.13
            Use :attr:`accel_preference` instead.

        """
        def __get__(self):
            return _ctouni(elm_config_preferred_engine_get())
        def __set__(self, engine):
            if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
            elm_config_preferred_engine_set(
                <const char *>engine if engine is not None else NULL)

    property accel_preference:
        """Elementary's acceleration preferences for new windows

        Note that it will take effect only to Elementary windows created after
        this is called. The value is a freeform string that indicates
        what kind of acceleration is preferred. This may or may not be honored,
        but a best attempt will be made. Known strings are as follows:

        * "gl", "opengl": try use opengl.
        * "3d": try and use a 3d acceleration unit.
        * "hw", "hardware", "accel": try any acceleration unit (best possible)

        .. note:: This takes precedence over engine preferences set with
                  :attr:`preferred_engine`

        :type: string

        .. versionadded:: 1.10

        """
        def __get__(self):
            return _ctouni(elm_config_accel_preference_get())
        def __set__(self, pref):
            if isinstance(pref, unicode): pref = PyUnicode_AsUTF8String(pref)
            elm_config_accel_preference_set(
                <const char *>pref if pref is not None else NULL)

    property accel_preference_override:
        """The acceleration override preference flag

        This is a flag that has the global system acceleration preference
        configuration forcibly override whatever acceleration preference the
        application may want.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_config_accel_preference_override_get())
        def __set__(self, bint enabled):
            elm_config_accel_preference_override_set(enabled)

    property text_classes_list:
        """Get Elementary's list of supported text classes.

        :type: list of tuples (name, desc)

        """
        def __get__(self):
            cdef:
                Eina_List *lst
                Elm_Text_Class *data
                const char *name
                const char *desc

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

        :type: list of tuples (text_class, font, size)

        """
        def __get__(self):
            cdef:
                const Eina_List *lst
                Elm_Font_Overlay *data
                const char *text_class
                const char *font
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
        """Set a font overlay for a given Elementary text class.

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
        :type size: int

        """
        a1 = text_class
        a2 = font
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if isinstance(a2, unicode): a2 = PyUnicode_AsUTF8String(a2)
        elm_config_font_overlay_set(
            <const char *>a1 if a1 is not None else NULL,
            <const char *>a2 if a2 is not None else NULL,
            size)

    property color_classes_list:
        """Get Elementary's list of supported color classes.

        :type: list of tuples (**color_class_name**, **color_class_description**)

        .. versionadded:: 1.10

        """
        def __get__(self):
            cdef:
                Eina_List *lst = elm_config_color_classes_list_get()
                Eina_List *itr = lst
                Elm_Color_Class *data
                const char *name
                const char *desc

            ret = []
            while itr:
                data = <Elm_Color_Class *>itr.data
                if data != NULL:
                    name = data.name
                    desc = data.desc
                    ret.append((_ctouni(name), _ctouni(desc)))
                itr = itr.next
            elm_config_color_classes_list_free(lst)
            return ret

    property color_overlay_list:
        """Get Elementary's list of color overlays

        Return the overlays setted using color_overlay_set()

        :type: list of tuples (**color_class**,
            (**r**, **g**, **b**, **a**),
            (**r2**, **g2**, **b2**, **a2**),
            (**r3**, **g3**, **b3**, **a3**))

        .. versionadded:: 1.10

        """
        def __get__(self):
            cdef:
                const Eina_List *lst = elm_config_color_overlay_list_get()
                Elm_Color_Overlay *ov
                const char *color_class

            ret = []
            while lst:
                ov = <Elm_Color_Overlay *>lst.data
                if ov != NULL:
                    color_class = ov.color_class
                    ret.append((
                        _ctouni(color_class),
                        (ov.color.r, ov.color.g, ov.color.b, ov.color.a),
                        (ov.outline.r, ov.outline.g, ov.outline.b, ov.outline.a),
                        (ov.shadow.r, ov.shadow.g, ov.shadow.b, ov.shadow.a)
                    ))

                lst = lst.next
            return ret

    def color_overlay_set(self, cc, int r,  int g,  int b,  int a,
                                    int r2, int g2, int b2, int a2,
                                    int r3, int g3, int b3, int a3):
        """Set a color overlay for a given Elementary color class.

        The first color is the object, the second is the text outline, and
        the third is the text shadow. (Note that the second two only apply
        to text parts).

        Setting color emits a signal "color_class,set" with source being
        the given color class in all edje objects.

        :param string cc: The color class name
        :param int r: Object Red value
        :param int g: Object Green value
        :param int b: Object Blue value
        :param int a: Object Alpha value
        :param int r2: Outline Red value
        :param int g2: Outline Green value
        :param int b2: Outline Blue value
        :param int a2: Outline Alpha value
        :param int r3: Shadow Red value
        :param int g3: Shadow Green value
        :param int b3: Shadow Blue value
        :param int a3: Shadow Alpha value

        .. versionadded:: 1.10

        """
        if isinstance(cc, unicode): cc = PyUnicode_AsUTF8String(cc)
        elm_config_color_overlay_set(<const char *>cc,
                                     r, g, b, a, r2, g2, b2, a2, r3, g3, b3, a3)

    def color_overlay_unset(self, cc):
        """Unset a color overlay for a given Elementary color class.

        This will bring back color elements belonging to color_class back
        to their default color settings.

        :param cc: The color class name

        .. versionadded:: 1.10

        """
        if isinstance(cc, unicode): cc = PyUnicode_AsUTF8String(cc)
        elm_config_color_overlay_unset(cc)

    def color_overlay_apply(self):
        """Apply the changes made with :meth:`color_overlay_set` and
        :meth:`color_overlay_unset` on the current Elementary window.

        .. versionadded:: 1.10

        """
        elm_config_color_overlay_apply()

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
        """Unset a font overlay for a given Elementary text class.

        This will bring back text elements belonging to text class
        ``text_class`` back to their default font settings.

        :param text_class: Text class name
        :type text_class: string

        """
        a1 = text_class
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        elm_config_font_overlay_unset(
            <const char *>a1 if a1 is not None else NULL)

    def font_overlay_apply(self):
        """Apply the changes made with :meth:`font_overlay_set` and
        :meth:`font_overlay_unset` on the current Elementary window.

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

    property focus_highlight_clip_disabled:
        """Whether the focus highlight clip feature is disabled.

        If disabled return True, else return False.
        If focus highlight clip feature is not disabled the focus highlight
        can be clipped.

        :type: bool

        .. versionadded:: 1.10

        """
        def __get__(self):
            return bool(elm_config_focus_highlight_clip_disabled_get())
        def __set__(self, bint disabled):
            elm_config_focus_highlight_clip_disabled_set(disabled)

    property focus_move_policy:
        """The focus movement policy.

        How the focus is moved to another object. It can be
        :attr:`ELM_FOCUS_MOVE_POLICY_CLICK` or
        :attr:`ELM_FOCUS_MOVE_POLICY_IN`. The first
        means elementary focus is moved on elementary object click. The
        second means elementary focus is moved on elementary object mouse in.

        :type: :ref:`Elm_Focus_Move_Policy`

        .. versionadded:: 1.10

        """
        def __get__(self):
            return elm_config_focus_move_policy_get()
        def __set__(self, policy):
            elm_config_focus_move_policy_set(policy)

    property item_select_on_focus_disabled:
        """Elementary item focus on selection.

        :type: bool

        .. versionadded:: 1.10

        """
        def __get__(self):
            return bool(elm_config_item_select_on_focus_disabled_get())
        def __set__(self, bint disabled):
            elm_config_item_select_on_focus_disabled_set(disabled)

    property first_item_focus_on_first_focusin:
        """The first item focus on first focusin feature.

        If this is enabled, then on the first focus of the widget the
        first item in lists will be automatically selected.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_config_first_item_focus_on_first_focusin_get())
        def __set__(self, bint enabled):
            elm_config_first_item_focus_on_first_focusin_set(enabled)

    property focus_autoscroll_mode:
        """Focus Autoscroll Mode

        When a region or an item is focused and it resides inside any scroller,
        elementary will automatically scroll the focused area to the visible
        viewport.

        :type: :ref:`Elm_Focus_Autoscroll_Mode`

        .. versionadded:: 1.10

        """
        def __get__(self):
            return elm_config_focus_autoscroll_mode_get()
        def __set__(self, Elm_Focus_Autoscroll_Mode mode):
            elm_config_focus_autoscroll_mode_set(mode)

    property font_hint_type:
        """ Apply the specified font hinting type.

        :type: :ref:`Evas_Font_Hinting_Flags` (**writeonly**)

        .. versionadded:: 1.18

        """
        def __set__(self, int mode):
            elm_config_font_hint_type_set(mode)

    property icon_theme:
        """The FDO icon theme for all elementary apps.

        This property control the icon theme for all
        :attr:`efl.elementary.Icon.standard` calls. Valid parameters are the
        name of an installed freedesktop.org icon theme or
        ELM_CONFIG_ICON_THEME_ELEMENTARY for the built in theme.

        :type: string

        .. versionadded:: 1.18

        """
        def __get__(self):
            return _ctouni(elm_config_icon_theme_get())
        def __set__(self, theme):
            if isinstance(theme, unicode): theme = PyUnicode_AsUTF8String(theme)
            elm_config_icon_theme_set(
                <const char *>theme if theme is not None else NULL)

    property vsync:
        """The configured vsync flag

        This is the globally configured vsync flag that asks some backend
        engines to use vsync display if possible.

        :type: bool

        .. versionadded:: 1.18

        """
        def __set__(self, bint enabled):
            elm_config_vsync_set(enabled)
        def __get__(self):
            return bool(elm_config_vsync_get())

    property window_auto_focus_enable:
        """The auto focus enable flag

        This determines if elementary will show a focus box indicating the
        focused widget automatically if keyboard controls like "Tab" are
        used to switch focus between widgets. Mouse or touch control will
        hide this auto shown focus, unless focus display has been explicitly
        forced on for the window.

        :type: bool

        .. versionadded:: 1.14

        """
        def __set__(self, bint enable):
            elm_config_window_auto_focus_enable_set(enable)
        def __get__(self):
            return bool(elm_config_window_auto_focus_enable_get())

    property window_auto_focus_animate:
        """The auto focus animate flag

        If auto focus is enabled then this will determine if the focus
        display will be animated or not.

        :type: bool

        .. versionadded:: 1.14

        """
        def __set__(self, bint enable):
            elm_config_window_auto_focus_animate_set(enable)
        def __get__(self):
            return bool(elm_config_window_auto_focus_animate_get())

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
        """

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

    property magnifier_enabled:
        """The magnifier enabled state for entries

        :type: bool

        .. versionadded:: 1.10

        """
        def __get__(self):
            return bool(elm_config_magnifier_enable_get())

        def __set__(self, bint enable):
            elm_config_magnifier_enable_set(enable)

    property magnifier_scale:
        """The amount of scaling the magnifer does

        :type: float

        .. versionadded:: 1.10

        """
        def __get__(self):
            return elm_config_magnifier_scale_get()

        def __set__(self, double scale):
            elm_config_magnifier_scale_set(scale)

    def audio_mute_get(self, Edje_Channel channel):
        """Get the mute state of an audio channel for effects

        :param channel: The channel to get the mute state of
        :return: The mute state

        .. versionadded:: 1.10

        """
        return bool(elm_config_audio_mute_get(channel))

    def audio_mute_set(self, Edje_Channel channel, bint mute):
        """Set the mute state of the specified channel

        :param channel: The channel to set the mute state of
        :param mute: The mute state to set

        .. versionadded:: 1.10

        """
        elm_config_audio_mute_set(channel, mute)

    property atspi_mode:
        """ATSPI mode

        :type: bool

        .. note:: Enables Linux Accessibility support for Elementary widgets.

        .. versionadded:: 1.10

        """
        def __get__(self):
            return bool(elm_config_atspi_mode_get())

        def __set__(self, bint is_atspi):
            elm_config_atspi_mode_set(is_atspi)

    property slider_indicator_visible_mode:
        """Slider's indicator visiblity mode.

        :type: :ref:`Elm_Slider_Indicator_Visible_Mode`

        .. versionadded:: 1.13

        """
        def __get__(self):
            return elm_config_slider_indicator_visible_mode_get()

        def __set__(self, mode):
            elm_config_slider_indicator_visible_mode_set(mode)

    property context_menu_disabled:
        """

        Enable or disable context menu in entries.

        :type: bool

        .. versionadded:: 1.17

        """
        def __get__(self):
            return bool(elm_config_context_menu_disabled_get())
        def __set__(self, bint disabled):
            elm_config_context_menu_disabled_set(disabled)

    property web_backend:
        """The backend engine used by Elm_Web widget

        This is the name of the external module used by elm_web to render web
        page.

        :type: string

        .. versionadded:: 1.18

        """
        def __get__(self):
            return _ctouni(elm_config_web_backend_get())
        def __set__(self, backend):
            if isinstance(backend, unicode): backend = PyUnicode_AsUTF8String(backend)
            elm_config_web_backend_set(
                        <const char *>backend if backend is not None else NULL)


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

def focus_highlight_clip_disabled_get():
    return elm_config_focus_highlight_clip_disabled_get()
def focus_highlight_clip_disabled_set(disabled):
    elm_config_focus_highlight_clip_disabled_set(disabled)

def focus_move_policy_get():
    return elm_config_focus_move_policy_get()
def focus_move_policy_set(policy):
    elm_config_focus_move_policy_set(policy)

def item_select_on_focus_disabled_get(self):
    return bool(elm_config_item_select_on_focus_disabled_get())
def item_select_on_focus_disabled_set(self, bint disabled):
    elm_config_item_select_on_focus_disabled_set(disabled)

@DEPRECATED("1.13", "Use accel_preference_get() instead.")
def preferred_engine_get():
    return _ctouni(elm_config_preferred_engine_get())
@DEPRECATED("1.13", "Use accel_preference_set() instead.")
def preferred_engine_set(engine):
    if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
    elm_config_preferred_engine_set(
        <const char *>engine if engine is not None else NULL)

def accel_preference_get():
    return _ctouni(elm_config_accel_preference_get())
def accel_preference_set(pref):
    if isinstance(pref, unicode): pref = PyUnicode_AsUTF8String(pref)
    elm_config_accel_preference_set(
        <const char *>pref if pref is not None else NULL)

@DEPRECATED("1.13", "Use accel_preference_get() instead.")
def engine_get():
    return _ctouni(elm_config_engine_get())
@DEPRECATED("1.13", "Use accel_preference_set() instead.")
def engine_set(engine):
    if isinstance(engine, unicode): engine = PyUnicode_AsUTF8String(engine)
    elm_config_engine_set(
        <const char *>engine if engine is not None else NULL)

def scale_get():
    return elm_config_scale_get()
def scale_set(scale):
    elm_config_scale_set(scale)

def cursor_engine_only_get():
    return elm_config_cursor_engine_only_get()
def cursor_engine_only_set(engine_only):
    elm_config_cursor_engine_only_set(engine_only)

