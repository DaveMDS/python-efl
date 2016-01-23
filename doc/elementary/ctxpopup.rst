.. currentmodule:: efl.elementary

Ctxpopup
########

.. image:: /images/ctxpopup-preview.png


Widget description
==================

A ctxpopup is a widget that, when shown, pops up a list of items. It
automatically chooses an area inside its parent object's view to
optimally fit into it. In the default theme, it will also point an arrow
to it's top left position at the time one shows it. Ctxpopup items have
a label and/or an icon. It is intended for a small number of items
(hence the use of list, not genlist).

.. note::

    Ctxpopup is a specialization of :py:class:`~efl.elementary.hover.Hover`.

Emitted signals
===============

- ``dismissed`` - This is called when 1. the outside of ctxpopup was clicked
  or 2. its parent area is changed or 3. the language is changed and also when
  4. the parent object is resized due to the window rotation. Then ctxpopup is
  dismissed.

- ``geometry,update`` - The geometry has changed (since 1.17)

Layout content parts
====================

- ``default`` - A content of the ctxpopup
- ``icon`` - An icon in the title area

Layout text parts
=================

- ``default`` - Title label in the title area


Enumerations
============

.. _Elm_Ctxpopup_Direction:

Ctxpopup arrow directions
-------------------------

.. data:: ELM_CTXPOPUP_DIRECTION_DOWN

    Arrow is pointing down

.. data:: ELM_CTXPOPUP_DIRECTION_RIGHT

    Arrow is pointing right

.. data:: ELM_CTXPOPUP_DIRECTION_LEFT

    Arrow is pointing left

.. data:: ELM_CTXPOPUP_DIRECTION_UP

    Arrow is pointing up

.. data:: ELM_CTXPOPUP_DIRECTION_UNKNOWN

    Arrow direction is unknown


Inheritance diagram
===================

.. inheritance-diagram::
    Ctxpopup
    CtxpopupItem
    :parts: 2


.. autoclass:: Ctxpopup
.. autoclass:: CtxpopupItem
