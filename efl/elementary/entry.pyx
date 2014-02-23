# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.
#

"""

Widget description
------------------

.. image:: /images/entry-preview.png
    :align: left

An entry is a convenience widget which shows a box that the user can
enter text into.

Entries by default don't scroll, so they grow to accommodate the entire text,
resizing the parent window as needed. This can be changed with the property
:py:attr:`~efl.elementary.entry.Entry.scrollable`.

They can also be single line or multi line (the default) and when set
to multi line mode they support text wrapping in any of the modes
indicated by :ref:`Elm_Entry_Wrap_Type`.

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

- <br>: Inserts a line break.
- <ps>: Inserts a paragraph separator. This is preferred over line
  breaks.
- <tab>: Inserts a tab.
- <em>...</em>: Emphasis. Sets the *oblique* style for the
  enclosed text.
- <b>...</b>: Sets the **bold** style for the enclosed text.
- <link>...</link>: Underlines the enclosed text.
- <hilight>...</hilight>: Highlights the enclosed text.

Special markups
===============

Besides those used to format text, entries support two special markup
tags used to insert click-able portions of text or items inlined within
the text.

Anchors
'''''''

Anchors are similar to HTML anchors. Text can be surrounded by <a> and
</a> tags and an event will be generated when this text is clicked,
like this::

    This text is outside <a href=anc-01>but this one is an anchor</a>

The ``href`` attribute in the opening tag gives the name that will be
used to identify the anchor and it can be any valid utf8 string.

When an anchor is clicked, an ``"anchor,clicked"`` signal is emitted with
an :py:class:`EntryAnchorInfo` in the ``event_info`` parameter for the
callback function. The same applies for "anchor,in" (mouse in),
"anchor,out" (mouse out), "anchor,down" (mouse down), and "anchor,up"
(mouse up) events on an anchor.

Items
'''''

Inlined in the text, any other :py:class:`~efl.elementary.object.Object` can
be inserted by using <item> tags this way::

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

- ascent: Item will be placed within the line's baseline and its
  ascent. That is, the height between the line where all characters are
  positioned and the highest point in the line. For ``size`` and
  ``absize`` items, the descent value will be added to the total line
  height to make them fit. ``relsize`` items will be adjusted to fit
  within this space.
- full: Items will be placed between the descent and ascent, or the
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
---------------

This widget emits the following signals:

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
- ``focused``: The entry has received focus.
- ``unfocused``: The entry has lost focus.
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
- ``language,changed``: Program language changed.
- ``text,set,done``: Whole text has been set to the entry.
- ``rejected``: .Called when some of inputs are rejected by the filter. (since 1.9)


Default content parts of the entry items that you can use for are:

- ``icon`` - An icon in the entry
- ``end`` - A content in the end of the entry

Default text parts of the entry that you can use for are:

- ``default`` - text of the entry
- ``guide`` - placeholder of the entry


Enumerations
------------

.. _Elm_Entry_Autocapital_Type:

Autocapitalization types
========================

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
==================

.. data:: ELM_CNP_MODE_MARKUP

    Copy & paste text with markup tags

.. data:: ELM_CNP_MODE_NO_IMAGE

    Copy & paste text without item (image) tags

.. data:: ELM_CNP_MODE_PLAINTEXT

    Copy & paste text without markup tags


.. _Elm_Entry_Input_Panel_Lang:

Input panel language sort order
===============================

.. data:: ELM_INPUT_PANEL_LANG_AUTOMATIC

    Automatic

.. data:: ELM_INPUT_PANEL_LANG_ALPHABET

    Alphabetic


.. _Elm_Entry_Input_Panel_Layout:

Input panel layouts
===================

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


.. _Elm_Entry_Input_Panel_Return_Key_Type:

Input panel return key modes
============================

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


.. _Elm_Entry_Text_Format:

Text format
===========

.. data:: ELM_TEXT_FORMAT_PLAIN_UTF8

    Plain UTF-8 type

.. data:: ELM_TEXT_FORMAT_MARKUP_UTF8

    UTF-8 with markup


.. _Elm_Entry_Wrap_Type:

Wrap mode
=========

.. data:: ELM_WRAP_NONE

    No wrap

.. data:: ELM_WRAP_CHAR

    Wrap between characters

.. data:: ELM_WRAP_WORD

    Wrap in allowed wrapping points (as defined in the unicode standard)

.. data:: ELM_WRAP_MIXED

    Word wrap, and if that fails, char wrap


.. _Elm_Entry_Icon_Type:

Icon types
==========

.. data:: ELM_ICON_NONE

    No icon

.. data:: ELM_ICON_FILE

    Icon is a file

.. data:: ELM_ICON_STANDARD

    Icon is set with standards names


"""

from libc.string cimport strdup
from libc.stdlib cimport free
from libc.stdint cimport uintptr_t
from cpython cimport PyUnicode_AsUTF8String, Py_INCREF

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.utils.conversions cimport _touni, _ctouni
from efl.evas cimport Object as evasObject
from object cimport Object
from layout_class cimport LayoutClass
from hover cimport Hover

from efl.utils.deprecated cimport DEPRECATED
from scroller cimport elm_scroller_policy_get, elm_scroller_policy_set, \
    elm_scroller_bounce_get, elm_scroller_bounce_set, Elm_Scroller_Policy

cimport enums

ELM_AUTOCAPITAL_TYPE_NONE = enums.ELM_AUTOCAPITAL_TYPE_NONE
ELM_AUTOCAPITAL_TYPE_WORD = enums.ELM_AUTOCAPITAL_TYPE_WORD
ELM_AUTOCAPITAL_TYPE_SENTENCE = enums.ELM_AUTOCAPITAL_TYPE_SENTENCE
ELM_AUTOCAPITAL_TYPE_ALLCHARACTER = enums.ELM_AUTOCAPITAL_TYPE_ALLCHARACTER

ELM_CNP_MODE_MARKUP = enums.ELM_CNP_MODE_MARKUP
ELM_CNP_MODE_NO_IMAGE = enums.ELM_CNP_MODE_NO_IMAGE
ELM_CNP_MODE_PLAINTEXT = enums.ELM_CNP_MODE_PLAINTEXT

ELM_INPUT_PANEL_LANG_AUTOMATIC = enums.ELM_INPUT_PANEL_LANG_AUTOMATIC
ELM_INPUT_PANEL_LANG_ALPHABET = enums.ELM_INPUT_PANEL_LANG_ALPHABET

ELM_INPUT_PANEL_LAYOUT_NORMAL = enums.ELM_INPUT_PANEL_LAYOUT_NORMAL
ELM_INPUT_PANEL_LAYOUT_NUMBER = enums.ELM_INPUT_PANEL_LAYOUT_NUMBER
ELM_INPUT_PANEL_LAYOUT_EMAIL = enums.ELM_INPUT_PANEL_LAYOUT_EMAIL
ELM_INPUT_PANEL_LAYOUT_URL = enums.ELM_INPUT_PANEL_LAYOUT_URL
ELM_INPUT_PANEL_LAYOUT_PHONENUMBER = enums.ELM_INPUT_PANEL_LAYOUT_PHONENUMBER
ELM_INPUT_PANEL_LAYOUT_IP = enums.ELM_INPUT_PANEL_LAYOUT_IP
ELM_INPUT_PANEL_LAYOUT_MONTH = enums.ELM_INPUT_PANEL_LAYOUT_MONTH
ELM_INPUT_PANEL_LAYOUT_NUMBERONLY = enums.ELM_INPUT_PANEL_LAYOUT_NUMBERONLY
ELM_INPUT_PANEL_LAYOUT_INVALID = enums.ELM_INPUT_PANEL_LAYOUT_INVALID
ELM_INPUT_PANEL_LAYOUT_HEX = enums.ELM_INPUT_PANEL_LAYOUT_HEX
ELM_INPUT_PANEL_LAYOUT_TERMINAL = enums.ELM_INPUT_PANEL_LAYOUT_TERMINAL
ELM_INPUT_PANEL_LAYOUT_PASSWORD = enums.ELM_INPUT_PANEL_LAYOUT_PASSWORD

ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_DEFAULT
ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_DONE
ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_GO
ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_JOIN
ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_LOGIN
ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_NEXT
ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEARCH
ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND = enums.ELM_INPUT_PANEL_RETURN_KEY_TYPE_SEND

ELM_SCROLLER_POLICY_AUTO = enums.ELM_SCROLLER_POLICY_AUTO
ELM_SCROLLER_POLICY_ON = enums.ELM_SCROLLER_POLICY_ON
ELM_SCROLLER_POLICY_OFF = enums.ELM_SCROLLER_POLICY_OFF

ELM_TEXT_FORMAT_PLAIN_UTF8 = enums.ELM_TEXT_FORMAT_PLAIN_UTF8
ELM_TEXT_FORMAT_MARKUP_UTF8 = enums.ELM_TEXT_FORMAT_MARKUP_UTF8

ELM_WRAP_NONE = enums.ELM_WRAP_NONE
ELM_WRAP_CHAR = enums.ELM_WRAP_CHAR
ELM_WRAP_WORD = enums.ELM_WRAP_WORD
ELM_WRAP_MIXED = enums.ELM_WRAP_MIXED

ELM_ICON_NONE = enums.ELM_ICON_NONE
ELM_ICON_FILE = enums.ELM_ICON_FILE
ELM_ICON_STANDARD = enums.ELM_ICON_STANDARD

import traceback

cdef void _entry_context_menu_callback(void *data, Evas_Object *obj, void *event_info) with gil:
    (callback, a, ka) = <object>data
    try:
        o = object_from_instance(obj)
        callback(o, *a, **ka)
    except Exception as e:
        traceback.print_exc()

@DEPRECATED("1.8", "Use markup_to_utf8() instead.")
def Entry_markup_to_utf8(string):
    """Entry_markup_to_utf8(string)"""
    if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
    return _touni(elm_entry_markup_to_utf8(
        <const_char *>string if string is not None else NULL))

@DEPRECATED("1.8", "Use utf8_to_markup() instead.")
def Entry_utf8_to_markup(string):
    """Entry_utf8_to_markup(string)"""
    if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
    return _touni(elm_entry_utf8_to_markup(
        <const_char *>string if string is not None else NULL))

def markup_to_utf8(string):
    if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
    return _touni(elm_entry_markup_to_utf8(
        <const_char *>string if string is not None else NULL))

def utf8_to_markup(string):
    if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
    return _touni(elm_entry_utf8_to_markup(
        <const_char *>string if string is not None else NULL))

cdef class EntryContextMenuItem(object):
    """

    Type of contextual item that can be added in to long press menu.

    .. versionadded:: 1.8

    """
    cdef Elm_Entry_Context_Menu_Item *item

    property label:
        """Get the text of the contextual menu item.

        Gets the text of the contextual menu item of entry.

        :type: unicode

        .. versionadded:: 1.8

        """
        def __get__(self):
            return _ctouni(elm_entry_context_menu_item_label_get(self.item))

    property icon:
        """Get the icon object of the contextual menu item.

        Gets the icon object packed in the contextual menu item of entry.

        :type: (unicode **icon_file**, unicode **icon_group**, :ref:`Icon type <Elm_Icon_Type>` **icon_type**)

        .. versionadded:: 1.8

        """
        def __get__(self):
            cdef:
                const_char *icon_file
                const_char *icon_group
                Elm_Icon_Type icon_type
            elm_entry_context_menu_item_icon_get(self.item,
                &icon_file,
                &icon_group,
                &icon_type)

            return (_ctouni(icon_file), _ctouni(icon_group), icon_type)

cdef class FilterLimitSize(object):
    """

    Data for the :py:meth:`~efl.elementary.entry.Entry.filter_limit_size`
    entry filter.

    """

    cdef:
        Elm_Entry_Filter_Limit_Size *fltr

    property max_char_count:
        """The maximum number of characters allowed.

        :type: int

        """
        def __set__(self, value):
            self.fltr.max_char_count = value

        def __get__(self):
            return self.fltr.max_char_count

    property max_byte_count:
        """The maximum number of bytes allowed.

        :type: int

        """
        def __set__(self, value):
            self.fltr.max_byte_count = value

        def __get__(self):
            return self.fltr.max_byte_count

cdef class FilterAcceptSet(object):
    """

    Data for the :py:meth:`~efl.elementary.entry.Entry.filter_accept_set`
    entry filter.

    """

    cdef:
        Elm_Entry_Filter_Accept_Set *fltr

    property accepted:
        """Set of characters accepted in the entry.

        :type: string

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.fltr.accepted = value

        def __get__(self):
            return _ctouni(self.fltr.accepted)

    property rejected:
        """Set of characters rejected from the entry.

        :type: string

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.fltr.rejected = value

        def __get__(self):
            return _ctouni(self.fltr.rejected)

cdef void py_elm_entry_filter_cb(void *data, Evas_Object *entry, char **text) with gil:
    """This callback type is used by entry filters to modify text.

    :param data: The data specified as the last param when adding the filter
    :param entry: The entry object
    :param text: A pointer to the location of the text being filtered. The type
        of text is always markup. This data can be modified, but any additional
        allocations must be managed by the user.

    """
    cdef:
        Entry en = object_from_instance(entry)

    cb_func, cb_data = <object>data
    try:
        ret = cb_func(en, _touni(text[0]), cb_data)
    except:
        traceback.print_exc()

    if ret is None:
        free(text[0])
        text[0] = NULL
        return

    text[0] = strdup(<char *>ret)

class EntryAnchorInfo(object):
    """

    The info sent in the callback for the "anchor,clicked" signals emitted by entries.

    :var name: The name of the anchor, as stated in its href.
    :var button: The mouse button used to click on it.
    :var x: Anchor geometry, relative to canvas.
    :var y: Anchor geometry, relative to canvas.
    :var w: Anchor geometry, relative to canvas.
    :var h: Anchor geometry, relative to canvas.

    """
    def __init__(self):
        self.name = None
        self.button = 0
        self.x = 0
        self.y = 0
        self.w = 0
        self.h = 0

class EntryAnchorHoverInfo(object):
    """

    The info sent in the callback for "anchor,clicked" signals emitted by the Anchor_Hover widget.

    :var anchor_info: The actual anchor info.
    :var hover: The hover object to use for the popup.
    :var hover_parent: Geometry of the object used as parent by the hover.
    :var hover_left: Hint indicating if there's space for content on the left side of the hover.
    :var hover_right: Hint indicating content fits on the right side of the hover.
    :var hover_top: Hint indicating content fits on top of the hover.
    :var hover_bottom: Hint indicating content fits below the hover.

    """
    def __init__(self):
        self.anchor_info = None
        self.hover = None
        self.hover_parent = (0, 0, 0, 0)
        self.hover_left = False
        self.hover_right = False
        self.hover_top = False
        self.hover_bottom = False

def _entryanchor_conv(uintptr_t addr):
    cdef Elm_Entry_Anchor_Info *ei = <Elm_Entry_Anchor_Info *>addr
    eai = EntryAnchorInfo()
    eai.name = _ctouni(ei.name)
    eai.button = ei.button
    eai.x = ei.x
    eai.y = ei.y
    eai.w = ei.w
    eai.h = ei.h
    return eai

def _entryanchorhover_conv(uintptr_t addr):
    cdef Elm_Entry_Anchor_Hover_Info *ehi = <Elm_Entry_Anchor_Hover_Info *>addr
    eahi = EntryAnchorHoverInfo()
    eahi.anchor_info = _entryanchor_conv(<uintptr_t><void *>ehi.anchor_info)
    eahi.hover = object_from_instance(ehi.hover)
    eahi.hover_parent = (ehi.hover_parent.x, ehi.hover_parent.y,
                       ehi.hover_parent.w, ehi.hover_parent.h)
    eahi.hover_left = ehi.hover_left
    eahi.hover_right = ehi.hover_right
    eahi.hover_top = ehi.hover_top
    eahi.hover_bottom = ehi.hover_bottom
    return eahi

cdef class Entry(LayoutClass):

    """This is the class that actually implements the widget.

    .. versionchanged:: 1.8
        Inherits from LayoutClass.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """By default, entries are:

        - not scrolled
        - multi-line
        - word wrapped
        - autosave is enabled

        :param parent: The parent object
        :type parent: :py:class:`~efl.elementary.object.Object`

        """
        self._set_obj(elm_entry_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def text_style_user_push(self, style):
        """text_style_user_push(style)

        Push the style to the top of user style stack. If there is styles in the
        user style stack, the properties in the top style of user style stack
        will replace the properties in current theme. The input style is
        specified in format ``tag='property=value'`` (i.e. ``DEFAULT='font=Sans
        font_size=60'hilight=' + font_weight=Bold'``).

        :param string style: The style user to push

        .. versionadded:: 1.8

        """
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_entry_text_style_user_push(self.obj,
            <const_char *>style if style is not None else NULL)

    def text_style_user_pop(self):
        """text_style_user_pop()

        Remove the style in the top of user style stack.

        :seealso: :py:meth:`text_style_user_push`

        .. versionadded:: 1.8

        """
        elm_entry_text_style_user_pop(self.obj)

    def text_style_user_peek(self):
        """text_style_user_peek() -> string

        Retrieve the style on the top of user style stack.

        :return string: style on the top of user style stack if exist, otherwise None.

        :seealso: :py:meth:`text_style_user_push`

        .. versionadded:: 1.8

        """
        return _ctouni(elm_entry_text_style_user_peek(self.obj))

    property single_line:
        """Single line mode.

        In single line mode, entries don't ever wrap when the text reaches the
        edge, and instead they keep growing horizontally. Pressing the ``Enter``
        key will generate an ``"activate"`` event instead of adding a new line.

        When ``single_line`` is ``False``, line wrapping takes effect again
        and pressing enter will break the text into a different line
        without generating any events.

        :type: bool

        """
        def __get__(self):
            return bool(elm_entry_single_line_get(self.obj))

        def __set__(self, single_line):
            elm_entry_single_line_set(self.obj, single_line)

    def single_line_set(self, single_line):
        elm_entry_single_line_set(self.obj, single_line)
    def single_line_get(self):
        return bool(elm_entry_single_line_get(self.obj))

    property password:
        """Sets the entry to password mode.

        In password mode, entries are implicitly single line and the display
        of any text in them is replaced with asterisks (*).

        :type: bool

        """
        def __get__(self):
            return bool(elm_entry_password_get(self.obj))

        def __set__(self, password):
            elm_entry_password_set(self.obj, password)

    def password_set(self, password):
        elm_entry_password_set(self.obj, password)
    def password_get(self):
        return bool(elm_entry_password_get(self.obj))

    property entry:
        """The text displayed within the entry to *entry*.

        .. note:: Setting this bypasses text filters

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_entry_entry_get(self.obj))

        def __set__(self, entry):
            if isinstance(entry, unicode): entry = PyUnicode_AsUTF8String(entry)
            elm_entry_entry_set(self.obj,
                <const_char *>entry if entry is not None else NULL)

    def entry_set(self, entry):
        if isinstance(entry, unicode): entry = PyUnicode_AsUTF8String(entry)
        elm_entry_entry_set(self.obj,
            <const_char *>entry if entry is not None else NULL)
    def entry_get(self):
        return _ctouni(elm_entry_entry_get(self.obj))

    def entry_append(self, text):
        """entry_append(text)

        Appends ``entry`` to the text of the entry.

        Adds the text in ``entry`` to the end of any text already present in
        the widget.

        The appended text is subject to any filters set for the widget.

        :seealso: :py:meth:`markup_filter_append`

        :param string entry: The text to be displayed

        """
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_entry_entry_append(self.obj,
            <const_char *>text if text is not None else NULL)

    property is_empty:
        """Gets whether the entry is empty.

        Empty means no text at all. If there are any markup tags, like an
        item tag for which no provider finds anything, and no text is
        displayed, this function still returns False.

        :type: bool

        """
        def __get__(self):
            return elm_entry_is_empty(self.obj)

    property selection:
        """Gets any selected text within the entry.

        If there's any selected text in the entry, this function returns it as
        a string in markup format. None is returned if no selection exists or
        if an error occurred.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_entry_selection_get(self.obj))

    def selection_get(self):
        return _ctouni(elm_entry_selection_get(self.obj))

    property textblock:
        """Returns the actual textblock object of the entry.

        This function exposes the internal textblock object that actually
        contains and draws the text. This should be used for low-level
        manipulations that are otherwise not possible.

        Changing the textblock directly from here will not notify edje/elm to
        recalculate the textblock size automatically, so any modifications
        done to the textblock returned by this function should be followed by
        a call to :py:func:`calc_force()`.

        The return value is marked as const_as an additional warning.
        One should not use the returned object with any of the generic evas
        functions (geometry_get/resize/move and etc), but only with the textblock
        functions; The former will either not work at all, or break the correct
        functionality.

        IMPORTANT: Many functions may change (i.e delete and create a new one)
        the internal textblock object. Do NOT cache the returned object, and try
        not to mix calls on this object with regular elm_entry calls (which may
        change the internal textblock object). This applies to all cursors
        returned from textblock calls, and all the other derivative values.

        :type: :py:class:`~efl.evas.Textblock`

        """
        def __get__(self):
            return object_from_instance(elm_entry_textblock_get(self.obj))

    def textblock_get(self):
        return object_from_instance(elm_entry_textblock_get(self.obj))

    def calc_force(self):
        """calc_force()

        Forces calculation of the entry size and text layouting.

        This should be used after modifying the textblock object directly.

        :seealso: :py:attr:`textblock`

        """
        elm_entry_calc_force(self.obj)

    def entry_insert(self, entry):
        """entry_insert(entry)

        Inserts the given text into the entry at the current cursor
        position.

        This inserts text at the cursor position as if it was typed by the
        user (note that this also allows markup which a user can't just
        "type" as it would be converted to escaped text, so this call can be
        used to insert things like emoticon items or bold push/pop tags,
        other font and color change tags etc.)

        If any selection exists, it will be replaced by the inserted text.

        The inserted text is subject to any filters set for the widget.

        :seealso: :py:meth:`markup_filter_append`

        :param entry: The text to insert
        :type entry: string

        """
        if isinstance(entry, unicode): entry = PyUnicode_AsUTF8String(entry)
        elm_entry_entry_insert(self.obj,
            <const_char *>entry if entry is not None else NULL)

    property line_wrap:
        """The line wrap type to use on multi-line entries.

        This tells how the text will be implicitly cut into a new line
        (without inserting a line break or paragraph separator) when it
        reaches the far edge of the widget.

        Note that this only makes sense for multi-line entries. A widget set
        to be single line will never wrap.

        :type: :ref:`Elm_Entry_Wrap_Type`

        """
        def __get__(self):
            return elm_entry_line_wrap_get(self.obj)

        def __set__(self, wrap):
            elm_entry_line_wrap_set(self.obj, wrap)

    def line_wrap_set(self, wrap):
        elm_entry_line_wrap_set(self.obj, wrap)
    def line_wrap_get(self):
        return elm_entry_line_wrap_get(self.obj)

    property editable:
        """If the entry is to be editable or not.

        By default, entries are editable and when focused, any text input by
        the user will be inserted at the current cursor position. Setting
        this as False will prevent the user from inputting text into the
        entry.

        The only way to change the text of a non-editable entry is to use
        :py:attr:`~efl.elementary.object.Object.text`, :py:meth:`entry_insert`
        and other related functions and properties.

        :type: bool

        """
        def __get__(self):
            return bool(elm_entry_editable_get(self.obj))

        def __set__(self, bint editable):
            elm_entry_editable_set(self.obj, editable)

    def editable_set(self, bint editable):
        elm_entry_editable_set(self.obj, editable)
    def editable_get(self):
        return bool(elm_entry_editable_get(self.obj))

    def select_none(self):
        """select_none()

        This drops any existing text selection within the entry."""
        elm_entry_select_none(self.obj)

    def select_all(self):
        """select_all()

        This selects all text within the entry."""
        elm_entry_select_all(self.obj)

    def select_region_set(self, int start, int end):
        """select_region_set()

        This selects a region of text within the entry.

        :param start: The starting position
        :type start: int
        :param end: The ending position
        :type end: int

        .. versionadded: 1.9

        """
        elm_entry_select_region_set(self.obj, start, end)

    def cursor_next(self):
        """cursor_next()

        This moves the cursor one place to the right within the entry.

        :return: True upon success, False upon failure
        :rtype: bool

        """
        return bool(elm_entry_cursor_next(self.obj))

    def cursor_prev(self):
        """cursor_prev()

        This moves the cursor one place to the left within the entry.

        :return: True upon success, False upon failure
        :rtype: bool

        """
        return bool(elm_entry_cursor_prev(self.obj))

    def cursor_up(self):
        """cursor_up()

        This moves the cursor one line up within the entry.

        :return: True upon success, False upon failure
        :rtype: bool

        """
        return bool(elm_entry_cursor_up(self.obj))

    def cursor_down(self):
        """cursor_down()

        This moves the cursor one line down within the entry.

        :return: True upon success, False upon failure
        :rtype: bool

        """
        return bool(elm_entry_cursor_down(self.obj))

    def cursor_begin_set(self):
        """cursor_begin_set()

        This moves the cursor to the beginning of the entry."""
        elm_entry_cursor_begin_set(self.obj)

    def cursor_end_set(self):
        """cursor_end_set()

        This moves the cursor to the end of the entry."""
        elm_entry_cursor_end_set(self.obj)

    def cursor_line_begin_set(self):
        """cursor_line_begin_set()

        This moves the cursor to the beginning of the current line."""
        elm_entry_cursor_line_begin_set(self.obj)

    def cursor_line_end_set(self):
        """cursor_line_end_set()

        This moves the cursor to the end of the current line."""
        elm_entry_cursor_line_end_set(self.obj)

    def cursor_selection_begin(self):
        """cursor_selection_begin()

        This begins a selection within the entry as though the user were
        holding down the mouse button to make a selection."""
        elm_entry_cursor_selection_begin(self.obj)

    def cursor_selection_end(self):
        """cursor_selection_end()

        This ends a selection within the entry as though the user had
        just released the mouse button while making a selection."""
        elm_entry_cursor_selection_end(self.obj)

    def cursor_is_format_get(self):
        """cursor_is_format_get() -> bool

        Gets whether a format node exists at the current cursor position.

        A format node is anything that defines how the text is rendered. It
        can be a visible format node, such as a line break or a paragraph
        separator, or an invisible one, such as bold begin or end tag. This
        function returns whether any format node exists at the current
        cursor position.

        :seealso: :py:meth:`cursor_is_visible_format_get`

        :return: True if the current cursor position contains a format node,
            False otherwise.
        :rtype: bool

        """
        return bool(elm_entry_cursor_is_format_get(self.obj))

    def cursor_is_visible_format_get(self):
        """cursor_is_visible_format_get -> bool

        Gets if the current cursor position holds a visible format node.

        :seealso: :py:meth:`cursor_is_format_get`

        :return: True if the current cursor is a visible format, False
            if it's an invisible one or no format exists.
        :rtype: bool

        """
        return bool(elm_entry_cursor_is_visible_format_get(self.obj))

    def cursor_content_get(self):
        """cursor_content_get() -> unicode

        Gets the character pointed by the cursor at its current position.

        This function returns a string with the utf8 character stored at the
        current cursor position.
        Only the text is returned, any format that may exist will not be part
        of the return value.

        :return: The text pointed by the cursors.
        :rtype: unicode

        """
        cdef:
            const_char *text = elm_entry_cursor_content_get(self.obj)
            unicode ret = _ctouni(text)

        free(<void *>text)
        return ret

    def cursor_geometry_get(self):
        """cursor_geometry_get() -> (int x, int y, int w, int h)

        This function returns the geometry of the cursor.

        It's useful if you want to draw something on the cursor (or where it is),
        or for example in the case of scrolled entry where you want to show the
        cursor.

        :return: Geometry (x, y, w, h)
        :rtype: tuple of Evas_Coords (int) or None

        .. versionchanged:: 1.8
            Returns None when the cursor geometry cannot be fetched.

        """
        cdef Evas_Coord x, y, w, h
        if elm_entry_cursor_geometry_get(self.obj, &x, &y, &w, &h):
            return (x, y, w, h)
        else:
            return None

    property cursor_pos:
        """The cursor position in the entry

        The value is the index of the character position within the
        contents of the string.

        :type: int

        """
        def __get__(self):
            return elm_entry_cursor_pos_get(self.obj)

        def __set__(self, pos):
            elm_entry_cursor_pos_set(self.obj, pos)

    def cursor_pos_set(self, pos):
        elm_entry_cursor_pos_set(self.obj, pos)
    def cursor_pos_get(self):
        return elm_entry_cursor_pos_get(self.obj)

    def selection_cut(self):
        """selection_cut()

        This executes a "cut" action on the selected text in the entry."""
        elm_entry_selection_cut(self.obj)

    def selection_copy(self):
        """selection_copy()

        This executes a "copy" action on the selected text in the entry."""
        elm_entry_selection_copy(self.obj)

    def selection_paste(self):
        """selection_paste()

        This executes a "paste" action in the entry."""
        elm_entry_selection_paste(self.obj)

    def context_menu_clear(self):
        """context_menu_clear()

        This clears and frees the items in a entry's contextual (longpress) menu.

        .. seealso:: :py:meth:`context_menu_item_add`

        """
        elm_entry_context_menu_clear(self.obj)

    def context_menu_item_add(self, label = None, icon_file = None, Elm_Icon_Type icon_type = enums.ELM_ICON_NONE, func = None, *args, **kwargs):
        """context_menu_item_add(label=None, icon_file=None, Elm_Icon_Type icon_type=enums.ELM_ICON_NONE, func=None, *args, **kwargs)

        This adds an item to the entry's contextual menu.

        A longpress on an entry will make the contextual menu show up, if this
        hasn't been disabled with :py:attr:`context_menu_disabled`.
        By default, this menu provides a few options like enabling selection mode,
        which is useful on embedded devices that need to be explicit about it,
        and when a selection exists it also shows the copy and cut actions.

        With this function, developers can add other options to this menu to
        perform any action they deem necessary.

        :param label: The item's text label
        :type label: string
        :param icon_file: The item's icon file
        :type icon_file: string
        :param icon_type: The item's icon type
        :type icon_type: string
        :param func: The callback to execute when the item is clicked
        :type func: function

        .. versionadded:: 1.8

        """
        cdef Evas_Smart_Cb cb = NULL
        if func is not None:
            if not callable(func):
                raise TypeError("func is not callable.")
            cb = _entry_context_menu_callback
        data = (func, args, kwargs)

        if isinstance(label, unicode): label = PyUnicode_AsUTF8String(label)
        if isinstance(icon_file, unicode): icon_file = PyUnicode_AsUTF8String(icon_file)

        elm_entry_context_menu_item_add(self.obj,
            <const_char *>label if label is not None else NULL,
            <const_char *>icon_file if icon_file is not None else NULL,
            icon_type,
            cb,
            <void *>data if func is not None else NULL)

    property context_menu_disabled:
        """This disables the entry's contextual (longpress) menu.

        :type: bool

        """
        def __get__(self):
            return elm_entry_context_menu_disabled_get(self.obj)

        def __set__(self, disabled):
            elm_entry_context_menu_disabled_set(self.obj, disabled)

    def context_menu_disabled_set(self, disabled):
        elm_entry_context_menu_disabled_set(self.obj, disabled)
    def context_menu_disabled_get(self):
        return elm_entry_context_menu_disabled_get(self.obj)

    # TODO:
    # def item_provide_append(self, func, data):
    #     """This appends a custom item provider to the list for that entry

    #     This appends the given callback. The list is walked from beginning to end
    #     with each function called given the item href string in the text. If the
    #     function returns an object handle other than NULL (it should create an
    #     object to do this), then this object is used to replace that item. If
    #     not the next provider is called until one provides an item object, or the
    #     default provider in entry does.

    #     :param func: The function called to provide the item object
    #     :param data: The data passed to ``func``

    #     """
    #     elm_entry_item_provider_append(self.obj, Elm_Entry_Item_Provider_Cb func, void *data)

    # TODO:
    # def item_provider_prepend(self, func, data):
    #     """This prepends a custom item provider to the list for that entry

    #     This prepends the given callback. See elm_entry_item_provider_append() for
    #     more information

    #     :param func: The function called to provide the item object
    #     :param data: The data passed to ``func``

    #     """
    #     elm_entry_item_provider_prepend(self.obj, Elm_Entry_Item_Provider_Cb func, void *data)

    # TODO:
    # def item_provider_remove(self, func, data):
    #     """This removes a custom item provider to the list for that entry

    #     This removes the given callback. See elm_entry_item_provider_append() for
    #     more information

    #     :param func: The function called to provide the item object
    #     :param data: The data passed to ``func``

    #     """
    #     elm_entry_item_provider_remove(self.obj, Elm_Entry_Item_Provider_Cb func, void *data)

    def markup_filter_append(self, func, data=None):
        """markup_filter_append(func, data=None)

        Append a markup filter function for text inserted in the entry

        Append the given callback to the list. This functions will be called
        whenever any text is inserted into the entry, with the text to be
        inserted as a parameter. The type of given text is always markup. The
        callback function is free to alter the text in any way it wants. If the
        new text is to be discarded, the function can return None. This will
        also prevent any following filters from being called.

        :param func: The function to use as text filter
        :param data: User data to pass to ``func``

        .. versionadded:: 1.8

        """
        cb_data = (func, data)
        # TODO: This is now a ref leak. It should be stored somewhere and
        #       deleted in the remove method.
        Py_INCREF(cb_data)
        elm_entry_markup_filter_append(self.obj,
            py_elm_entry_filter_cb,
            <void *>cb_data)

    def markup_filter_prepend(self, func, data=None):
        """markup_filter_prepend(func, data=None)

        Prepend a markup filter function for text inserted in the entry

        Prepend the given callback to the list. See
        :py:meth:`markup_filter_append` for more information

        :param func: The function to use as text filter
        :param data: User data to pass to ``func``

        .. versionadded:: 1.8

        """
        cb_data = (func, data)
        Py_INCREF(cb_data)
        elm_entry_markup_filter_prepend(self.obj,
            py_elm_entry_filter_cb,
            <void *>cb_data)

    def markup_filter_remove(self, func, data=None):
        """markup_filter_remove(func, data=None)

        Remove a markup filter from the list

        Removes the given callback from the filter list. See
        :py:meth:`markup_filter_append` for more information

        :param func: The filter function to remove
        :param data: The user data passed when adding the function

        .. versionadded:: 1.8

        """
        cb_data = (func, data)
        Py_INCREF(cb_data)
        elm_entry_markup_filter_remove(self.obj,
            py_elm_entry_filter_cb,
            <void *>cb_data)

    @DEPRECATED("1.8", "Use the module level markup_to_utf8() method instead.")
    def markup_to_utf8(self, string):
        """markup_to_utf8(string)"""
        if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
        return _touni(elm_entry_markup_to_utf8(
            <const_char *>string if string is not None else NULL))

    @DEPRECATED("1.8", "Use the module level utf8_to_markup() method instead.")
    def utf8_to_markup(self, string):
        """utf8_to_markup(string)"""
        if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
        return _touni(elm_entry_utf8_to_markup(
            <const_char *>string if string is not None else NULL))

    property file:
        """The file for the text to display and then edit.

        All changes are written back to the file after a short delay if
        the entry object is set to autosave (which is the default).

        If the entry had any other file set previously, any changes made to it
        will be saved if the autosave feature is enabled, otherwise, the file
        will be silently discarded and any non-saved changes will be lost.

        :type: (unicode **file_name**, :ref:`Elm_Entry_Text_Format` **file_format**)
        :raise RuntimeError: when setting the file fails

        .. versionchanged:: 1.8
            Raise RuntimeError when setting the file fails, instead of
            returning a bool.

        """
        def __get__(self):
            cdef const_char *file
            cdef Elm_Text_Format format
            elm_entry_file_get(self.obj, &file, &format)
            return (_ctouni(file), format)

        def __set__(self, value):
            file_name, file_format = value
            a1 = file_name
            a2 = file_format
            if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
            if not elm_entry_file_set(self.obj,
                <const_char *>a1 if a1 is not None else NULL,
                a2 if a2 is not None else enums.ELM_TEXT_FORMAT_PLAIN_UTF8):
                raise RuntimeError("Could not set file")

    def file_set(self, file_name, file_format):
        a1 = file_name
        a2 = file_format
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if not elm_entry_file_set(self.obj,
            <const_char *>a1 if a1 is not None else NULL,
            a2 if a2 is not None else enums.ELM_TEXT_FORMAT_PLAIN_UTF8):
            raise RuntimeError("Could not set file")
    def file_get(self):
        cdef const_char *file
        cdef Elm_Text_Format format
        elm_entry_file_get(self.obj, &file, &format)
        return (_ctouni(file), format)

    def file_save(self):
        """file_save()

        This function writes any changes made to the file set with
        :py:attr:`file`.

        """
        elm_entry_file_save(self.obj)

    property autosave:
        """Whether the entry object 'autosaves' the loaded text file or not.

        :type: bool

        """
        def __get__(self):
            return elm_entry_autosave_get(self.obj)

        def __set__(self, autosave):
            elm_entry_autosave_set(self.obj, autosave)

    def autosave_set(self, autosave):
        elm_entry_autosave_set(self.obj, autosave)
    def autosave_get(self):
        return elm_entry_autosave_get(self.obj)

    property scrollable:
        """Enable or disable scrolling in entry

        Normally the entry is not scrollable.

        :type: bool

        """
        def __get__(self):
            return bool(elm_entry_scrollable_get(self.obj))

        def __set__(self, scrollable):
            elm_entry_scrollable_set(self.obj, scrollable)

    def scrollable_set(self, scrollable):
        elm_entry_scrollable_set(self.obj, scrollable)
    def scrollable_get(self):
        return bool(elm_entry_scrollable_get(self.obj))

    property icon_visible:
        """Sets the visibility of the end widget of the entry, set by
        ``Entry.part_content_set("icon", content)``.

        :type: bool

        """
        def __set__(self, bint visible):
            elm_entry_icon_visible_set(self.obj, visible)

    def icon_visible_set(self, bint visible):
        elm_entry_icon_visible_set(self.obj, visible)

    property end_visible:
        """Sets the visibility of the end widget of the entry, set by
        ``Entry.part_content_set("end", content)``.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint setting):
            elm_entry_end_visible_set(self.obj, setting)

    def end_visible_set(self, bint setting):
        elm_entry_end_visible_set(self.obj, setting)

    property input_panel_layout:
        """The input panel layout of the entry

        :type: :ref:`Elm_Entry_Input_Panel_Layout`

        """
        def __get__(self):
            return elm_entry_input_panel_layout_get(self.obj)

        def __set__(self, layout):
            elm_entry_input_panel_layout_set(self.obj, layout)

    def input_panel_layout_set(self, layout):
        elm_entry_input_panel_layout_set(self.obj, layout)
    def input_panel_layout_get(self):
        return elm_entry_input_panel_layout_get(self.obj)

    property input_panel_layout_variation:
        """Input panel layout variation of the entry

        :type: int

        .. versionadded:: 1.8

        """
        def __set__(self, int variation):
            elm_entry_input_panel_layout_variation_set(self.obj, variation)

        def __get__(self):
            return elm_entry_input_panel_layout_variation_get(self.obj)

    def input_panel_layout_variation_set(self, int variation):
        elm_entry_input_panel_layout_variation_set(self.obj, variation)

    def input_panel_layout_variation_get(self):
        return elm_entry_input_panel_layout_variation_get(self.obj)

    property input_panel_show_on_demand:
        """Input panel show on demand.

        Set the attribute to show the input panel in case of only
        an user's explicit Mouse Up event.

        :type: bool

        .. versionadded:: 1.9

        """
        def __set__(self, ondemand):
            elm_entry_input_panel_show_on_demand_set(self.obj, ondemand)

        def __get__(self):
            return bool(elm_entry_input_panel_show_on_demand_get(self.obj))

    def input_panel_show_on_demand_set(self, ondemand):
        elm_entry_input_panel_show_on_demand_set(self.obj, ondemand)
    def input_panel_show_on_demand_get(self):
        return bool(elm_entry_input_panel_show_on_demand_get(self.obj))

    property autocapital_type:
        """Autocapitalization type on the immodule.

        :type: :ref:`Elm_Entry_Autocapital_Type`

        .. versionadded:: 1.8

        """
        def __set__(self, Elm_Autocapital_Type autocapital_type):
            elm_entry_autocapital_type_set(self.obj, autocapital_type)

        def __get__(self):
            return elm_entry_autocapital_type_get(self.obj)

    def autocapital_type_set(self, Elm_Autocapital_Type autocapital_type):
        elm_entry_autocapital_type_set(self.obj, autocapital_type)

    def autocapital_type_get(self):
        return elm_entry_autocapital_type_get(self.obj)

    property input_panel_enabled:
        """Whether to show the input panel automatically or not.

        :type: bool

        """
        def __get__(self):
            return bool(elm_entry_input_panel_enabled_get(self.obj))

        def __set__(self, enabled):
            elm_entry_input_panel_enabled_set(self.obj, enabled)

    def input_panel_enabled_set(self, enabled):
        elm_entry_input_panel_enabled_set(self.obj, enabled)
    def input_panel_enabled_get(self):
        return bool(elm_entry_input_panel_enabled_get(self.obj))

    def input_panel_show(self):
        """input_panel_show()

        Show the input panel (virtual keyboard) based on the input panel
        property of entry such as layout, autocapital types, and so on.

        Note that input panel is shown or hidden automatically according to the
        focus state of entry widget.
        This API can be used in the case of manually controlling by using
        *Entry.input_panel_enabled = False*.

        """
        elm_entry_input_panel_show(self.obj)

    def input_panel_hide(self):
        """input_panel_hide()

        Hide the input panel (virtual keyboard).

        Note that input panel is shown or hidden automatically according to the
        focus state of entry widget.
        This API can be used in the case of manually controlling by using
        *Entry.input_panel_enabled_set = False*.

        """
        elm_entry_input_panel_hide(self.obj)

    property input_panel_language:
        """The language mode of the input panel.

        This API can be used if you want to show the alphabet keyboard mode.

        :type: :ref:`Elm_Entry_Input_Panel_Lang`

        """
        def __get__(self):
            return elm_entry_input_panel_language_get(self.obj)

        def __set__(self, lang):
            elm_entry_input_panel_language_set(self.obj, lang)

    def input_panel_language_set(self, lang):
        elm_entry_input_panel_language_set(self.obj, lang)
    def input_panel_language_get(self):
        return elm_entry_input_panel_language_get(self.obj)

    # TODO:
    # def input_panel_imdata_set(self, data, length):
    #     """Set the input panel-specific data to deliver to the input panel.

    #     This API is used by applications to deliver specific data to the input panel.
    #     The data format MUST be negotiated by both application and the input panel.
    #     The size and format of data are defined by the input panel.

    #     :param data: The specific data to be set to the input panel.
    #     :param len: the length of data, in bytes, to send to the input panel

    #     """
    #     elm_entry_input_panel_imdata_set(self.obj, const_void *data, int len)

    # TODO:
    # def input_panel_imdata_get(self, data, length):
    #     """Get the specific data of the current input panel.

    #     See :py:func:`input_panel_imdata_set` for more details.

    #     :param data: The specific data to be got from the input panel
    #     :param len: The length of data

    #     """
    #     elm_entry_input_panel_imdata_get(self.obj, void *data, int *len)

    property input_panel_return_key_type:
        """The "return" key type. This type is used to set string or icon on
        the "return" key of the input panel.

        An input panel displays the string or icon associated with this type

        :type: :ref:`Elm_Entry_Input_Panel_Return_Key_Type`

        """
        def __get__(self):
            return elm_entry_input_panel_return_key_type_get(self.obj)

        def __set__(self, return_key_type):
            elm_entry_input_panel_return_key_type_set(self.obj, return_key_type)

    def input_panel_return_key_type_set(self, return_key_type):
        elm_entry_input_panel_return_key_type_set(self.obj, return_key_type)
    def input_panel_return_key_type_get(self):
        return elm_entry_input_panel_return_key_type_get(self.obj)

    property input_panel_return_key_disabled:
        """Whether the return key on the input panel is disabled or not.

        :type: bool

        """
        def __get__(self):
            return elm_entry_input_panel_return_key_disabled_get(self.obj)

        def __set__(self, disabled):
            elm_entry_input_panel_return_key_disabled_set(self.obj, disabled)

    def input_panel_return_key_disabled_set(self, disabled):
        elm_entry_input_panel_return_key_disabled_set(self.obj, disabled)
    def input_panel_return_key_disabled_get(self):
        return elm_entry_input_panel_return_key_disabled_get(self.obj)

    property input_panel_return_key_autoenabled:
        """Set whether the return key on the input panel is disabled
        automatically when entry has no text.

        If ``enabled`` is True, The return key on input panel is disabled
        when the entry has no text. The return key on the input panel is
        automatically enabled when the entry has text. The default value is
        False.

        :type: bool

        """
        def __set__(self, enabled):
            elm_entry_input_panel_return_key_autoenabled_set(self.obj, enabled)

    def input_panel_return_key_autoenabled_set(self, enabled):
        elm_entry_input_panel_return_key_autoenabled_set(self.obj, enabled)

    def imf_context_reset(self):
        """imf_context_reset()

        Reset the input method context of the entry if needed.

        This can be necessary in the case where modifying the buffer would
        confuse on-going input method behavior. This will typically cause
        the Input Method Context to clear the preedit state.

        """
        elm_entry_imf_context_reset(self.obj)

    property prediction_allow:
        """Whether the entry should allow to use the text prediction.

        :type: bool

        """
        def __get__(self):
            return elm_entry_prediction_allow_get(self.obj)

        def __set__(self, allow):
            elm_entry_prediction_allow_set(self.obj, allow)

    def prediction_allow_set(self, allow):
        elm_entry_prediction_allow_set(self.obj, allow)
    def prediction_allow_get(self):
        return elm_entry_prediction_allow_get(self.obj)

    # TODO:
    # def filter_limit_size(self, data, text):
    #     """Filter inserted text based on user defined character and byte limits

    #     Add this filter to an entry to limit the characters that it will accept
    #     based the contents of the provided #Elm_Entry_Filter_Limit_Size.
    #     The function works on the UTF-8 representation of the string, converting
    #     it from the set markup, thus not accounting for any format in it.

    #     The user must create an #Elm_Entry_Filter_Limit_Size structure and pass
    #     it as data when setting the filter. In it, it's possible to set limits
    #     by character count or bytes (any of them is disabled if 0), and both can
    #     be set at the same time. In that case, it first checks for characters,
    #     then bytes. The #Elm_Entry_Filter_Limit_Size structure must be alive and
    #     valid for as long as the entry is alive AND the elm_entry_filter_limit_size
    #     filter is set.

    #     The function will cut the inserted text in order to allow only the first
    #     number of characters that are still allowed. The cut is made in
    #     characters, even when limiting by bytes, in order to always contain
    #     valid ones and avoid half unicode characters making it in.

    #     This filter, like any others, does not apply when setting the entry text
    #     directly with elm_object_text_set().

    #     """
    #     elm_entry_filter_limit_size(void *data, Evas_Object *entry, char **text)

    # TODO:
    # def filter_accept_set(self, data, text):
    #     """Filter inserted text based on accepted or rejected sets of characters

    #     Add this filter to an entry to restrict the set of accepted characters
    #     based on the sets in the provided #Elm_Entry_Filter_Accept_Set.
    #     This structure contains both accepted and rejected sets, but they are
    #     mutually exclusive. This structure must be available for as long as
    #     the entry is alive AND the elm_entry_filter_accept_set is being used.

    #     The ``accepted`` set takes preference, so if it is set, the filter will
    #     only work based on the accepted characters, ignoring anything in the
    #     ``rejected`` value. If ``accepted`` is ``None``, then ``rejected`` is used.

    #     In both cases, the function filters by matching utf8 characters to the
    #     raw markup text, so it can be used to remove formatting tags.

    #     This filter, like any others, does not apply when setting the entry text
    #     directly with elm_object_text_set()

    #     """
    #     elm_entry_filter_accept_set(void *data, Evas_Object *entry, char **text)

    # TODO:
    # property imf_context:
    #     """Input method context of the entry.

    #     IMPORTANT: Many functions may change (i.e delete and create a new one)
    #     the internal input method context. Do NOT cache the returned object.

    #     :return: The input method context (Ecore_IMF_Context *) in entry.

    #     """
    #     def __get__(self):
    #         void *elm_entry_imf_context_get(self.obj)

    # def imf_context_get(self):
    #     void *elm_entry_imf_context_get(self.obj)

    property cnp_mode:
        """Control pasting of text and images for the widget.

        Normally the entry allows both text and images to be pasted.
        By setting cnp_mode to be *ELM_CNP_MODE_NO_IMAGE*, this prevents
        images from being copy or past. By setting cnp_mode to be
        *ELM_CNP_MODE_PLAINTEXT*, this remove all tags in text .

        .. note:: This only changes the behaviour of text.

        :type: :ref:`Elm_Entry_Cnp_Mode`

        """
        def __get__(self):
            return elm_entry_cnp_mode_get(self.obj)

        def __set__(self, mode):
            elm_entry_cnp_mode_set(self.obj, mode)

    def cnp_mode_set(self, mode):
        elm_entry_cnp_mode_set(self.obj, mode)
    def cnp_mode_get(self):
        return elm_entry_cnp_mode_get(self.obj)

    property anchor_hover_parent:
        """Parent of the hover popup

        The parent object to use by the hover created by the entry when an
        anchor is clicked. See :py:class:`~efl.elementary.hover.Hover` for more
        details on this.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            cdef Evas_Object *anchor_hover_parent
            anchor_hover_parent = elm_entry_anchor_hover_parent_get(self.obj)
            return object_from_instance(anchor_hover_parent)

        def __set__(self, evasObject anchor_hover_parent):
            elm_entry_anchor_hover_parent_set(self.obj, anchor_hover_parent.obj)

    def anchor_hover_parent_set(self, evasObject anchor_hover_parent):
        elm_entry_anchor_hover_parent_set(self.obj, anchor_hover_parent.obj)
    def anchor_hover_parent_get(self):
        cdef Evas_Object *anchor_hover_parent
        anchor_hover_parent = elm_entry_anchor_hover_parent_get(self.obj)
        return object_from_instance(anchor_hover_parent)

    property anchor_hover_style:
        """The style that the hover should use

        When creating the popup hover, entry will request that it's
        themed according to *style*.

        Setting style to ``None`` means disabling automatic hover.

        :seealso: :py:attr:`~efl.elementary.object.Object.style`

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_entry_anchor_hover_style_get(self.obj))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_entry_anchor_hover_style_set(self.obj,
                <const_char *>style if style is not None else NULL)

    def anchor_hover_style_set(self, style):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_entry_anchor_hover_style_set(self.obj,
            <const_char *>style if style is not None else NULL)
    def anchor_hover_style_get(self):
        return _ctouni(elm_entry_anchor_hover_style_get(self.obj))

    def anchor_hover_end(self):
        """anchor_hover_end()

        Ends the hover popup in the entry

        When an anchor is clicked, the entry widget will create a hover
        object to use as a popup with user provided content. This function
        terminates this popup, returning the entry to its normal state.

        """
        elm_entry_anchor_hover_end(self.obj)


    # Copy and paste
    def cnp_selection_get(self, selection, format):
        """cnp_selection_get(selection, format)

        Retrieve data from a widget that has a selection.

        Gets the current selection data from a widget.

        .. seealso::

            :py:func:`efl.elementary.object.Object.cnp_selection_get`

        :param selection: Selection type for copying and pasting
        :param format: Selection format

        :return bool: Whether getting cnp data is successful or not.

        """
        return bool(elm_cnp_selection_get(
            self.obj, selection, format, NULL, NULL))


    def callback_changed_add(self, func, *args, **kwargs):
        """The text within the entry was changed."""
        self._callback_add("changed", func, *args, **kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_changed_user_add(self, func, *args, **kwargs):
        """The text within the entry was changed because of user interaction."""
        self._callback_add("changed,user", func, *args, **kwargs)

    def callback_changed_user_del(self, func):
        self._callback_del("changed,user", func)

    def callback_activated_add(self, func, *args, **kwargs):
        """The enter key was pressed on a single line entry."""
        self._callback_add("activated", func, *args, **kwargs)

    def callback_activated_del(self, func):
        self._callback_del("activated", func)

    def callback_aborted_add(self, func, *args, **kwargs):
        """The enter key was pressed on a single line entry."""
        self._callback_add("aborted", func, *args, **kwargs)

    def callback_aborted_del(self, func):
        self._callback_del("aborted", func)

    def callback_press_add(self, func, *args, **kwargs):
        """A mouse button has been pressed on the entry."""
        self._callback_add("press", func, *args, **kwargs)

    def callback_press_del(self, func):
        self._callback_del("press", func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        """A mouse button has been pressed and held for a couple seconds."""
        self._callback_add("longpressed", func, *args, **kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del("longpressed", func)

    def callback_clicked_add(self, func, *args, **kwargs):
        """The entry has been clicked (mouse press and release)."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_double_clicked_add(self, func, *args, **kwargs):
        """The entry has been double clicked."""
        self._callback_add("clicked,double", func, *args, **kwargs)

    def callback_double_clicked_del(self, func):
        self._callback_del("clicked,double", func)

    def callback_triple_clicked_add(self, func, *args, **kwargs):
        """The entry has been triple clicked."""
        self._callback_add("clicked,triple", func, *args, **kwargs)

    def callback_triple_clicked_del(self, func):
        self._callback_del("clicked,triple", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """The entry has received focus."""
        self._callback_add("focused", func, *args, **kwargs)

    def callback_focused_del(self, func):
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """The entry has lost focus."""
        self._callback_add("unfocused", func, *args, **kwargs)

    def callback_unfocused_del(self, func):
        self._callback_del("unfocused", func)

    def callback_selection_paste_add(self, func, *args, **kwargs):
        """A paste of the clipboard contents was requested."""
        self._callback_add("selection,paste", func, *args, **kwargs)

    def callback_selection_paste_del(self, func):
        self._callback_del("selection,paste", func)

    def callback_selection_copy_add(self, func, *args, **kwargs):
        """A copy of the selected text into the clipboard was requested."""
        self._callback_add("selection,copy", func, *args, **kwargs)

    def callback_selection_copy_del(self, func):
        self._callback_del("selection,copy", func)

    def callback_selection_cut_add(self, func, *args, **kwargs):
        """A cut of the selected text into the clipboard was requested."""
        self._callback_add("selection,cut", func, *args, **kwargs)

    def callback_selection_cut_del(self, func):
        self._callback_del("selection,cut", func)

    def callback_selection_start_add(self, func, *args, **kwargs):
        """A selection has begun and no previous selection existed."""
        self._callback_add("selection,start", func, *args, **kwargs)

    def callback_selection_start_del(self, func):
        self._callback_del("selection,start", func)

    def callback_selection_changed_add(self, func, *args, **kwargs):
        """The current selection has changed."""
        self._callback_add("selection,changed", func, *args, **kwargs)

    def callback_selection_changed_del(self, func):
        self._callback_del("selection,changed", func)

    def callback_selection_cleared_add(self, func, *args, **kwargs):
        """The current selection has been cleared."""
        self._callback_add("selection,cleared", func, *args, **kwargs)

    def callback_selection_cleared_del(self, func):
        self._callback_del("selection,cleared", func)

    def callback_cursor_changed_add(self, func, *args, **kwargs):
        """The cursor has changed position."""
        self._callback_add("cursor,changed", func, *args, **kwargs)

    def callback_cursor_changed_del(self, func):
        self._callback_del("cursor,changed", func)

    def callback_anchor_clicked_add(self, func, *args, **kwargs):
        """An anchor has been clicked. The event_info
        parameter for the callback will be an :py:class:`EntryAnchorInfo`.

        """
        self._callback_add_full("anchor,clicked", _entryanchor_conv,
                                func, *args, **kwargs)

    def callback_anchor_clicked_del(self, func):
        self._callback_del_full("anchor,clicked", _entryanchor_conv,
                                func)

    def callback_anchor_in_add(self, func, *args, **kwargs):
        """Mouse cursor has moved into an anchor. The event_info
        parameter for the callback will be an :py:class:`EntryAnchorInfo`.

        """
        self._callback_add_full("anchor,in", _entryanchor_conv,
                                func, *args, **kwargs)

    def callback_anchor_in_del(self, func):
        self._callback_del_full("anchor,in", _entryanchor_conv,
                                func)

    def callback_anchor_out_add(self, func, *args, **kwargs):
        """Mouse cursor has moved out of an anchor. The event_info
        parameter for the callback will be an :py:class:`EntryAnchorInfo`.

        """
        self._callback_add_full("anchor,out", _entryanchor_conv,
                                func, *args, **kwargs)

    def callback_anchor_out_del(self, func):
        self._callback_del_full("anchor,out", _entryanchor_conv,
                                func)

    def callback_anchor_up_add(self, func, *args, **kwargs):
        """Mouse button has been unpressed on an anchor. The event_info
        parameter for the callback will be an :py:class:`EntryAnchorInfo`.

        """
        self._callback_add_full("anchor,up", _entryanchor_conv,
                                func, *args, **kwargs)

    def callback_anchor_up_del(self, func):
        self._callback_del_full("anchor,up", _entryanchor_conv,
                                func)

    def callback_anchor_down_add(self, func, *args, **kwargs):
        """Mouse button has been pressed on an anchor. The event_info
        parameter for the callback will be an :py:class:`EntryAnchorInfo`.

        """
        self._callback_add_full("anchor,down", _entryanchor_conv,
                                func, *args, **kwargs)

    def callback_anchor_down_del(self, func):
        self._callback_del_full("anchor,down", _entryanchor_conv,
                                func)

    def callback_anchor_hover_opened_add(self, func, *args, **kwargs):
        self._callback_add_full("anchor,hover,opened", _entryanchorhover_conv,
                                func, *args, **kwargs)

    def callback_anchor_hover_opened_del(self, func):
        self._callback_del_full("anchor,hover,opened", _entryanchorhover_conv,
                                func)

    def callback_preedit_changed_add(self, func, *args, **kwargs):
        """The preedit string has changed."""
        self._callback_add("preedit,changed", func, *args, **kwargs)

    def callback_preedit_changed_del(self, func):
        self._callback_del("preedit,changed", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """Program language changed."""
        self._callback_add("language,changed", func, *args, **kwargs)

    def callback_language_changed_del(self, func):
        self._callback_del("language,changed", func)

    def callback_text_set_done_add(self, func, *args, **kwargs):
        """Whole text has been set to the entry."""
        self._callback_add("text,set,done", func, *args, **kwargs)

    def callback_text_set_done_del(self, func):
        self._callback_del("text,set,done", func)

    def callback_rejected_add(self, func, *args, **kwargs):
        """Called when some of inputs are rejected by the filter.

        .. versionadded:: 1.9

        """
        self._callback_add("rejected", func, *args, **kwargs)

    def callback_text_set_done_del(self, func):
        self._callback_del("rejected", func)


    property scrollbar_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.scrollbar_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scrollbar_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scrollbar_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scrollbar_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)


_object_mapping_register("Elm_Entry", Entry)
