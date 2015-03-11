# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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

from efl.utils.conversions cimport eina_list_objects_to_python_list
from efl.c_eo cimport eo_do, eo_do_ret, eo_key_data_del, eo_key_data_set, eo_key_data_get
from efl.eo cimport Eo, EoIterator

from cpython cimport PyMem_Malloc, PyMethod_New, Py_INCREF, Py_DECREF

#cdef object _smart_classes
#_smart_classes = list()


cdef void _smart_object_delete(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    try:
        cls.delete(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_move(Evas_Object *o, Evas_Coord x, Evas_Coord y) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.move is not None:
        try:
            cls.move(obj, x, y)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_resize(Evas_Object *o, Evas_Coord w, Evas_Coord h) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.resize is not None:
        try:
            cls.resize(obj, w, h)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_show(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.show is not None:
        try:
            cls.show(obj)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_hide(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.hide is not None:
        try:
            cls.hide(obj)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_color_set(Evas_Object *o, int r, int g, int b, int a) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.color_set is not None:
        try:
            cls.color_set(obj, r, g, b, a)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_clip_set(Evas_Object *o, Evas_Object *clip) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj
        Object other

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    other = object_from_instance(clip)

    if cls.clip_set is not None:
        try:
            cls.clip_set(obj, other)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_clip_unset(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.clip_unset is not None:
        try:
            cls.clip_unset(obj)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_calculate(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    if cls.calculate is not None:
        try:
            cls.calculate(obj)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_member_add(Evas_Object *o, Evas_Object *clip) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj
        Object other

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    other = object_from_instance(clip)

    if cls.member_add is not None:
        try:
            cls.member_add(obj, other)
        except Exception:
            traceback.print_exc()


cdef void _smart_object_member_del(Evas_Object *o, Evas_Object *clip) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj
        Object other

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    other = object_from_instance(clip)

    if cls.member_del is not None:
        try:
            cls.member_del(obj, other)
        except Exception:
            traceback.print_exc()


cdef void _smart_callback(void *data, Evas_Object *o, void *event_info) with gil:

    cdef:
        void *tmp = NULL
        SmartObject obj
        object ei
        object(*event_conv)(void*)

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
    else:
        obj = <SmartObject>tmp

    if data == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "data is NULL!", NULL)
        return
    else:
        conv, func, args, kargs = <tuple>data

    if conv != 0:
        event_conv = <object(*)(void*)><void *><uintptr_t>conv
    else:
        event_conv = NULL

    try:
        if event_conv is NULL:
            func(obj, *args, **kargs)
        else:
            ei = event_conv(event_info)
            func(obj, ei, *args, **kargs)
    except Exception:
        traceback.print_exc()


cdef class Smart(object):

    """
    An abstract class with callback methods.

    Use :meth:`free` to delete the instance.

    :param clipped: Make this Smart use a clipped class, ignoring the provided
        callback methods.
    :type clipped: bool

    ..
        note::
        You should never instantiate the Smart base class directly,
        but inherit and implement methods, then instantiate this new subclass.

    .. note::
        Do not call your parent on methods you want to replace the behavior
        instead of extending it. For example, some methods have default
        implementation, you may want to remove and replace it with something
        else.

    .. versionadded:: 1.14
    """

    cdef Evas_Smart *cls

    def __cinit__(self, bint clipped=False):
        cdef Evas_Smart_Class *cls_def

        cls_def = <Evas_Smart_Class*>PyMem_Malloc(sizeof(Evas_Smart_Class))
        if cls_def == NULL:
            return # raise MemoryError

        name = self.__class__.__name__
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)

        cls_def.name = name
        cls_def.version = EVAS_SMART_CLASS_VERSION

        if clipped:
            evas_object_smart_clipped_smart_set(cls_def)
        else:
            cls_def.add = NULL # use python constructor
            cls_def.delete = _smart_object_delete
            cls_def.move = _smart_object_move
            cls_def.resize = _smart_object_resize
            cls_def.show = _smart_object_show
            cls_def.hide = _smart_object_hide
            cls_def.color_set = _smart_object_color_set
            cls_def.clip_set = _smart_object_clip_set
            cls_def.clip_unset = _smart_object_clip_unset
            cls_def.calculate = _smart_object_calculate
            cls_def.member_add = _smart_object_member_add
            cls_def.member_del = _smart_object_member_del

        cls_def.parent = NULL
        cls_def.callbacks = NULL
        cls_def.interfaces = NULL
        cls_def.data = <void *>self

        self.cls = evas_smart_class_new(cls_def)
        Py_INCREF(self)

    def free(self):
        """Deletes this Smart instance and frees the C resources."""
        evas_smart_free(self.cls)
        self.cls = NULL
        Py_DECREF(self)

    @staticmethod
    def delete(obj):
        """
        Called in order to remove object from canvas and deallocate its resources.

        Usually you delete object's children here.

        ..
            *Default implementation deletes all registered children.*
        """
        pass

    @staticmethod
    def member_add(obj, Object child):
        """
        Called when children is added to object.

        ..
            *Default implementation does nothing.*
        """
        pass

    @staticmethod
    def member_del(obj, Object child):
        """
        Called when children is removed from object.

        ..
            *Default implementation does nothing.*
        """
        pass

    @staticmethod
    def move(obj, int x, int y):
        """
        Called in order to move object to given position.

        Usually you move children here.

        ..
            *Default implementation calculates offset and move registered children
            by it.*
        """
        pass

    @staticmethod
    def resize(obj, int w, int h):
        """
        Called in order to resize object.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.resize(w, h) not implemented." % obj.__class__.__name__)

    @staticmethod
    def show(obj):
        """
        Called in order to show the given element.

        Usually you call the same function on children.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.show() not implemented." % obj.__class__.__name__)

    @staticmethod
    def hide(obj):
        """
        Called in order to hide the given element.

        Usually you call the same function on children.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.hide() not implemented." % obj.__class__.__name__)

    @staticmethod
    def color_set(obj, int r, int g, int b, int a):
        """
        Called in order to change object color.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.color_set(r, g, b, a) not implemented." % obj.__class__.__name__)

    @staticmethod
    def clip_set(obj, Object clip):
        """
        Called in order to limit object's visible area.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.clip_set(object) not implemented." % obj.__class__.__name__)

    @staticmethod
    def clip_unset(obj):
        """
        Called in order to unlimit object's visible area.

        ..
            *No default implementation.*
        """
        raise NotImplementedError("%s.clip_unset() not implemented." % obj.__class__.__name__)

    @staticmethod
    def calculate(obj):
        """
        Called before object is used for rendering and it is marked as dirty/changed with :py:func:`changed`.

        ..
            *Default implementation does nothing.*
        """
        pass


cdef class SmartObject(Object):

    """
    Smart Evas Objects.

    Smart objects are user-defined Evas components, often used to group
    multiple basic elements, associate an object with a clip and deal with
    them as an unit. See evas documentation for more details.

    ..
        Recommended use is to create an **clipper** object and clip every other
        member to it, then you can have all your other members to be always
        visible and implement :py:func:`hide`, :py:func:`show`,
        :py:func:`color_set`, :py:func:`clip_set` and :py:func:`clip_unset` to
        just affect the **clipper**. See :py:class:`ClippedSmartObject`.

    **Pay attention that just creating an object within the SmartObject
    doesn't make it a member!** You must do :py:func:`member_add` or use one of
    the provided factories to ensure that. Failing to do so will leave
    created objects on different layer and no stacking will be done for you.

    .. note::
        If you redefine object's __init__(), you MUST call your parent!
        Failing to do so will result in objects that just work from Python
        and not from C, for instance, adding your object to Edje swallow
        that clips or set color it will not behave as expected.

    :param canvas: Evas canvas for this object
    :type canvas: :class:`~efl.evas.Canvas`
    :param smart: Smart prototype
    :type smart: :class:`Smart`

    ..
        :keyword size: Width and height
        :type size: tuple of ints
        :keyword pos: X and Y
        :type pos: tuple of ints
        :keyword geometry: X, Y, width, height
        :type geometry: tuple of ints
        :keyword color: R, G, B, A
        :type color: tuple of ints
        :keyword name: Object name
        :type name: string

    .. versionchanged:: 1.14
        API was broken because this class had some "hackish" behavior which
        could no longer be supported because of changes in Cython 0.21.1

        The abstract methods are now in a separate class :class:`Smart` which
        should be instantiated and passed to this classes constructor as
        parameter ``smart``
    """
    def __cinit__(self):
        self._owned_references = list()

    def __init__(self, Canvas canvas not None, Smart smart not None, **kwargs):
        #_smart_classes.append(<uintptr_t>cls_def)
        self._set_obj(evas_object_smart_add(canvas.obj, smart.cls))
        self._set_properties_from_keyword_args(kwargs)

    cdef int _set_obj(self, cEo *obj) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_key_data_set("python-eo", <void *>self, NULL))
        evas_object_event_callback_add(obj, EVAS_CALLBACK_FREE,
                                       obj_free_cb, <void *>self)
        Py_INCREF(self)

        return 1

    def __iter__(self):
        return EoIterator.create(evas_object_smart_iterator_new(self.obj))

    def member_add(self, Object child):
        """Set an evas object as a member of this object.

        Members will automatically be stacked and layered with the smart
        object. The various stacking function will operate on members relative
        to the other members instead of the entire canvas.

        Non-member objects can not interleave a smart object's members.

        :note: if **child** is already member of another SmartObject, it
           will be deleted from that membership and added to this object.
        """
        evas_object_smart_member_add(child.obj, self.obj)

    @staticmethod
    def member_del(Object child):
        """Removes a member object from a smart object.

        .. attention:: this will actually map to C API as
            ``evas_object_smart_member_del(child)``, so the object will loose
            it's parent **event if the object is not part of this object**.
        """
        evas_object_smart_member_del(child.obj)

    property members:
        """

        :rtype: tuple of :py:class:`Object`

        """
        def __get__(self):
            cdef:
                Eina_List *lst = evas_object_smart_members_get(self.obj)
                list ret = eina_list_objects_to_python_list(lst)
            eina_list_free(lst)
            return tuple(ret)

    def members_get(self):
        cdef:
            Eina_List *lst = evas_object_smart_members_get(self.obj)
            list ret = eina_list_objects_to_python_list(lst)
        eina_list_free(lst)
        return tuple(ret)

    property smart:
        def __get__(self):
            return <Smart>evas_smart_data_get(evas_object_smart_smart_get(self.obj))

    def smart_get(self):
        return <Smart>evas_smart_data_get(evas_object_smart_smart_get(self.obj))

    def move_children_relative(self, int dx, int dy):
        """Move all children relatively."""
        evas_object_smart_move_children_relative(self.obj, dx, dy)

    def changed(self):
        """Mark object as changed, so it's :py:func:`calculate()` will be called.

        If an object is changed and it provides a calculate() method,
        it will be called from :py:func:`Canvas.render()`, what we call pre-render
        calculate.

        This can be used to postpone heavy calculations until you need to
        display the object, example: layout calculations.
        """
        evas_object_smart_changed(self.obj)

    property need_recalculate:
        """The need_recalculate flag of given smart object.

        If this flag is set then calculate() callback (method) of the
        given smart object will be called, if one is provided, during
        render phase usually evas_render(). After this step, this flag
        will be automatically unset.

        If no calculate() is provided, this flag will be left unchanged.

        .. note::
            Just setting this flag will not make scene dirty and
            evas_render() will have no effect. To do that, use
            evas_object_smart_changed(), that will automatically call this
            function with 1 as parameter.

        .. note::
            This flag will be unset during the render phase, after
            calculate() is called if one is provided.  If no calculate()
            is provided, then the flag will be left unchanged after render
            phase.

        """
        def __set__(self, value):
            evas_object_smart_need_recalculate_set(self.obj, value)

        def __get__(self):
            return evas_object_smart_need_recalculate_get(self.obj)

    def need_recalculate_set(self, unsigned int value):
        evas_object_smart_need_recalculate_set(self.obj, value)

    def need_recalculate_get(self):
        return evas_object_smart_need_recalculate_get(self.obj)

    def calculate(self):
        evas_object_smart_calculate(self.obj)

    #
    # Callbacks
    # =========
    #

    cdef int _callback_add_full(self, event, object(*event_conv)(void *), func, tuple args, dict kargs) except 0:
        """Add a callback for the smart event specified by event.

        :param event: event name
        :type event: string
        :param event_conv: Conversion function to get the
            pointer (as a long) to the object to be given to the
            function as the second parameter. If None, then no
            parameter will be given to the callback.
        :type event_conv: function
        :param func: what to callback. Should have the signature::

            function(object, event_info, *args, **kargs)
            function(object, *args, **kargs) (if no event_conv is provided)

        :type func: function

        :raise TypeError: if **func** is not callable.
        :raise TypeError: if **event_conv** is not callable or None.

        """
        if not callable(func):
            raise TypeError("func must be callable")
        if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)

        spec = (<uintptr_t><void *>event_conv, func, args, kargs)
        self._owned_references.append(spec)
        #Py_INCREF(spec)

        evas_object_smart_callback_add(self.obj,
            <const char *>event if event is not None else NULL,
            _smart_callback, <void *>spec)

        return 1

    cdef int _callback_del_full(self, event, object(*event_conv)(void *), func) except 0:
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`_callback_add_full()`.

        :param event: event name
        :type event: string
        :param event_conv: same as registered with :py:func:`_callback_add_full()`
        :type event_conv: function
        :param func: what to callback, should have be previously registered.
        :type func: function

        :precond: **event**, **event_conv** and **func** must be used as
           parameter for :py:func:`_callback_add_full()`.

        :raise ValueError: if there was no **func** connected with this event.

        """
        cdef:
            void *tmp
            tuple spec

        if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)

        tmp = evas_object_smart_callback_del(self.obj,
            <const char *>event if event is not None else NULL,
            _smart_callback)

        if tmp == NULL:
            return 1
        else:
            spec = <tuple>tmp
            self._owned_references.remove(spec)
            #Py_DECREF(spec)

        return 1

    cdef int _callback_add(self, event, func, args, kargs) except 0:
        """Add a callback for the smart event specified by event.

        :param event: event name
        :type event: string
        :param func: what to callback. Should have the signature:
            *function(object, *args, **kargs)*
        :type func: function

        :raise TypeError: if **func** is not callable.

        """
        return self._callback_add_full(event, NULL, func, args, kargs)

    cdef int _callback_del(self, event, func) except 0:
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`_callback_add()`.

        :param event: event name
        :type event: string
        :param func: what to callback, should have be previously registered.
        :type func: function

        :precond: **event** and **func** must be used as parameter for
            :py:func:`_callback_add()`.

        :raise ValueError: if there was no **func** connected with this event.

        """
        return self._callback_del_full(event, NULL, func)

    def callback_add(self, name, func, *args, **kargs):
        """Add a callback for the smart event specified by event.

        :param name: Event name
        :param func:
            What to callback.
            Should have the signature::

                function(object, event_info, *args, **kargs)

        :raise TypeError: if **func** is not callable.

        .. warning::
            **event_info** will always be a python object, if the
            signal is provided by a C-only class, it will crash.

        """
        self._callback_add_full(name, NULL, func, args, kargs)

    def callback_del(self, name, func):
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`callback_add()`.

        :param name: event name
        :param func: what to callback, should have be previously registered.
        :precond: **event** and **func** must be used as parameter for
           :py:func:`callback_add`.

        :raise ValueError: if there was no **func** connected with this event.
        """
        self._callback_del_full(name, NULL, func)

    def callback_call(self, name, event_info=None):
        """Call any smart callbacks for event.

        :param name: the event name
        :param event_info: an event specific info to pass to the callback.

        This should be called internally in the smart object when some
        specific event has occurred. The documentation for the smart object
        should include a list of possible events and what type of
        **event_info** to expect.

        .. attention::
            **event_info** will always be a python object.
        """
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        evas_object_smart_callback_call(self.obj, name, <void*>event_info)


_object_mapping_register("Evas_Smart", SmartObject)
