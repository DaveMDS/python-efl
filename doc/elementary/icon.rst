.. currentmodule:: efl.elementary

Icon
####

.. image:: /images/icon-preview.png


Widget description
==================

An icon object is used to display standard icon images ("delete",
"edit", "arrows", etc.) or images coming from a custom file (PNG, JPG,
EDJE, etc.), on icon contexts.

The icon image requested can be in the Elementary theme in use, or in
the ``freedesktop.org`` theme paths. It's possible to set the order of
preference from where an image will be fetched.

This widget inherits from the :py:class:`~efl.elementary.image.Image` one, so
that all the functions acting on it also work for icon objects.

You should be using an icon, instead of an image, whenever one of the
following apply:

- you need a **thumbnail** version of an original image
- you need freedesktop.org provided icon images
- you need theme provided icon images (Edje groups)

Default images provided by Elementary's default theme are described below.

These are names that follow (more or less) the **Freedesktop** icon naming
specification. Use of these names are **preferred**, at least if you want to
give your user the ability to use other themes. All these icons can be
seen in the elementary_test application, the test is called "Icon Standard".

- ``folder`` (since 1.13)
- ``user-home`` (since 1.13)
- ``user-trash`` (since 1.13)

- ``view-close`` (since 1.13)
- ``view-refresh`` (since 1.13)

- ``window-close`` 1.13)

- ``document-close`` (since 1.13)
- ``document-edit`` (since 1.13)

- ``dialog-info`` (since 1.13)
- ``dialog-close`` (since 1.13)

- ``arrow-up`` (since 1.13)
- ``arrow-down`` (since 1.13)
- ``arrow-left`` (since 1.13)
- ``arrow-right`` (since 1.13)
- ``arrow-up-left`` (since 1.13)
- ``arrow-up-right`` (since 1.13)
- ``arrow-down-left`` (since 1.13)
- ``arrow-down-right`` (since 1.13)

- ``edit-delete`` (since 1.13)

- ``application-chat`` (since 1.13)
- ``application-clock`` (since 1.13)

- ``media-seek-forward`` 1.13)
- ``media-seek-backward`` (since 1.13)
- ``media-skip-forward`` (since 1.13)
- ``media-skip-backward`` (since 1.13)
- ``media-playback-pause`` (since 1.13)
- ``media-playback-start`` (since 1.13)
- ``media-playback-stop`` (since 1.13)
- ``media-eject`` (since 1.13)

- ``audio-volume`` (since 1.13)
- ``audio-volume-muted`` (since 1.13)

These are names for icons that were first intended to be used in
toolbars, but can be used in many other places too:

- ``home``
- ``close``
- ``apps``
- ``arrow_up``
- ``arrow_down``
- ``arrow_left``
- ``arrow_right``
- ``chat``
- ``clock``
- ``delete``
- ``edit``
- ``refresh``
- ``folder``
- ``file``

These are names for icons that were designed to be used in menus
(but again, you can use them anywhere else):

- ``menu/home``
- ``menu/close``
- ``menu/apps``
- ``menu/arrow_up``
- ``menu/arrow_down``
- ``menu/arrow_left``
- ``menu/arrow_right``
- ``menu/chat``
- ``menu/clock``
- ``menu/delete``
- ``menu/edit``
- ``menu/refresh``
- ``menu/folder``
- ``menu/file``

And these are names for some media player specific icons:

- ``media_player/forward``
- ``media_player/info``
- ``media_player/next``
- ``media_player/pause``
- ``media_player/play``
- ``media_player/prev``
- ``media_player/rewind``
- ``media_player/stop``


Emitted signals
===============

- ``thumb,done`` - Setting :py:attr:`~Icon.thumb` has completed with success
- ``thumb,error`` - Setting :py:attr:`~Icon.thumb` has failed


Enumerations
============

.. _Elm_Icon_Lookup_Order:

Icon lookup modes
-----------------

.. data:: ELM_ICON_LOOKUP_FDO_THEME

    freedesktop, theme

.. data:: ELM_ICON_LOOKUP_THEME_FDO

    theme, freedesktop

.. data:: ELM_ICON_LOOKUP_FDO

    freedesktop

.. data:: ELM_ICON_LOOKUP_THEME

    theme


.. _Elm_Icon_Type:

Icon type
---------

.. data:: ELM_ICON_NONE

    No icon

.. data:: ELM_ICON_FILE

    Icon is a file

.. data:: ELM_ICON_STANDARD

    Icon is set with standards name


Inheritance diagram
===================

.. inheritance-diagram:: Icon
    :parts: 2


.. autoclass:: Icon
