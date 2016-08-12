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


cdef class Rectangle(Object):
    """

    A rectangle.

    There is only one function to deal with rectangle objects, this may make
    this function seem useless given there are no functions to manipulate
    the created rectangle, however the rectangle is actually very useful and
    should be manipulated using the generic :py:class:`efl.evas.Object`
    functions.

    The evas rectangle serves a number of key functions when working on evas
    programs:

    - Debugging
    - Clipper

    .. rubric:: Debugging

    Debugging is a major part of any programmers task and when debugging
    visual issues with evas programs the rectangle is an extremely useful
    tool. The rectangle's simplicity means that it's easier to pinpoint
    issues with it than with more complex objects. Therefore a common
    technique to use when writing an evas program and not getting the
    desired visual result is to replace the misbehaving object for a solid
    color rectangle and seeing how it interacts with the other elements,
    this often allows us to notice clipping, parenting or positioning
    issues. Once the issues have been identified and corrected the rectangle
    can be replaced for the original part and in all likelihood any
    remaining issues will be specific to that object's type.

    .. rubric:: Clipping

    Clipping serves two main functions:

    - Limiting visibility(i.e. hiding portions of an object).
    - Applying a layer of color to an object.

    .. rubric:: Limiting visibility

    It is often necessary to show only parts of an object, while it may be
    possible to create an object that corresponds only to the part that must
    be shown (and it isn't always possible) it's usually easier to use a a
    clipper. A clipper is a rectangle that defines what's visible and what
    is not. The way to do this is to create a solid white rectangle(which is
    the default, no need to call :func:`efl.evas.Object.color_set`) and give
    it a position and size of what should be visible. The following code
    exemplifies showing the center half of ``my_evas_object``::

        clipper = Rectangle(evas_canvas)
        clipper.move(my_evas_object_x / 4, my_evas_object_y / 4)
        clipper.resize(my_evas_object_width / 2, my_evas_object_height / 2)
        my_evas_object.clip_set(clipper)
        clipper.show()


    .. rubric:: Layer of color

    In the *clipping* section we used a solid white clipper, which produced
    no change in the color of the clipped object, it just hid what was
    outside the clippers area. It is however sometimes desirable to change
    the of color an object, this can be accomplished using a clipper that
    has a non-white color. Clippers with color work by multiplying the
    colors of clipped object. The following code will show how to remove all
    the red from an object::

        clipper = Rectangle(evas_canvas)
        clipper.move(my_evas_object_x, my_evas_object_y)
        clipper.resize(my_evas_object_width, my_evas_object_height)
        clipper.color_set(0, 255, 255, 255)
        my_evas_object.clip_set(clipper)
        clipper.show()

    """
    def __init__(self, Canvas canvas not None, **kwargs):
        """Rectangle(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance
        
        """
        self._set_obj(evas_object_rectangle_add(canvas.obj))
        self._set_properties_from_keyword_args(kwargs)


_object_mapping_register("Efl_Canvas_Rectangle", Rectangle)
