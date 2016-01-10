.. currentmodule:: efl.elementary

Window
######

Widget description
==================

The window class of Elementary.

Contains functions to manipulate windows. The Evas engine used to render
the window contents is specified in the system or user elementary config
files (whichever is found last), and can be overridden with the
ELM_ENGINE environment variable for testing.  Engines that may be
supported (depending on Evas and Ecore-Evas compilation setup and
modules actually installed at runtime) are (listed in order of best
supported and most likely to be complete and work to lowest quality).

Note that ELM_ENGINE is really only needed for special cases and debugging.
you should normally use ELM_DISPLAY and ELM_ACCEL environment variables, or
core elementary config. ELM_DISPLAY can be set to "x11" or "wl" to indicate
the target display system (as on Linux systems you may have both display
systems available, so this selects which to use). ELM_ACCEL may also be set
to indicate if you want accelerations and which kind to use. see
:py:attr:`~efl.elementary.configuration.Configuration.accel_preference` for
details on this environment variable values.

``x11``, ``x``, ``software-x11``, ``software_x11``
    Software rendering in X11
``gl``, ``opengl``, ``opengl-x11``, ``opengl_x11``
    OpenGL or OpenGL-ES2 rendering in X11
``shot:...``
    Virtual screenshot renderer - renders to output file and exits
``fb``, ``software-fb``, ``software_fb``
    Linux framebuffer direct software rendering
``sdl``, ``software-sdl``, ``software_sdl``
    SDL software rendering to SDL buffer
``gl-sdl``, ``gl_sdl``, ``opengl-sdl``, ``opengl_sdl``
    OpenGL or OpenGL-ES2 using SDL
``gdi``, ``software-gdi``, ``software_gdi``
    Windows WIN32 rendering via GDI with software
``ews``
    rendering to EWS (Ecore + Evas Single Process Windowing System)
``gl-cocoa``, ``gl_cocoa``, ``opengl-cocoa``, ``opengl_cocoa``
    OpenGL rendering in Cocoa
``wayland_shm``
    Wayland client SHM rendering
``wayland_egl``
    Wayland client OpenGL/EGL rendering
``drm``
    Linux drm/kms etc. direct display

All engines use a simple string to select the engine to render, EXCEPT
the "shot" engine. This actually encodes the output of the virtual
screenshot and how long to delay in the engine string. The engine string
is encoded in the following way::

    "shot:[delay=XX][:][repeat=DDD][:][file=XX]"

Where options are separated by a ``:`` char if more than one option is
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


Emitted signals
===============

- ``delete,request``: the user requested to close the window. See
  :py:attr:`~Window.autodel`.
- ``focus,in``: window got focus
- ``focus,out``: window lost focus
- ``moved``: window that holds the canvas was moved
- ``withdrawn``: window is still managed normally but removed from view
- ``iconified``: window is minimized (perhaps into an icon or taskbar)
- ``normal``: window is in a normal state (not withdrawn or iconified)
- ``stick``: window has become sticky (shows on all desktops)
- ``unstick``: window has stopped being sticky
- ``fullscreen``: window has become fullscreen
- ``unfullscreen``: window has stopped being fullscreen
- ``maximized``: window has been maximized
- ``unmaximized``: window has stopped being maximized
- ``ioerr``: there has been a low-level I/O error with the display system
- ``indicator,prop,changed``: an indicator's property has been changed
- ``rotation,changed``: window rotation has been changed
- ``profile,changed``: profile of the window has been changed
- ``theme,changed`` - The theme was changed. (since 1.13)


Enumerations
============

.. _Elm_Win_Type:

Window types
------------

.. data:: ELM_WIN_UNKNOWN

    Unknown window type (since 1.9)

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

    Typically used with :py:attr:`~Window.override`. This hint exists for
    completion only, as the EFL way of implementing a menu would not
    normally use a separate window for its contents.

.. data:: ELM_WIN_POPUP_MENU

    Like ELM_WIN_DROPDOWN_MENU, but for the menu triggered by right-clicking
    an object.

.. data:: ELM_WIN_TOOLTIP

    The window is a tooltip.

    A short piece of explanatory text that typically appear after the mouse
    cursor hovers over an object for a while. Typically used with
    :py:attr:`~Window.override` and also not very commonly used in the EFL.

.. data:: ELM_WIN_NOTIFICATION

    A notification window, like a warning about battery life or a new E-Mail
    received.

.. data:: ELM_WIN_COMBO

    A window holding the contents of a combo box.

    Not usually used in the EFL.

.. data:: ELM_WIN_DND

    Used to indicate the window is a representation of an object being
    dragged across different windows, or even applications.

    Typically used with :py:attr:`~Window.override`.

.. data:: ELM_WIN_INLINED_IMAGE

    The window is rendered onto an image buffer.

    No actual window is created for this type, instead the window and all of
    its contents will be rendered to an image buffer. This allows to have
    children window inside a parent one just like any other object would be,
    and do other things like applying Evas_Map effects to it. This is the
    only type of window that requires the ``parent`` parameter
    to be a valid :py:class:`efl.evas.Object`.

.. data:: ELM_WIN_SOCKET_IMAGE

    The window is rendered onto an image buffer and can be shown other
    process's plug image object.

    No actual window is created for this type, instead the window and all of
    its contents will be rendered to an image buffer and can be shown other
    process's plug image object


.. _Elm_Win_Indicator_Mode:

Indicator states
----------------

.. data:: ELM_WIN_INDICATOR_UNKNOWN

    Unknown indicator state.

.. data:: ELM_WIN_INDICATOR_HIDE

    Hides the indicator.

.. data:: ELM_WIN_INDICATOR_SHOW

    Shows the indicator.


.. _Elm_Win_Indicator_Opacity_Mode:

Indicator opacity
-----------------

.. data:: ELM_WIN_INDICATOR_OPACITY_UNKNOWN

    Unknown indicator opacity mode.

.. data:: ELM_WIN_INDICATOR_OPAQUE

    Opacifies the indicator.

.. data:: ELM_WIN_INDICATOR_TRANSLUCENT

    Be translucent the indicator.

.. data:: ELM_WIN_INDICATOR_TRANSPARENT

    Transparentizes the indicator.


.. _Elm_Win_Keyboard_Mode:

Keyboard virtual keyboard modes
-------------------------------

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


.. _Elm_Illume_Command:

Illume commands
---------------

Available commands that can be sent to the Illume manager.

When running under an Illume session, a window may send commands to the
Illume manager to perform different actions.

.. data:: ELM_ILLUME_COMMAND_FOCUS_BACK

    Reverts focus to the previous window

.. data:: ELM_ILLUME_COMMAND_FOCUS_FORWARD

    Sends focus to the next window in the list

.. data:: ELM_ILLUME_COMMAND_FOCUS_HOME

    Hides all windows to show the Home screen

.. data:: ELM_ILLUME_COMMAND_CLOSE

    Closes the currently active window


Inheritance diagram
===================

.. inheritance-diagram::
    Window
    StandardWindow
    DialogWindow
    :parts: 2


.. autoclass:: Window
.. autoclass:: StandardWindow
.. autoclass:: DialogWindow
