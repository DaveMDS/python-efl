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

from efl.utils.conversions cimport eina_list_objects_to_python_list
from efl.c_eo cimport eo_key_data_set, eo_key_data_get
from efl.eo cimport Eo, EoIterator

from cpython cimport Py_INCREF, Py_DECREF, PyObject_Call, \
    PyMem_Malloc, PyMem_Free
from libc.stdlib cimport malloc, calloc
from libc.string cimport strdup

#cdef object _smart_classes
#_smart_classes = list()

cdef list _descriptions_to_list(const Evas_Smart_Cb_Description **arr, unsigned int arr_len):
    cdef:
        unsigned int i
        list ret = list()

    if arr == NULL:
        return ret

    for i in range(arr_len):
        ret.append(SmartCbDescription.create(arr[i]))

    if arr[i+1] != NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "array was not NULL terminated!", NULL)

    return ret

cdef Evas_Smart_Cb_Description *_descriptions_to_array(descs):
    cdef:
        unsigned int arr_len = len(descs)
        Evas_Smart_Cb_Description *arr
        SmartCbDescription desc

    if arr_len == 0:
        return NULL

    # allocate arr_len + 1 so it's NULL terminated
    arr = <Evas_Smart_Cb_Description *>calloc(arr_len + 1, sizeof(Evas_Smart_Cb_Description))

    for i, desc in enumerate(descs):
        arr[i] = desc.desc[0]

    return arr


cdef class SmartCbDescription:
    """Introspection description for a smart callback"""
    cdef const Evas_Smart_Cb_Description *desc

    def __init__(self, name, types):
        cdef Evas_Smart_Cb_Description *tmp
        tmp = <Evas_Smart_Cb_Description *>malloc(sizeof(Evas_Smart_Cb_Description*))
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        tmp.name = strdup(name)
        if isinstance(types, unicode): types = PyUnicode_AsUTF8String(types)
        tmp.type = strdup(types)
        self.desc = <const Evas_Smart_Cb_Description *>tmp

    @staticmethod
    cdef create(const Evas_Smart_Cb_Description *desc):
        cdef SmartCbDescription ret = SmartCbDescription.__new__(SmartCbDescription)
        ret.desc = desc
        return ret

    def __repr__(self):
        return "%s(%r, %r)" % (self.__class__.__name__, self.name, self.type)

    property name:
        """:type: string"""
        def __get__(self):
            return _ctouni(self.desc.name)

    property type:
        """:type: string"""
        def __get__(self):
            return _ctouni(self.desc.type)


cdef void _smart_object_delete(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.delete(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_move(Evas_Object *o, Evas_Coord x, Evas_Coord y) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.move(obj, x, y)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_resize(Evas_Object *o, Evas_Coord w, Evas_Coord h) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.resize(obj, w, h)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_show(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.show(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_hide(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.hide(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_color_set(Evas_Object *o, int r, int g, int b, int a) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.color_set(obj, r, g, b, a)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_clip_set(Evas_Object *o, Evas_Object *clip) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj
        Object other

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    other = object_from_instance(clip)

    try:
        cls.clip_set(obj, other)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_clip_unset(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.clip_unset(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_calculate(Evas_Object *o) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    try:
        cls.calculate(obj)
    except Exception:
        traceback.print_exc()


cdef void _smart_object_member_add(Evas_Object *o, Evas_Object *clip) with gil:
    cdef:
        void *tmp
        Smart cls
        SmartObject obj
        Object other

    tmp = evas_smart_data_get(evas_object_smart_smart_get(o))
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "cls is NULL!", NULL)
        return
    cls = <Smart>tmp

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <SmartObject>tmp

    other = object_from_instance(clip)

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

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_WARN(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        obj = None
    else:
        obj = <Eo>tmp

    other = object_from_instance(clip)

    try:
        cls.member_del(obj, other)
    except Exception:
        traceback.print_exc()


cdef class _SmartCb:
    cdef:
        SmartObject obj
        bytes event
        object(*event_conv)(void*)
        uintptr_t conv
        object func
        tuple args
        dict kargs


cdef object _smart_cb_pass_conv(void *addr):
    return <object>addr


cdef void _smart_callback(void *data, Evas_Object *o, void *event_info) with gil:
    if data == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "data is NULL!", NULL)
        return

    cdef:
        void *tmp = NULL
        SmartObject obj
        object event, ei
        _SmartCb spec
        list tmp_args
        list lst

    tmp = eo_key_data_get(o, "python-eo")
    if tmp == NULL:
        EINA_LOG_DOM_ERR(PY_EFL_EVAS_LOG_DOMAIN, "obj is NULL!", NULL)
        return
    else:
        obj = <SmartObject>tmp

    event = <object>data
    lst = <list>obj._smart_callback_specs[event]

    for spec in lst:
        if event_info == NULL:
            try:
                tmp_args = [spec.obj]
                if spec.event_conv != NULL:
                    tmp_args.append(None)
                tmp_args.extend(spec.args)
                PyObject_Call(spec.func, tuple(tmp_args), spec.kargs)
            except Exception:
                traceback.print_exc()
        elif event_info != NULL and spec.event_conv == NULL:
            #EINA_LOG_DOM_WARN(
            #    PY_EFL_EVAS_LOG_DOMAIN,
            #    'event_info for event "%s" is not NULL and there is no event_conv!',
            #    <const char*>event
            #    )
            try:
                tmp_args = [spec.obj]
                tmp_args.extend(spec.args)
                PyObject_Call(spec.func, tuple(tmp_args), spec.kargs)
            except Exception:
                traceback.print_exc()
        else:
            try:
                tmp_args = [spec.obj]
                tmp_args.append(spec.event_conv(event_info))
                tmp_args.extend(spec.args)
                PyObject_Call(spec.func, tuple(tmp_args), spec.kargs)
            except Exception:
                traceback.print_exc()


cdef class Smart(object):

    """
    An abstract class that defines the behavior of the SmartObject.

    :param clipped: Make this Smart use a clipped class, ignoring the provided
        callback methods, except :meth:`calculate` and :meth:`resize`.
    :type clipped: bool

    .. versionadded:: 1.14

    .. staticmethod:: delete(obj)

        Called in order to remove object from canvas and deallocate its resources.

        Usually you delete object's children here.

    .. staticmethod:: member_add(obj, Object child)

        Called when children is added to object.

    .. staticmethod:: member_del(obj, Object child)

        Called when children is removed from object.

    .. staticmethod:: move(obj, int x, int y)

        Called in order to move object to given position.

        Usually you move children here.

    .. staticmethod:: resize(obj, int w, int h)

        Called in order to resize object.

    .. staticmethod:: show(obj)

        Called in order to show the given element.

        Usually you call the same function on children.

    .. staticmethod:: hide(obj)

        Called in order to hide the given element.

        Usually you call the same function on children.

    .. staticmethod:: color_set(obj, int r, int g, int b, int a)

        Called in order to change object color.

    .. staticmethod:: clip_set(obj, Eo clip)

        Called in order to limit object's visible area.

    .. staticmethod:: clip_unset(obj)

        Called in order to unlimit object's visible area.

    .. staticmethod:: calculate(obj)

        Called before object is used for rendering and it is marked as dirty/changed with :py:func:`changed`.

    """

    def __cinit__(self, Smart parent=None, bint clipped=False, callback_descriptions=[], *args, **kwargs):
        cdef Evas_Smart_Class *cls_def

        cls_def = <Evas_Smart_Class*>PyMem_Malloc(sizeof(Evas_Smart_Class))
        if cls_def == NULL:
            raise MemoryError

        name = self.__class__.__name__
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)

        cls_def.name = name
        cls_def.version = enums.EVAS_SMART_CLASS_VERSION

        if clipped:
            evas_object_smart_clipped_smart_set(cls_def)
            # override add to NULL?
        else:
            cls_def.add = NULL # use python constructor

            if "delete" in self.__class__.__dict__:
                cls_def.delete = _smart_object_delete
            else:
                cls_def.delete = NULL

            if "move" in self.__class__.__dict__:
                cls_def.move = _smart_object_move
            else:
                cls_def.move = NULL

            if "show" in self.__class__.__dict__:
                cls_def.show = _smart_object_show
            else:
                cls_def.show = NULL

            if "hide" in self.__class__.__dict__:
                cls_def.hide = _smart_object_hide
            else:
                cls_def.hide = NULL

            if "color_set" in self.__class__.__dict__:
                cls_def.color_set = _smart_object_color_set
            else:
                cls_def.color_set = NULL

            if "clip_set" in self.__class__.__dict__:
                cls_def.clip_set = _smart_object_clip_set
            else:
                cls_def.clip_set = NULL

            if "clip_unset" in self.__class__.__dict__:
                cls_def.clip_unset = _smart_object_clip_unset
            else:
                cls_def.clip_unset = NULL

            if "member_add" in self.__class__.__dict__:
                cls_def.member_add = _smart_object_member_add
            else:
                cls_def.member_add = NULL

            if "member_del" in self.__class__.__dict__:
                cls_def.member_del = _smart_object_member_del
            else:
                cls_def.member_del = NULL

        if "resize" in self.__class__.__dict__:
            cls_def.resize = _smart_object_resize
        else:
            cls_def.resize = NULL

        if "calculate" in self.__class__.__dict__:
            cls_def.calculate = _smart_object_calculate
        else:
            cls_def.calculate = NULL


        cls_def.parent = parent.cls_def if parent is not None else NULL

        cls_def.callbacks = _descriptions_to_array(callback_descriptions)

        # TODO: interfaces?
        cls_def.interfaces = NULL

        cls_def.data = <void *>self

        self.cls_def = <const Evas_Smart_Class *>cls_def
        self.cls = evas_smart_class_new(self.cls_def)

    def __dealloc__(self):
        cdef const Evas_Smart_Class *cls_def
        cls_def = evas_smart_class_get(self.cls)
        PyMem_Free(<void*>cls_def)
        evas_smart_free(self.cls) # FIXME: Check that all resources (cb descriptions etc.) are truly freed
        self.cls = NULL

    property callback_descriptions:
        def __get__(self):
            cdef:
                const Evas_Smart_Cb_Description **descriptions
                unsigned int count

            descriptions = evas_smart_callbacks_descriptions_get(self.cls, &count)

            return _descriptions_to_list(descriptions, count)

    def callback_descriptions_get(self):
        cdef:
            const Evas_Smart_Cb_Description **descriptions
            unsigned int count

        descriptions = evas_smart_callbacks_descriptions_get(self.cls, &count)

        return _descriptions_to_list(descriptions, count)

    def callback_description_find(self, name):
        cdef:
            const Evas_Smart_Cb_Description *desc

        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        desc = evas_smart_callback_description_find(self.cls, name)
        if desc == NULL:
            return None

        return SmartCbDescription.create(desc)


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
        self._smart_callback_specs = dict()

    def __init__(self, Canvas canvas not None, Smart smart not None, **kwargs):
        #_smart_classes.append(<uintptr_t>cls_def)
        self._set_obj(evas_object_smart_add(canvas.obj, smart.cls))
        self._set_properties_from_keyword_args(kwargs)
        self._smart = smart

    cdef int _set_obj(self, cEo *obj) except 0:
        assert self.obj == NULL, "Object must be clean"
        assert obj != NULL, "Cannot set a NULL object"

        self.obj = obj
        eo_key_data_set(self.obj, "python-eo", <void *>self)
        evas_object_event_callback_add(obj, enums.EVAS_CALLBACK_FREE,
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
            if self._smart is not None:
                return self._smart
            else:
                return Smart.create(evas_object_smart_smart_get(self.obj))

    def smart_get(self):
        return self.smart

    def move_children_relative(self, int dx, int dy):
        """Moves all children objects relative to a given offset.

        This will make each of object's children to move, from where
        they before, with those delta values (offsets) on both directions.

        .. note:: This is most useful on custom :func:`Smart.move` functions.

        .. note:: Clipped smart objects already make use of this function on
            their :func:`Smart.move` function definition.

        :param dx: horizontal offset (delta).
        :param dy: vertical offset (delta).
        """
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

        if event is None:
            raise TypeError("event must be the name of the event")

        cdef:
            list lst
            _SmartCb spec

        if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)

        spec = _SmartCb.__new__(_SmartCb)
        spec.obj = self
        spec.event = event
        spec.event_conv = event_conv
        spec.func = func
        spec.args = args
        spec.kargs = kargs

        lst = <list>self._smart_callback_specs.setdefault(event, [])
        if not lst:
            evas_object_smart_callback_add(self.obj,
                <const char*>spec.event,
                _smart_callback,
                <void *>spec.event
                )
        lst.append(spec)

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
            _SmartCb spec
            int found = 0
            int i
            void *tmp
            list lst

        if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)

        lst = <list>self._smart_callback_specs.get(event, None)
        if lst is None:
            raise ValueError("No callbacks registered for the given event type")

        for i, spec in enumerate(lst):
            if spec.func == func:
                found = 1
                break

        if found == 0:
            raise ValueError("func not registered")

        lst.pop(i)

        if not lst:
            tmp = evas_object_smart_callback_del(self.obj,
                event,
                _smart_callback
                )
            if tmp == NULL:
                raise RuntimeError("Something went wrong while unregistering!")

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
        self._callback_add_full(name, _smart_cb_pass_conv, func, args, kargs)

    def callback_del(self, name, func):
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`callback_add()`.

        :param name: event name
        :param func: what to callback, should have be previously registered.
        :precond: **event** and **func** must be used as parameter for
           :py:func:`callback_add`.

        :raise ValueError: if there was no **func** connected with this event.
        """
        self._callback_del_full(name, _smart_cb_pass_conv, func)

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
        evas_object_smart_callback_call(
            self.obj, name,
            <void*>event_info if event_info is not None else NULL
            )

    def callback_descriptions_set(self, descriptions):
        """Set an smart object **instance's** smart callbacks descriptions.

        :return: ``True`` on success, ``False`` on failure.

        These descriptions are hints to be used by introspection and are
        not enforced in any way.

        It will not be checked if instance callbacks descriptions have the same
        name as respective possibly registered in the smart object **class**.
        Both are kept in different arrays and users of
        :meth:`callbacks_descriptions_get` should handle this case as they
        wish.

        .. note::

            While instance callbacks descriptions are possible, they are
            **not** recommended. Use **class** callbacks descriptions
            instead as they make you smart object user's life simpler and
            will use less memory, as descriptions and arrays will be
            shared among all instances.


        :param descriptions: A list with :class:`SmartCbDescription`
            descriptions. List elements won't be modified at run time, but
            references to them and their contents will be made, so this array
            should be kept alive during the whole object's lifetime.

        """

        if not evas_object_smart_callbacks_descriptions_set(
                self.obj,
                <const Evas_Smart_Cb_Description *>_descriptions_to_array(descriptions)
                ):
            raise ValueError("Could not set callback descriptions")

    def callback_descriptions_get(self, get_class=True, get_instance=True):
        """Retrieve a smart object's known smart callback descriptions

        This call searches for registered callback descriptions for both
        instance and class of the given smart object. These lists will be
        sorted by name.

        .. note::

            If just class descriptions are of interest, try
            :meth:`Smart.callbacks_descriptions_get` instead.

        :param bool get_class: Get class descriptions
        :param bool get_instance: Get instance descriptions
        :return: A tuple with two lists, for both class and instance
            descriptions.
        :rtype: tuple
        """
        cdef:
            const Evas_Smart_Cb_Description **class_descriptions
            const Evas_Smart_Cb_Description **instance_descriptions
            unsigned int class_count, instance_count

        evas_object_smart_callbacks_descriptions_get(
            self.obj,
            &class_descriptions if get_class is True else NULL,
            &class_count,
            &instance_descriptions if get_instance is True else NULL,
            &instance_count
            )
        return (
            _descriptions_to_list(class_descriptions, class_count),
            _descriptions_to_list(instance_descriptions, instance_count)
            )

    def callback_description_find(self, name, search_class=True, search_instance=True):
        """Find callback description for callback given in ``name``.

        or ``None`` if not found.

        :param string name: name of desired callback, must **not** be ``None``.
        :param bool search_class: whether to search in class descriptions
        :param bool search_instance: whether to search in instance descriptions
        :return: reference to description if found, ``None`` if not found.

        ..
            The
            search have a special case for ``name`` being the same
            pointer as registered with Evas_Smart_Cb_Description, one
            can use it to avoid excessive use of strcmp().
        """
        cdef:
            const Evas_Smart_Cb_Description *class_description
            const Evas_Smart_Cb_Description *instance_description
            list ret = list()

        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)

        evas_object_smart_callback_description_find(
            self.obj, name,
            &class_description if search_class is True else NULL,
            &instance_description if search_instance is True else NULL
            )

        if class_description != NULL:
            ret.append(SmartCbDescription.create(class_description))
        else:
            ret.append(None)
        if instance_description != NULL:
            ret.append(SmartCbDescription.create(instance_description))
        else:
            ret.append(None)
        return ret

_object_mapping_register("Evas_Smart", SmartObject)
