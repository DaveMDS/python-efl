.. currentmodule:: efl.elementary

Naviframe
#########

.. image:: /images/naviframe-preview.png


Widget description
==================

Naviframe stands for navigation frame. It's a views manager
for applications.

A naviframe holds views (or pages) as its items. Those items are
organized in a stack, so that new items get pushed on top of the
old, and only the topmost view is displayed at one time. The
transition between views is animated, depending on the theme
applied to the widget.

Naviframe views hold spaces to various elements, which are:

- back button, used to navigate to previous views,
- next button, used to navigate to next views in the stack,
- title label,
- sub-title label,
- title icon and
- content area.


Layout content parts
====================

- ``default`` - The main content of the current page
- ``icon`` - An icon in the title area of the current page
- ``prev_btn`` - A button of the current page to go to the previous page
- ``next_btn`` - A button of the current page to go to the next page


Layout text parts
=================

- ``default`` - Title label in the title area of the current page
- ``subtitle`` - Sub-title label in the title area of the current page

Most of those content objects can be passed at the time of an item
creation (see :py:meth:`~NaviframeItem.push_to`).


Available styles
================

Naviframe items can have different styles, which affect the
transition between views, for example. On the default theme, two of
them are supported:

- ``basic``   - views are switched sliding horizontally, one after the other
- ``overlap`` - like the previous one, but the previous view stays at its place
  and is overlapped by the new


Emitted signals
===============

- ``transition,finished`` - When the transition is finished in changing the item
- ``title,transition,finished`` -  When the title area's transition is finished
- ``title,clicked`` - User clicked title area

All the parts, for content and text, described here will also be
reachable by naviframe **items** direct calls:

- :py:meth:`~efl.elementary.object_item.ObjectItem.delete`
- :py:meth:`~efl.elementary.object_item.ObjectItem.part_text_set`
- :py:meth:`~efl.elementary.object_item.ObjectItem.part_text_get`
- :py:meth:`~efl.elementary.object_item.ObjectItem.part_content_set`
- :py:meth:`~efl.elementary.object_item.ObjectItem.part_content_get`
- :py:meth:`~efl.elementary.object_item.ObjectItem.part_content_unset`
- :py:meth:`~efl.elementary.object_item.ObjectItem.signal_emit`

What happens is that the topmost item of a naviframe will be the
widget's target layout, when accessed directly. Items lying below
the top one can be interacted with this way.


Inheritance diagram
===================

.. inheritance-diagram::
    Naviframe
    NaviframeItem
    :parts: 2


.. autoclass:: Naviframe
.. autoclass:: NaviframeItem
