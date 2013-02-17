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

.. rubric:: Window types

.. data:: ELM_WIN_BASIC

    A normal window.

    Indicates a normal, top-level window. Almost every window will be
    created with this type.

.. data:: ELM_WIN_DIALOG_BASIC

    Used for simple dialog windows

.. data:: ELM_WIN_DESKTOP

    For special desktop windows, like a background window holding desktop icons.

.. data:: ELM_WIN_DOCK

    The window is used as a dock or panel.

    Usually would be kept on top of any other window by the Window Manager.

.. data:: ELM_WIN_TOOLBAR

    The window is used to hold a floating toolbar, or similar.

.. data:: ELM_WIN_MENU

    Similar to ELM_WIN_TOOLBAR.

.. data:: ELM_WIN_UTILITY

    A persistent utility window, like a toolbox or palette.

.. data:: ELM_WIN_SPLASH

    Splash window for a starting up application.

.. data:: ELM_WIN_DROPDOWN_MENU

    The window is a dropdown menu, as when an entry in a menubar is clicked.

    Typically used with elm_win_override_set(). This hint exists for
    completion only, as the EFL way of implementing a menu would not
    normally use a separate window for its contents.

.. data:: ELM_WIN_POPUP_MENU

    Like ELM_WIN_DROPDOWN_MENU, but for the menu triggered by right-clicking
    an object.

.. data:: ELM_WIN_TOOLTIP

    The window is a tooltip.

    A short piece of explanatory text that typically appear after the mouse
    cursor hovers over an object for a while. Typically used with
    elm_win_override_set() and also not very commonly used in the EFL.

.. data:: ELM_WIN_NOTIFICATION

    A notification window, like a warning about battery life or a new E-Mail
    received.

.. data:: ELM_WIN_COMBO

    A window holding the contents of a combo box.

    Not usually used in the EFL.

.. data:: ELM_WIN_DND

    Used to indicate the window is a representation of an object being
    dragged across different windows, or even applications.

    Typically used with elm_win_override_set().

.. data:: ELM_WIN_INLINED_IMAGE

    The window is rendered onto an image buffer.

    No actual window is created for this type, instead the window and all of
    its contents will be rendered to an image buffer. This allows to have
    children window inside a parent one just like any other object would be,
    and do other things like applying Evas_Map effects to it. This is the
    only type of window that requires the parent parameter of elm_win_add()
    to be a valid Evas_Object.

.. data:: ELM_WIN_SOCKET_IMAGE

    The window is rendered onto an image buffer and can be shown other
    process's plug image object.

    No actual window is created for this type, instead the window and all of
    its contents will be rendered to an image buffer and can be shown other
    process's plug image object


.. rubric:: Indicator states

.. data:: ELM_WIN_INDICATOR_UNKNOWN

    Unknown indicator state.

.. data:: ELM_WIN_INDICATOR_HIDE

    Hides the indicator.

.. data:: ELM_WIN_INDICATOR_SHOW

    Shows the indicator.


.. rubric:: Indicator opacity

.. data:: ELM_WIN_INDICATOR_OPACITY_UNKNOWN

    Unknown indicator opacity mode.

.. data:: ELM_WIN_INDICATOR_OPAQUE

    Opacifies the indicator.

.. data:: ELM_WIN_INDICATOR_TRANSLUCENT

    Be translucent the indicator.

.. data:: ELM_WIN_INDICATOR_TRANSPARENT

    Transparentizes the indicator.


.. rubric:: Keyboard virtual keyboard modes

.. data:: ELM_WIN_KEYBOARD_UNKNOWN

    Unknown keyboard state.

.. data:: ELM_WIN_KEYBOARD_OFF

    Request to deactivate the keyboard.

.. data:: ELM_WIN_KEYBOARD_ON

    Enable keyboard with default layout.

.. data:: ELM_WIN_KEYBOARD_ALPHA

    Alpha (a-z) keyboard layout.

.. data:: ELM_WIN_KEYBOARD_NUMERIC

    Numeric keyboard layout.

.. data:: ELM_WIN_KEYBOARD_PIN

    PIN keyboard layout.

.. data:: ELM_WIN_KEYBOARD_PHONE_NUMBER

    Phone keyboard layout.

.. data:: ELM_WIN_KEYBOARD_HEX

    Hexadecimal numeric keyboard layout.

.. data:: ELM_WIN_KEYBOARD_TERMINAL

    Full (QWERTY) keyboard layout.

.. data:: ELM_WIN_KEYBOARD_PASSWORD

    Password keyboard layout.

.. data:: ELM_WIN_KEYBOARD_IP

    IP keyboard layout.

.. data:: ELM_WIN_KEYBOARD_HOST

    Host keyboard layout.

.. data:: ELM_WIN_KEYBOARD_FILE

    File keyboard layout.

.. data:: ELM_WIN_KEYBOARD_URL

    URL keyboard layout.

.. data:: ELM_WIN_KEYBOARD_KEYPAD

    Keypad layout.

.. data:: ELM_WIN_KEYBOARD_J2ME

    J2ME keyboard layout.

"""

include "widget_header.pxi"

from object cimport Object

from efl.evas cimport Evas
from efl.evas cimport evas_object_evas_get
#from efl.evas cimport Canvas_from_instance
from efl.evas cimport Image as evasImage

cimport enums

ELM_WIN_BASIC = enums.ELM_WIN_BASIC
ELM_WIN_DIALOG_BASIC = enums.ELM_WIN_DIALOG_BASIC
ELM_WIN_DESKTOP = enums.ELM_WIN_DESKTOP
ELM_WIN_DOCK = enums.ELM_WIN_DOCK
ELM_WIN_TOOLBAR = enums.ELM_WIN_TOOLBAR
ELM_WIN_MENU = enums.ELM_WIN_MENU
ELM_WIN_UTILITY = enums.ELM_WIN_UTILITY
ELM_WIN_SPLASH = enums.ELM_WIN_SPLASH
ELM_WIN_DROPDOWN_MENU = enums.ELM_WIN_DROPDOWN_MENU
ELM_WIN_POPUP_MENU = enums.ELM_WIN_POPUP_MENU
ELM_WIN_TOOLTIP = enums.ELM_WIN_TOOLTIP
ELM_WIN_NOTIFICATION = enums.ELM_WIN_NOTIFICATION
ELM_WIN_COMBO = enums.ELM_WIN_COMBO
ELM_WIN_DND = enums.ELM_WIN_DND
ELM_WIN_INLINED_IMAGE = enums.ELM_WIN_INLINED_IMAGE
ELM_WIN_SOCKET_IMAGE = enums.ELM_WIN_SOCKET_IMAGE

ELM_WIN_INDICATOR_UNKNOWN = enums.ELM_WIN_INDICATOR_UNKNOWN
ELM_WIN_INDICATOR_HIDE = enums.ELM_WIN_INDICATOR_HIDE
ELM_WIN_INDICATOR_SHOW = enums.ELM_WIN_INDICATOR_SHOW

ELM_WIN_INDICATOR_OPACITY_UNKNOWN = enums.ELM_WIN_INDICATOR_OPACITY_UNKNOWN
ELM_WIN_INDICATOR_OPAQUE = enums.ELM_WIN_INDICATOR_OPAQUE
ELM_WIN_INDICATOR_TRANSLUCENT = enums.ELM_WIN_INDICATOR_TRANSLUCENT
ELM_WIN_INDICATOR_TRANSPARENT = enums.ELM_WIN_INDICATOR_TRANSPARENT

ELM_WIN_KEYBOARD_UNKNOWN = enums.ELM_WIN_KEYBOARD_UNKNOWN
ELM_WIN_KEYBOARD_OFF = enums.ELM_WIN_KEYBOARD_OFF
ELM_WIN_KEYBOARD_ON = enums.ELM_WIN_KEYBOARD_ON
ELM_WIN_KEYBOARD_ALPHA = enums.ELM_WIN_KEYBOARD_ALPHA
ELM_WIN_KEYBOARD_NUMERIC = enums.ELM_WIN_KEYBOARD_NUMERIC
ELM_WIN_KEYBOARD_PIN = enums.ELM_WIN_KEYBOARD_PIN
ELM_WIN_KEYBOARD_PHONE_NUMBER = enums.ELM_WIN_KEYBOARD_PHONE_NUMBER
ELM_WIN_KEYBOARD_HEX = enums.ELM_WIN_KEYBOARD_HEX
ELM_WIN_KEYBOARD_TERMINAL = enums.ELM_WIN_KEYBOARD_TERMINAL
ELM_WIN_KEYBOARD_PASSWORD = enums.ELM_WIN_KEYBOARD_PASSWORD
ELM_WIN_KEYBOARD_IP = enums.ELM_WIN_KEYBOARD_IP
ELM_WIN_KEYBOARD_HOST = enums.ELM_WIN_KEYBOARD_HOST
ELM_WIN_KEYBOARD_FILE = enums.ELM_WIN_KEYBOARD_FILE
ELM_WIN_KEYBOARD_URL = enums.ELM_WIN_KEYBOARD_URL
ELM_WIN_KEYBOARD_KEYPAD = enums.ELM_WIN_KEYBOARD_KEYPAD
ELM_WIN_KEYBOARD_J2ME = enums.ELM_WIN_KEYBOARD_J2ME

cdef class Window(Object):

    """

    The window class of Elementary.

    Contains functions to manipulate windows. The Evas engine used to render
    the window contents is specified in the system or user elementary config
    files (whichever is found last), and can be overridden with the
    ELM_ENGINE environment variable for testing.  Engines that may be
    supported (depending on Evas and Ecore-Evas compilation setup and
    modules actually installed at runtime) are (listed in order of best
    supported and most likely to be complete and work to lowest quality).

    - "x11", "x", "software-x11", "software_x11" (Software rendering in
        X11)
    - "gl", "opengl", "opengl-x11", "opengl_x11" (OpenGL or OpenGL-ES2
        rendering in X11)
    - "shot:..." (Virtual screenshot renderer - renders to output file
        and exits)
    - "fb", "software-fb", "software_fb" (Linux framebuffer direct
        software rendering)
    - "sdl", "software-sdl", "software_sdl" (SDL software rendering to
        SDL buffer)
    - "gl-sdl", "gl_sdl", "opengl-sdl", "opengl_sdl" (OpenGL or
        OpenGL-ES2 rendering using SDL as the buffer)
    - "gdi", "software-gdi", "software_gdi" (Windows WIN32 rendering via
        GDI with software)
    - "dfb", "directfb" (Rendering to a DirectFB window)
    - "x11-8", "x8", "software-8-x11", "software_8_x11" (Rendering in
        grayscale using dedicated 8bit software engine in X11)
    - "x11-16", "x16", "software-16-x11", "software_16_x11" (Rendering in
        X11 using 16bit software engine)
    - "wince-gdi", "software-16-wince-gdi", "software_16_wince_gdi"
        (Windows CE rendering via GDI with 16bit software renderer)
    - "sdl-16", "software-16-sdl", "software_16_sdl" (Rendering to SDL
        buffer with 16bit software renderer)
    - "ews" (rendering to EWS - Ecore + Evas Single Process Windowing
        System)
    - "gl-cocoa", "gl_cocoa", "opengl-cocoa", "opengl_cocoa" (OpenGL
        rendering in Cocoa)
    - "psl1ght" (PS3 rendering using PSL1GHT)

    All engines use a simple string to select the engine to render, EXCEPT
    the "shot" engine. This actually encodes the output of the virtual
    screenshot and how long to delay in the engine string. The engine string
    is encoded in the following way::

        "shot:[delay=XX][:][repeat=DDD][:][file=XX]"

    Where options are separated by a ":" char if more than one option is
    given, with delay, if provided being the first option and file the last
    (order is important). The delay specifies how long to wait after the
    window is shown before doing the virtual "in memory" rendering and then
    save the output to the file specified by the file option (and then exit).
    If no delay is given, the default is 0.5 seconds. If no file is given the
    default output file is "out.png". Repeat option is for continuous
    capturing screenshots. Repeat range is from 1 to 999 and filename is
    fixed to "out001.png" Some examples of using the shot engine::

        ELM_ENGINE="shot:delay=1.0:repeat=5:file=elm_test.png" elementary_test
        ELM_ENGINE="shot:delay=1.0:file=elm_test.png" elementary_test
        ELM_ENGINE="shot:file=elm_test2.png" elementary_test
        ELM_ENGINE="shot:delay=2.0" elementary_test
        ELM_ENGINE="shot:" elementary_test

    Signals that you can add callbacks for are:

    - "delete,request": the user requested to close the window. See
        :py:attr:`autodel`.
    - "focus,in": window got focus
    - "focus,out": window lost focus
    - "moved": window that holds the canvas was moved
    - "withdrawn": window is still managed normally but removed from view
    - "iconified": window is minimized (perhaps into an icon or taskbar)
    - "normal": window is in a normal state (not withdrawn or iconified)
    - "stick": window has become sticky (shows on all desktops)
    - "unstick": window has stopped being sticky
    - "fullscreen": window has become fullscreen
    - "unfullscreen": window has stopped being fullscreen
    - "maximized": window has been maximized
    - "unmaximized": window has stopped being maximized

    :param name: A name for the new window.
    :type name: string
    :param type: A type for the new window:
    :type type: Elm_Win_Type

    """

    def __init__(self, name, type):
        self._set_obj(elm_win_add(NULL, _cfruni(name), type))

    def resize_object_add(self, evasObject subobj):
        """resize_object_add(evas.Object subobj)

        Add ``subobj`` as a resize object of the window.

        Setting an object as a resize object of the window means that the
        ``subobj`` child's size and position will be controlled by the window
        directly. That is, the object will be resized to match the window size
        and should never be moved or resized manually by the developer.

        In addition, resize objects of the window control what the minimum size
        of it will be, as well as whether it can or not be resized by the user.

        For the end user to be able to resize a window by dragging the handles
        or borders provided by the Window Manager, or using any other similar
        mechanism, all of the resize objects in the window should have their
        :py:attr:`size_hint_weight` set to EVAS_HINT_EXPAND.

        Also notice that the window can get resized to the current size of the
        object if the EVAS_HINT_EXPAND is set **after** the call to
        resize_object_add(). So if the object should get resized to the
        size of the window, set this hint **before** adding it as a resize object
        (this happens because the size of the window and the object are evaluated
        as soon as the object is added to the window).

        :param subobj: The resize object to add
        :type subobj: :py:class:`elementary.object.Object`

        """
        elm_win_resize_object_add(self.obj, subobj.obj)

    def resize_object_del(self, evasObject subobj):
        """resize_object_del(evas.Object subobj)

        Delete ``subobj`` as a resize object of the window.

        This function removes the object ``subobj`` from the resize objects of
        the window. It will not delete the object itself, which will be
        left unmanaged and should be deleted by the developer, manually handled
        or set as child of some other container.

        :param subobj: The resize object to add
        :type subobj: :py:class:`elementary.object.Object`

        """
        elm_win_resize_object_del(self.obj, subobj.obj)

    property title:
        """The title of the window.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_win_title_get(self.obj))
        def __set__(self, title):
            elm_win_title_set(self.obj, _cfruni(title))

    def title_set(self, title):
        elm_win_title_set(self.obj, _cfruni(title))
    def title_get(self):
        return _ctouni(elm_win_title_get(self.obj))

    property icon_name:
        """The icon name of the window.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_win_icon_name_get(self.obj))
        def __set__(self, icon_name):
            elm_win_icon_name_set(self.obj, _cfruni(icon_name))

    def icon_name_set(self, icon_name):
        elm_win_icon_name_set(self.obj, _cfruni(icon_name))
    def icon_name_get(self):
        return _ctouni(elm_win_icon_name_get(self.obj))

    property role:
        """The role of the window.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_win_role_get(self.obj))
        def __set__(self, role):
            elm_win_role_set(self.obj, _cfruni(role))

    def role_set(self, role):
        elm_win_role_set(self.obj, _cfruni(role))
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

        :type: :py:class:`elementary.image.Image`

        """
        def __get__(self):
            return object_from_instance(elm_win_icon_object_get(self.obj))
        def __set__(self, evasObject icon):
            elm_win_icon_object_set(self.obj, icon.obj)

    def icon_object_set(self, evasObject icon):
        elm_win_icon_object_set(self.obj, icon.obj)
    def icon_object_get(self):
        return object_from_instance(elm_win_icon_object_get(self.obj))

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

    def activate(self):
        """activate()

        Activate a window object.

        This function sends a request to the Window Manager to activate the
        window. If honored by the WM, the window will receive the keyboard
        focus.

        .. note:: This is just a request that a Window Manager may ignore, so
            calling this function does not ensure in any way that the window
            will be the active one after it.

        """
        elm_win_activate(self.obj)

    def lower(self):
        """lower()

        Lower a window object.

        Places the window at the bottom of the stack, so that no other
        window is covered by it.

        If :py:attr:`override` is not set, the Window Manager may ignore this
        request.

        """
        elm_win_lower(self.obj)

    def _raise(self):
        """_raise()

        Raise a window object.

        Places the window at the top of the stack, so that it's not covered
        by any other window.

        If :py:attr:`override` is not set, the Window Manager may ignore this
        request.

        """
        elm_win_raise(self.obj)

    def center(self, h, v):
        """center(bool h, bool v)

        Center a window on its screen

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

        .. seealso:: alpha

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
        instead fallback to using shaped windows, with :py::`shaped`.

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

        :type: tuple(int w, int h)

        .. seealso:: size_step

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

        :type: tuple(int w, int h)

        .. seealso:: size_base

        """
        def __set__(self, value):
            w, h = value
            elm_win_size_step_set(self.obj, w, h)

        def __get__(self):
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

    def layer_set(self, layer):
        elm_win_layer_set(self.obj, layer)
    def layer_get(self):
        return elm_win_layer_get(self.obj)

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
        """illume_command_send(command, *args, **kwargs)

        Send a command to the windowing environment

        This is intended to work in touchscreen or small screen device
        environments where there is a more simplistic window management
        policy in place. This uses the window object indicated to select
        which part of the environment to control (the part that this window
        lives in), and provides a command and an optional parameter
        structure (use None for this if not needed).

        :param command: The command to send
        :type command: Elm_Illume_Command
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

        :type: evasObject

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

        :type: tuple of ints

        """
        def __get__(self):
            cdef int x, y, w, h
            elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

    def screen_size_get(self):
        cdef int x, y, w, h
        elm_win_screen_size_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

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
            elm_win_focus_highlight_style_set(self.obj, _cfruni(style))

    def focus_highlight_style_set(self, style):
        elm_win_focus_highlight_style_set(self.obj, _cfruni(style))
    def focus_highlight_style_get(self):
        return _ctouni(elm_win_focus_highlight_style_get(self.obj))

    property keyboard_mode:
        """The keyboard mode of the window.

        :type: Elm_Win_Keyboard_Mode

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

        :type: Elm_Win_Indicator_Mode

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

        :type: Elm_Win_Indicator_Opacity_Mode

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

        :type: tuple of ints

        """
        def __get__(self):
            cdef int x, y
            elm_win_screen_position_get(self.obj, &x, &y)
            return (x, y)

    def screen_position_get(self):
        cdef int x, y
        elm_win_screen_position_get(self.obj, &x, &y)
        return (x, y)

    def socket_listen(self, svcname, svcnum, svcsys):
        """socket_listen(unicode svcname, int svcnum, bool svcsys)

        Create a socket to provide the service for Plug widget

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

        """
        return bool(elm_win_socket_listen(self.obj, _cfruni(svcname), svcnum, svcsys))

    property xwindow_xid:
        """Returns the X Window id.

        X Window id is a value of type long int which can be used in
        combination with some functions/objects in the ecore.x module.

        For example you can hide the mouse cursor with:
        import ecore.x
        xid = your_elm_win.xwindow_xid_get()
        xwin = ecore.x.Window_from_xid(xid)
        xwin.cursor_hide()

        .. note:: This is not portable at all. Works only under the X window
            system.

        :type: long

        """
        def __get__(self):
            cdef Ecore_X_Window xwin
            xwin = elm_win_xwindow_get(self.obj)
            return xwin

    def xwindow_xid_get(self):
        cdef Ecore_X_Window xwin
        xwin = elm_win_xwindow_get(self.obj)
        return xwin

    def callback_delete_request_add(self, func, *args, **kwargs):
        """The user requested to close the window. See :py:attr:`autodel`."""
        self._callback_add("delete,request", func, *args, **kwargs)

    def callback_delete_request_del(self, func):
        self._callback_del("delete,request", func)

    def callback_focus_in_add(self, func, *args, **kwargs):
        """window got focus"""
        self._callback_add("focus,in", func, *args, **kwargs)

    def callback_focus_in_del(self, func):
        self._callback_del("focus,in", func)

    def callback_focus_out_add(self, func, *args, **kwargs):
        """window lost focus"""
        self._callback_add("focus,out", func, *args, **kwargs)

    def callback_focus_out_del(self, func):
        self._callback_del("focus,out")

    def callback_moved_add(self, func, *args, **kwargs):
        """window that holds the canvas was moved"""
        self._callback_add("moved", func, *args, **kwargs)

    def callback_moved_del(self, func):
        self._callback_del("moved")

    def callback_withdrawn_add(self, func, *args, **kwargs):
        """window is still managed normally but removed from view"""
        self._callback_add("withdrawn", func, *args, **kwargs)

    def callback_withdrawn_del(self, func):
        self._callback_del("withdrawn")

    def callback_iconified_add(self, func, *args, **kwargs):
        """window is minimized (perhaps into an icon or taskbar)"""
        self._callback_add("iconified", func, *args, **kwargs)

    def callback_iconified_del(self, func):
        self._callback_del("iconified")

    def callback_normal_add(self, func, *args, **kwargs):
        """window is in a normal state (not withdrawn or iconified)"""
        self._callback_add("normal", func, *args, **kwargs)

    def callback_normal_del(self, func):
        self._callback_del("normal")

    def callback_stick_add(self, func, *args, **kwargs):
        """window has become sticky (shows on all desktops)"""
        self._callback_add("stick", func, *args, **kwargs)

    def callback_stick_del(self, func):
        self._callback_del("stick")

    def callback_unstick_add(self, func, *args, **kwargs):
        """window has stopped being sticky"""
        self._callback_add("unstick", func, *args, **kwargs)

    def callback_unstick_del(self, func):
        self._callback_del("unstick")

    def callback_fullscreen_add(self, func, *args, **kwargs):
        """window has become fullscreen"""
        self._callback_add("fullscreen", func, *args, **kwargs)

    def callback_fullscreen_del(self, func):
        self._callback_del("fullscreen")

    def callback_unfullscreen_add(self, func, *args, **kwargs):
        """window has stopped being fullscreen"""
        self._callback_add("unfullscreen", func, *args, **kwargs)

    def callback_unfullscreen_del(self, func):
        self._callback_del("unfullscreen")

    def callback_maximized_add(self, func, *args, **kwargs):
        """window has been maximized"""
        self._callback_add("maximized", func, *args, **kwargs)

    def callback_maximized_del(self, func):
        self._callback_del("maximized")

    def callback_unmaximized_add(self, func, *args, **kwargs):
        """window has stopped being maximized"""
        self._callback_add("unmaximized", func, *args, **kwargs)

    def callback_unmaximized_del(self, func):
        self._callback_del("unmaximized")

_object_mapping_register("elm_win", Window)


cdef class StandardWindow(Window):

    """A :py:class:`Window` with standard setup.

    :param name: A name for the new window.
    :type name: string
    :param title: A title for the new window.
    :type title: string

    """

    def __init__(self, name, title):
        self._set_obj(elm_win_util_standard_add(_cfruni(name), _cfruni(title)))


_object_mapping_register("elm_standardwin", StandardWindow)
