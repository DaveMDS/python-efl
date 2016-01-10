.. currentmodule:: efl.elementary

Object
######

Copy and Paste
==============

Implements the following functionality

a. select, copy/cut and paste
b. clipboard
c. drag and drop

in order to share data across application windows.

Contains functions to select text or a portion of data,
send it to a buffer, and paste the data into a target.

elm_cnp provides a generic copy and paste facility based on its windowing
system.
It is not necessary to know the details of each windowing system,
but some terms and behavior are common.
Currently the X11 window system is widely used, and only X11 functionality is
implemented.

In X11R6 window system, CopyPaste works like a peer-to-peer communication.
Copying is an operation on an object in an X server.
X11 calls those objects 'selections' which have names.
Generally, two selection types are needed for copy and paste:
The Primary selection and the Clipboard selection.
Primary selection is for selecting text (that means highlighted text).
Clipboard selection is for explicit copying behavior
(such as ctrl+c, or 'copy' in a menu).
Thus, in applications most cases only use the clipboard selection.
As stated before, taking ownership of a selection doesn't move any actual data.
Copying and Pasting is described as follows:

1. Copy text in Program A : Program A takes ownership of the selection
2. Paste text in Program B : Program B notes that Program A owns the selection
3. Program B asks A for the text
4. Program A responds and sends the text to program B
5. Program B pastes the response

More information is on
 - http://www.jwz.org/doc/x-cut-and-paste.html
 - X11R6 Inter-Client Communication Conventions Manual, section 2


Emitted smart events
====================

- ``moved`` - When the object change position. (since 1.17)
- ``focus`` - When the object has received focus. (since 1.8)
- ``unfocus`` - When the object has lost focus. (since 1.8)
- ``language,changed`` - Whenever system locale changes.


Enumerations
============

.. _Elm_Object_Focus_Direction:

Focus direction
---------------

.. data:: ELM_FOCUS_PREVIOUS

    Focus previous

.. data:: ELM_FOCUS_NEXT

    Focus next

.. data:: ELM_FOCUS_UP

    Focus up

    .. versionadded:: 1.8.1

.. data:: ELM_FOCUS_DOWN

    Focus down

    .. versionadded:: 1.8.1

.. data:: ELM_FOCUS_RIGHT

    Focus right

    .. versionadded:: 1.8.1

.. data:: ELM_FOCUS_LEFT

    Focus left

    .. versionadded:: 1.8.1


.. _Elm_Focus_Move_Policy:

Focus move policy
-----------------

.. data:: ELM_FOCUS_MOVE_POLICY_CLICK

    Give focus to object when they are clicked

    .. versionadded:: 1.10

.. data:: ELM_FOCUS_MOVE_POLICY_IN

    Give focus to object on mouse-in

    .. versionadded:: 1.10

.. data:: ELM_FOCUS_MOVE_POLICY_KEY_ONLY

    Focus is set on key input like Left, Right, Up, Down, Tab, or Shift+Tab

    .. versionadded:: 1.15


.. _Elm_Focus_Autoscroll_Mode:

Focus autoscroll mode
---------------------

.. data:: ELM_FOCUS_AUTOSCROLL_MODE_SHOW

    Directly show the focused region or item automatically.

    .. versionadded:: 1.10

.. data:: ELM_FOCUS_AUTOSCROLL_MODE_NONE

    Do not show the focused region or item automatically.

    .. versionadded:: 1.10

.. data:: ELM_FOCUS_AUTOSCROLL_MODE_BRING_IN

    Bring_in the focused region or item automatically which might
    invole the scrolling

    .. versionadded:: 1.10


.. _Elm_Focus_Region_Show_Mode:

Focus region show mode
----------------------

.. data:: ELM_FOCUS_REGION_SHOW_WIDGET

    as a widget

    .. versionadded:: 1.16

.. data:: ELM_FOCUS_REGION_SHOW_ITEM

    as an item

    .. versionadded:: 1.16


.. _Elm_Input_Event_Type:

Input event types
-----------------

.. data:: EVAS_CALLBACK_KEY_DOWN
.. data:: EVAS_CALLBACK_KEY_UP
.. data:: EVAS_CALLBACK_MOUSE_WHEEL


.. _Elm_Object_Sel_Type:

Selection type
--------------

Defines the types of selection property names.

:see: http://www.x.org/docs/X11/xlib.pdf for more details.

.. data:: ELM_SEL_TYPE_PRIMARY

    Primary text selection (highlighted or selected text)

.. data:: ELM_SEL_TYPE_SECONDARY

    Used when primary selection is in use

.. data:: ELM_SEL_TYPE_XDND

    Drag 'n' Drop

.. data:: ELM_SEL_TYPE_CLIPBOARD

    Clipboard selection (ctrl+C)


.. _Elm_Object_Sel_Format:

Selection format
----------------

Defines the types of content.

.. data:: ELM_SEL_FORMAT_TARGETS

    For matching every possible atom

.. data:: ELM_SEL_FORMAT_NONE

    Content is from outside of Elementary

.. data:: ELM_SEL_FORMAT_TEXT

    Plain unformatted text: Used for things that don't want rich markup

.. data:: ELM_SEL_FORMAT_MARKUP

    Edje textblock markup, including inline images

.. data:: ELM_SEL_FORMAT_IMAGE

    Images

.. data:: ELM_SEL_FORMAT_VCARD

    Vcards

.. data:: ELM_SEL_FORMAT_HTML

    Raw HTML-like data (eg. webkit)


.. _Elm_Object_Xdnd_Action:

XDND action
-----------

Defines the kind of action associated with the drop data if for XDND

.. versionadded:: 1.8

.. data:: ELM_XDND_ACTION_UNKNOWN

    Action type is unknown

.. data:: ELM_XDND_ACTION_COPY

    Copy the data

.. data:: ELM_XDND_ACTION_MOVE

    Move the data

.. data:: ELM_XDND_ACTION_PRIVATE

    Private action type

.. data:: ELM_XDND_ACTION_ASK

    Ask the user what to do

.. data:: ELM_XDND_ACTION_LIST

    List the data

.. data:: ELM_XDND_ACTION_LINK

    Link the data

.. data:: ELM_XDND_ACTION_DESCRIPTION

    Describe the data


.. _Elm_Object_Select_Mode:

Selection modes
---------------

.. data:: ELM_OBJECT_SELECT_MODE_DEFAULT

    Items will only call their selection func and callback when
    first becoming selected. Any further clicks will do nothing,
    unless you set always select mode.

.. data:: ELM_OBJECT_SELECT_MODE_ALWAYS

    This means that, even if selected, every click will make the
    selected callbacks be called.

.. data:: ELM_OBJECT_SELECT_MODE_NONE

    This will turn off the ability to select items entirely and
    they will neither appear selected nor call selected callback
    functions.

.. data:: ELM_OBJECT_SELECT_MODE_DISPLAY_ONLY

    No select mode with no finger size rule


.. _Elm_Tooltip_Orient:

Tooltip orientation
-------------------

.. data:: ELM_TOOLTIP_ORIENT_NONE

    Default value, Tooltip moves with mouse pointer
    
    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_TOP_LEFT

    Tooltip should appear at the top left of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_TOP

    Tooltip should appear at the top of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_TOP_RIGHT

    Tooltip should appear at the top right of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_LEFT

    Tooltip should appear at the left of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_CENTER

    Tooltip should appear at the center of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_RIGHT

    Tooltip should appear at the right of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_BOTTOM_LEFT

    Tooltip should appear at the bottom left of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_BOTTOM

    Tooltip should appear at the bottom of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_BOTTOM_RIGHT

    Tooltip should appear at the bottom right of parent

    .. versionadded:: 1.16

.. data:: ELM_TOOLTIP_ORIENT_LAST

    Sentinel value, don't use

    .. versionadded:: 1.16



Inheritance diagram
===================

.. inheritance-diagram:: Object
    :parts: 2


.. autoclass:: Object
