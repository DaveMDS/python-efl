.. currentmodule:: efl.elementary

Configuration
#############

Description
===========

Elementary configuration is formed by a set options bounded to a
given profile, like theme, "finger size", etc.

These are functions with which one synchronizes changes made to those
values to the configuration storing files, de facto. You most probably
don't want to use the functions in this group unless you're writing an
elementary configuration manager.

Profiles
========

Profiles are pre-set options that affect the whole look-and-feel of
Elementary-based applications. There are, for example, profiles
aimed at desktop computer applications and others aimed at mobile,
touchscreen-based ones. You most probably don't want to use the
functions in this group unless you're writing an elementary
configuration manager.

Elementary Scrolling
====================

These set how scrollable views in Elementary widgets should behave on
user interaction.

Password show last
==================

Show last feature of password mode enables user to view the last input
entered for few seconds before masking it. These functions allow to set
this feature in password mode of entry widget and also allow to
manipulate the duration for which the input has to be visible.

Elementary Engine
=================

These are functions setting and querying which rendering engine
Elementary will use for drawing its windows' pixels.

The following are the available engines:

- "software_x11"
- "fb"
- "directfb"
- "software_16_x11"
- "software_8_x11"
- "xrender_x11"
- "opengl_x11"
- "software_gdi"
- "software_16_wince_gdi"
- "sdl"
- "software_16_sdl"
- "opengl_sdl"
- "buffer"
- "ews"
- "opengl_cocoa"
- "psl1ght"


ATSPI AT-SPI2 Accessibility
===========================

Elementary widgets support Linux Accessibility standard. For more
information please visit:
http://www.linuxfoundation.org/collaborate/workgroups/accessibility/atk/at-spi/at-spi_on_d-bus


Enumerations
============

.. _Elm_Softcursor_Mode:

Elm_Softcursor_Mode
-------------------

.. data:: ELM_SOFTCURSOR_MODE_AUTO

    Auto-detect if a software cursor should be used (default)

.. data:: ELM_SOFTCURSOR_MODE_ON

    Always use a softcursor

.. data:: ELM_SOFTCURSOR_MODE_OFF

    Never use a softcursor


.. _Elm_Slider_Indicator_Visible_Mode:

Elm_Slider_Indicator_Visible_Mode
---------------------------------

.. data:: ELM_SLIDER_INDICATOR_VISIBLE_MODE_DEFAULT

    show indicator on mouse down or change in slider value

.. data:: ELM_SLIDER_INDICATOR_VISIBLE_MODE_ALWAYS

    Always show the indicator

.. data:: ELM_SLIDER_INDICATOR_VISIBLE_MODE_ON_FOCUS

    Show the indicator on focus

.. data:: ELM_SLIDER_INDICATOR_VISIBLE_MODE_NONE

    Never show the indicator


.. _Edje_Channel:

Audio Channels
--------------

.. data:: EDJE_CHANNEL_EFFECT

    Standard audio effects

.. data:: EDJE_CHANNEL_BACKGROUND

    Background audio sounds

.. data:: EDJE_CHANNEL_MUSIC

    Music audio

.. data:: EDJE_CHANNEL_FOREGROUND

    Foreground audio sounds

.. data:: EDJE_CHANNEL_INTERFACE

    Sounds related to the interface

.. data:: EDJE_CHANNEL_INPUT

    Sounds related to regular input

.. data:: EDJE_CHANNEL_ALERT

    Sounds for major alerts

.. data:: EDJE_CHANNEL_ALL

    All audio channels (convenience)


Inheritance diagram
===================

.. inheritance-diagram:: Configuration
    :parts: 2

.. autoclass:: Configuration
