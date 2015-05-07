.. currentmodule:: efl.elementary

Theme
#####


Description
===========

Elementary uses Edje to theme its widgets, naturally. But for the most
part this is hidden behind a simpler interface that lets the user set
extensions and choose the style of widgets in a much easier way.

Instead of thinking in terms of paths to Edje files and their groups
each time you want to change the appearance of a widget, Elementary
works so you can add any theme file with extensions or replace the
main theme at one point in the application, and then just set the style
of widgets with
:py:attr:`Object.style<efl.elementary.object.Object.style>`
and related functions. Elementary
will then look in its list of themes for a matching group and apply it,
and when the theme changes midway through the application, all widgets
will be updated accordingly.

There are three concepts you need to know to understand how Elementary
theming works: default theme, extensions and overlays.

Default theme, obviously enough, is the one that provides the default
look of all widgets. End users can change the theme used by Elementary
by setting the ``ELM_THEME`` environment variable before running an
application, or globally for all programs using the ``elementary_config``
utility. Applications can change the default theme using :py:attr:`Theme.order`,
but this can go against the user wishes, so it's not an advised practice.

Ideally, applications should find everything they need in the already
provided theme, but there may be occasions when that's not enough and
custom styles are required to correctly express the idea. For this
cases, Elementary has extensions.

Extensions allow the application developer to write styles of its own
to apply to some widgets. This requires knowledge of how each widget
is themed, as extensions will always replace the entire group used by
the widget, so important signals and parts need to be there for the
object to behave properly (see documentation of Edje for details).
Once the theme for the extension is done, the application needs to add
it to the list of themes Elementary will look into, using
:py:func:`Theme.extension_add()`, and set the style of the desired widgets as
he would normally with
:py:attr:`Object.style<efl.elementary.object.Object.style>`.

Overlays, on the other hand, can replace the look of all widgets by
overriding the default style. Like extensions, it's up to the application
developer to write the theme for the widgets it wants, the difference
being that when looking for the theme, Elementary will check first the
list of overlays, then the set theme and lastly the list of extensions,
so with overlays it's possible to replace the default view and every
widget will be affected. This is very much alike to setting the whole
theme for the application and will probably clash with the end user
options, not to mention the risk of ending up with not matching styles
across the program. Unless there's a very special reason to use them,
overlays should be avoided for the reasons exposed before.

All these theme lists are handled by :py:class:`Theme` instances. Elementary
keeps one default internally. It's possible to create a new instance of a
:py:class:`Theme` to set other theme for a specific widget (and all of its
children), but this is as discouraged, if not even more so, than using
overlays. Don't use this unless you really know what you are doing.

.. note::

    Remember to :py:func:`Theme.free` the instance when you're done with it!


Inheritance diagram
===================

.. inheritance-diagram:: Theme
    :parts: 2


.. autoclass:: Theme
