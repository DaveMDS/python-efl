.. currentmodule:: efl.elementary

Button
######

.. image:: /images/button-preview.png


Widget description
==================

This is a push-button. Press it and run some function. It can contain
a simple label and icon object and it also has an autorepeat feature.


Available styles
================

- ``default`` a normal button.
- ``anchor`` Like default, but the button fades away when the mouse is not
  over it, leaving only the text or icon.
- ``hoversel_vertical`` Internally used by
  :py:class:`~efl.elementary.hoversel.Hoversel` to give a continuous look
  across its options.
- ``hoversel_vertical_entry`` Another internal for
  :py:class:`~efl.elementary.hoversel.Hoversel`.
- ``naviframe`` Internally used by
  :py:class:`~efl.elementary.naviframe.Naviframe` for its back button.
- ``colorselector`` Internally used by
  :py:class:`~efl.elementary.colorselector.Colorselector` for its left and
  right buttons.


Layout content parts
====================

- ``icon`` - An icon of the button


Layout text parts
=================

- ``default`` - Label of the button


Emitted signals
===============

- ``clicked``: the user clicked the button (press/release).
- ``repeated``: the user pressed the button without releasing it.
- ``pressed``: button was pressed.
- ``unpressed``: button was released after being pressed.


Inheritance diagram
===================

.. inheritance-diagram:: Button
    :parts: 2


.. autoclass:: Button

