.. module:: efl.elementary

What is elementary?
*******************

Elementary is a  the high level toolkit based on the underlying efl
technologies (:doc:`Evas </evas/evas>`, :doc:`Edje </edje/edje>`,
:doc:`Ecore </ecore/ecore>`, etc...). It provide all the
widget you need to build a full application.

It is meant to make the programmers work almost brainless but give them lots
of flexibility.


Callbacks
*********

Widget callbacks
================

Widget callbacks are set with callback_*_add methods which take a callable,
and optional args, kwargs as data.

The callbacks have a signature of either::

    obj, *args, **kwargs

or::

    obj, event_info, *args, **kwargs


Event callbacks
===============

Event callbacks have signature of::

    object, source_object, event_type, event_info, *args, **kwargs


A sample Python Elementary program
**********************************

.. literalinclude:: ../../examples/elementary/test_win_dialog.py
    :language: python


API Reference
*************


Enumerations
============

.. _Elm_Object_Layer:

Object layers
-------------

.. versionadded:: 1.14

.. data:: ELM_OBJECT_LAYER_BACKGROUND

    where to place backgrounds

.. data:: ELM_OBJECT_LAYER_DEFAULT

    Evas_Object default layer (and thus for Elementary)

.. data:: ELM_OBJECT_LAYER_FOCUS

    where focus object visualization is

.. data:: ELM_OBJECT_LAYER_TOOLTIP

    where to show tooltips

.. data:: ELM_OBJECT_LAYER_CURSOR

    where to show cursors

.. data:: ELM_OBJECT_LAYER_LAST

    last layer known by Elementary


.. _Elm_Policy:

Policy types
------------

.. data:: ELM_POLICY_QUIT

    Under which circumstances the application should quit automatically.

.. data:: ELM_POLICY_EXIT

    Defines elm_exit() behaviour. (since 1.8)

.. data:: ELM_POLICY_THROTTLE

    Defines how throttling should work (since 1.8)


.. _Elm_Policy_Quit:

Quit policy types
-----------------

.. data:: ELM_POLICY_QUIT_NONE

    Never quit the application automatically

.. data:: ELM_POLICY_QUIT_LAST_WINDOW_CLOSED

    Quit when the application's last window is closed

.. data:: ELM_POLICY_QUIT_LAST_WINDOW_HIDDEN

    Quit when the application's last window is hidden

    .. versionadded:: 1.15


.. _Elm_Policy_Exit:

Exit policy types
-----------------

Possible values for the ELM_POLICY_EXIT policy.

.. data:: ELM_POLICY_EXIT_NONE

    Just quit the main loop on exit().

.. data:: ELM_POLICY_EXIT_WINDOWS_DEL

    Delete all the windows after quitting the main loop.


.. _Elm_Policy_Throttle:

Throttle policy types
---------------------

Possible values for the #ELM_POLICY_THROTTLE policy.

.. data:: ELM_POLICY_THROTTLE_CONFIG

    Do whatever elementary config is configured to do.

.. data:: ELM_POLICY_THROTTLE_HIDDEN_ALWAYS

    Always throttle when all windows are no longer visible.

.. data:: ELM_POLICY_THROTTLE_NEVER

    Never throttle when windows are all hidden, regardless of config settings.


.. _Elm_Object_Multi_Select_Mode:

Object multi select policy values
---------------------------------

Possible values for the #ELM_OBJECT_MULTI_SELECT_MODE policy.

.. versionadded:: 1.18

.. data:: ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT

    Default multiple select mode.

.. data:: ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL

    Disallow mutiple selection when clicked without control key pressed.


.. _Elm_Process_State:

Elm_Process_State
-----------------

.. data:: ELM_PROCESS_STATE_FOREGROUND

    The process is in a foreground/active/running state - work as normal.

    .. versionadded:: 1.12

.. data:: ELM_PROCESS_STATE_BACKGROUND

    The process is in the bacgkround, so you may want to stop animating,
    fetching data as often etc.

    .. versionadded:: 1.12


.. _Elm_Sys_Notify_Closed_Reason:

Notify close reasons
--------------------

The reason the notification was closed

.. data:: ELM_SYS_NOTIFY_CLOSED_EXPIRED

    The notification expired.

    .. versionadded:: 1.10

.. data:: ELM_SYS_NOTIFY_CLOSED_DISMISSED

    The notification was dismissed by the user.

    .. versionadded:: 1.10

.. data:: ELM_SYS_NOTIFY_CLOSED_REQUESTED

    The notification was closed by a call to CloseNotification method.

    .. versionadded:: 1.10

.. data:: ELM_SYS_NOTIFY_CLOSED_UNDEFINED

    Undefined/reserved reasons.

    .. versionadded:: 1.10


.. _Elm_Sys_Notify_Urgency:

Notify urgency levels
---------------------

Urgency levels of a notification

:see: :py:func:`sys_notify_send`

.. data:: ELM_SYS_NOTIFY_URGENCY_LOW

    Low

    .. versionadded:: 1.10

.. data:: ELM_SYS_NOTIFY_URGENCY_NORMAL

    Normal

    .. versionadded:: 1.10

.. data:: ELM_SYS_NOTIFY_URGENCY_CRITICAL

    Critical

    .. versionadded:: 1.10


.. _Elm_Glob_Match_Flags:

Glob matching
-------------

Glob matching bitfiled flags

.. data:: ELM_GLOB_MATCH_NO_ESCAPE

    Treat backslash as an ordinary character instead of escape.

    .. versionadded:: 1.11

.. data:: ELM_GLOB_MATCH_PATH

    Match a slash in string only with a slash in pattern and not by an
    asterisk (*) or a question mark (?) metacharacter, nor by a bracket
    expression ([]) containing a slash.

    .. versionadded:: 1.11

.. data:: ELM_GLOB_MATCH_PERIOD

    Leading period in string has to be matched exactly by a period in
    pattern. A period is considered to be leading if it is the first
    character in string, or if both ELM_GLOB_MATCH_PATH is set and the
    period immediately follows a slash.

    .. versionadded:: 1.11

.. data:: ELM_GLOB_MATCH_NOCASE

    The pattern is matched case-insensitively.

    .. versionadded:: 1.11


.. _General:

General
=======

General Elementary API. Functions that don't relate to
Elementary objects specifically.

Here are documented functions which init/shutdown the library,
that apply to generic Elementary objects, that deal with
configuration, et cetera.

.. autoclass:: EthumbConnect
.. autoclass:: ConfigAllChanged
.. autoclass:: PolicyChanged
.. autoclass:: ProcessBackground
.. autoclass:: ProcessForeground

.. autofunction:: on_ethumb_connect
.. autofunction:: on_config_all_changed
.. autofunction:: on_policy_changed
.. autofunction:: on_process_background
.. autofunction:: on_process_foreground

.. autofunction:: init
.. autofunction:: shutdown
.. autofunction:: run
.. autofunction:: exit

.. autofunction:: policy_set
.. autofunction:: policy_get
.. autofunction:: language_set
.. autofunction:: process_state_get


.. _Fingers:

Fingers
=======

Elementary is designed to be finger-friendly for touchscreens,
and so in addition to scaling for display resolution, it can
also scale based on finger "resolution" (or size). You can then
customize the granularity of the areas meant to receive clicks
on touchscreens.

Different profiles may have pre-set values for finger sizes.

.. autofunction:: coords_finger_size_adjust


.. _Caches:

Caches
======

These are functions which let one fine-tune some cache values for
Elementary applications, thus allowing for performance adjustments.

.. autofunction:: cache_all_flush


.. _Fonts:

Fonts
=====

These are functions dealing with font rendering, selection and the
like for Elementary applications. One might fetch which system
fonts are there to use and set custom fonts for individual classes
of UI items containing text (text classes).

.. autofunction:: font_properties_get
.. autofunction:: font_properties_free

.. autofunction:: font_fontconfig_name_get

.. autoclass:: FontProperties


.. _Debug:

Debug
=====

Don't use them unless you are sure.

.. autofunction:: object_tree_dump
.. autofunction:: object_tree_dot_dump


.. _Sys_Notify:

Sys Notify
==========

.. autofunction:: sys_notify_close
.. autofunction:: sys_notify_send

.. autofunction:: on_sys_notify_notification_closed
.. autofunction:: on_sys_notify_action_invoked

.. autoclass:: SysNotifyNotificationClosed
.. autoclass:: SysNotifyActionInvoked


Widgets
=======

.. toctree:: *
   :glob:
   :maxdepth: 1



Inheritance diagram
===================

.. inheritance-diagram::
    efl.elementary.Actionslider
    efl.elementary.Background
    efl.elementary.Box
    efl.elementary.Bubble
    efl.elementary.Button
    efl.elementary.Calendar
    efl.elementary.Check
    efl.elementary.Clock
    efl.elementary.Colorselector
    efl.elementary.Combobox
    efl.elementary.Configuration
    efl.elementary.Conformant
    efl.elementary.Ctxpopup
    efl.elementary.Datetime
    efl.elementary.Dayselector
    efl.elementary.Diskselector
    efl.elementary.Entry
    efl.elementary.Fileselector
    efl.elementary.FileselectorButton
    efl.elementary.FileselectorEntry
    efl.elementary.Flip
    efl.elementary.FlipSelector
    efl.elementary.Frame
    efl.elementary.Gengrid
    efl.elementary.Genlist
    efl.elementary.GestureLayer
    efl.elementary.Grid
    efl.elementary.Hover
    efl.elementary.Hoversel
    efl.elementary.Icon
    efl.elementary.Image
    efl.elementary.Index
    efl.elementary.InnerWindow
    efl.elementary.Label
    efl.elementary.Layout
    efl.elementary.List
    efl.elementary.Map
    efl.elementary.Mapbuf
    efl.elementary.Menu
    efl.elementary.MultiButtonEntry
    efl.elementary.Naviframe
    efl.elementary.Notify
    efl.elementary.Object
    efl.elementary.ObjectItem
    efl.elementary.Panel
    efl.elementary.Panes
    efl.elementary.Photo
    efl.elementary.Photocam
    efl.elementary.Plug
    efl.elementary.Popup
    efl.elementary.Progressbar
    efl.elementary.Radio
    efl.elementary.Scroller
    efl.elementary.SegmentControl
    efl.elementary.Separator
    efl.elementary.Slider
    efl.elementary.Slideshow
    efl.elementary.Spinner
    efl.elementary.Systray
    efl.elementary.Table
    efl.elementary.Theme
    efl.elementary.Thumb
    efl.elementary.Toolbar
    efl.elementary.Transit
    efl.elementary.Video
    efl.elementary.Web
    efl.elementary.Window
    :parts: 1
