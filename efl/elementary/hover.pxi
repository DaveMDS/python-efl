# Copyright (C) 2007-2016 various contributors (see AUTHORS)
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

include "hover_cdef.pxi"

cdef class Hover(LayoutClass):
    """

    This is the class that actually implement the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Hover(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_hover_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def target_set(self, evasObject target):
        elm_hover_target_set(self.obj, target.obj)

    def target_get(self):
        return object_from_instance(elm_hover_target_get(self.obj))

    property target:
        """The target object for the hover.

        Setting this will cause the hover to be centered on the target object.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_hover_target_get(self.obj))
        def __set__(self, evasObject target):
            elm_hover_target_set(self.obj, target.obj)

    def parent_set(self, evasObject parent):
        elm_hover_parent_set(self.obj, parent.obj)

    def parent_get(self):
        return object_from_instance(elm_hover_parent_get(self.obj))

    property parent:
        """The parent object for the hover.

        This will cause the hover to take up the entire space that the
        parent object fills.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __set__(self, evasObject parent):
            elm_hover_parent_set(self.obj, parent.obj)

        def __get__(self):
            return object_from_instance(elm_hover_parent_get(self.obj))

    def best_content_location_get(self, pref_axis):
        """Returns the best swallow location for content in the hover.

        Best is defined here as the location at which there is the most
        available space.

        If :attr:`ELM_HOVER_AXIS_HORIZONTAL` is chosen the returned position
        will necessarily be along the horizontal axis("left" or "right"). If
        :attr:`ELM_HOVER_AXIS_VERTICAL` is chosen the returned position will
        necessarily be along the vertical axis("top" or "bottom"). Choosing
        :attr:`ELM_HOVER_AXIS_BOTH` or :attr:`ELM_HOVER_AXIS_NONE` has the same
        effect and the returned position may be in either axis.

        .. seealso:: :py:meth:`~efl.elementary.object.Object.part_content_set`

        :param pref_axis: The preferred orientation axis for the hover
            object to use
        :type pref_axis: :ref:`Elm_Hover_Axis`

        :return: The edje location to place content into the hover or *None*,
            on errors.
        :rtype: string

        """
        return _ctouni(elm_hover_best_content_location_get(self.obj, pref_axis))

    def dismiss(self):
        """Dismiss a hover object

        Use this function to simulate clicking outside the hover to dismiss
        it. In this way, the hover will be hidden and the "clicked" signal
        will be emitted.

        """
        elm_hover_dismiss(self.obj)

    def callback_clicked_add(self, func, *args, **kwargs):
        """the user clicked the empty space in the hover to dismiss"""
        self._callback_add("clicked", func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_dismissed_add(self, func, *args, **kwargs):
        """the user clicked the empty space in the hover to dismiss

        .. versionadded:: 1.8.1

        """
        self._callback_add("dismissed", func, args, kwargs)

    def callback_dismissed_del(self, func):
        self._callback_del("dismissed", func)

    def callback_smart_changed_add(self, func, *args, **kwargs):
        """a content object placed under the "smart" policy was replaced to a
        new slot direction."""
        self._callback_add("smart,changed", func, args, kwargs)

    def callback_smart_changed_del(self, func):
        self._callback_del("smart,changed", func)


_object_mapping_register("Elm_Hover", Hover)
