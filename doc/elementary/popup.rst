.. currentmodule:: efl.elementary

Popup
#####

.. image:: /images/popup-preview.png


Widget description
==================

This widget is an enhancement of :py:class:`~efl.elementary.notify.Notify`.
In addition to Content area, there are two optional sections namely Title
area and Action area.

Popup Widget displays its content with a particular orientation in the
parent area. This orientation can be one among top, center, bottom,
left, top-left, top-right, bottom-left and bottom-right. Content part of
Popup can be an Evas Object set by application or it can be Text set by
application or set of items containing an icon and/or text. The
content/item-list can be removed using elm_object_content_set with second
parameter passed as None.

Following figures shows the textual layouts of popup in which Title Area
and Action area area are optional ones. Action area can have up to 3
buttons handled using elm_object common APIs mentioned below. If user
wants to have more than 3 buttons then these buttons can be put inside
the items of a list as content. User needs to handle the clicked signal
of these action buttons if required. No event is processed by the widget
automatically when clicked on these action buttons.

Figure::

    |---------------------|    |---------------------|    |---------------------|
    |     Title Area      |    |     Title Area      |    |     Title Area      |
    |Icon|    Text        |    |Icon|    Text        |    |Icon|    Text        |
    |---------------------|    |---------------------|    |---------------------|
    |       Item 1        |    |                     |    |                     |
    |---------------------|    |                     |    |                     |
    |       Item 2        |    |                     |    |    Description      |
    |---------------------|    |       Content       |    |                     |
    |       Item 3        |    |                     |    |                     |
    |---------------------|    |                     |    |                     |
    |         .           |    |---------------------|    |---------------------|
    |         .           |    |     Action Area     |    |     Action Area     |
    |         .           |    | Btn1  |Btn2|. |Btn3 |    | Btn1  |Btn2|  |Btn3 |
    |---------------------|    |---------------------|    |---------------------|
    |       Item N        |     Content Based Layout     Description based Layout
    |---------------------|
    |     Action Area     |
    | Btn1  |Btn2|. |Btn3 |
    |---------------------|
       Item Based Layout

Timeout can be set on expiry of which popup instance hides and sends a
smart signal "timeout" to the user. The visible region of popup is
surrounded by a translucent region called Blocked Event area. By
clicking on Blocked Event area, the signal "block,clicked" is sent to
the application. This block event area can be avoided by using API
elm_popup_allow_events_set. When gets hidden, popup does not get
destroyed automatically, application should destroy the popup instance
after use. To control the maximum height of the internal scroller for
item, we use the height of the action area which is passed by theme
based on the number of buttons currently set to popup.


Emitted signals
===============

- ``timeout`` - when ever popup is closed as a result of timeout.
- ``block,clicked`` - when ever user taps on Blocked Event area.
- ``item,focused`` - the popup item has received focus. (since 1.10)
- ``item,unfocused`` - the popup item has lost focus. (since 1.10)
- ``dismissed`` - the popup has been dismissed. (since 1.17)


Layout content parts
====================

- ``default`` - The content of the popup
- ``title,icon`` - Title area's icon
- ``button1`` - 1st button of the action area
- ``button2`` - 2nd button of the action area
- ``button3`` - 3rd button of the action area
- ``default`` - Item's icon


Layout text parts
=================

- ``title,text`` - This operates on Title area's label
- ``default`` - content-text set in the content area of the widget
- ``default`` - Item's label


Enumerations
============

.. _Elm_Popup_Orient:

Popup orientation types
-----------------------

.. data:: ELM_POPUP_ORIENT_TOP

    Popup should appear in the top of parent, default

.. data:: ELM_POPUP_ORIENT_CENTER

    Popup should appear in the center of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM

    Popup should appear in the bottom of parent

.. data:: ELM_POPUP_ORIENT_LEFT

    Popup should appear in the left of parent

.. data:: ELM_POPUP_ORIENT_RIGHT

    Popup should appear in the right of parent

.. data:: ELM_POPUP_ORIENT_TOP_LEFT

    Popup should appear in the top left of parent

.. data:: ELM_POPUP_ORIENT_TOP_RIGHT

    Popup should appear in the top right of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM_LEFT

    Popup should appear in the bottom left of parent

.. data:: ELM_POPUP_ORIENT_BOTTOM_RIGHT

    Popup should appear in the bottom right of parent


Inheritance diagram
===================

.. inheritance-diagram::
    Popup
    PopupItem
    :parts: 2


.. autoclass:: Popup
.. autoclass:: PopupItem
