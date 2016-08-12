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

"""

A GLView widget allows for simple GL rendering in elementary environment.
GLView hides all the complicated evas_gl details so that the user only
has to deal with registering a few callback functions for rendering
to a surface using OpenGL APIs.


Enumerations
============

.. _Elm_GLView_Mode:

GLView Mode
-----------

Defines mode of GLView

.. data:: ELM_GLVIEW_NONE

    None

.. data:: ELM_GLVIEW_ALPHA

    Alpha channel enabled rendering mode

.. data:: ELM_GLVIEW_DEPTH

    Depth buffer enabled rendering mode

.. data:: ELM_GLVIEW_STENCIL

    Stencil buffer enabled rendering mode

.. data:: ELM_GLVIEW_DIRECT

    Direct rendering optimization hint


.. _Elm_GLView_Resize_Policy:

GLView Resize Policy
--------------------

Defines a policy for the glview resizing.

The resizing policy tells glview what to do with the underlying
surface when resize happens. ELM_GLVIEW_RESIZE_POLICY_RECREATE
will destroy the current surface and recreate the surface to the
new size.  ELM_GLVIEW_RESIZE_POLICY_SCALE will instead keep the
current surface but only display the result at the desired size
scaled.

.. note:: Default is ELM_GLVIEW_RESIZE_POLICY_RECREATE

.. data:: ELM_GLVIEW_RESIZE_POLICY_RECREATE

    Resize the internal surface along with the image

.. data:: ELM_GLVIEW_RESIZE_POLICY_SCALE

    Only resize the internal image and not the surface


.. _Elm_GLView_Render_Policy:

GLView Render Policy
--------------------

Defines a policy for gl rendering.

The rendering policy tells glview where to run the gl rendering code.
ELM_GLVIEW_RENDER_POLICY_ON_DEMAND tells glview to call the rendering
calls on demand, which means that the rendering code gets called
only when it is visible.

.. note:: Default is ELM_GLVIEW_RENDER_POLICY_ON_DEMAND

.. data:: ELM_GLVIEW_RENDER_POLICY_ON_DEMAND

    Render only when there is a need for redrawing

.. data:: ELM_GLVIEW_RENDER_POLICY_ALWAYS

    Render always even when it is not visible


"""

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.evas cimport Object as evasObject
from layout_class cimport LayoutClass

import traceback


cdef void py_elm_glview_init_func_cb(Evas_Object *obj):
    assert obj != NULL
    o = object_from_instance(obj)
    try:
        o.init_func(o)
    except Exception:
        traceback.print_exc()

cdef void py_elm_glview_del_func_cb(Evas_Object *obj):
    assert obj != NULL
    o = object_from_instance(obj)
    try:
        o.del_func(o)
    except Exception:
        traceback.print_exc()

cdef void py_elm_glview_resize_func_cb(Evas_Object *obj):
    assert obj != NULL
    o = object_from_instance(obj)
    try:
        o.resize_func(o)
    except Exception:
        traceback.print_exc()

cdef void py_elm_glview_render_func_cb(Evas_Object *obj):
    assert obj != NULL
    o = object_from_instance(obj)
    try:
        o.render_func(o)
    except Exception:
        traceback.print_exc()

cdef class GLView(LayoutClass):
    """

    This is the class that actually implements the widget.

    """

    cdef object init_func_cb, del_func_cb, resize_func_cb, render_func_cb

    def __init__(self, evasObject parent, *args, **kwargs):
        """GLView(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_glview_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    # TODO:
    # def gl_api_get(self):
    #     """

    #     Get the gl api struct for gl rendering

    #     :return: The api object or None if it cannot be created

    #     """
    #     cdef Evas_GL_API *obj = elm_glview_gl_api_get(self.obj)
    #     assert obj != NULL
    #     cdef EvasGLAPI ret = EvasGLAPI.__new__(EvasGLAPI)
    #     ret.obj = obj
    #     return ret

    def mode_set(self, Elm_GLView_Mode mode):
        """

        Set the mode of the GLView. Supports alpha, depth, stencil.

        :param Elm_GLView_Mode mode: The mode Options OR'ed enabling Alpha, Depth, Stencil, Direct.
        :raise RuntimeError: on failure

        Direct is a hint for the elm_glview to render directly to the window
        given that the right conditions are met. Otherwise it falls back
        to rendering to an offscreen buffer before it gets composited to the
        window.

        """
        if not elm_glview_mode_set(self.obj, mode):
            raise RuntimeError

    def resize_policy_set(self, Elm_GLView_Resize_Policy policy):
        """

        Set the resize policy for the glview object.

        :param Elm_GLView_Resize_Policy policy: The scaling policy.
        :raise RuntimeError: on failure

        By default, the resize policy is set to ELM_GLVIEW_RESIZE_POLICY_RECREATE.
        When resize is called it destroys the previous surface and recreates the
        newly specified size. If the policy is set to
        ELM_GLVIEW_RESIZE_POLICY_SCALE, however, glview only scales the image
        object and not the underlying GL Surface.

        """
        if not elm_glview_resize_policy_set(self.obj, policy):
            raise RuntimeError

    def render_policy_set(self, Elm_GLView_Render_Policy policy):
        """

        Set the render policy for the glview object.

        :param Elm_GLView_Render_Policy policy: The render policy.
        :raise RuntimeError: on failure

        By default, the render policy is set to ELM_GLVIEW_RENDER_POLICY_ON_DEMAND.
        This policy is set such that during the render loop, glview is only
        redrawn if it needs to be redrawn. (i.e. when it is visible) If the policy
        is set to ELM_GLVIEW_RENDER_POLICY_ALWAYS, it redraws regardless of
        whether it is visible or needs redrawing.

        """
        if not elm_glview_render_policy_set(self.obj, policy):
            raise RuntimeError

    property size:
        """

        Size of the glview

        Note that this returns the actual image size of the
        glview.  This means that when the scale policy is set to
        ELM_GLVIEW_RESIZE_POLICY_SCALE, it'll return the non-scaled
        size.

        :param int w: width of the glview object
        :param int h: height of the glview object

        """
        def __set__(self, value):
            cdef Evas_Coord w, h
            w, h = value
            elm_glview_size_set(self.obj, w, h)

        def __get__(self):
            cdef Evas_Coord w, h
            elm_glview_size_get(self.obj, &w, &h)
            return w, h

    def size_set(self, Evas_Coord w, Evas_Coord h):
        elm_glview_size_set(self.obj, w, h)
    def size_get(self):
        cdef Evas_Coord w, h
        elm_glview_size_get(self.obj, &w, &h)
        return w, h

    def init_func_set(self, func):
        """

        Set the init function that runs once in the main loop.

        :param func: The init function to be registered.

        The registered init function gets called once during the render loop.
        This function allows glview to hide all the rendering context/surface
        details and have the user just call GL calls that they desire
        for initialization GL calls.

        """
        assert callable(func) == True
        self.init_func_cb = func
        elm_glview_init_func_set(self.obj, py_elm_glview_init_func_cb)

    def del_func_set(self, func):
        """

        Set the render function that runs in the main loop.

        :param func: The delete function to be registered.

        The registered del function gets called when GLView object is deleted.
        This function allows glview to hide all the rendering context/surface
        details and have the user just call GL calls that they desire
        when delete happens.

        """
        assert callable(func) == True
        self.del_func_cb = func
        elm_glview_del_func_set(self.obj, py_elm_glview_del_func_cb)

    def resize_func_set(self, func):
        """

        Set the resize function that gets called when resize happens.

        :param func: The resize function to be registered.

        The resize function gets called during the render loop.
        This function allows glview to hide all the rendering context/surface
        details and have the user just call GL calls that they desire
        when resize happens.

        """
        assert callable(func) == True
        self.resize_func_cb = func
        elm_glview_resize_func_set(self.obj, py_elm_glview_resize_func_cb)

    def render_func_set(self, func):
        """

        Set the render function that runs in the main loop.

        The render function gets called in the main loop but whether it runs
        depends on the rendering policy and whether elm_glview_changed_set()
        gets called.

        :param func: The render function to be registered.

        """
        assert callable(func) == True
        self.render_func_cb = func
        elm_glview_render_func_set(self.obj, py_elm_glview_render_func_cb)

    def changed_set(self):
        """

        Notifies that there has been changes in the GLView.

        """
        elm_glview_changed_set(self.obj)


_object_mapping_register("Elm_Glview", GLView)
