.. currentmodule:: efl.elementary

Progressbar
###########

.. image:: /images/progressbar-preview.png


Widget description
==================

The progress bar is a widget for visually representing the progress
status of a given job/task.

A progress bar may be horizontal or vertical. It may display an icon
besides it, as well as primary and **units** labels. The former is meant
to label the widget as a whole, while the latter, which is formatted
with floating point values (and thus accepts a ``printf``-style format
string, like ``"%1.2f units"``), is meant to label the widget's **progress
value**. Label, icon and unit strings/objects are **optional** for
progress bars.

A progress bar may be **inverted**, in which case it gets its values
inverted, i.e., high values being on the left or top and low values on
the right or bottom, for horizontal and vertical modes respectively.

The **span** of the progress, as set by :py:attr:`~Progressbar.span_size`, is
its length (horizontally or vertically), unless one puts size hints on the
widget to expand on desired directions, by any container. That length will be
scaled by the object or applications scaling factor. Applications can query the
progress bar for its value with :py:attr:`~Progressbar.value`.

This widget emits the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``changed`` - when the value is changed


This widget has the following styles:

- ``default``
- ``wheel`` (simple style, no text, no progression, only "pulse"
  effect is available)
- ``double`` (style with two independent progress indicators)

Default text parts of the progressbar widget that you can use for are:

- ``default`` - Label of the progressbar

Default content parts of the progressbar widget that you can use for are:

- ``icon`` - An icon of the progressbar

Default part names for the "recording" style:

- ``elm.cur.progressbar`` - The "main" indicator bar
- ``elm.cur.progressbar1`` - The "secondary" indicator bar


Inheritance diagram
===================

.. inheritance-diagram:: Progressbar
    :parts: 2


.. autoclass:: Progressbar
