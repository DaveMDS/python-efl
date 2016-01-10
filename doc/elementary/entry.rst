.. currentmodule:: efl.elementary

Entry
#####

.. image:: /images/entry-preview.png


Widget description
==================

An entry is a convenience widget which shows a box that the user can
enter text into.

Entries by default don't scroll, so they grow to accommodate the entire text,
resizing the parent window as needed. This can be changed with the property
:py:attr:`~efl.elementary.entry.Entry.scrollable`.

They can also be single line or multi line (the default) and when set
to multi line mode they support text wrapping in any of the modes
indicated by :ref:`Elm_Wrap_Type`.

Other features include password mode, filtering of inserted text with
:py:meth:`~efl.elementary.entry.Entry.markup_filter_append` and related
functions, inline "items" and formatted markup text.


Scrollable Interface
====================

This widget supports the scrollable interface.

If you wish to control the scolling behaviour using these functions,
inherit both the widget class and the
:py:class:`~efl.elementary.scroller.Scrollable` class
using multiple inheritance, for example::

    class ScrollableGenlist(Genlist, Scrollable):
        def __init__(self, canvas, *args, **kwargs):
            Genlist.__init__(self, canvas)


Formatted text
==============

The markup tags supported by the Entry are defined by the theme, but
even when writing new themes or extensions it's a good idea to stick to
a sane default, to maintain coherency and avoid application breakages.
Currently defined by the default theme are the following tags:

``<br>``
    Inserts a line break.
``<ps>``
    Inserts a paragraph separator. This is preferred over line
    breaks.
``<tab>``
    Inserts a tab.
``<em>...</em>``
    Emphasis. Sets the *oblique* style for the
    enclosed text.
``<b>...</b>``
    Sets the **bold** style for the enclosed text.
``<link>...</link>``
    Underlines the enclosed text.
``<hilight>...</hilight>``
    Highlights the enclosed text.


Special markups
===============

Besides those used to format text, entries support two special markup
tags used to insert click-able portions of text or items inlined within
the text.


Anchors
-------

Anchors are similar to HTML anchors. Text can be surrounded by <a> and
</a> tags and an event will be generated when this text is clicked,
like this::

    This text is outside <a href=anc-01>but this one is an anchor</a>

The ``href`` attribute in the opening tag gives the name that will be
used to identify the anchor and it can be any valid utf8 string.

When an anchor is clicked, an ``"anchor,clicked"`` signal is emitted with
an :py:class:`EntryAnchorInfo` in the ``event_info`` parameter for the
callback function. The same applies for ``anchor,in`` (mouse in),
``anchor,out`` (mouse out), ``anchor,down`` (mouse down), and ``anchor,up``
(mouse up) events on an anchor.


Items
-----

Inlined in the text, any other :py:class:`~efl.elementary.object.Object` can
be inserted by using ``<item>`` tags this way::

    <item size=16x16 vsize=full href=emoticon/haha></item>

Just like with anchors, the ``href`` identifies each item, but these need,
in addition, to indicate their size, which is done using any one of
``size``, ``absize`` or ``relsize`` attributes. These attributes take their
value in the WxH format, where W is the width and H the height of the
item.

- absize: Absolute pixel size for the item. Whatever value is set will
  be the item's size regardless of any scale value the object may have
  been set to. The final line height will be adjusted to fit larger items.
- size: Similar to *absize*, but it's adjusted to the scale value set
  for the object.
- relsize: Size is adjusted for the item to fit within the current
  line height.

Besides their size, items are specified a ``vsize`` value that affects
how their final size and position are calculated. The possible values
are:

- ``ascent``: Item will be placed within the line's baseline and its
  ascent. That is, the height between the line where all characters are
  positioned and the highest point in the line. For ``size`` and
  ``absize`` items, the descent value will be added to the total line
  height to make them fit. ``relsize`` items will be adjusted to fit
  within this space.
- ``full``: Items will be placed between the descent and ascent, or the
  lowest point in the line and its highest.

After the size for an item is calculated, the entry will request an object to
place in its space. For this, the functions set with
:py:meth:`~efl.elementary.entry.Entry.item_provider_append` and related
functions will be called in order until one of them returns a non-*None* value.
If no providers are available, or all of them return *None*, then the entry
falls back to one of the internal defaults, provided the name matches with one
of them.

All of the following are currently supported:

- emoticon/angry
- emoticon/angry-shout
- emoticon/crazy-laugh
- emoticon/evil-laugh
- emoticon/evil
- emoticon/goggle-smile
- emoticon/grumpy
- emoticon/grumpy-smile
- emoticon/guilty
- emoticon/guilty-smile
- emoticon/haha
- emoticon/half-smile
- emoticon/happy-panting
- emoticon/happy
- emoticon/indifferent
- emoticon/kiss
- emoticon/knowing-grin
- emoticon/laugh
- emoticon/little-bit-sorry
- emoticon/love-lots
- emoticon/love
- emoticon/minimal-smile
- emoticon/not-happy
- emoticon/not-impressed
- emoticon/omg
- emoticon/opensmile
- emoticon/smile
- emoticon/sorry
- emoticon/squint-laugh
- emoticon/surprised
- emoticon/suspicious
- emoticon/tongue-dangling
- emoticon/tongue-poke
- emoticon/uh
- emoticon/unhappy
- emoticon/very-sorry
- emoticon/what
- emoticon/wink
- emoticon/worried
- emoticon/wtf

Alternatively, an item may reference an image by its path, using
the URI form ``file:///path/to/an/image.png`` and the entry will then
use that image for the item.


Setting entry's style
=====================

There are 2 major ways to change the entry's style:

- Theme - set the "base" field to the desired style.
- User style - Pushing overrides to the theme style to the textblock object
  by using :py:meth:`~efl.elementary.entry.Entry.text_style_user_push`.

You should modify the theme when you would like to change the style for
aesthetic reasons. While the user style should be changed when you would
like to change the style to something specific defined at run-time, e.g,
setting font or font size in a text editor.


Loading and saving files
========================

Entries have convenience functions to load text from a file and save changes
back to it after a short delay. The automatic saving is enabled by default, but
can be disabled with :py:attr:`~efl.elementary.entry.Entry.autosave` and files
can be loaded directly as plain text or have any markup in them recognized. See
:py:attr:`~efl.elementary.entry.Entry.file` for more details.


Emitted signals
===============

- ``changed``: The text within the entry was changed.
- ``changed,user``: The text within the entry was changed because of user
  interaction.
- ``activated``: The enter key was pressed on a single line entry.
- ``aborted``: The escape key was pressed on a single line entry. (since 1.7)
- ``press``: A mouse button has been pressed on the entry.
- ``longpressed``: A mouse button has been pressed and held for a couple
  seconds.
- ``clicked``: The entry has been clicked (mouse press and release).
- ``clicked,double``: The entry has been double clicked.
- ``clicked,triple``: The entry has been triple clicked.
- ``selection,paste``: A paste of the clipboard contents was requested.
- ``selection,copy``: A copy of the selected text into the clipboard was
  requested.
- ``selection,cut``: A cut of the selected text into the clipboard was
  requested.
- ``selection,start``: A selection has begun and no previous selection
  existed.
- ``selection,changed``: The current selection has changed.
- ``selection,cleared``: The current selection has been cleared.
- ``cursor,changed``: The cursor has changed position.
- ``anchor,clicked``: An anchor has been clicked. The event_info
  parameter for the callback will be an :py:class:`EntryAnchorInfo`.
- ``anchor,in``: Mouse cursor has moved into an anchor. The event_info
  parameter for the callback will be an :py:class:`EntryAnchorInfo`.
- ``anchor,out``: Mouse cursor has moved out of an anchor. The event_info
  parameter for the callback will be an :py:class:`EntryAnchorInfo`.
- ``anchor,up``: Mouse button has been unpressed on an anchor. The event_info
  parameter for the callback will be an :py:class:`EntryAnchorInfo`.
- ``anchor,down``: Mouse button has been pressed on an anchor. The event_info
  parameter for the callback will be an :py:class:`EntryAnchorInfo`.
- ``preedit,changed``: The preedit string has changed.
- ``text,set,done``: Whole text has been set to the entry.
- ``rejected``: .Called when some of inputs are rejected by the filter. (since 1.9)


Layout content parts
====================

- ``icon`` - An icon in the entry
- ``end`` - A content in the end of the entry


Layout text parts
=================

- ``default`` - text of the entry
- ``guide`` - placeholder of the entry


Enumerations
============

.. _Elm_Entry_Autocapital_Type:

Autocapitalization types
------------------------

.. data:: ELM_AUTOCAPITAL_TYPE_NONE

    No auto-capitalization when typing

.. data:: ELM_AUTOCAPITAL_TYPE_WORD

    Autocapitalize each word typed

.. data:: ELM_AUTOCAPITAL_TYPE_SENTENCE

    Autocapitalize the start of each sentence

.. data:: ELM_AUTOCAPITAL_TYPE_ALLCHARACTER

    Autocapitalize all letters


.. _Elm_Entry_Cnp_Mode:

Copy & paste modes
------------------

.. data:: ELM_CNP_MODE_MARKUP

    Copy & paste text with markup tags

.. data:: ELM_CNP_MODE_NO_IMAGE

    Copy & paste text without item (image) tags

.. data:: ELM_CNP_MODE_PLAINTEXT

    Copy & paste text without markup tags


.. _Elm_Input_Hints:

Input Hints
-----------

.. data:: ELM_INPUT_HINT_NONE

    No active hints

    .. versionadded:: 1.12

.. data:: ELM_INPUT_HINT_AUTO_COMPLETE

    Suggest word auto completion

    .. versionadded:: 1.12

.. data:: ELM_INPUT_HINT_SENSITIVE_DATA

    typed text should not be stored

    .. versionadded:: 1.12


.. _Elm_Entry_Input_Panel_Lang:

Input panel language sort order
-------------------------------

.. data:: ELM_INPUT_PANEL_LANG_AUTOMATIC

    Automatic

.. data:: ELM_INPUT_PANEL_LANG_ALPHABET

    Alphabetic


.. _Elm_Entry_Input_Panel_Layout:

Input panel layouts
-------------------

.. data:: ELM_INPUT_PANEL_LAYOUT_NORMAL

    Default layout

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBER

    Number layout

.. data:: ELM_INPUT_PANEL_LAYOUT_EMAIL

    Email layout

.. data:: ELM_INPUT_PANEL_LAYOUT_URL

    URL layout

.. data:: ELM_INPUT_PANEL_LAYOUT_PHONENUMBER

    Phone number layout

.. data:: ELM_INPUT_PANEL_LAYOUT_IP

    IP layout

.. data:: ELM_INPUT_PANEL_LAYOUT_MONTH

    Month layout

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBERONLY

    Number only layout

.. data:: ELM_INPUT_PANEL_LAYOUT_INVALID

    Never use this

.. data:: ELM_INPUT_PANEL_LAYOUT_HEX

    Hexadecimal layout

.. data:: ELM_INPUT_PANEL_LAYOUT_TERMINAL

    Command-line terminal layout

.. data:: ELM_INPUT_PANEL_LAYOUT_PASSWORD

    Like normal, but no auto-correct, no auto-capitalization etc.

.. data:: ELM_INPUT_PANEL_LAYOUT_DATETIME

    Date and time layout

    .. versionadded:: 1.10

.. data:: ELM_INPUT_PANEL_LAYOUT_EMOTICON

    Emoticon layout

    .. versionadded:: 1.10


.. _Elm_Input_Panel_Layout_Normal_Variation:

Input panel normal layout variation
-----------------------------------

.. data:: ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_NORMAL

    The plain normal layout

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_FILENAME

    Filename layout. Symbols such as '/' should be disabled

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_NORMAL_VARIATION_PERSON_NAME

    The name of a person

    .. versionadded:: 1.12


.. _Elm_Input_Panel_Layout_Numberonly_Variation:

Input panel numberonly layout variation
---------------------------------------

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_NORMAL

    The numberonly normal layout

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_SIGNED

    The signed number layout

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_DECIMAL

    The decimal number layout

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_NUMBERONLY_VARIATION_SIGNED_AND_DECIMAL

    The signed and decimal number layout

    .. versionadded:: 1.12


.. _Elm_Input_Panel_Layout_Password_Variation:

Input panel password layout variation
-------------------------------------

.. data:: ELM_INPUT_PANEL_LAYOUT_PASSWORD_VARIATION_NORMAL

    The normal password layout

    .. versionadded:: 1.12

.. data:: ELM_INPUT_PANEL_LAYOUT_PASSWORD_VARIATION_NUMBERONLY

    The password layout to allow only number

    .. versionadded:: 1.12


.. _Elm_Entry_Input_Panel_Return_Key_Type:

Input panel return key modes
----------------------------

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT

    Default

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE

    Done

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO

    Go

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN

    Join

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN

    Login

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT

    Next

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH

    Search

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND

    Send

.. data:: ELM_INPUT_PANEL_RETURN_KEY_TYPE_SIGNIN

    Sign-in

    .. versionadded:: 1.10


.. _Elm_Entry_Text_Format:

Text format
-----------

.. data:: ELM_TEXT_FORMAT_PLAIN_UTF8

    Plain UTF-8 type

.. data:: ELM_TEXT_FORMAT_MARKUP_UTF8

    UTF-8 with markup


.. _Elm_Wrap_Type:

Wrap mode
---------

.. data:: ELM_WRAP_NONE

    No wrap

.. data:: ELM_WRAP_CHAR

    Wrap between characters

.. data:: ELM_WRAP_WORD

    Wrap in allowed wrapping points (as defined in the unicode standard)

.. data:: ELM_WRAP_MIXED

    Word wrap, and if that fails, char wrap


Inheritance diagram
===================

.. inheritance-diagram:: Entry
    :parts: 2

.. autofunction:: markup_to_utf8
.. autofunction:: utf8_to_markup

.. autoclass:: Entry
.. autoclass:: EntryContextMenuItem
.. autoclass:: FilterLimitSize
.. autoclass:: FilterAcceptSet
.. autoclass:: EntryAnchorInfo
.. autoclass:: EntryAnchorHoverInfo
