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
from efl.eo cimport Eo

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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
    obj = <Eo>tmp

    try:
        cls.delete(obj)
    except Exception:
        traceback.print_exc()

    # eo_do(self.obj,
    #     eo_event_callback_del(EO_EV_DEL, _eo_event_del_cb, <const void *>self))
    eo_do(o, eo_key_data_del("python-eo"))
    #evas_object_smart_data_set(obj.obj, NULL)
    obj.obj = NULL
    Py_DECREF(obj)


cdef void _smart_object_move(Evas_Object *o, Evas_Coord x, Evas_Coord y) with gil:
    cdef:
        void *tmp
        Smart cls
        Eo obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
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
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
    obj = <Eo>tmp

    other = object_from_instance(clip)

    if cls.member_del is not None:
        try:
            cls.member_del(obj, other)
        except Exception:
            traceback.print_exc()


cdef void _smart_callback(void *data, Evas_Object *o, void *event_info) with gil:

    cdef:
        void *tmp
        Smart cls
        Eo obj
        object event, ei

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    eo_do_ret(o, tmp, eo_key_data_get("python-eo"))
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
    obj = <Eo>tmp

    event = <object>data
    ei = <object>event_info
    lst = tuple(obj._smart_callbacks[event])

    for func, args, kargs in lst:
        try:
            func(obj, ei, *args, **kargs)
        except Exception:
            traceback.print_exc()


cdef class Smart:

    cdef Evas_Smart *cls

    def __cinit__(self):
        cdef Evas_Smart_Class *cls_def

        cls_def = <Evas_Smart_Class*>PyMem_Malloc(sizeof(Evas_Smart_Class))
        if cls_def == NULL:
            return # raise MemoryError

        name = self.__class__.__name__
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)

        cls_def.name = name
        cls_def.version = EVAS_SMART_CLASS_VERSION
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

    def delete(self):
        evas_smart_free(self.cls)
        Py_DECREF(self)

    @staticmethod
    def delete(obj):
        pass

    @staticmethod
    def member_add(obj, Object child):
        pass

    @staticmethod
    def member_del(obj, Object child):
        pass

    @staticmethod
    def move(obj, int x, int y):
        pass

    @staticmethod
    def resize(obj, int w, int h):
        raise NotImplementedError("%s.resize(w, h) not implemented." % obj.__class__.__name__)

    @staticmethod
    def show(obj):
        raise NotImplementedError("%s.show() not implemented." % obj.__class__.__name__)

    @staticmethod
    def hide(obj):
        raise NotImplementedError("%s.hide() not implemented." % obj.__class__.__name__)

    @staticmethod
    def color_set(obj, int r, int g, int b, int a):
        raise NotImplementedError("%s.color_set(r, g, b, a) not implemented." % obj.__class__.__name__)

    @staticmethod
    def clip_set(obj, Object clip):
        raise NotImplementedError("%s.clip_set(object) not implemented." % obj.__class__.__name__)

    @staticmethod
    def clip_unset(obj):
        raise NotImplementedError("%s.clip_unset() not implemented." % obj.__class__.__name__)

    @staticmethod
    def calculate(obj):
        pass


cdef class SmartObjectIterator:

    """Retrieves an iterator of the member objects of a given Evas smart
    object

    :return: Returns the iterator of the member objects of @p obj.

    .. versionadded:: 1.14

    """

    cdef Eina_Iterator *itr

    def __cinit__(self, SmartObject obj):
        self.itr = evas_object_smart_iterator_new(obj.obj)

    def __iter__(self):
        return self

    def __next__(self):
        cdef:
            void* tmp
            Eina_Bool result

        if not eina_iterator_next(self.itr, &tmp):
            raise StopIteration

        return <Object>tmp

    def __dealloc__(self):
        eina_iterator_free(self.itr)


cdef class SmartObject(Object):

    """Smart Evas Objects.

    Smart objects are user-defined Evas components, often used to group
    multiple basic elements, associate an object with a clip and deal with
    them as an unit. See evas documentation for more details.

    Recommended use is to create an **clipper** object and clip every other
    member to it, then you can have all your other members to be always
    visible and implement :py:func:`hide`, :py:func:`show`,
    :py:func:`color_set`, :py:func:`clip_set` and :py:func:`clip_unset` to
    just affect the **clipper**. See :py:class:`ClippedSmartObject`.

    **Pay attention that just creating an object within the SmartObject
    doesn't make it a member!** You must do :py:func:`member_add` or use one of
    the provided factories to ensure that. Failing to do so will leave
    created objects on different layer and no stacking will be done for you.

    Behavior is defined by defining the following methods:

    :py:func:`delete`
        called in order to remove object from canvas and deallocate its
        resources. Usually you delete object's children here. *Default
        implementation deletes all registered children.*

    :py:func:`move`
        called in order to move object to given position. Usually you move
        children here. *Default implementation calculates offset and move
        registered children by it.*

    :py:func:`resize`
        called in order to resize object. *No default implementation.*

    :py:func:`show`
        called in order to show the given element. Usually you call the same
        function on children. *No default implementation.*

    :py:func:`hide`
        called in order to hide the given element. Usually you call the same
        function on children. *No default implementation.*

    :py:func:`color_set`
        called in order to change object color. *No default implementation.*

    :py:func:`clip_set`
        called in order to limit object's visible area. *No default
        implementation.*

    :py:func:`clip_unset`
        called in order to unlimit object's visible area. *No default
        implementation.*

    :py:func:`calculate`
        called before object is used for rendering and it is marked as
        dirty/changed with :py:func:`changed`. *Default implementation does
        nothing.*

    :py:func:`member_add`
        called when children is added to object. *Default implementation
        does nothing.*

    :py:func:`member_del`
        called when children is removed from object. *Default implementation
        does nothing.*

    .. note::
        You should never instantiate the SmartObject base class directly,
        but inherit and implement methods, then instantiate this new subclass.

    .. note::
        If you redefine object's __init__(), you MUST call your parent!
        Failing to do so will result in objects that just work from Python
        and not from C, for instance, adding your object to Edje swallow
        that clips or set color it will not behave as expected.

    .. note::
        Do not call your parent on methods you want to replace the behavior
        instead of extending it. For example, some methods have default
        implementation, you may want to remove and replace it with something
        else.


    :seealso: :py:class:`ClippedSmartObject`

    :param canvas: Evas canvas for this object
    :type canvas: Canvas
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

    """
    def __cinit__(self, *a, **ka):
        self._smart_callbacks = dict()

    def __dealloc__(self):
        self._smart_callbacks = None

    def __init__(self, Canvas canvas not None, Smart smart not None, **kwargs):
        #_smart_classes.append(<uintptr_t>cls_def)
        self._set_obj(evas_object_smart_add(canvas.obj, smart.cls))
        self._set_properties_from_keyword_args(kwargs)

    cdef int _set_obj(self, cEo *obj) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_do(self.obj, eo_key_data_set("python-eo", <void *>self, NULL))
        # eo_do(self.obj,
        #     eo_event_callback_add(EO_EV_DEL, _eo_event_del_cb, <const void *>self))
        Py_INCREF(self)

        return 1

    def __iter__(self):
        return SmartObjectIterator(self)

    # property parent:
    #     def __get__(self):
    #         return object_from_instance(evas_object_parent_get(self.obj))

    # def parent_get(self):
    #     return object_from_instance(evas_object_parent_get(self.obj))

    def member_add(self, Object child):
        """member_add(Object child)

        Set an evas object as a member of this object.

        Members will automatically be stacked and layered with the smart
        object. The various stacking function will operate on members relative
        to the other members instead of the entire canvas.

        Non-member objects can not interleave a smart object's members.

        :note: if **child** is already member of another SmartObject, it
           will be deleted from that membership and added to this object.
        """
        evas_object_smart_member_add(child.obj, self.obj)

    def member_del(self, Object child):
        """member_del(Object child)

        Removes a member object from a smart object.

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

    def callback_add(self, char *event, func, *args, **kargs):
        """Add a callback for the smart event specified by event.

        :param event: Event name
        :param func:
            What to callback.
            Should have the signature::

                function(object, event_info, *args, **kargs)

        :raise TypeError: if **func** is not callable.

        .. warning::
            **event_info** will always be a python object, if the
            signal is provided by a C-only class, it will crash.

        """
        if not callable(func):
            raise TypeError("func must be callable")

        # FIXME: Why is this interned?
        #        What is the reason to use char * and cast it to void *?
        e = intern(event)
        lst = self._smart_callbacks.setdefault(e, [])
        if not lst:
            evas_object_smart_callback_add(self.obj, event, _smart_callback,
                                           <void *>e)
        lst.append((func, args, kargs))

    def callback_del(self, char *event, func):
        """callback_del(event, func)

        Remove a smart callback.

        Removes a callback that was added by :py:func:`callback_add()`.

        :param event: event name
        :param func: what to callback, should have be previously registered.
        :precond: **event** and **func** must be used as parameter for
           :py:func:`callback_add`.

        :raise ValueError: if there was no **func** connected with this event.
        """
        try:
            lst = self._smart_callbacks[event]
        except KeyError:
            raise ValueError("Unknown event %r" % event)

        i = -1
        f = None
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break

        if f != func:
            raise ValueError("Callback %s was not registered with event %r" %
                             (func, event))
        lst.pop(i)
        if lst:
            return
        self._smart_callbacks.pop(event)
        evas_object_smart_callback_del(self.obj, event, _smart_callback)

    def callback_call(self, char *event, event_info=None):
        """callback_call(event, event_info=None)

        Call any smart callbacks for event.

        :param event: the event name
        :param event_info: an event specific info to pass to the callback.

        This should be called internally in the smart object when some
        specific event has occurred. The documentation for the smart object
        should include a list of possible events and what type of
        **event_info** to expect.

        .. attention::
            **event_info** will always be a python object.
        """
        evas_object_smart_callback_call(self.obj, event, <void*>event_info)

    def move_children_relative(self, int dx, int dy):
        """move_children_relative(int dx, int dy)

        Move all children relatively.

        """
        evas_object_smart_move_children_relative(self.obj, dx, dy)

    def changed(self):
        """changed()

        Mark object as changed, so it's :py:func:`calculate()` will be called.

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

_object_mapping_register("Evas_Smart", SmartObject)


cdef class ClippedSmartObject(SmartObject):
    """SmartObject subclass that automatically handles an internal clipper.

    This class is optimized for the recommended SmartObject usage of
    having an internal clipper, with all member objects clipped to it and
    operations like :py:func:`hide()`, :py:func:`show()`, :py:func:`color_set()`, :py:func:`clip_set()` and
    :py:func:`clip_unset()` operating on it.

    This internal clipper size is huge by default (and not the same as the
    object size), this means that you should clip this object to another
    object clipper to get its contents restricted. This is the default
    because many times what we want are contents that can overflow SmartObject
    boundaries (ie: members with animations coming in from outside).

    :ivar clipper: the internal object used for clipping. You shouldn't
       mess with it.

    :todo: remove current code and wrap C version (now it's in evas).

    :param canvas: Evas canvas for this object
    :type canvas: Canvas
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
    :keyword file: File name
    :type file: string

    """
    def __init__(self, Canvas canvas not None, **kargs):
        if type(self) is ClippedSmartObject:
            raise TypeError("Must not instantiate ClippedSmartObject, but "
                            "subclasses")
        SmartObject.__init__(self, canvas, **kargs)
        if self.clipper is None:
            self.clipper = Rectangle(canvas)
            evas_object_move(self.clipper.obj, -100000, -100000)
            evas_object_resize(self.clipper.obj, 200000, 200000)
            evas_object_static_clip_set(self.clipper.obj, 1)
            evas_object_pass_events_set(self.clipper.obj, 1)
            evas_object_smart_member_add(self.clipper.obj, self.obj)

    def member_add(self, Object child):
        """Set an evas object as a member of this object, already clipping."""
        if self.clipper is None or self.clipper is child:
            return
        evas_object_clip_set(child.obj, self.clipper.obj)
        if evas_object_visible_get(self.obj):
            evas_object_show(self.clipper.obj)

    def member_del(self, Object child):
        """Removes a member object from a smart object, already unsets its clip."""
        if self.clipper is child:
            return
        evas_object_clip_unset(child.obj)
        if evas_object_clipees_get(self.clipper.obj) == NULL:
            evas_object_hide(self.clipper.obj)

    def show(self):
        """Default implementation that acts on the the clipper."""
        if evas_object_clipees_get(self.clipper.obj) != NULL:
            evas_object_show(self.clipper.obj)

    def hide(self):
        """Default implementation that acts on the the clipper."""
        evas_object_hide(self.clipper.obj)

    def color_set(self, int r, int g, int b, int a):
        """Default implementation that acts on the the clipper."""
        evas_object_color_set(self.clipper.obj, r, g, b, a)

    def clip_set(self, Object clip):
        """Default implementation that acts on the the clipper."""
        evas_object_clip_set(self.clipper.obj, clip.obj)

    def clip_unset(self):
        """Default implementation that acts on the the clipper."""
        evas_object_clip_unset(self.clipper.obj)

_object_mapping_register("Evas_Smart_Clipped", ClippedSmartObject)

