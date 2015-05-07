.. currentmodule:: efl.elementary

Video
#####


Widget description
==================

Display a video by using Emotion.

It embeds the video inside an Edje object, so you can do some
animation depending on the video state change. It also implements a
resource management policy to remove this burden from the application.

These widgets emit the following signals, besides the ones sent from
:py:class:`~efl.elementary.layout_class.LayoutClass`:

- ``focused`` - When the widget has received focus. (since 1.8)
- ``unfocused`` - When the widget has lost focus. (since 1.8)


Inheritance diagram
===================

.. inheritance-diagram::
    Video
    Player
    :parts: 2


.. autoclass:: Video
.. autoclass:: Player
