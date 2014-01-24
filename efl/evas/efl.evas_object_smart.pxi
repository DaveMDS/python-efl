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

from efl.utils.conversions cimport eina_list_objects_to_python_list

from cpython cimport PyMethod_New
import types

#cdef object _smart_classes
#_smart_classes = list()


include "smart_object_metaclass.pxi"
_install_metaclass(EvasSmartObjectMeta, SmartObject)
_install_metaclass(EvasSmartObjectMeta, ClippedSmartObject)


cdef void _smart_object_delete(Evas_Object *o) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")

    try:
        obj._m_delete(obj)
    except Exception, e:
        traceback.print_exc()

    if type(obj.delete) is types.MethodType:
        try:
            del obj.delete
        except AttributeError, e:
            pass
    if type(obj.move) is types.MethodType:
        try:
            del obj.move
        except AttributeError, e:
            pass
    if type(obj.resize) is types.MethodType:
        try:
            del obj.resize
        except AttributeError, e:
            pass
    if type(obj.show) is types.MethodType:
        try:
            del obj.show
        except AttributeError, e:
            pass
    if type(obj.hide) is types.MethodType:
        try:
            del obj.hide
        except AttributeError, e:
            pass
    if type(obj.color_set) is types.MethodType:
        try:
            del obj.color_set
        except AttributeError, e:
            pass
    if type(obj.clip_set) is types.MethodType:
        try:
            del obj.clip_set
        except AttributeError, e:
            pass
    if type(obj.clip_unset) is types.MethodType:
        try:
            del obj.clip_unset
        except AttributeError, e:
            pass
    if type(obj.calculate) is types.MethodType:
        try:
            del obj.calculate
        except AttributeError, e:
            pass
    if type(obj.member_add) is types.MethodType:
        try:
            del obj.member_add
        except AttributeError, e:
            pass
    if type(obj.member_del) is types.MethodType:
        try:
            del obj.member_del
        except AttributeError, e:
            pass

    obj._smart_callbacks = None
    obj._m_delete = None
    obj._m_move = None
    obj._m_resize = None
    obj._m_show = None
    obj._m_hide = None
    obj._m_color_set = None
    obj._m_clip_set = None
    obj._m_clip_unset = None
    obj._m_calculate = None
    obj._m_member_add = None
    obj._m_member_del = None


cdef void _smart_object_move(Evas_Object *o,
                             Evas_Coord x, Evas_Coord y) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_move is not None:
        try:
            obj._m_move(obj, x, y)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_resize(Evas_Object *o,
                               Evas_Coord w, Evas_Coord h) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_resize is not None:
        try:
            obj._m_resize(obj, w, h)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_show(Evas_Object *o) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_show is not None:
        try:
            obj._m_show(obj)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_hide(Evas_Object *o) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_hide is not None:
        try:
            obj._m_hide(obj)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_color_set(Evas_Object *o,
                                  int r, int g, int b, int a) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_color_set is not None:
        try:
            obj._m_color_set(obj, r, g, b, a)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_clip_set(Evas_Object *o, Evas_Object *clip) with gil:
    cdef SmartObject obj
    cdef Object other
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    other = object_from_instance(clip)
    if obj._m_clip_set is not None:
        try:
            obj._m_clip_set(obj, other)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_clip_unset(Evas_Object *o) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_clip_unset is not None:
        try:
            obj._m_clip_unset(obj)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_calculate(Evas_Object *o) with gil:
    cdef SmartObject obj
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    if obj._m_calculate is not None:
        try:
            obj._m_calculate(obj)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_member_add(Evas_Object *o, Evas_Object *clip) with gil:
    cdef SmartObject obj
    cdef Object other
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    other = object_from_instance(clip)
    if obj._m_member_add is not None:
        try:
            obj._m_member_add(obj, other)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_object_member_del(Evas_Object *o, Evas_Object *clip) with gil:
    cdef SmartObject obj
    cdef Object other
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    other = object_from_instance(clip)
    if obj._m_member_del is not None:
        try:
            obj._m_member_del(obj, other)
        except Exception, e:
            traceback.print_exc()


cdef void _smart_callback(void *data,
                          Evas_Object *o, void *event_info) with gil:
    cdef SmartObject obj
    cdef object event, ei
    obj = <SmartObject>evas_object_data_get(o, "python-eo")
    event = <object>data
    ei = <object>event_info
    lst = tuple(obj._smart_callbacks[event])
    for func, args, kargs in lst:
        try:
            func(obj, ei, *args, **kargs)
        except Exception, e:
            traceback.print_exc()


cdef object _smart_class_get_impl_method(object cls, name):
    meth = getattr(cls, name)
    orig = getattr(Object, name)
    if meth is orig:
        return None
    else:
        return meth


cdef object _smart_class_get_impl_method_cls(object cls, object parent_cls,
                                             name):
    meth = getattr(cls, name)
    orig = getattr(parent_cls, name)
    if meth is orig:
        return None
    else:
        return meth


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
        cls = self.__class__
        self._m_delete = _smart_class_get_impl_method(cls, "delete")
        if self._m_delete is not None:
            self.delete = PyMethod_New(Object.delete, self, cls)
        self._m_move = _smart_class_get_impl_method(cls, "move")
        if self._m_move is not None:
            self.move = PyMethod_New(Object.move, self, cls)
        self._m_resize = _smart_class_get_impl_method(cls, "resize")
        if self._m_resize is not None:
            self.resize = PyMethod_New(Object.resize, self, cls)
        self._m_show = _smart_class_get_impl_method(cls, "show")
        if self._m_show is not None:
            self.show = PyMethod_New(Object.show, self, cls)
        self._m_hide = _smart_class_get_impl_method(cls, "hide")
        if self._m_hide is not None:
            self.hide = PyMethod_New(Object.hide, self, cls)
        self._m_color_set = _smart_class_get_impl_method(cls, "color_set")
        if self._m_color_set is not None:
            self.color_set = PyMethod_New(Object.color_set, self, cls)
        self._m_clip_set = _smart_class_get_impl_method(cls, "clip_set")
        if self._m_clip_set is not None:
            self.clip_set = PyMethod_New(Object.clip_set, self, cls)
        self._m_clip_unset = _smart_class_get_impl_method(cls, "clip_unset")
        if self._m_clip_unset is not None:
            self.clip_unset = PyMethod_New(Object.clip_unset, self, cls)
        self._m_calculate = _smart_class_get_impl_method_cls(
            cls, SmartObject, "calculate")
        if self._m_calculate is not None:
            self.calculate = PyMethod_New(
                SmartObject.calculate, self, cls)
        self._m_member_add = _smart_class_get_impl_method_cls(
            cls, SmartObject, "member_add")
        if self._m_member_add is not None:
            self.member_add = PyMethod_New(
                SmartObject.member_add, self, cls)
        self._m_member_del = _smart_class_get_impl_method_cls(
            cls, SmartObject, "member_del")
        if self._m_member_del is not None:
            self.member_del = PyMethod_New(
                SmartObject.member_del, self, cls)

    def __dealloc__(self):
        self._smart_callbacks = None

    def __init__(self, Canvas canvas not None, **kwargs):
        cdef uintptr_t addr
        if type(self) is SmartObject:
            raise TypeError("Must not instantiate SmartObject, but subclasses")
        if self.obj == NULL:
            addr = self.__evas_smart_class__
            self._set_obj(evas_object_smart_add(canvas.obj, <Evas_Smart*>addr))

        self._set_properties_from_keyword_args(kwargs)

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

    def members_get(self):
        """members_get() -> tuple

        :rtype: tuple of :py:class:`Object`

        """
        cdef:
            Eina_List *lst = evas_object_smart_members_get(self.obj)
            list ret = eina_list_objects_to_python_list(lst)
        eina_list_free(lst)
        return tuple(ret)

    property members:
        def __get__(self):
            return self.members_get()

    def callback_add(self, char *event, func, *args, **kargs):
        """callback_add(event, func, *args, **kargs)

        Add a callback for the smart event specified by event.

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
        except KeyError, e:
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

    def delete(self):
        """delete()

        Default implementation to delete all children.

        """
        cdef:
            Eina_List *lst
            Eina_List *itr

        lst = evas_object_smart_members_get(self.obj)
        itr = lst
        while itr:
            evas_object_del(<Evas_Object*>itr.data)
            itr = itr.next
        eina_list_free(lst)

    def move_children_relative(self, int dx, int dy):
        """move_children_relative(int dx, int dy)

        Move all children relatively.

        """
        evas_object_smart_move_children_relative(self.obj, dx, dy)

    def move(self, int x, int y):
        """move(int x, int y)

        Default implementation to move all children.

        """
        cdef int orig_x, orig_y, dx, dy
        evas_object_geometry_get(self.obj, &orig_x, &orig_y, NULL, NULL)
        dx = x - orig_x
        dy = y - orig_y
        self.move_children_relative(dx, dy)

    def resize(self, int w, int h):
        """resize(int w, int h)

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.resize(w, h) not implemented." % self.__class__.__name__

    def show(self):
        """show()

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.show() not implemented." % self.__class__.__name__

    def hide(self):
        """hide()

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.hide() not implemented." % self.__class__.__name__

    def color_set(self, int r, int g, int b, int a):
        """color_set(int r, int g, int b, int a)

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.color_set(r, g, b, a) not implemented." % \
              #self.__class__.__name__

    def clip_set(self, Object clip):
        """clip_set(Object clip)

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.clip_set(object) not implemented." % self.__class__.__name__

    def clip_unset(self):
        """clip_unset()

        Abstract method.

        """
        raise NotImplementedError
        #print "%s.clip_unset() not implemented." % self.__class__.__name__

    def calculate(self):
        """calculate()

        Request object to recalculate it's internal state.

        """
        evas_object_smart_calculate(self.obj)

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

    # TODO: Move docstrings to property; What is the actual type of value?
    def need_recalculate_set(self, unsigned int value):
        """Set need_recalculate flag.

        Set the need_recalculate flag of given smart object.

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

        """
        evas_object_smart_need_recalculate_set(self.obj, value)

    def need_recalculate_get(self):
        """Get the current value of need_recalculate flag.

        .. note::
            This flag will be unset during the render phase, after
            calculate() is called if one is provided.  If no calculate()
            is provided, then the flag will be left unchanged after render
            phase.

        """
        return evas_object_smart_need_recalculate_get(self.obj)

    property need_recalculate:
        def __set__(self, value):
            self.need_recalculate_set(value)

        def __get__(self):
            self.need_recalculate_get()

    # Factory
    def Rectangle(self, **kargs):
        """Factory of children :py:class:`~efl.evas.Rectangle`.

        :rtype: :py:class:`~efl.evas.Rectangle`

        """
        obj = Rectangle(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def Line(self, **kargs):
        """Factory of children :py:class:`~efl.evas.Line`.

        :rtype: :py:class:`~efl.evas.Line`

        """
        obj = Line(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def Image(self, **kargs):
        """Factory of children :py:class:`evas.Image`.

        :rtype: :py:class:`Image<evas.Image>`

        """
        obj = Image(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def FilledImage(self, **kargs):
        """Factory of :py:class:`evas.FilledImage` associated with this canvas.

        :rtype: :py:class:`FilledImage<evas.FilledImage>`

        """
        obj = FilledImage(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def Polygon(self, **kargs):
        """Factory of children :py:class:`evas.Polygon`.

        :rtype: :py:class:`Polygon<evas.Polygon>`

        """
        obj = Polygon(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def Text(self, **kargs):
        """Factory of children :py:class:`evas.Text`.

        :rtype: :py:class:`Text<evas.Text>`

        """
        obj = Text(self.evas, **kargs)
        self.member_add(obj)
        return obj

    def Textblock(self, **kargs):
        """Factory of children :py:class:`evas.Textblock`.

        :rtype: :py:class:`Textblock<evas.Textblock>`

        """
        obj = Textblock(self.evas, **kargs)
        self.member_add(obj)
        return obj

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
    boudaries (ie: members with animations coming in from outside).

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
            evas_object_move(self.clipper.obj, -100000, -100000);
            evas_object_resize(self.clipper.obj, 200000, 200000);
            evas_object_static_clip_set(self.clipper.obj, 1);
            evas_object_pass_events_set(self.clipper.obj, 1);
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

