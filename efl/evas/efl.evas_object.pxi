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

from cpython cimport Py_INCREF, Py_DECREF
from efl.utils.conversions cimport eina_list_objects_to_python_list


cdef int _object_free_wrapper_resources(Object obj) except 0:
    cdef int i
    for i from 0 <= i < evas_object_event_callbacks_len:
        obj._event_callbacks[i] = None
    return 1


cdef int _object_unregister_callbacks(Object obj) except 0:
    cdef Evas_Object *o
    cdef Evas_Object_Event_Cb cb
    o = obj.obj
    if o != NULL:
        for i, lst in enumerate(obj._event_callbacks):
            if lst is not None:
                cb = evas_object_event_callbacks[i]
                evas_object_event_callback_del(o, i, cb)

    evas_object_event_callback_del(o, EVAS_CALLBACK_FREE, obj_free_cb)
    return 1


cdef void obj_free_cb(void *data, Evas *e,
                      Evas_Object *obj, void *event_info) with gil:
    cdef Object self = <Object>data

    lst = self._event_callbacks[<int>EVAS_CALLBACK_FREE]

    if lst is not None:
        for func, args, kargs in lst:
            try:
                func(self, *args, **kargs)
            except Exception:
                traceback.print_exc()

    _object_unregister_callbacks(self)
    _object_free_wrapper_resources(self)
    Py_DECREF(self)


# cdef _object_register_decorated_callbacks(obj):
#     if not hasattr(obj, "__evas_event_callbacks__"):
#         return
#
#     for attr_name, evt in obj.__evas_event_callbacks__:
#         attr_value = getattr(obj, attr_name)
#         obj.event_callback_add(evt, attr_value)


cdef _object_add_callback_to_list(Object obj, int type, func, args, kargs):
    if type < 0 or type >= evas_object_event_callbacks_len:
        raise ValueError("Invalid callback type")

    r = (func, args, kargs)
    lst = obj._event_callbacks[type]
    if lst is not None:
        lst.append(r)
        return False
    else:
        obj._event_callbacks[type] = [r]
        return True


cdef _object_del_callback_from_list(Object obj, int type, func):
    if type < 0 or type >= evas_object_event_callbacks_len:
        raise ValueError("Invalid callback type")

    lst = obj._event_callbacks[type]
    if not lst:
        raise ValueError("Callback %s was not registered with type %d" %
                         (func, type))

    i = None
    for i, r in enumerate(lst):
        if func == r[0]:
            break
    else:
        raise ValueError("Callback %s was not registered with type %d" %
                         (func, type))

    lst.pop(i)
    if len(lst) == 0:
        obj._event_callbacks[type] = None
        return True
    else:
        return False


cdef class Object(Eo):
    """

    Basic Graphical Object (or actor).

    Objects are managed by :py:class:`Canvas <efl.evas.Canvas>` in a non-
    immediate way, that is, all operations, like moving, resizing, changing the
    color, etc will not trigger immediate repainting, instead it will save the
    new state and mark both this object and its Canvas as "dirty" so can be
    redrawn on :py:func:`Canvas.render() <efl.evas.Canvas.render>` (usually
    called by the underlying system, when you're entering idle. This means that
    doesn't matter how many times you're moving an object between frame updates:
    just the last state will be used, that's why you really should do animations
    using :py:func:`~efl.ecore.Animator` instead of
    :py:class:`~efl.ecore.Timer`, since it will call registered functions in one
    batch and then trigger redraw, instead of calling one function, then redraw,
    then the next function, and redraw...

    The most important concept for evas object is *clipping*
    (:py:attr:`clip`), usually done by use of
    :py:class:`~efl.evas.Rectangle` as clipper. Clip objects will
    affect the drawing behavior:

    - Limiting visibility
    - Limiting geometry
    - Modulating color

    Clips respects the hierarchy: the minimum area and the composed color
    will be used used at the end, if one object is not visible, the lower
    objects (clipped by it) will not be visible as well. Clipping is the
    recommended way of doing fade out/in effect, instead of changing object's
    color, clip it to a rectangle and change its color: this will work as
    expected with every object, unlike directly changing color that just
    work for :py:class:`Images <efl.evas.Image>`

    As with every evas component, colors should be specified in
    **pre-multiplied** format, see :py:func:`efl.evas.color_parse` and
    :py:func:`efl.evas.color_argb_premul`.

    Objects can be grouped by means of :py:class:`SmartObject`, a virtual class
    that can have it's methods implemented in order to apply methods to its
    children.

    .. warning::

        Since we have two systems controlling object's life (Evas and Python)
        objects need to be explicitly deleted using :py:func:`delete` call. If
        this call is not issued, the Python object will not be released, but if
        the object is deleted by Evas (ie: due parent deletion), the object will
        become "shallow" and all operations will either have no effect or raise
        exceptions. You can be notified of object deletion by
        ``EVAS_CALLBACK_FREE``

    .. seealso::

        :py:func:`efl.evas.Object.on_free_add`
        :py:func:`efl.evas.Object.event_callback_add`

    """
    def __cinit__(self):
        self._event_callbacks = [None] * evas_object_event_callbacks_len

    def __init__(self, *args, **kwargs):
        if type(self) is Object:
            raise TypeError("Must not instantiate Object, but subclasses")

    def __repr__(self):
        cdef:
            const char *name = evas_object_name_get(self.obj)
            bint clipped = evas_object_clip_get(self.obj) is not NULL
            int layer = evas_object_layer_get(self.obj)
            bint visible = evas_object_visible_get(self.obj)
            int x, y, w, h
            int r, g, b, a

        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        evas_object_color_get(self.obj, &r, &g, &b, &a)

        name_str = "name=%s, " % name if name is not NULL else ""

        return ("<%s (%s geometry=(%d, %d, %d, %d), color=(%d, %d, %d, %d), "
                "layer=%s, clip=%s, visible=%s)>") % (
            Eo.__repr__(self),
            name_str,
            x, y, w, h,
            r, g, b, a,
            layer, clipped, visible)

    cdef int _set_obj(self, Evas_Object *obj) except 0:
        Eo._set_obj(self, obj)
        evas_object_event_callback_add(obj, EVAS_CALLBACK_FREE,
                                       obj_free_cb, <void *>self)
        Py_INCREF(self)

        return 1

    cdef int _set_properties_from_keyword_args(self, dict kwargs) except 0:
        color = kwargs.pop("color", None)
        if color is not None:
            self.color_set(*color_parse(color))
        return Eo._set_properties_from_keyword_args(self, kwargs)

    def delete(self):
        """delete()

        Delete object and free it's internal (wrapped) resources.

        .. note:: after this operation the object will be still alive in
            Python, but it will be shallow and every operation
            will have no effect (and may raise exceptions).

        :raise ValueError: if object already deleted.

        """
        evas_object_del(self.obj)

    property evas:
        """ The evas Canvas that owns this object.

        :type: :py:class:`efl.evas.Canvas`

        """
        def __get__(self):
            return object_from_instance(evas_object_evas_get(self.obj))

    def evas_get(self):
        return object_from_instance(evas_object_evas_get(self.obj))

    def smart_member_add(self, SmartObject parent):
        """

        Set this object as a member of the parent object.

        Members will automatically be stacked and layered with the smart
        object. The various stacking function will operate on members relative
        to the other members instead of the entire canvas.

        Non-member objects can not interleave a smart object's members.

        :note: if this object is already member of another SmartObject, it
           will be deleted from that membership and added to the given object.
        """
        evas_object_smart_member_add(self.obj, parent.obj)

    def smart_member_del(self):
        """Removes this object as a member of a smart object."""
        evas_object_smart_member_del(self.obj)


    def show(self):
        """show()

        Show the object.

        """
        evas_object_show(self.obj)

    def hide(self):
        """hide()

        Hide the object.

        """
        evas_object_hide(self.obj)

    property visible:
        """Whenever it's visible or not.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_visible_get(self.obj))

        def __set__(self, spec):
            if spec:
                self.show()
            else:
                self.hide()

    def visible_get(self):
        return bool(evas_object_visible_get(self.obj))
    def visible_set(self, spec):
        if spec:
            self.show()
        else:
            self.hide()

    property precise_is_inside:
        """Set whether to use precise (usually expensive) point collision
        detection for a given Evas object.

        Use this function to make Evas treat objects' transparent areas as
        **not** belonging to it with regard to mouse pointer events. By
        default, all of the object's boundary rectangle will be taken in
        account for them.

        :type: bool

        .. warning:: By using precise point collision detection you'll be
            making Evas more resource intensive.

        """
        def __set__(self, precise):
            evas_object_precise_is_inside_set(self.obj, precise)

        def __get__(self):
            return bool(evas_object_precise_is_inside_get(self.obj))

    def precise_is_inside_set(self, precise):
        evas_object_precise_is_inside_set(self.obj, precise)

    def precise_is_inside_get(self):
        return bool(evas_object_precise_is_inside_get(self.obj))

    property static_clip:
        """A hint flag on the object, whether this is used as a static clipper
        or not.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_static_clip_get(self.obj))

        def __set__(self, value):
            evas_object_static_clip_set(self.obj, value)

    def static_clip_get(self):
        return bool(evas_object_static_clip_get(self.obj))
    def static_clip_set(self, int value):
        evas_object_static_clip_set(self.obj, value)

    property render_op:
        """Render operation used at drawing.

        :type: Evas_Render_Op

        """
        def __get__(self):
            return evas_object_render_op_get(self.obj)

        def __set__(self, int value):
            evas_object_render_op_set(self.obj, <Evas_Render_Op>value)

    def render_op_get(self):
        return evas_object_render_op_get(self.obj)
    def render_op_set(self, int value):
        evas_object_render_op_set(self.obj, <Evas_Render_Op>value)

    property anti_alias:
        """If anti-aliased primitives should be used.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_anti_alias_get(self.obj))

        def __set__(self, int value):
            evas_object_anti_alias_set(self.obj, value)

    def anti_alias_get(self):
        return bool(evas_object_anti_alias_get(self.obj))
    def anti_alias_set(self, int value):
        evas_object_anti_alias_set(self.obj, value)

    property scale:
        """The scaling factor for an Evas object. Does not affect all objects.

        Value of ``1.0`` means no scaling, default size.

        This will multiply the object's dimension by the given factor, thus
        altering its geometry (width and height). Useful when you want
        scalable UI elements, possibly at run time.

        :type: double

        .. note:: Only text and textblock objects have scaling change
            handlers. Other objects won't change visually on this call.

        """
        def __set__(self, scale):
            evas_object_scale_set(self.obj, scale)

        def __get__(self):
            return evas_object_scale_get(self.obj)

    def scale_set(self, double scale):
        evas_object_scale_set(self.obj, scale)

    def scale_get(self):
        return evas_object_scale_get(self.obj)

    property color:
        """Object's (r, g, b, a) color, in pre-multiply colorspace.

        :type: (int **r**, int **g**, int **b**, int **a**)

        """

        def __get__(self):
            cdef int r, g, b, a
            evas_object_color_get(self.obj, &r, &g, &b, &a)
            return (r, g, b, a)

        def __set__(self, color):
            cdef int r, g, b, a
            r, g, b, a = color
            evas_object_color_set(self.obj, r, g, b, a)

    def color_set(self, int r, int g, int b, int a):
        evas_object_color_set(self.obj, r, g, b, a)
    def color_get(self):
        cdef int r, g, b, a
        evas_object_color_get(self.obj, &r, &g, &b, &a)
        return (r, g, b, a)

    property clip:
        """Object's clipper.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(evas_object_clip_get(self.obj))

        def __set__(self, value):
            cdef Evas_Object *clip
            cdef Object o
            if value is None:
                evas_object_clip_unset(self.obj)
            elif isinstance(value, Object):
                o = <Object>value
                clip = o.obj
                evas_object_clip_set(self.obj, clip)
            else:
                raise ValueError("clip must be evas.Object or None")

        def __del__(self):
            evas_object_clip_unset(self.obj)

    def clip_get(self):
        return object_from_instance(evas_object_clip_get(self.obj))

    def clip_set(self, value):
        cdef Evas_Object *clip
        cdef Object o
        if value is None:
            evas_object_clip_unset(self.obj)
        elif isinstance(value, Object):
            o = <Object>value
            clip = o.obj
            evas_object_clip_set(self.obj, clip)
        else:
            raise ValueError("clip must be evas.Object or None")

    def clip_unset(self):
        evas_object_clip_unset(self.obj)

    property clipees:
        """Objects that this object clips.

        :type: tuple of :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return self.clipees_get()

    def clipees_get(self):
        return eina_list_objects_to_python_list(evas_object_clipees_get(self.obj))

    property name:
        """Object name or *None*.

        :type: string

        """
        def __get__(self):
            return _ctouni(evas_object_name_get(self.obj))

        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            evas_object_name_set(self.obj,
                <const char *>value if value is not None else NULL)

    def name_get(self):
        return _ctouni(evas_object_name_get(self.obj))
    def name_set(self, value):
        if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
        evas_object_name_set(self.obj,
            <const char *>value if value is not None else NULL)

    property focus:
        """Whenever object currently have the focus.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_focus_get(self.obj))

        def __set__(self, value):
            evas_object_focus_set(self.obj, value)

    def focus_get(self):
        return bool(evas_object_focus_get(self.obj))
    def focus_set(self, value):
        evas_object_focus_set(self.obj, value)

    property pointer_mode:
        """If pointer should be grabbed while processing events.

        If *EVAS_OBJECT_POINTER_MODE_AUTOGRAB*, then when mouse is
        down at this object, events will be restricted to it as source, mouse
        moves, for example, will be emitted even if outside this object area.

        If *EVAS_OBJECT_POINTER_MODE_NOGRAB*, then events will be emitted
        just when inside this object area.

        The default value is *EVAS_OBJECT_POINTER_MODE_AUTOGRAB*.

        :type: Evas_Object_Pointer_Mode

        """
        def __get__(self):
            return <int>evas_object_pointer_mode_get(self.obj)

        def __set__(self, int value):
            evas_object_pointer_mode_set(self.obj, <Evas_Object_Pointer_Mode>value)

    def pointer_mode_get(self):
        return <int>evas_object_pointer_mode_get(self.obj)
    def pointer_mode_set(self, int value):
        evas_object_pointer_mode_set(self.obj, <Evas_Object_Pointer_Mode>value)

    property smart_parent:
        """Object that this object is member of, or *None*.

        :type: :py:class:`efl.evas.Object`

        .. versionchanged:: 1.14

            This was renamed from ``parent`` as it was clashing with
            :py:meth:`efl.eo.Eo.parent_get` and is more correct in regards to
            C api naming.

        """
        def __get__(self):
            cdef Evas_Object *obj
            obj = evas_object_smart_parent_get(self.obj)
            return object_from_instance(obj)

    def smart_parent_get(self):
        cdef Evas_Object *obj
        obj = evas_object_smart_parent_get(self.obj)
        return object_from_instance(obj)

    property map_enabled:
        """Map enabled state

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_map_enable_get(self.obj))
        def __set__(self, value):
            evas_object_map_enable_set(self.obj, bool(value))

    def map_enabled_set(self, enabled):
        evas_object_map_enable_set(self.obj, bool(enabled))
    def map_enabled_get(self):
        return bool(evas_object_map_enable_get(self.obj))

    property map:
        """Map

        :type: :py:class:`Map`

        """
        def __get__(self):
            cdef Map ret = Map.__new__(Map)
            ret.map = <Evas_Map *>evas_object_map_get(self.obj)
            return ret
        def __set__(self, Map m):
            evas_object_map_set(self.obj, m.map)

    def map_set(self, Map m):
        evas_object_map_set(self.obj, m.map)

    def map_get(self):
        cdef Map ret = Map.__new__(Map)
        ret.map = <Evas_Map *>evas_object_map_get(self.obj)
        return ret

    def key_grab(self, keyname not None, Evas_Modifier_Mask modifiers, Evas_Modifier_Mask not_modifiers, bint exclusive):
        """Requests ``keyname`` key events be directed to ``obj``.

        :param keyname: the key to request events for.
        :param modifiers: a mask of modifiers that must be present to
            trigger the event.
        :type modifiers: Evas_Modifier_Mask
        :param not_modifiers: a mask of modifiers that must **not** be present
            to trigger the event.
        :type not_modifiers: Evas_Modifier_Mask
        :param exclusive: request that the ``obj`` is the only object
            receiving the ``keyname`` events.
        :type exclusive: bool
        :raise RuntimeError: if grabbing the key was unsuccesful

        Key grabs allow one or more objects to receive key events for
        specific key strokes even if other objects have focus. Whenever a
        key is grabbed, only the objects grabbing it will get the events
        for the given keys.

        ``keyname`` is a platform dependent symbolic name for the key
        pressed

        ``modifiers`` and ``not_modifiers`` are bit masks of all the
        modifiers that must and mustn't, respectively, be pressed along
        with ``keyname`` key in order to trigger this new key
        grab. Modifiers can be things such as Shift and Ctrl as well as
        user defined types via evas_key_modifier_add(). Retrieve them with
        evas_key_modifier_mask_get() or use ``0`` for empty masks.

        ``exclusive`` will make the given object the only one permitted to
        grab the given key. If given ``EINA_TRUE``, subsequent calls on this
        function with different ``obj`` arguments will fail, unless the key
        is ungrabbed again.

        .. warning:: Providing impossible modifier sets creates undefined behavior

        :see: evas_object_key_ungrab
        :see: evas_object_focus_set
        :see: evas_object_focus_get
        :see: evas_focus_get
        :see: evas_key_modifier_add

        """
        if isinstance(keyname, unicode): keyname = PyUnicode_AsUTF8String(keyname)
        if not evas_object_key_grab(self.obj, <const char *>keyname, modifiers, not_modifiers, exclusive):
            raise RuntimeError("Could not grab key.")

    def key_ungrab(self, keyname not None, Evas_Modifier_Mask modifiers, Evas_Modifier_Mask not_modifiers):
        """Removes the grab on ``keyname`` key events by ``obj``.

        :param keyname: the key the grab is set for.
        :param modifiers: a mask of modifiers that must be present to
            trigger the event.
        :param not_modifiers: a mask of modifiers that must not not be
            present to trigger the event.

        Removes a key grab on ``obj`` if ``keyname``, ``modifiers``, and
        ``not_modifiers`` match.

        :see: evas_object_key_grab
        :see: evas_object_focus_set
        :see: evas_object_focus_get
        :see: evas_focus_get

        """
        if isinstance(keyname, unicode): keyname = PyUnicode_AsUTF8String(keyname)
        evas_object_key_ungrab(self.obj, <const char *>keyname, modifiers, not_modifiers)

    property is_frame_object:
        """:type: bool"""
        def __set__(self, bint is_frame):
            evas_object_is_frame_object_set(self.obj, is_frame)

        def __get__(self):
            return bool(evas_object_is_frame_object_get(self.obj))

    def is_frame_object_set(self, bint is_frame):
        evas_object_is_frame_object_set(self.obj, is_frame)

    def is_frame_object_get(self):
        return bool(evas_object_is_frame_object_get(self.obj))

    property paragraph_direction:
        """This handles text paragraph direction of the object.

        Even if the object is not textblock or text, its smart child objects
        can inherit the paragraph direction from the object.

        The default paragraph direction is EVAS_BIDI_DIRECTION_INHERIT.

        :type: :ref:`Evas_BiDi_Direction`

        .. versionadded:: 1.17

        """
        def __set__(self, Evas_BiDi_Direction direction):
            evas_object_paragraph_direction_set(self.obj, direction)

        def __get__(self):
            return evas_object_paragraph_direction_get(self.obj)

    ##################
    #### Stacking ####
    ##################

    property layer:
        """Object's layer number.

        :type: int

        """
        def __set__(self, int layer):
            evas_object_layer_set(self.obj, layer)

        def __get__(self):
            return evas_object_layer_get(self.obj)

    def layer_set(self, int layer):
        evas_object_layer_set(self.obj, layer)
    def layer_get(self):
        return evas_object_layer_get(self.obj)


    def raise_(self):
        """Raise to the top of its layer."""
        evas_object_raise(self.obj)

    def lower(self):
        """Lower to the bottom of its layer. """
        evas_object_lower(self.obj)

    def stack_above(self, Object above):
        """Reorder to be above the given one.

        :param above:
        :type above: :py:class:`efl.evas.Object`

        """
        evas_object_stack_above(self.obj, above.obj)

    def stack_below(self, Object below):
        """Reorder to be below the given one.

        :param below:
        :type below: :py:class:`efl.evas.Object`

        """
        evas_object_stack_below(self.obj, below.obj)

    property above:
        """ The object above this.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(evas_object_above_get(self.obj))

    def above_get(self):
        return object_from_instance(evas_object_above_get(self.obj))

    property below:
        """ The object below this.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(evas_object_below_get(self.obj))

    def below_get(self):
        return object_from_instance(evas_object_below_get(self.obj))

    property top:
        """The topmost object.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return self.evas.top_get()

    def top_get(self):
        return self.evas.top_get()

    property bottom:
        """The bottommost object.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return self.evas.bottom_get()

    def bottom_get(self):
        return self.evas.bottom_get()


    ########################
    #### Pixel geometry ####
    ########################

    property geometry:
        """Object's position and size.

        :type: (int **x**, int **y**, int **w**, int **h**)

        """
        def __get__(self):
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x, y, w, h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y, w, h = spec
            evas_object_move(self.obj, x, y)
            evas_object_resize(self.obj, w, h)

    def geometry_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)
    def geometry_set(self, int x, int y, int w, int h):
        evas_object_move(self.obj, x, y)
        evas_object_resize(self.obj, w, h)

    property size:
        """Object's size (width and height).

        :type: (int **w**, int **h**)

        """
        def __get__(self):
            cdef int w, h
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            return (w, h)

        def __set__(self, spec):
            cdef int w, h
            w, h = spec
            evas_object_resize(self.obj, w, h)

    def size_get(self):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        return (w, h)
    def size_set(self, int w, int h):
        evas_object_resize(self.obj, w, h)

    def resize(self, int w, int h):
        """Same as assigning to :py:attr:`size`.

        :param w: Width.
        :type w: int
        :param h: Height.
        :type h: int

        """
        evas_object_resize(self.obj, w, h)

    property pos:
        """Object's position on the X and Y coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y
            evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
            return (x, y)

        def __set__(self, spec):
            cdef int x, y
            x, y = spec
            evas_object_move(self.obj, x, y)

    def pos_get(self):
        cdef int x, y
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        return (x, y)
    def pos_set(self, int x, int y):
        evas_object_move(self.obj, x, y)

    property top_left:
        """Object's top-left corner coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y
            evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
            return (x, y)

        def __set__(self, spec):
            cdef int x, y
            x, y = spec
            evas_object_move(self.obj, x, y)

    def top_left_get(self):
        cdef int x, y
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        return (x, y)
    def top_left_set(self, int x, int y):
        evas_object_move(self.obj, x, y)

    property top_center:
        """The coordinates of the top-center position.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w
            evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
            return (x + w/2, y)

        def __set__(self, spec):
            cdef int x, y, w
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
            evas_object_move(self.obj, x - w/2, y)

    def top_center_get(self):
        cdef int x, y, w
        evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
        return (x + w/2, y)
    def top_center_set(self, int x, int y):
        cdef int w
        evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
        evas_object_move(self.obj, x - w/2, y)

    property top_right:
        """Object's top-right corner coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w
            evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
            return (x + w, y)

        def __set__(self, spec):
            cdef int x, y, w
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
            evas_object_move(self.obj, x - w, y)

    def top_right_get(self):
        cdef int x, y, w
        evas_object_geometry_get(self.obj, &x, &y, &w, NULL)
        return (x + w, y)
    def top_right_set(self, int x, int y):
        cdef int w
        evas_object_geometry_get(self.obj, NULL, NULL, &w, NULL)
        evas_object_move(self.obj, x - w, y)

    property left_center:
        """The coordinates of the left-center position.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, h
            evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
            return (x, y + h/2)

        def __set__(self, spec):
            cdef int x, y, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
            evas_object_move(self.obj, x, y - h/2)

    def left_center_get(self):
        cdef int x, y, h
        evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
        return (x, y + h/2)
    def left_center_set(self, int x, int y):
        cdef int h
        evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
        evas_object_move(self.obj, x, y - h/2)

    property right_center:
        """The coordinates of the right-center position.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w, y + h/2)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w, y - h/2)

    def right_center_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w, y + h/2)
    def right_center_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w, y - h/2)

    property bottom_left:
        """Object's bottom-left corner coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, h
            evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
            return (x, y + h)

        def __set__(self, spec):
            cdef int x, y, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
            evas_object_move(self.obj, x, y - h)

    def bottom_left_get(self):
        cdef int x, y, h
        evas_object_geometry_get(self.obj, &x, &y, NULL, &h)
        return (x, y + h)
    def bottom_left_set(self, int x, int y):
        cdef int h
        evas_object_geometry_get(self.obj, NULL, NULL, NULL, &h)
        evas_object_move(self.obj, x, y - h)

    property bottom_center:
        """Object's bottom-center coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w/2, y + h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w/2, y - h)

    def bottom_center_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w/2, y + h)
    def bottom_center_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w/2, y - h)

    property bottom_right:
        """Object's bottom-right corner coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            return (x + w, y + h)

        def __set__(self, spec):
            cdef int x, y, w, h
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            evas_object_move(self.obj, x - w, y - h)

    def bottom_right_get(self):
        cdef int x, y, w, h
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        return (x + w, y + h)
    def bottom_right_set(self, int x, int y):
        cdef int w, h
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        evas_object_move(self.obj, x - w, y - h)

    property center:
        """Object's center coordinates.

        :type: (int **x**, int **y**)

        """
        def __get__(self): # replicated to avoid performance hit
            cdef int x, y, w, h, x2, y2
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            x2 = x + w/2
            y2 = y + h/2
            return (x2, y2)

        def __set__(self, spec):
            cdef int x, y, w, h, x2, y2
            x, y = spec
            evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
            x2 = x - w/2
            y2 = y - h/2
            evas_object_move(self.obj, x2, y2)

    def center_get(self):
        cdef int x, y, w, h, x2, y2
        evas_object_geometry_get(self.obj, &x, &y, &w, &h)
        x2 = x + w/2
        y2 = y + h/2
        return (x2, y2)
    def center_set(self, int x, int y):
        cdef int w, h, x2, y2
        evas_object_geometry_get(self.obj, NULL, NULL, &w, &h)
        x2 = x - w/2
        y2 = y - h/2
        evas_object_move(self.obj, x2, y2)

    property rect:
        """A rectangle representing the object's geometry.

        Rectangles have useful operations like clip, clamp, union and
        also provides various attributes like top_left, center_x, ...

        .. note::

            The rectangle you receive is a snapshot of current state, it
            is not synchronized to the object, so modifying attributes WILL NOT
            change the object itself! You must assign it back to this property
            to update object information.

        :type: :py:class:`efl.evas.Rect`

        """
        def __get__(self):
            cdef:
                int x, y, w, h
                Rect ret = Rect.__new__(Rect)
            evas_object_geometry_get(self.obj, &x, &y, &w, &h)
            ret.x0 = x
            ret.y0 = y
            ret._w = w
            ret._h = h
            ret.x1 = x + w
            ret.cx = x + w/2
            ret.y1 = y + h
            ret.cy = y + h/2
            return ret

        def __set__(self, spec):
            cdef Rect r
            if isinstance(spec, Rect):
                r = spec
            else:
                r = Rect(spec)
            evas_object_move(self.obj, r.x0, r.y0)
            evas_object_resize(self.obj, r._w, r._h)


    def move(self, int x, int y):
        """Same as assigning to :py:attr:`pos`.

        :param x:
        :type x: int
        :param y:
        :type y: int

        """
        evas_object_move(self.obj, x, y)

    def move_relative(self, int dx, int dy):
        """Move relatively to objects current position.

        :param dx:
        :type dx: int
        :param dy:
        :type dy: int

        """
        cdef int x, y, x2, y2
        evas_object_geometry_get(self.obj, &x, &y, NULL, NULL)
        x2 = x + dx
        y2 = y + dy
        evas_object_move(self.obj, x2, y2)


    ####################
    #### Size hints ####
    ####################

    property size_hint_min:
        """Hints for an object's minimum size.

        This is not an enforcement, just a hint that can be used by
        other objects like Edje, boxes, tables and others.

        Values ``0`` will be treated as unset hint components, when queried
        by managers.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS
        will be emitted.

        :type: (int **w**, int **h**)

        .. note::

            Smart objects (such as elementary) can have their own size hint
            policy. So calling this API may or may not affect the size of smart
            objects.

        """
        def __get__(self):
            cdef int w, h
            evas_object_size_hint_min_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, spec):
            w, h = spec
            evas_object_size_hint_min_set(self.obj, w, h)

    def size_hint_min_get(self):
        cdef int w, h
        evas_object_size_hint_min_get(self.obj, &w, &h)
        return (w, h)
    def size_hint_min_set(self, int w, int h):
        evas_object_size_hint_min_set(self.obj, w, h)

    property size_hint_max:
        """The hints for an object's maximum size.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        Values ``-1`` will be treated as unset hint components, when queried by
        managers.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (int **w**, int **h**)

        .. note::

            Smart objects(such as elementary) can have their own size hint
            policy. So calling this API may or may not affect the size of smart
            objects.

        """
        def __get__(self):
            cdef int w, h
            evas_object_size_hint_max_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, spec):
            w, h = spec
            evas_object_size_hint_max_set(self.obj, w, h)

    def size_hint_max_get(self):
        cdef int w, h
        evas_object_size_hint_max_get(self.obj, &w, &h)
        return (w, h)
    def size_hint_max_set(self, int w, int h):
        evas_object_size_hint_max_set(self.obj, w, h)

    property size_hint_display_mode:
        """The hints for an object's display mode

        This is not a size enforcement in any way, it's just a hint that can be
        used whenever appropriate. This mode can be used objects display mode
        like compress or expand.

        This can be used for objects display mode like compress or expand.

        :type: :ref:`Evas_Display_Mode`

        """
        def __get__(self):
            return evas_object_size_hint_display_mode_get(self.obj)

        def __set__(self, Evas_Display_Mode dispmode):
            evas_object_size_hint_display_mode_set(self.obj, dispmode)

    def size_hint_display_mode_get(self):
        return evas_object_size_hint_display_mode_get(self.obj)

    def size_hint_display_mode_set(self, Evas_Display_Mode dispmode):
        evas_object_size_hint_display_mode_set(self.obj, dispmode)

    property size_hint_request:
        """The hints for an object's optimum size.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        Value 0 is disabled.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (int **w**, int **h**)

        .. note::

            Smart objects(such as elementary) can have their own size hint
            policy. So calling this API may or may not affect the size of smart
            objects.

        """
        def __get__(self):
            cdef int w, h
            evas_object_size_hint_request_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, spec):
            w, h = spec
            evas_object_size_hint_request_set(self.obj, w, h)

    def size_hint_request_get(self):
        cdef int w, h
        evas_object_size_hint_request_get(self.obj, &w, &h)
        return (w, h)
    def size_hint_request_set(self, int w, int h):
        evas_object_size_hint_request_set(self.obj, w, h)

    property size_hint_aspect:
        """The hints for an object's aspect ratio.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        Aspect EVAS_ASPECT_CONTROL_NONE is disabled.

        If any of the given aspect ratio terms are ``0``, the object's
        container will ignore the aspect and scale the object to occupy the
        whole available area, for any given policy.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (:ref:`Evas_Aspect_Control` **aspect**, int **w**, int **h**)

        .. note::

            Smart objects (such as elementary) can have their own size hint
            policy. So calling this API may or may not affect the size of smart
            objects.

        """
        def __get__(self):
            cdef int w, h
            cdef Evas_Aspect_Control aspect
            evas_object_size_hint_aspect_get(self.obj, &aspect, &w, &h)
            return (<int>aspect, w, h)

        def __set__(self, spec):
            aspect, w, h = spec
            evas_object_size_hint_aspect_set(   self.obj,
                                                <Evas_Aspect_Control>aspect,
                                                w, h)

    def size_hint_aspect_get(self):
        cdef int w, h
        cdef Evas_Aspect_Control aspect
        evas_object_size_hint_aspect_get(self.obj, &aspect, &w, &h)
        return (<int>aspect, w, h)
    def size_hint_aspect_set(self, int aspect, int w, int h):
        evas_object_size_hint_aspect_set(self.obj, <Evas_Aspect_Control>aspect,
                                         w, h)

    property size_hint_align:
        """The hints for an object's alignment.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        These are hints on how to align an object **inside the boundaries of a
        container/manager**. Accepted values are in the ``0.0`` to ``1.0``
        range, with the special value :attr:`EVAS_HINT_FILL` used to specify
        "justify" or "fill" by some users. In this case, maximum size hints
        should be enforced with higher priority, if they are set. Also, any
        padding hint set on objects should add up to the alignment space on the
        final scene composition.

        For the horizontal component, ``0.0`` means to the left, ``1.0`` means
        to the right. Analogously, for the vertical component, ``0.0`` to the
        top, ``1.0`` means to the bottom.

        .. note:: Default alignment hint values are 0.5, for both axis.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (float **x**, float **y**)

        .. seealso:: :ref:`evas-size-hints`

        """
        def __get__(self):
            cdef double x, y
            evas_object_size_hint_align_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, spec):
            x, y = spec
            evas_object_size_hint_align_set(self.obj, x, y)

    def size_hint_align_get(self):
        cdef double x, y
        evas_object_size_hint_align_get(self.obj, &x, &y)
        return (x, y)
    def size_hint_align_set(self, double x, double y):
        evas_object_size_hint_align_set(self.obj, x, y)

    property size_hint_fill:
        """Hint about fill.

        This is just a convenience property to make it easier to understand
        that **align** is also used for **fill** properties (as fill is mutually
        exclusive to align).
        This is **exactly** the same as using :attr:`size_hint_align`

        :type: (float **x**, float **y**)

        .. seealso:: :ref:`evas-size-hints`

        .. versionadded:: 1.13

        """
        def __get__(self):
            cdef double x, y
            evas_object_size_hint_fill_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, spec):
            x, y = spec
            evas_object_size_hint_fill_set(self.obj, x, y)

    def size_hint_fill_get(self):
        cdef double x, y
        evas_object_size_hint_fill_get(self.obj, &x, &y)
        return (x, y)
    def size_hint_fill_set(self, double x, double y):
        evas_object_size_hint_fill_set(self.obj, x, y)

    property size_hint_weight:
        """Hint about weight.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        This is a hint on how a container object should **resize** a given
        child within its area. Containers may adhere to the simpler logic of
        just expanding the child object's dimensions to fit its own (see the
        :attr:`EVAS_HINT_EXPAND` helper weight macro) or the complete one of
        taking each child's weight hint as real **weights** to how much of its
        size to allocate for them in each axis. A container is supposed to,
        after **normalizing** the weights of its children (with weight hints),
        distribute the space it has to layout them by those factors -- most
        weighted children get larger in this process than the least ones.

        Accepted values are zero or positive values. Some users might use this
        hint as a boolean, but some might consider it as a **proportion**, see
        documentation of possible users, which in Evas are the :class:`Box` and
        :class:`Table` smart objects.

        .. note:: Default weight hint values are ``0.0``, for both axis.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (float **x**, float **y**)

        .. seealso:: :ref:`evas-size-hints`

        """
        def __get__(self):
            cdef double x, y
            evas_object_size_hint_weight_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, spec):
            x, y = spec
            evas_object_size_hint_weight_set(self.obj, x, y)

    def size_hint_weight_get(self):
        cdef double x, y
        evas_object_size_hint_weight_get(self.obj, &x, &y)
        return (x, y)
    def size_hint_weight_set(self, double x, double y):
        evas_object_size_hint_weight_set(self.obj, x, y)

    property size_hint_expand:
        """Hint about expand.

        This is just a convenience property to make it easier to understand
        that **weight** is also used for **expand** properties.
        This is **exactly** the same as using :attr:`size_hint_weight`

        :type: (float **x**, float **y**)

        .. seealso:: :ref:`evas-size-hints`

        .. versionadded:: 1.13

        """
        def __get__(self):
            cdef double x, y
            evas_object_size_hint_expand_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, spec):
            x, y = spec
            evas_object_size_hint_expand_set(self.obj, x, y)

    def size_hint_expand_get(self):
        cdef double x, y
        evas_object_size_hint_expand_get(self.obj, &x, &y)
        return (x, y)
    def size_hint_expand_set(self, double x, double y):
        evas_object_size_hint_expand_set(self.obj, x, y)

    property size_hint_padding:
        """The hints for an object's padding space.

        This is not an enforcement, just a hint that can be used by other
        objects like Edje, boxes, tables and others.

        Padding is extra space an object takes on each of its delimiting
        rectangle sides, in canvas units. This space will be rendered
        transparent.

        When this property changes, EVAS_CALLBACK_CHANGED_SIZE_HINTS will be
        emitted.

        :type: (int **l**, int **r**, int **t**, int **b**)

        .. note::

            Smart objects(such as elementary) can have their own size hint
            policy. So calling this API may or may not affect the size of smart
            objects.

        """
        def __get__(self):
            cdef int l, r, t, b
            evas_object_size_hint_padding_get(self.obj, &l, &r, &t, &b)
            return (l, r, t, b)

        def __set__(self, spec):
            l, r, t, b = spec
            evas_object_size_hint_padding_set(self.obj, l, r, t, b)

    def size_hint_padding_get(self):
        cdef int l, r, t, b
        evas_object_size_hint_padding_get(self.obj, &l, &r, &t, &b)
        return (l, r, t, b)
    def size_hint_padding_set(self, int l, int r, int t, int b):
        evas_object_size_hint_padding_set(self.obj, l, r, t, b)


    ############################
    #### Evas_Object Events ####
    ############################

    property pass_events:
        """Whenever object should ignore and pass events.

        If True, this will cause events on it to be ignored. They will be
        triggered on the next lower object (that is not set to pass events)
        instead.

        Objects that pass events will also not be accounted in some operations
        unless explicitly required, like
        :py:func:`efl.evas.Canvas.top_at_xy_get`,
        :py:func:`efl.evas.Canvas.top_in_rectangle_get`,
        :py:func:`efl.evas.Canvas.objects_at_xy_get`,
        :py:func:`efl.evas.Canvas.objects_in_rectangle_get`.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_pass_events_get(self.obj))

        def __set__(self, int value):
            evas_object_pass_events_set(self.obj, value)

    def pass_events_get(self):
        return bool(evas_object_pass_events_get(self.obj))
    def pass_events_set(self, value):
        evas_object_pass_events_set(self.obj, value)

    property repeat_events:
        """Whenever object should process and then repeat events.

        If True, this will cause events on it to be processed but then
        they will be triggered on the next lower object (that is not set to
        pass events).

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_repeat_events_get(self.obj))

        def __set__(self, int value):
            evas_object_repeat_events_set(self.obj, value)

    def repeat_events_get(self):
        return bool(evas_object_repeat_events_get(self.obj))
    def repeat_events_set(self, value):
        evas_object_repeat_events_set(self.obj, value)

    property propagate_events:
        """Whenever object should propagate events to its parent.

        If True, this will cause events on this object to propagate to its
        :py:class:`efl.evas.SmartObject` parent, if it's a member
        of one.

        :type: bool

        """
        def __get__(self):
            return bool(evas_object_propagate_events_get(self.obj))

        def __set__(self, int value):
            evas_object_propagate_events_set(self.obj, value)

    def propagate_events_get(self):
        return bool(evas_object_propagate_events_get(self.obj))
    def propagate_events_set(self, value):
        evas_object_propagate_events_set(self.obj, value)

    property freeze_events:
        """Whether an Evas object is to freeze (discard) events.

        If True, events will be **discarded**. Unlike :py:attr:`pass_events`,
        events will not be passed to **next** lower object. This API can be used
        for blocking events while the object is on transiting.

        If False, events will be processed as normal.

        :type: bool

        .. seealso::

            :py:attr:`pass_events`
            :py:attr:`repeat_events`
            :py:attr:`propagate_events`

        """
        def __set__(self, freeze):
            evas_object_freeze_events_set(self.obj, freeze)

        def __get__(self):
            return bool(evas_object_freeze_events_get(self.obj))

    def freeze_events_set(self, freeze):
        evas_object_freeze_events_set(self.obj, freeze)

    def freeze_events_get(self):
        return bool(evas_object_freeze_events_get(self.obj))


    def event_callback_add(self, Evas_Callback_Type type, func, *args, **kargs):
        """Add a new callback for the given event.

        :param type: an integer with event type code, like
            *EVAS_CALLBACK_MOUSE_IN*, *EVAS_CALLBACK_KEY_DOWN* and
            other *EVAS_CALLBACK_* constants.
        :type type: int
        :param func: function to call back, this function will have one of
            the following signatures::

                function(object, event, *args, **kargs)
                function(object, *args, **kargs)

            The former is used by events that provide more data, like
            *EVAS_CALLBACK_MOUSE_*, *EVAS_CALLBACK_KEY_*, while the
            second is used by events without. Parameters given at the
            end of *event_callback_add()* will be given to the callback.
            Note that the object passed to the callback in **event**
            parameter will only be valid during the callback, using it
            after callback returns will raise an ValueError.
        :type func: function

        :raise ValueError: if **type** is unknown.
        :raise TypeError: if **func** is not callable.
        """
        cdef Evas_Object_Event_Cb cb

        if not callable(func):
            raise TypeError("func must be callable")

        if _object_add_callback_to_list(self, type, func, args, kargs):
            if <int>type != EVAS_CALLBACK_FREE:
                cb = evas_object_event_callbacks[<int>type]
                evas_object_event_callback_add(self.obj, type, cb, <void*>self)

    def event_callback_del(self, Evas_Callback_Type type, func):
        """Remove callback for the given event.

        :param type: an integer with event type code.
        :type type: int
        :param func: function used with :py:func:`event_callback_add()`.
        :type func: function
        :precond: **type** and **func** must be used as parameter for
            :py:func:`event_callback_add()`.

        :raise ValueError: if **type** is unknown or if there was no
            **func** connected with this type.

        """
        cdef Evas_Object_Event_Cb cb
        if _object_del_callback_from_list(self, type, func):
            if <int>type != EVAS_CALLBACK_FREE:
                cb = evas_object_event_callbacks[<int>type]
                evas_object_event_callback_del(self.obj, type, cb)

    def on_mouse_in_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_IN, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_IN, func, *a, **k)

    def on_mouse_in_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_IN, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_IN, func)

    def on_mouse_out_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_OUT, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_OUT, func, *a, **k)

    def on_mouse_out_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_OUT, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_OUT, func)

    def on_mouse_down_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, func, *a, **k)

    def on_mouse_down_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_DOWN, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_DOWN, func)

    def on_mouse_up_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_UP, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_UP, func, *a, **k)

    def on_mouse_up_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_UP, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_UP, func)

    def on_mouse_move_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_MOVE, func, *a, **k)

    def on_mouse_move_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_MOVE, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_MOVE, func)

    def on_mouse_wheel_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOUSE_WHEEL, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOUSE_WHEEL, func, *a, **k)

    def on_mouse_wheel_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOUSE_WHEEL, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOUSE_WHEEL, func)

    def on_free_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_FREE, ...)

        This is called after freeing object resources (see
        EVAS_CALLBACK_DEL).

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_FREE, func, *a, **k)

    def on_free_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_FREE, ...)"""
        self.event_callback_del(EVAS_CALLBACK_FREE, func)

    def on_key_down_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_KEY_DOWN, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_KEY_DOWN, func, *a, **k)

    def on_key_down_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_KEY_DOWN, ...)"""
        self.event_callback_del(EVAS_CALLBACK_KEY_DOWN, func)

    def on_key_up_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_KEY_UP, ...)

        Expected signature::

            function(object, event_info, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_KEY_UP, func, *a, **k)

    def on_key_up_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_KEY_UP, ...)"""
        self.event_callback_del(EVAS_CALLBACK_KEY_UP, func)

    def on_focus_in_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_FOCUS_IN, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_FOCUS_IN, func, *a, **k)

    def on_focus_in_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_FOCUS_IN, ...)"""
        self.event_callback_del(EVAS_CALLBACK_FOCUS_IN, func)

    def on_focus_out_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_FOCUS_OUT, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_FOCUS_OUT, func, *a, **k)

    def on_focus_out_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_FOCUS_OUT, ...)"""
        self.event_callback_del(EVAS_CALLBACK_FOCUS_OUT, func)

    def on_show_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_SHOW, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_SHOW, func, *a, **k)

    def on_show_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_SHOW, ...)"""
        self.event_callback_del(EVAS_CALLBACK_SHOW, func)

    def on_hide_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_HIDE, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_HIDE, func, *a, **k)

    def on_hide_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_HIDE, ...)"""
        self.event_callback_del(EVAS_CALLBACK_HIDE, func)

    def on_move_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_MOVE, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_MOVE, func, *a, **k)

    def on_move_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_MOVE, ...)"""
        self.event_callback_del(EVAS_CALLBACK_MOVE, func)

    def on_resize_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_RESIZE, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_RESIZE, func, *a, **k)

    def on_resize_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_RESIZE, ...)"""
        self.event_callback_del(EVAS_CALLBACK_RESIZE, func)

    def on_restack_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_RESTACK, ...)

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_RESTACK, func, *a, **k)

    def on_restack_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_RESTACK, ...)"""
        self.event_callback_del(EVAS_CALLBACK_RESTACK, func)

    def on_del_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_DEL, ...)

        This is called before freeing object resources (see
        EVAS_CALLBACK_FREE).

        Expected signature::

            function(object, *args, **kargs)
        """
        self.event_callback_add(EVAS_CALLBACK_DEL, func, *a, **k)

    def on_del_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_DEL, ...)"""
        self.event_callback_del(EVAS_CALLBACK_DEL, func)

    def on_hold_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_HOLD, ...)"""
        self.event_callback_add(EVAS_CALLBACK_HOLD, func, *a, **k)

    def on_hold_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_HOLD, ...)"""
        self.event_callback_del(EVAS_CALLBACK_HOLD, func)

    def on_changed_size_hints_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_CHANGED_SIZE_HINTS, ...)"""
        self.event_callback_add(EVAS_CALLBACK_CHANGED_SIZE_HINTS, func, *a, **k)

    def on_changed_size_hints_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_CHANGED_SIZE_HINTS, ...)"""
        self.event_callback_del(EVAS_CALLBACK_CHANGED_SIZE_HINTS, func)
