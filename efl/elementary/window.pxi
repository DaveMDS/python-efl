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

include "window_cdef.pxi"

cdef class Window(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, name, type, evasObject parent=None, *args, **kwargs):
        """Window(...)

        :param name: A name for the new window - used by the window
            manager for identifying the window uniquely amongst all the windows
            within this application (and all instances of the application).

            (This is the ``instance`` portion of the ``WM_CLASS`` string.)
        :type name: string
        :param type: A type for the new window.
        :type type: :ref:`Elm_Win_Type`
        :keyword parent: Parent object to add the window to - eg for a dialog
            you want to have a main window it is related to - defaults to None
        :type parent: :py:class:`efl.evas.Object`

        """
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        self._set_obj(elm_win_add(parent.obj if parent is not None else NULL,
            <const char *>name if name is not None else NULL,
            type))
        self._set_properties_from_keyword_args(kwargs)

    def resize_object_add(self, evasObject subobj):
        """Add ``subobj`` as a resize object of the window.

        Setting an object as a resize object of the window means that the
        ``subobj`` child's size and position will be controlled by the window
        directly. That is, the object will be resized to match the window size
        and should never be moved or resized manually by the developer.

        In addition, resize objects of the window control what the minimum size
        of it will be, as well as whether it can or not be resized by the user.

        For the end user to be able to resize a window by dragging the handles
        or borders provided by the Window Manager, or using any other similar
        mechanism, all of the resize objects in the window should have their
        :py:attr:`~efl.evas.Object.size_hint_weight` set to EVAS_HINT_EXPAND.

        Also notice that the window can get resized to the current size of the
        object if the :attr:`EVAS_HINT_EXPAND` is set **after** the call to
        resize_object_add(). So if the object should get resized to the
        size of the window, set this hint **before** adding it as a resize object
        (this happens because the size of the window and the object are evaluated
        as soon as the object is added to the window).

        :param subobj: The resize object to add
        :type subobj: :py:class:`~efl.elementary.object.Object`

        """
        elm_win_resize_object_add(self.obj, subobj.obj)

    def resize_object_del(self, evasObject subobj):
        """Delete ``subobj`` as a resize object of the window.

        This function removes the object ``subobj`` from the resize objects of
        the window. It will not delete the object itself, which will be
        left unmanaged and should be deleted by the developer, manually handled
        or set as child of some other container.

        :param subobj: The resize object to add
        :type subobj: :py:class:`efl.elementary.object.Object`

        """
        elm_win_resize_object_del(self.obj, subobj.obj)

    property title:
        """The title of the window.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_win_title_get(self.obj))
        def __set__(self, title):
            if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
            elm_win_title_set(self.obj,
                <const char *>title if title is not None else NULL)

    def title_set(self, title):
        if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
        elm_win_title_set(self.obj,
            <const char *>title if title is not None else NULL)
    def title_get(self):
        return _ctouni(elm_win_title_get(self.obj))

    # TODO: Add a property for this and move docs there
    def type_get(self):
        """Get the type of a window.

        :return: The type of the window
        :return type: :ref:`Elm_Win_Type`

        .. versionadded: 1.9

        """
        return elm_win_type_get(self.obj)

    property icon_name:
        """The icon name of the window.

        :type: string

        """
        def __get__(self):
            return self.icon_name_get()
        def __set__(self, icon_name):
            self.icon_name_set(icon_name)

    def icon_name_set(self, icon_name):
        if isinstance(icon_name, unicode): icon_name = PyUnicode_AsUTF8String(icon_name)
        elm_win_icon_name_set(self.obj,
            <const char *>icon_name if icon_name is not None else NULL)
    def icon_name_get(self):
        return _ctouni(elm_win_icon_name_get(self.obj))

    property role:
        """The role of the window.

        :type: string

        """
        def __get__(self):
            return self.role_get()
        def __set__(self, role):
            self.role_set(role)

    def role_set(self, role):
        if isinstance(role, unicode): role = PyUnicode_AsUTF8String(role)
        elm_win_role_set(self.obj,
            <const char *>role if role is not None else NULL)
    def role_get(self):
        return _ctouni(elm_win_role_get(self.obj))

    property icon_object:
        """The object to represent the window icon

        This sets an object that will be used as the icon for the window.
        The exact pixel dimensions of the object (not object size) will be
        used, and the image pixels will be used as-is when this function is
        called. If the image object has been updated, then call this
        function again to source the image pixels and put them on the
        window's icon. This has limitations as only image objects allowed at
        this stage. This may be lifted in future.

        :type: :py:class:`efl.elementary.image.Image`

        """
        def __get__(self):
            return object_from_instance(<Evas_Object *>elm_win_icon_object_get(self.obj))
        def __set__(self, evasObject icon):
            elm_win_icon_object_set(self.obj, icon.obj)

    def icon_object_set(self, evasObject icon):
        elm_win_icon_object_set(self.obj, icon.obj)
    def icon_object_get(self):
        return object_from_instance(<Evas_Object *>elm_win_icon_object_get(self.obj))

    property autodel:
        """The window's autodel state.

        When closing the window in any way outside of the program control,
        like pressing the X button in the titlebar or using a command from
        the Window Manager, a "delete,request" signal is emitted to indicate
        that this event occurred and the developer can take any action,
        which may include, or not, destroying the window object.

        When this property is set, the window will be automatically
        destroyed when this event occurs, after the signal is emitted. If
        ``autodel`` is ``False``, then the window will not be destroyed and is
        up to the program to do so when it's required.

        :type: bool

        """
        def __get__(self):
            return elm_win_autodel_get(self.obj)
        def __set__(self, autodel):
            elm_win_autodel_set(self.obj, autodel)

    def autodel_set(self, autodel):
        elm_win_autodel_set(self.obj, autodel)
    def autodel_get(self):
        return elm_win_autodel_get(self.obj)

    property autohide:
        """The window's autohide state.

        This property works similarly to :func:`autodel`, automatically handling
        "delete,request" signals when set to ``True``, with the difference
        that it will hide the window, instead of destroying it.

        It is specially designed to work together with 
        ELM_POLICY_QUIT_LAST_WINDOW_HIDDEN which allows exiting Elementary's
        main loop when all the windows are hidden.
        
        .. note:: :func:`autodel` and :func:`autohide` are not mutually exclusive.
                  The window will be deleted if both are set to ``True``.

        :type: bool
        
        .. versionadded:: 1.15

        """
        def __get__(self):
            return elm_win_autohide_get(self.obj)
        def __set__(self, autohide):
            elm_win_autohide_set(self.obj, autohide)

    def autohide_set(self, autohide):
        elm_win_autohide_set(self.obj, autohide)
    def autohide_get(self):
        return elm_win_autohide_get(self.obj)

    def activate(self):
        """Activate a window object.

        This function sends a request to the Window Manager to activate the
        window. If honored by the WM, the window will receive the keyboard
        focus.

        .. note:: This is just a request that a Window Manager may ignore, so
            calling this function does not ensure in any way that the window
            will be the active one after it.

        """
        elm_win_activate(self.obj)

    def lower(self):
        """Lower a window object.

        Places the window at the bottom of the stack, so that no other
        window is covered by it.

        If :py:attr:`override` is not set, the Window Manager may ignore this
        request.

        """
        elm_win_lower(self.obj)

    def _raise(self):
        """Raise a window object.

        Places the window at the top of the stack, so that it's not covered
        by any other window.

        If :py:attr:`override` is not set, the Window Manager may ignore this
        request.

        """
        elm_win_raise(self.obj)

    def center(self, h, v):
        """Center a window on its screen

        This function centers window horizontally and/or vertically
        based on the values of ``h`` and ``v``.

        :param h: If True, center horizontally. If False, do not change
            horizontal location.
        :type h: bool
        :param v: If True, center vertically. If False, do not change
            vertical location.
        :type v: bool

        """
        elm_win_center(self.obj, h, v)

    property borderless:
        """The borderless state of a window.

        Setting this to True requests the Window Manager to not draw any
        decoration around the window.

        :type: bool

        """
        def __get__(self):
            return self.borderless_get()
        def __set__(self, borderless):
            self.borderless_set(borderless)

    def borderless_set(self, borderless):
        elm_win_borderless_set(self.obj, borderless)
    def borderless_get(self):
        return bool(elm_win_borderless_get(self.obj))

    property shaped:
        """The shaped state of a window.

        Shaped windows, when supported, will render the parts of the window that
        has no content, transparent.

        If ``shaped`` is False, then it is strongly advised to have some
        background object or cover the entire window in any other way, or the
        parts of the canvas that have no data will show framebuffer artifacts.

        .. seealso:: :py:attr:`alpha`

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_shaped_get(self.obj))
        def __set__(self, shaped):
            elm_win_shaped_set(self.obj, shaped)

    def shaped_set(self,shaped):
        elm_win_shaped_set(self.obj, shaped)
    def shaped_get(self):
        return bool(elm_win_shaped_get(self.obj))

    property alpha:
        """The alpha channel state of a window.

        If ``alpha`` is True, the alpha channel of the canvas will be enabled
        possibly making parts of the window completely or partially
        transparent. This is also subject to the underlying system
        supporting it, like for example, running under a compositing
        manager. If no compositing is available, enabling this option will
        instead fallback to using shaped windows, with :py:attr:`shaped`.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_alpha_get(self.obj))
        def __set__(self, alpha):
            elm_win_alpha_set(self.obj, alpha)

    def alpha_set(self,alpha):
        elm_win_alpha_set(self.obj, alpha)
    def alpha_get(self):
        return bool(elm_win_alpha_get(self.obj))

    property override:
        """The override state of a window.

        A window with ``override`` set to True will not be managed by the
        Window Manager. This means that no decorations of any kind will be
        shown for it, moving and resizing must be handled by the
        application, as well as the window visibility.

        This should not be used for normal windows, and even for not so
        normal ones, it should only be used when there's a good reason and
        with a lot of care. Mishandling override windows may result
        situations that disrupt the normal workflow of the end user.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_override_get(self.obj))
        def __set__(self, override):
            elm_win_override_set(self.obj, override)

    def override_set(self, override):
        elm_win_override_set(self.obj, override)
    def override_get(self):
        return bool(elm_win_override_get(self.obj))

    property fullscreen:
        """The fullscreen state of a window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_fullscreen_get(self.obj))
        def __set__(self, fullscreen):
            elm_win_fullscreen_set(self.obj, fullscreen)

    def fullscreen_set(self, fullscreen):
        elm_win_fullscreen_set(self.obj, fullscreen)
    def fullscreen_get(self):
        return bool(elm_win_fullscreen_get(self.obj))

    property main_menu:
        """Get the Main Menu of a window.

        :type: :py:class:`efl.evas.Object`

        .. versionadded:: 1.8

        """
        def __get__(self):
            return object_from_instance(elm_win_main_menu_get(self.obj))

    def main_menu_get(self):
        return object_from_instance(elm_win_main_menu_get(self.obj))

    property maximized:
        """The maximized state of a window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_maximized_get(self.obj))
        def __set__(self, maximized):
            elm_win_maximized_set(self.obj, maximized)

    def maximized_set(self, maximized):
        elm_win_maximized_set(self.obj, maximized)
    def maximized_get(self):
        return bool(elm_win_maximized_get(self.obj))

    property iconified:
        """The iconified state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_iconified_get(self.obj))
        def __set__(self, iconified):
            elm_win_iconified_set(self.obj, iconified)

    def iconified_set(self, iconified):
        elm_win_iconified_set(self.obj, iconified)
    def iconified_get(self):
        return bool(elm_win_iconified_get(self.obj))

    property withdrawn:
        """The withdrawn state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_withdrawn_get(self.obj))
        def __set__(self, withdrawn):
            elm_win_withdrawn_set(self.obj, withdrawn)

    def withdrawn_set(self, withdrawn):
        elm_win_withdrawn_set(self.obj, withdrawn)
    def withdrawn_get(self):
        return bool(elm_win_withdrawn_get(self.obj))

    property available_profiles:
        """The array of available profiles to a window.

        :type: list of strings

        .. versionadded:: 1.8

        """
        def __set__(self, list profiles):
            cdef:
                const char **array = NULL
                unsigned int arr_len = len(profiles)
                unsigned int i

            try:
                array = python_list_strings_to_array_of_strings(profiles)
                elm_win_available_profiles_set(self.obj, array, arr_len)
            finally:
                for i in range(arr_len):
                    free(<void *>array[i])
                free(array)

        def __get__(self):
            cdef:
                char **profiles
                unsigned int count
                int ret

            ret = elm_win_available_profiles_get(self.obj, &profiles, &count)
            if ret == 0:
                return None
            else:
                return array_of_strings_to_python_list(profiles, count)

    def available_profiles_set(self, list profiles):
        cdef:
            const char **array = NULL
            unsigned int arr_len = len(profiles)
            unsigned int i

        try:
            array = python_list_strings_to_array_of_strings(profiles)
            elm_win_available_profiles_set(self.obj, array, arr_len)
        finally:
            for i in range(arr_len):
                free(<void *>array[i])
            free(array)

    def available_profiles_get(self):
        cdef:
            char **profiles
            unsigned int count
            int ret

        ret = elm_win_available_profiles_get(self.obj, &profiles, &count)
        if ret == 0:
            return None
        else:
            return array_of_strings_to_python_list(profiles, count)

    property profile:
        """The profile of a window.

        :type: unicode

        .. versionadded:: 1.8

        """
        def __set__(self, profile):
            if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
            elm_win_profile_set(self.obj,
                <const char *>profile if profile is not None else NULL)

        def __get__(self):
            return _ctouni(elm_win_profile_get(self.obj))

    def profile_set(self, profile):
        if isinstance(profile, unicode): profile = PyUnicode_AsUTF8String(profile)
        elm_win_profile_set(self.obj,
            <const char *>profile if profile is not None else NULL)
    def profile_get(self):
        return _ctouni(elm_win_profile_get(self.obj))

    property urgent:
        """The urgent state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_urgent_get(self.obj))
        def __set__(self, urgent):
            elm_win_urgent_set(self.obj, urgent)

    def urgent_set(self, urgent):
        elm_win_urgent_set(self.obj, urgent)
    def urgent_get(self):
        return bool(elm_win_urgent_get(self.obj))

    property demand_attention:
        """The demand attention state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_demand_attention_get(self.obj))
        def __set__(self, demand_attention):
            elm_win_demand_attention_set(self.obj, demand_attention)

    def demand_attention_set(self, demand_attention):
        elm_win_demand_attention_set(self.obj, demand_attention)
    def demand_attention_get(self):
        return bool(elm_win_demand_attention_get(self.obj))

    property modal:
        """The Modal state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_modal_get(self.obj))
        def __set__(self, modal):
            elm_win_modal_set(self.obj, modal)

    def modal_set(self, modal):
        elm_win_modal_set(self.obj, modal)
    def modal_get(self):
        return bool(elm_win_modal_get(self.obj))

    property aspect:
        """Set the aspect ratio of a window.

        If 0, the window has no aspect limits, otherwise it is width divided
        by height

        :type: float

        """
        def __get__(self):
            return elm_win_aspect_get(self.obj)
        def __set__(self, aspect):
            elm_win_aspect_set(self.obj, aspect)

    def aspect_set(self, aspect):
        elm_win_aspect_set(self.obj, aspect)
    def aspect_get(self):
        return elm_win_aspect_get(self.obj)

    property size_base:
        """The base window size used with stepping calculation

        Base size + stepping is what is calculated for window sizing restrictions.

        :type: (int w, int h)

        .. seealso:: :py:attr:`size_step`

        """
        def __set__(self, value):
            w, h = value
            elm_win_size_base_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            elm_win_size_base_get(self.obj, &w, &h)
            return (w, h)

    property size_step:
        """Set the window stepping used with sizing calculation

        Base size + stepping is what is calculated for window sizing restrictions.

        :type: (int w, int h)

        .. seealso:: :py:attr:`size_base`

        """
        def __set__(self, value):
            w, h = value
            elm_win_size_step_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            elm_win_size_step_get(self.obj, &w, &h)
            return (w, h)

    def size_step_set(self, int w, int h):
        elm_win_size_step_set(self.obj, w, h)
    def size_step_get(self):
        cdef int w, h
        elm_win_size_step_get(self.obj, &w, &h)
        return (w, h)

    property layer:
        """The layer of the window.

        What this means exactly will depend on the underlying engine used.

        In the case of X11 backed engines, the value in ``layer`` has the
        following meanings:

        - < 3: The window will be placed below all others.
        - > 5: The window will be placed above all others.
        - other: The window will be placed in the default layer.

        :type: int

        """
        def __get__(self):
            return elm_win_layer_get(self.obj)
        def __set__(self, layer):
            elm_win_layer_set(self.obj, layer)

    def layer_set(self, int layer):
        elm_win_layer_set(self.obj, layer)
    def layer_get(self):
        return elm_win_layer_get(self.obj)

    def norender_push(self):
        """This pushes (increments) the norender counter on the window

        There are some occasions where you wish to suspend rendering on a window.
        You may be "sleeping" and have nothing to update and do not want animations
        or other theme side-effects causing rendering to the window while "asleep".
        You can push (and pop) the norender mode to have this work.

        If combined with evas_render_dump(), evas_image_cache_flush() and
        evas_font_cache_flush() (and maybe edje_file_cache_flush() and
        edje_collection_cache_flush()), you can minimize memory footprint
        significantly while "asleep", and the pausing of rendering ensures
        evas does not re-load data into memory until needed. When rendering is
        resumed, data will be re-loaded as needed, which may result in some
        lag, but does save memory.

        .. seealso::
            :py:func:`norender_pop`
            :py:attr:`norender`
            :py:func:`render`

        .. versionadded:: 1.8

        """
        elm_win_norender_push(self.obj)

    def norender_pop(self):
        """This pops (decrements) the norender counter on the window

        Once norender has gone back to 0, then automatic rendering will continue
        in the given window. If it is already at 0, this will have no effect.

        .. seealso::
            :py:func:`norender_push`
            :py:attr:`norender`
            :py:func:`render`

        .. versionadded:: 1.8

        """
        elm_win_norender_pop(self.obj)

    property norender:
        """How many times norender has been pushed on the window

        :type: int

        .. seealso::
            :py:func:`norender_push`
            :py:func:`norender_pop`
            :py:func:`render`

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_win_norender_get(self.obj)

    def norender_get(self):
        return elm_win_norender_get(self.obj)

    def render(self):
        """This manually asks evas to render the window now

        You should NEVER call this unless you really know what you are doing and
        why. Never call this unless you are asking for performance degradation
        and possibly weird behavior. Windows get automatically rendered when the
        application goes idle so there is never a need to call this UNLESS you
        have enabled "norender" mode.

        .. seealso::
            :py:func:`norender_push`
            :py:func:`norender_pop`
            :py:attr:`norender`

        .. versionadded:: 1.8

        """
        elm_win_render(self.obj)

    property rotation:
        """The rotation of the window.

        Most engines only work with multiples of 90.

        This function is used to set the orientation of the window to match
        that of the screen. The window itself will be resized to adjust to
        the new geometry of its contents. If you want to keep the window
        size, see :py:attr:`rotation_with_resize`.

        :type: int

        """
        def __get__(self):
            return elm_win_rotation_get(self.obj)
        def __set__(self, rotation):
            elm_win_rotation_set(self.obj, rotation)

    def rotation_set(self, rotation):
        elm_win_rotation_set(self.obj, rotation)
    def rotation_get(self):
        return elm_win_rotation_get(self.obj)

    property rotation_with_resize:
        """Rotates the window and resizes it.

        Like :py:attr:`rotation`, but it also resizes the window's contents so that
        they fit inside the current window geometry.

        :type: int

        """
        def __set__(self, rotation):
            elm_win_rotation_set(self.obj, rotation)

    def rotation_with_resize_set(self, rotation):
        elm_win_rotation_set(self.obj, rotation)

    property sticky:
        """The Sticky state of the window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_sticky_get(self.obj))
        def __set__(self, sticky):
            elm_win_sticky_set(self.obj, sticky)

    def sticky_set(self, sticky):
        elm_win_sticky_set(self.obj, sticky)
    def sticky_get(self):
        return bool(elm_win_sticky_get(self.obj))

    property conformant:
        """Whether this window is an illume conformant window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_conformant_get(self.obj))
        def __set__(self, conformant):
            elm_win_conformant_set(self.obj, conformant)

    def conformant_set(self, conformant):
        elm_win_conformant_set(self.obj, conformant)
    def conformant_get(self):
        return bool(elm_win_conformant_get(self.obj))

    property quickpanel:
        """Whether this window is an illume quickpanel window.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_quickpanel_get(self.obj))
        def __set__(self, quickpanel):
            elm_win_quickpanel_set(self.obj, quickpanel)

    def quickpanel_set(self, quickpanel):
        elm_win_quickpanel_set(self.obj, quickpanel)
    def quickpanel_get(self):
        return bool(elm_win_quickpanel_get(self.obj))

    property quickpanel_priority_major:
        """The major priority of a quickpanel window.

        :type: int

        """
        def __get__(self):
            return elm_win_quickpanel_priority_major_get(self.obj)
        def __set__(self, priority):
            elm_win_quickpanel_priority_major_set(self.obj, priority)

    def quickpanel_priority_major_set(self, priority):
        elm_win_quickpanel_priority_major_set(self.obj, priority)
    def quickpanel_priority_major_get(self):
        return elm_win_quickpanel_priority_major_get(self.obj)

    property quickpanel_priority_minor:
        """The minor priority of a quickpanel window.

        :type: int

        """
        def __get__(self):
            return elm_win_quickpanel_priority_minor_get(self.obj)
        def __set__(self, priority):
            elm_win_quickpanel_priority_minor_set(self.obj, priority)

    def quickpanel_priority_minor_set(self, priority):
        elm_win_quickpanel_priority_minor_set(self.obj, priority)
    def quickpanel_priority_minor_get(self):
        return elm_win_quickpanel_priority_minor_get(self.obj)

    property quickpanel_zone:
        """Which zone this quickpanel should appear in.

        :type: int

        """
        def __get__(self):
            return elm_win_quickpanel_zone_get(self.obj)
        def __set__(self, zone):
            elm_win_quickpanel_zone_set(self.obj, zone)

    def quickpanel_zone_set(self, zone):
        elm_win_quickpanel_zone_set(self.obj, zone)
    def quickpanel_zone_get(self):
        return elm_win_quickpanel_zone_get(self.obj)

    property focus_skip:
        """Set the window to be skipped by keyboard focus

        This sets the window to be skipped by normal keyboard input. This
        means a window manager will be asked to not focus this window as
        well as omit it from things like the taskbar, pager, "alt-tab" list
        etc. etc.

        Set this and enable it on a window BEFORE you show it for the first
        time, otherwise it may have no effect.

        Use this for windows that have only output information or might only
        be interacted with by the mouse or fingers, and never for typing
        input. Be careful that this may have side-effects like making the
        window non-accessible in some cases unless the window is specially
        handled. Use this with care.

        :type: bool

        """
        def __set__(self, skip):
            elm_win_prop_focus_skip_set(self.obj, skip)

    def prop_focus_skip_set(self, skip):
        elm_win_prop_focus_skip_set(self.obj, skip)

    def illume_command_send(self, command, *args, **kwargs):
        """Send a command to the windowing environment

        This is intended to work in touchscreen or small screen device
        environments where there is a more simplistic window management
        policy in place. This uses the window object indicated to select
        which part of the environment to control (the part that this window
        lives in), and provides a command and an optional parameter
        structure (use None for this if not needed).

        :param command: The command to send
        :type command: :ref:`Elm_Illume_Command`
        :param params: Optional parameters for the command

        """
        params = (args, kwargs)
        elm_win_illume_command_send(self.obj, command, params)

    property inlined_image_object:
        """Get the inlined image object handle

        When you create a window of type ELM_WIN_INLINED_IMAGE, then the
        window is in fact an evas image object inlined in the parent canvas.
        You can get this object (be careful to not manipulate it as it is
        under control of elementary), and use it to do things like get pixel
        data, save the image to a file, etc.

        :type: :py:class:`efl.evas.Image`

        """
        def __get__(self):
            return object_from_instance(elm_win_inlined_image_object_get(self.obj))

    def inlined_image_object_get(self):
        return object_from_instance(elm_win_inlined_image_object_get(self.obj))

    property focus:
        """Determine whether a window has focus

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_focus_get(self.obj))

    def focus_get(self):
        return bool(elm_win_focus_get(self.obj))

    property screen_constrain:
        """Constrain the maximum width and height of a window to the width
        and height of its screen

        When ``constrain`` is true, the window will never resize larger than
        the screen.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_screen_constrain_get(self.obj))
        def __set__(self, constrain):
            elm_win_screen_constrain_set(self.obj, constrain)

    def screen_constrain_set(self, constrain):
        elm_win_screen_constrain_set(self.obj, constrain)
    def screen_constrain_get(self):
        return bool(elm_win_screen_constrain_get(self.obj))

    property screen_size:
        """Get screen geometry details for the screen that a window is on

        :type: (int X, int Y, int W, int H)

        """
        def __get__(self):
            cdef int x, y, w, h
            elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

    def screen_size_get(self):
        cdef int x, y, w, h
        elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    property screen_dpi:
        """Get screen DPI for the screen that a window is on

        :type: (int X_DPI, int Y_DPI)

        .. versionadded:: 1.8

        """
        def __get__(self):
            cdef int xdpi, ydpi
            elm_win_screen_dpi_get(self.obj, &xdpi, &ydpi)
            return (xdpi, ydpi)

    def screen_dpi_get(self):
        cdef int xdpi, ydpi
        elm_win_screen_dpi_get(self.obj, &xdpi, &ydpi)
        return (xdpi, ydpi)

    property focus_highlight_enabled:
        """The enabled status of the focus highlight in a window

        This will enable or disable the focus highlight only for the given
        window, regardless of the global setting for it

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_focus_highlight_enabled_get(self.obj))
        def __set__(self, enabled):
            elm_win_focus_highlight_enabled_set(self.obj, enabled)

    def focus_highlight_enabled_set(self, enabled):
        elm_win_focus_highlight_enabled_set(self.obj, enabled)
    def focus_highlight_enabled_get(self):
        return bool(elm_win_focus_highlight_enabled_get(self.obj))

    property focus_highlight_style:
        """The style for the focus highlight on this window

        The style to use for theming the highlight of focused objects on
        the given window. If ``style`` is None, the default will be used.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_win_focus_highlight_style_get(self.obj))
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_win_focus_highlight_style_set(self.obj,
                <const char *>style if style is not None else NULL)

    def focus_highlight_style_set(self, style):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_win_focus_highlight_style_set(self.obj,
            <const char *>style if style is not None else NULL)
    def focus_highlight_style_get(self):
        return _ctouni(elm_win_focus_highlight_style_get(self.obj))

    property focus_highlight_animate:
        """

        The animate status for the focus highlight for this window.

        This will enable or disable the animation of focus highlight only
        for the given window, regardless of the global setting for it

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint enabled):
            elm_win_focus_highlight_animate_set(self.obj, enabled)
        def __get__(self):
            return bool(elm_win_focus_highlight_animate_get(self.obj))

    property keyboard_mode:
        """The keyboard mode of the window.

        :type: :ref:`Elm_Win_Keyboard_Mode`

        """
        def __get__(self):
            return elm_win_keyboard_mode_get(self.obj)
        def __set__(self, mode):
            elm_win_keyboard_mode_set(self.obj, mode)

    def keyboard_mode_set(self, mode):
        elm_win_keyboard_mode_set(self.obj, mode)
    def keyboard_mode_get(self):
        return elm_win_keyboard_mode_get(self.obj)

    property keyboard_win:
        """Whether the window is a keyboard.

        :type: bool

        """
        def __get__(self):
            return bool(elm_win_keyboard_win_get(self.obj))
        def __set__(self, is_keyboard):
            elm_win_keyboard_win_set(self.obj, is_keyboard)

    def keyboard_win_set(self, is_keyboard):
        elm_win_keyboard_win_set(self.obj, is_keyboard)
    def keyboard_win_get(self):
        return bool(elm_win_keyboard_win_get(self.obj))

    property indicator_mode:
        """The indicator mode of the window.

        :type: :ref:`Elm_Win_Indicator_Mode`

        """
        def __get__(self):
            return elm_win_indicator_mode_get(self.obj)
        def __set__(self, mode):
            elm_win_indicator_mode_set(self.obj, mode)

    def indicator_mode_set(self, mode):
        elm_win_indicator_mode_set(self.obj, mode)
    def indicator_mode_get(self):
        return elm_win_indicator_mode_get(self.obj)

    property indicator_opacity:
        """The indicator opacity mode of the window.

        :type: :ref:`Elm_Win_Indicator_Opacity_Mode`

        """
        def __get__(self):
            return elm_win_indicator_opacity_get(self.obj)
        def __set__(self, mode):
            elm_win_indicator_opacity_set(self.obj, mode)

    def indicator_opacity_set(self, mode):
        elm_win_indicator_opacity_set(self.obj, mode)
    def indicator_opacity_get(self):
        return elm_win_indicator_opacity_get(self.obj)

    property screen_position:
        """Get the screen position of a window.

        :type: (int X, int Y)

        """
        def __get__(self):
            cdef int x, y
            elm_win_screen_position_get(self.obj, &x, &y)
            return (x, y)

    def screen_position_get(self):
        cdef int x, y
        elm_win_screen_position_get(self.obj, &x, &y)
        return (x, y)

    def socket_listen(self, svcname, int svcnum, bint svcsys):
        """Create a socket to provide the service for Plug widget

        :param svcname: The name of the service to be advertised. ensure
            that it is unique.
        :type svcname: string
        :param svcnum: A number (any value, 0 being the common default) to
            differentiate multiple instances of services with the same name.
        :type svcnum: int
        :param svcsys: A boolean that if true, specifies to create a
            system-wide service all users can connect to, otherwise the
            service is private to the user id that created the service.
        :type svcsys: bool

        :raise RuntimeError: if the socket could not be created.

        .. versionchanged:: 1.8
            Raises RuntimeError if creating a socket fails

        """
        if isinstance(svcname, unicode): svcname = PyUnicode_AsUTF8String(svcname)
        if not elm_win_socket_listen(self.obj, <const char *>svcname, svcnum, svcsys):
            raise RuntimeError("Could not create a socket.")

    property wm_rotation_supported:
        """Whether window manager supports window rotation or not.

        The window manager rotation allows the WM to controls the rotation of
        application windows. It is designed to support synchronized rotation
        for the multiple application windows at same time.

        :type: bool

        .. versionadded:: 1.9

        """
        def __get__(self):
            return bool(elm_win_wm_rotation_supported_get(self.obj))

    def wm_rotation_supported_get(self):
        return bool(elm_win_wm_rotation_supported_get(self.obj))

    property wm_rotation_preferred_rotation:
        """The preferred rotation value.

        This is used to set the orientation of the window to a specific fixed
        angle in degrees, 0-360 counter-clockwise.

        :type: int

        .. versionadded:: 1.9

        """
        def __get__(self):
            return elm_win_wm_rotation_preferred_rotation_get(self.obj)
        def __set__(self, int rotation):
            elm_win_wm_rotation_preferred_rotation_set(self.obj, rotation)

    def wm_rotation_preferred_rotation_get(self):
        return elm_win_wm_rotation_preferred_rotation_get(self.obj)
    def wm_rotation_preferred_rotation_set(self, int rotation):
        elm_win_wm_rotation_preferred_rotation_set(self.obj, rotation)

    property wm_rotation_available_rotations:
        """List of available window rotations.

        :type: list of int

        .. versionadded:: 1.9

        """
        def __get__(self):
            cdef:
                int *rots
                unsigned int count

            elm_win_wm_rotation_available_rotations_get(self.obj, &rots, &count)
            return array_of_ints_to_python_list(rots, count)

        def __set__(self, rotations):
            cdef:
                int *rots = python_list_ints_to_array_of_ints(rotations)
                unsigned int count = len(rotations)

            elm_win_wm_rotation_available_rotations_set(self.obj, rots, count)
            free(rots)

    def wm_rotation_available_rotations_get(self):
        return self.wm_rotation_available_rotations
    def wm_rotation_available_rotations_set(self, list rotations):
        self.wm_rotation_available_rotations = rotations

    property wm_rotation_manual_done:
        """The manual rotation done mode.

        This is used to set the manual rotation done mode.
        The message of rotation done is sent to WM after rendering its canvas
        but, if this property is set to `True`, the user should call the
        :py:func:`wm_rotation_manual_rotation_done` explicitly to sends
        the message.

        :type: bool

        .. versionadded:: 1.9

        """
        def __get__(self):
            return bool(elm_win_wm_rotation_manual_rotation_done_get(self.obj))
        def __set__(self, bint manual):
            elm_win_wm_rotation_manual_rotation_done_set(self.obj, manual)

    def wm_rotation_manual_done_get(self):
        return bool(elm_win_wm_rotation_manual_rotation_done_get(self.obj))
    def wm_rotation_manual_done_set(self, bint manual):
        elm_win_wm_rotation_manual_rotation_done_set(self.obj, manual)

    def wm_rotation_manual_rotation_done(self):
        """This function is used to notify the rotation done to WM manually.

        .. versionadded:: 1.9

        """
        elm_win_wm_rotation_manual_rotation_done(self.obj)

    property xwindow_xid:
        """Returns the X Window id.

        X Window id is a value of type long int which can be used in
        combination with some functions/objects in the ecore_x module.

        For example you can hide the mouse cursor with::

            import ecore_x
            xid = your_elm_win.xwindow_xid
            xwin = ecore_x.Window_from_xid(xid)
            xwin.cursor_hide()

        .. warning:: This is not portable at all. Works only under the X
                     window system. And you must build python-efl with ecore_x
                     enabled.

        :type: long

        """
        def __get__(self):
            return elm_win_xwindow_get(self.obj)

    def xwindow_xid_get(self):
        return elm_win_xwindow_get(self.obj)

    property floating_mode:
        """Floating mode of a window.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, floating):
            elm_win_floating_mode_set(self.obj, floating)

        def __get__(self):
            return bool(elm_win_floating_mode_get(self.obj))

    def floating_mode_set(self, floating):
        elm_win_floating_mode_set(self.obj, floating)
    def floating_mode_get(self):
        return bool(elm_win_floating_mode_get(self.obj))

    property noblank:
        """The noblank property of a window.

        The "noblank" property is a way to request the display on which the
        window is shown does not blank, screensaver or otherwise hide or
        obscure the window. It is intended for uses such as media playback on a
        television where a user may not want to be interrupted by an idle
        screen. The noblank property may have no effect if the window is
        iconified/minimized or hidden.

        :type: bool

        .. versionadded:: 1.18

        """
        def __get__(self):
            return bool(elm_win_noblank_get(self.obj))
        def __set__(self, bint noblank):
            elm_win_noblank_set(self.obj, noblank)

    def noblank_set(self, bint noblank):
        elm_win_noblank_set(self.obj, noblank)
    def noblank_get(self):
        return bool(elm_win_noblank_get(self.obj))

    def callback_delete_request_add(self, func, *args, **kwargs):
        """The user requested to close the window. See :py:attr:`autodel`."""
        self._callback_add("delete,request", func, args, kwargs)

    def callback_delete_request_del(self, func):
        self._callback_del("delete,request", func)

    def callback_focus_in_add(self, func, *args, **kwargs):
        """window got focus"""
        self._callback_add("focus,in", func, args, kwargs)

    def callback_focus_in_del(self, func):
        self._callback_del("focus,in", func)

    def callback_focus_out_add(self, func, *args, **kwargs):
        """window lost focus"""
        self._callback_add("focus,out", func, args, kwargs)

    def callback_focus_out_del(self, func):
        self._callback_del("focus,out", func)

    def callback_moved_add(self, func, *args, **kwargs):
        """window that holds the canvas was moved"""
        self._callback_add("moved", func, args, kwargs)

    def callback_moved_del(self, func):
        self._callback_del("moved", func)

    def callback_withdrawn_add(self, func, *args, **kwargs):
        """window is still managed normally but removed from view"""
        self._callback_add("withdrawn", func, args, kwargs)

    def callback_withdrawn_del(self, func):
        self._callback_del("withdrawn", func)

    def callback_iconified_add(self, func, *args, **kwargs):
        """window is minimized (perhaps into an icon or taskbar)"""
        self._callback_add("iconified", func, args, kwargs)

    def callback_iconified_del(self, func):
        self._callback_del("iconified", func)

    def callback_normal_add(self, func, *args, **kwargs):
        """window is in a normal state (not withdrawn or iconified)"""
        self._callback_add("normal", func, args, kwargs)

    def callback_normal_del(self, func):
        self._callback_del("normal", func)

    def callback_stick_add(self, func, *args, **kwargs):
        """window has become sticky (shows on all desktops)"""
        self._callback_add("stick", func, args, kwargs)

    def callback_stick_del(self, func):
        self._callback_del("stick", func)

    def callback_unstick_add(self, func, *args, **kwargs):
        """window has stopped being sticky"""
        self._callback_add("unstick", func, args, kwargs)

    def callback_unstick_del(self, func):
        self._callback_del("unstick", func)

    def callback_fullscreen_add(self, func, *args, **kwargs):
        """window has become fullscreen"""
        self._callback_add("fullscreen", func, args, kwargs)

    def callback_fullscreen_del(self, func):
        self._callback_del("fullscreen", func)

    def callback_unfullscreen_add(self, func, *args, **kwargs):
        """window has stopped being fullscreen"""
        self._callback_add("unfullscreen", func, args, kwargs)

    def callback_unfullscreen_del(self, func):
        self._callback_del("unfullscreen", func)

    def callback_maximized_add(self, func, *args, **kwargs):
        """window has been maximized"""
        self._callback_add("maximized", func, args, kwargs)

    def callback_maximized_del(self, func):
        self._callback_del("maximized", func)

    def callback_unmaximized_add(self, func, *args, **kwargs):
        """window has stopped being maximized"""
        self._callback_add("unmaximized", func, args, kwargs)

    def callback_unmaximized_del(self, func):
        self._callback_del("unmaximized", func)

    def callback_ioerr_add(self, func, *args, **kwargs):
        """there has been a low-level I/O error with the display system"""
        self._callback_add("ioerr", func, args, kwargs)

    def callback_ioerr_del(self, func):
        self._callback_del("ioerr", func)

    def callback_indicator_prop_changed_add(self, func, *args, **kwargs):
        """an indicator's property has been changed"""
        self._callback_add("indicator,prop,changed", func, args, kwargs)

    def callback_indicator_prop_changed_del(self, func):
        self._callback_del("indicator,prop,changed", func)

    def callback_rotation_changed_add(self, func, *args, **kwargs):
        """window rotation has been changed"""
        self._callback_add("rotation,changed", func, args, kwargs)

    def callback_rotation_changed_del(self, func):
        self._callback_del("rotation,changed", func)

    def callback_profile_changed_add(self, func, *args, **kwargs):
        """profile of the window has been changed"""
        self._callback_add("profile,changed", func, args, kwargs)

    def callback_profile_changed_del(self, func):
        self._callback_del("profile,changed", func)

    def callback_theme_changed_add(self, func, *args, **kwargs):
        """When the theme was changed.

        .. versionadded:: 1.13
        """
        self._callback_add("theme,changed", func, args, kwargs)

    def callback_theme_changed_del(self, func):
        self._callback_del("theme,changed", func)

_object_mapping_register("Efl_Ui_Win", Window)


cdef class StandardWindow(Window):
    """
    A :py:class:`Window` with standard setup.

    This creates a window like :py:class:`Window` but also puts in a standard
    :py:class:`Background <efl.elementary.background.Background>`, as well as
    setting the window title to ``title``. The window type created is of type
    ELM_WIN_BASIC, with ``None`` as the parent widget.

    """

    def __init__(self, name, title, *args, **kwargs):
        """StandardWindow(..)

        :param name: A name for the new window.
        :type name: string
        :param title: A title for the new window.
        :type title: string

        """
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
        self._set_obj(elm_win_util_standard_add(
            <const char *>name if name is not None else NULL,
            <const char *>title if title is not None else NULL))
        self._set_properties_from_keyword_args(kwargs)


cdef class DialogWindow(Window):
    """
    A :py:class:`Window` with standard dialog setup.

    This creates a window like :py:class:`Window` but also puts in a standard
    :py:class:`Background <efl.elementary.background.Background>`, as well as
    setting the window title to ``title``. The window type created is of type
    ELM_WIN_DIALOG_BASIC. This tipe of window will be handled in special
    mode by window managers with regards of it's parent window.

    .. versionadded:: 1.13

    """

    def __init__(self, evasObject parent not None, name, title, *args, **kwargs):
        """DialogWindow(...)

        :param parent: The parent window (mandatory)
        :type parent: :py:class:`efl.evas.Object`
        :param name: A name for the new window.
        :type name: string
        :param title: A title for the new window.
        :type title: string

        """
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        if isinstance(title, unicode): title = PyUnicode_AsUTF8String(title)
        self._set_obj(elm_win_util_dialog_add(parent.obj,
            <const char *>name if name is not None else NULL,
            <const char *>title if title is not None else NULL))
        self._set_properties_from_keyword_args(kwargs)
