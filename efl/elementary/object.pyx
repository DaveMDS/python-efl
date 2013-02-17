# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
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

.. rubric:: Focus direction

.. data:: ELM_FOCUS_PREVIOUS

    Focus previous

.. data:: ELM_FOCUS_NEXT

    Focus next

"""

from cpython cimport PyObject, Py_INCREF, Py_DECREF, PyObject_GetAttr

include "widget_header.pxi"
include "tooltips.pxi"

from efl.evas cimport EventKeyDown, EventKeyUp, EventMouseWheel
#from efl.evas cimport evas_object_data_get
from efl.evas cimport evas_object_smart_callback_add
from efl.evas cimport evas_object_smart_callback_del

from efl.evas import EVAS_CALLBACK_KEY_DOWN
from efl.evas import EVAS_CALLBACK_KEY_UP
from efl.evas import EVAS_CALLBACK_MOUSE_WHEEL

from efl.evas cimport eina_list_append
#from efl.evas import _extended_object_mapping_register
#from efl.evas import _object_mapping_register
#from efl.evas import _object_mapping_unregister

import logging
log = logging.getLogger("elementary")

from theme cimport Theme

import traceback

cimport enums

ELM_FOCUS_PREVIOUS = enums.ELM_FOCUS_PREVIOUS
ELM_FOCUS_NEXT = enums.ELM_FOCUS_NEXT

#API XXX: Callbacks!
cdef void _object_callback(void *data,
                           Evas_Object *o, void *event_info) with gil:
    cdef Object obj
    cdef object event, ei
    obj = object_from_instance(o)
    event = <object>data
    lst = tuple(obj._elmcallbacks[event])
    for event_conv, func, args, kargs in lst:
        try:
            if event_conv is None:
                func(obj, *args, **kargs)
            else:
                ei = event_conv(<long>event_info)
                func(obj, ei, *args, **kargs)
        except Exception, e:
            traceback.print_exc()

cdef Eina_Bool _event_dispatcher(o, src, Evas_Callback_Type t, event_info):
    cdef Object obj = o
    cdef object ret
    for func, args, kargs in obj._elm_event_cbs:
        try:
            ret = func(obj, src, t, event_info, *args, **kargs)
        except Exception, e:
            traceback.print_exc()
        else:
            if ret:
                return True
    return False

#TODO: More event types
cdef Eina_Bool _event_callback(void *data, Evas_Object *o, Evas_Object *src, Evas_Callback_Type t, void *event_info) with gil:
    cdef Object obj = object_from_instance(o)
    cdef Object src_obj = object_from_instance(src)
    cdef Eina_Bool ret = False
    cdef EventKeyDown down_event
    cdef EventKeyUp up_event
    if t == EVAS_CALLBACK_KEY_DOWN:
        down_event = EventKeyDown()
        down_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, down_event)
        down_event._unset_obj()
    elif t == EVAS_CALLBACK_KEY_UP:
        up_event = EventKeyUp()
        up_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, up_event)
        up_event._unset_obj()
    elif t == EVAS_CALLBACK_MOUSE_WHEEL:
        wheel_event = EventMouseWheel()
        wheel_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, wheel_event)
        wheel_event._unset_obj()
    else:
        log.debug("Unhandled elm input event of type %i" % (t))


cdef void _event_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    pass
#     Py_DECREF(<object>data)


def _cb_string_conv(long addr):
    cdef const_char_ptr s = <const_char_ptr>addr
    return s if s is not NULL else None

cdef _object_list_to_python(const_Eina_List *lst):
    cdef Evas_Object *o
    ret = []
    while lst:
        o = <Evas_Object *>lst.data
        obj = object_from_instance(o)
        ret.append(obj)
        lst = lst.next
    return ret

cdef class Canvas(evasCanvas):
    def __init__(self):
        pass

cdef class Object(evasObject):

    """

    An abstract class to manage object and callback handling.

    All widgets are based on this class.

    """

    def part_text_set(self, part, text):
        """part_text_set(unicode part, unicode text)

        Sets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_get()`

        :param part: part name to set the text.
        :type part: string
        :param text: text to set.
        :type text: string

        """
        elm_object_part_text_set(self.obj, _cfruni(part) if part is not None else NULL, _cfruni(text))

    def part_text_get(self, part):
        """part_text_get(unicode part) -> unicode

        Gets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_set()`

        :param part: part name to get the text.
        :type part: string
        :return: the text of a part or None if nothing was set.
        :rtype: string

        """
        return _ctouni(elm_object_part_text_get(self.obj, _cfruni(part) if part is not None else NULL))

    property text:
        """The main text for this object.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_text_get(self.obj))

        def __set__(self, text):
            elm_object_text_set(self.obj, _cfruni(text))

    def text_set(self, text):
        elm_object_text_set(self.obj, _cfruni(text))
    def text_get(self):
        return _ctouni(elm_object_text_get(self.obj))

    def part_content_set(self, part, evasObject content):
        """part_content_set(unicode part, evas.Object content)

        Set a content of an object

        This sets a new object to a widget as a content object. If any
        object was already set as a content object in the same part,
        previous object will be deleted automatically.

        .. note:: Elementary objects may have many contents

        :param part: The content part name to set (None for the default content)
        :type part: string
        :param content: The new content of the object
        :type content: :py:class:`evas.object.Object`

        """
        elm_object_part_content_set(self.obj, _cfruni(part) if part is not None else NULL, content.obj)

    def part_content_get(self, part):
        """part_content_get(unicode part) -> evas.Object

        Get a content of an object

        .. note:: Elementary objects may have many contents

        :param part: The content part name to get (None for the default content)
        :type part: string
        :return: content of the object or None for any error
        :rtype: :py:class:`evas.object.Object`

        """
        return object_from_instance(elm_object_part_content_get(self.obj, _cfruni(part) if part is not None else NULL))

    def part_content_unset(self, part):
        """part_content_unset(unicode part)

        Unset a content of an object

        .. note:: Elementary objects may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string

        """
        return object_from_instance(elm_object_part_content_unset(self.obj, _cfruni(part) if part is not None else NULL))

    property content:
        def __get__(self):
            return object_from_instance(elm_object_content_get(self.obj))

        def __set__(self, evasObject content):
            elm_object_content_set(self.obj, content.obj)

        def __del__(self):
            elm_object_content_unset(self.obj)

    def content_set(self, evasObject obj):
        elm_object_part_content_set(self.obj, NULL, obj.obj)
    def content_get(self):
        return object_from_instance(elm_object_content_get(self.obj))
    def content_unset(self):
        return object_from_instance(elm_object_content_unset(self.obj))

    def access_info_set(self, txt):
        """access_info_set(unicode txt)

        Set the text to read out when in accessibility mode

        :param txt: The text that describes the widget to people with poor
            or no vision
        :type txt: string

        """
        elm_object_access_info_set(self.obj, _cfruni(txt))

    def name_find(self, name not None, int recurse = 0):
        """name_find(unicode name, int recurse = 0) -> evas.Object

        Get a named object from the children

        This function searches the children (or recursively children of
        children and so on) of the given object looking for a child with the
        name of *name*. If the child is found the object is returned, or
        None is returned. You can set the name of an object with
        :py:func:`name_set()`. If the name is not unique within the child
        objects (or the tree is ``recurse`` is greater than 0) then it is
        undefined as to which child of that name is returned, so ensure the
        name is unique amongst children. If recurse is set to -1 it will
        recurse without limit.

        :param name: The name of the child to find
        :type name: string
        :param recurse: Set to the maximum number of levels to recurse (0 ==
            none, 1 is only look at 1 level of children etc.)
        :type recurse: int
        :return: The found object of that name, or None if none is found
        :rtype: :py:class:`elementary.object.Object`

        """
        return object_from_instance(elm_object_name_find(self.obj, _cfruni(name), recurse))

    property style:
        """The style to be used by the widget

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_style_get(self.obj))

        def __set__(self, style):
            elm_object_style_set(self.obj, _cfruni(style))

    def style_set(self, style):
        elm_object_style_set(self.obj, _cfruni(style))
    def style_get(self):
        return _ctouni(elm_object_style_get(self.obj))

    property disabled:
        """The disabled state of an Elementary object.

        Elementary objects can be **disabled**, in which state they won't
        receive input and, in general, will be themed differently from
        their normal state, usually greyed out. Useful for contexts
        where you don't want your users to interact with some of the
        parts of you interface.

        :type: bool

        """
        def __get__(self):
            return bool(elm_object_disabled_get(self.obj))
        def __set__(self, disabled):
            elm_object_disabled_set(self.obj, disabled)

    def disabled_set(self, disabled):
        elm_object_disabled_set(self.obj, disabled)
    def disabled_get(self):
        return bool(elm_object_disabled_get(self.obj))

    def widget_check(self):
        """widget_check() -> bool

        Check if the given Evas Object is an Elementary widget.

        :return: ``True`` if it is an elementary widget variant, ``False``
            otherwise
        :rtype: bool

        """
        return bool(elm_object_widget_check(self.obj))

    property parent_widget:
        """The first parent of the given object that is an Elementary
        widget. This is a readonly property.

        .. note:: Most of Elementary users wouldn't be mixing non-Elementary
            smart objects in the objects tree of an application, as this is
            an advanced usage of Elementary with Evas. So, except for the
            application's window, which is the root of that tree, all other
            objects would have valid Elementary widget parents.

        :type: :py:class:`elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_parent_widget_get(self.obj))

    def parent_widget_get(self):
        return object_from_instance(elm_object_parent_widget_get(self.obj))

    property top_widget:
        """The top level parent of an Elementary widget.
        This is a readonly property.

        :type: :py:class:`elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_top_widget_get(self.obj))

    property widget_type:
        """The string that represents this Elementary widget.
        This is a readonly property.

        .. note:: Elementary is weird and exposes itself as a single
            Evas_Object_Smart_Class of type "elm_widget", so
            evas_object_type_get() always return that, making debug and
            language bindings hard. This function tries to mitigate this
            problem, but the solution is to change Elementary to use
            proper inheritance.

        :type: string

        """
        def __get__(self):
            return elm_object_widget_type_get(self.obj)

    def top_widget_get(self):
        return object_from_instance(elm_object_top_widget_get(self.obj))

    def signal_emit(self, emission, source):
        """signal_emit(unicode emission, unicode source)

        Send a signal to the widget edje object.

        This function sends a signal to the edje object of the obj. An edje
        program can respond to a signal by specifying matching 'signal' and
        'source' fields.

        :param emission: The signal's name.
        :type emission: string
        :param source: The signal's source.
        :type source: string

        """
        elm_object_signal_emit(self.obj, _cfruni(emission), _cfruni(source))

    #def signal_callback_add(self, emission, source, func, data):
        #elm_object_signal_callback_add(self.obj, emission, source, func, data)

    #def signal_callback_del(self, emission, source, func):
        #elm_object_signal_callback_del(self.obj, emission, source, func)

    # XXX: Clashes badly with evas event_callback_*
    def elm_event_callback_add(self, func, *args, **kargs):
        """elm_event_callback_add(func, *args, **kargs)

        Add a callback for input events (key up, key down, mouse wheel)
        on a given Elementary widget

        Every widget in an Elementary interface set to receive focus, with
        elm_object_focus_allow_set(), will propagate **all** of its key up,
        key down and mouse wheel input events up to its parent object, and
        so on. All of the focusable ones in this chain which had an event
        callback set, with this call, will be able to treat those events.
        There are two ways of making the propagation of these event upwards
        in the tree of widgets to **cease**:

        - Just return ``True`` on *func*. ``False`` will mean the event
            was **not** processed, so the propagation will go on.
        - The ``event_info`` pointer passed to ``func`` will contain the
            event's structure and, if you OR its ``event_flags`` inner
            value to *EVAS_EVENT_FLAG_ON_HOLD*, you're telling
            Elementary one has already handled it, thus killing the
            event's propagation, too.

        .. note:: Your event callback will be issued on those events taking
            place only if no other child widget has consumed the event already.

        .. note:: Not to be confused with *evas_object_event_callback_add()*,
            which will add event callbacks per type on general Evas objects
            (no event propagation infrastructure taken in account).

        .. note:: Not to be confused with :py:func:`signal_callback_add()`,
            which will add callbacks to **signals** coming from a widget's
            theme, not input events.

        .. note:: Not to be confused with *edje_object_signal_callback_add()*,
            which does the same as :py:func:`signal_callback_add()`, but
            directly on an Edje object.

        .. note:: Not to be confused with *evas_object_smart_callback_add()*,
            which adds callbacks to smart objects' **smart events**, and not
            input events.

        .. seealso:: :py:func:`elm_event_callback_del()`

        :param func: The callback function to be executed when the event
            happens
        :type func: function
        :param args: Optional arguments containing data passed to ``func``
        :param kargs: Optional keyword arguments containing data passed to
            ``func``

        """
        if not callable(func):
            raise TypeError("func must be callable")

        if self._elm_event_cbs is None:
            self._elm_event_cbs = []

        if not self._elm_event_cbs:
            elm_object_event_callback_add(self.obj, _event_callback, NULL)

        data = (func, args, kargs)
        self._elm_event_cbs.append(data)

    def elm_event_callback_del(self, func, *args, **kargs):
        """elm_event_callback_del(func, *args, **kargs)

        Remove an event callback from a widget.

        This function removes a callback, previously attached to event emission.
        The parameters func and args, kwargs must match exactly those passed to
        a previous call to :py:func:`elm_event_callback_add()`.

        :param func: The callback function to be executed when the event is
            emitted.
        :type func: function
        :param args: Optional arguments containing data passed to ``func``
        :param kargs: Optional keyword arguments containing data passed to
            ``func``

        """
        data = (func, args, kargs)
        self._elm_event_cbs.remove(data)

        if not self._elm_event_cbs:
            elm_object_event_callback_del(self.obj, _event_callback, NULL)

    # Cursors
    property cursor:
        """The cursor to be shown when mouse is over the object

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_cursor_get(self.obj))

        def __set__(self, cursor):
            elm_object_cursor_set(self.obj, _cfruni(cursor))

        def __del__(self):
            elm_object_cursor_unset(self.obj)

    def cursor_set(self, cursor):
        elm_object_cursor_set(self.obj, _cfruni(cursor))
    def cursor_get(self):
        return _ctouni(elm_object_cursor_get(self.obj))
    def cursor_unset(self):
        elm_object_cursor_unset(self.obj)

    property cursor_style:
        """The style for this object cursor."""
        def __get__(self):
            return _ctouni(elm_object_cursor_style_get(self.obj))

        def __set__(self, style):
            elm_object_cursor_style_set(self.obj, _cfruni(style) if style is not None else NULL)

    def cursor_style_set(self, style=None):
        elm_object_cursor_style_set(self.obj, _cfruni(style) if style is not None else NULL)
    def cursor_style_get(self):
        return _ctouni(elm_object_cursor_style_get(self.obj))

    property cursor_theme_search_enabled:
        """Whether cursor engine only usage is enabled for this object.

        .. note:: before you set engine only usage you should define a
            cursor with :py:attr:`cursor`

        """
        def __get__(self):
            return elm_object_cursor_theme_search_enabled_get(self.obj)

        def __set__(self, engine_only):
            elm_object_cursor_theme_search_enabled_set(self.obj, bool(engine_only))

    def cursor_theme_search_enabled_set(self, engine_only):
        elm_object_cursor_theme_search_enabled_set(self.obj, bool(engine_only))
    def cursor_theme_search_enabled_get(self):
        return elm_object_cursor_theme_search_enabled_get(self.obj)

    # Focus
    property focus:
        """Set/unset focus to a given Elementary object.

        .. note:: When you set focus to this object, if it can handle focus,
            will take the focus away from the one who had it previously and
            will, for now on, be the one receiving input events. Unsetting
            focus will remove the focus from the object, passing it back to
            the previous element in the focus chain list.

        :type focus: bool

        """
        def __set__(self, focus):
            elm_object_focus_set(self.obj, focus)

        def __get__(self):
            return bool(elm_object_focus_get(self.obj))

    def focus_get(self):
        return bool(elm_object_focus_get(self.obj))
    def focus_set(self, focus):
        elm_object_focus_set(self.obj, focus)

    property focus_allow:
        """The ability for the Elementary object to be focused.

        Whether the object is able to take focus or not.
        Unfocusable objects do nothing when programmatically focused, being
        the nearest focusable parent object the one really getting focus.
        Also, when they receive mouse input, they will get the event, but
        not take away the focus from where it was previously.

        :type: bool

        """
        def __get__(self):
            return elm_object_focus_allow_get(self.obj)

        def __set__(self, allow):
            elm_object_focus_allow_set(self.obj, allow)

    def focus_allow_set(self, allow):
        elm_object_focus_allow_set(self.obj, allow)
    def focus_allow_get(self):
        return elm_object_focus_allow_get(self.obj)

    property focus_custom_chain:
        """The custom focus chain.

        :type: list of :py:class:`elementary.object.Object`

        """
        def __get__(self):
            return _object_list_to_python(elm_object_focus_custom_chain_get(self.obj))

        def __set__(self, objs):
            elm_object_focus_custom_chain_unset(self.obj)
            cdef Object obj
            for obj in objs:
                elm_object_focus_custom_chain_append(self.obj, obj.obj, NULL)

        def __del__(self):
            elm_object_focus_custom_chain_unset(self.obj)

    def focus_custom_chain_set(self, objs):
        elm_object_focus_custom_chain_unset(self.obj)
        cdef Object obj
        for obj in objs:
            elm_object_focus_custom_chain_append(self.obj, obj.obj, NULL)
    def focus_custom_chain_unset(self):
        elm_object_focus_custom_chain_unset(self.obj)
    def focus_custom_chain_get(self):
        return _object_list_to_python(elm_object_focus_custom_chain_get(self.obj))

    def focus_custom_chain_append(self, Object child, Object relative_child=None):
        """focus_custom_chain_append(Object child, Object relative_child=None)

        Append object to custom focus chain.

        .. note:: If relative_child equal to None or not in custom chain, the
            object will be added in end.

        .. note:: On focus cycle, only will be evaluated children of this
            container.

        :param child: The child to be added in custom chain
        :type child: :py:class:`elementary.object.Object`
        :param relative_child: The relative object to position the child
        :type relative_child: :py:class:`elementary.object.Object`

        """
        cdef Evas_Object *rel = NULL
        if relative_child:
            rel = relative_child.obj
        elm_object_focus_custom_chain_append(self.obj, child.obj, rel)

    def focus_custom_chain_prepend(self, Object child, Object relative_child=None):
        """focus_custom_chain_prepend(Object child, Object relative_child=None)

        Prepend object to custom focus chain.

        .. note:: If relative_child equal to None or not in custom chain, the
            object will be added in begin.

        .. note:: On focus cycle, only will be evaluated children of this
            container.

        :param child: The child to be added in custom chain
        :type child: :py:class:`elementary.object.Object`
        :param relative_child: The relative object to position the child
        :type relative_child: :py:class:`elementary.object.Object`

        """
        cdef Evas_Object *rel = NULL
        if relative_child:
            rel = relative_child.obj
        elm_object_focus_custom_chain_prepend(self.obj, child.obj, rel)

    #def focus_next(self, direction):
        """Give focus to next object in object tree.

        Give focus to next object in focus chain of one object sub-tree. If
        the last object of chain already have focus, the focus will go to the
        first object of chain.

        :param dir: Direction to move the focus
        :type dir: Elm_Focus_Direction

        """
        #elm_object_focus_next(self.obj, direction)

    property tree_focus_allow:
        """Whether the Elementary object and its children are focusable
        or not.

        This reflects whether the object and its children objects are able to
        take focus or not. If the tree is set as unfocusable, newest focused
        object which is not in this tree will get focus. This API can be
        helpful for an object to be deleted. When an object will be deleted
        soon, it and its children may not want to get focus (by focus
        reverting or by other focus controls). Then, just use this API
        before deleting.

        :type: bool

        """
        def __get__(self):
            return bool(elm_object_tree_focus_allow_get(self.obj))

        def __set__(self, focusable):
            elm_object_tree_focus_allow_set(self.obj, focusable)

    def tree_focus_allow_set(self, focusable):
        elm_object_tree_focus_allow_set(self.obj, focusable)
    def tree_focus_allow_get(self):
        return bool(elm_object_tree_focus_allow_get(self.obj))

    # Mirroring
    property mirrored:
        """The widget's mirrored mode.

        :type: bool

        """
        def __get__(self):
            return bool(elm_object_mirrored_get(self.obj))
        def __set__(self, mirrored):
            elm_object_mirrored_set(self.obj, mirrored)

    def mirrored_get(self):
        return bool(elm_object_mirrored_get(self.obj))
    def mirrored_set(self, mirrored):
        elm_object_mirrored_set(self.obj, mirrored)

    property mirrored_automatic:
        """The widget's mirrored mode setting. When widget in automatic
        mode, it follows the system mirrored mode set by elm_mirrored_set().

        :type: bool

        """
        def __get__(self):
            return bool(elm_object_mirrored_automatic_get(self.obj))
        def __set__(self, automatic):
            elm_object_mirrored_automatic_set(self.obj, automatic)

    def mirrored_automatic_get(self):
        return bool(elm_object_mirrored_automatic_get(self.obj))
    def mirrored_automatic_set(self, automatic):
        elm_object_mirrored_automatic_set(self.obj, automatic)

    # Scaling
    property scale:
        """The scaling factor for the Elementary object.

        :type: float

        """
        def __get__(self):
            return elm_object_scale_get(self.obj)

        def __set__(self, scale):
            elm_object_scale_set(self.obj, scale)

    def scale_set(self, scale):
        elm_object_scale_set(self.obj, scale)
    def scale_get(self):
        return elm_object_scale_get(self.obj)

    # Scrollhints
    def scroll_hold_push(self):
        """scroll_hold_push()

        Push the scroll hold by 1

        This increments the scroll hold count by one. If it is more
        than 0 it will take effect on the parents of the indicated
        object.

        """
        elm_object_scroll_hold_push(self.obj)

    def scroll_hold_pop(self):
        """scroll_hold_pop()

        Pop the scroll hold by 1

        This decrements the scroll hold count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_hold_pop(self.obj)

    def scroll_freeze_push(self):
        """scroll_freeze_push()

        Push the scroll freeze by 1

        This increments the scroll freeze count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_freeze_push(self.obj)

    def scroll_freeze_pop(self):
        """scroll_freeze_pop()

        Pop the scroll freeze by 1

        This decrements the scroll freeze count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_freeze_pop(self.obj)

    property scroll_lock_x:
        def __get__(self):
            return bool(elm_object_scroll_lock_x_get(self.obj))

        def __set__(self, lock):
            elm_object_scroll_lock_x_set(self.obj, lock)

    def scroll_lock_x_set(self, lock):
        elm_object_scroll_lock_x_set(self.obj, lock)
    def scroll_lock_x_get(self):
        return bool(elm_object_scroll_lock_x_get(self.obj))

    property scroll_lock_y:
        def __get__(self):
            return bool(elm_object_scroll_lock_y_get(self.obj))

        def __set__(self, lock):
            elm_object_scroll_lock_y_set(self.obj, lock)

    def scroll_lock_y_set(self, lock):
        elm_object_scroll_lock_y_set(self.obj, lock)
    def scroll_lock_y_get(self):
        return bool(elm_object_scroll_lock_y_get(self.obj))

    # Theme
    property theme:
        """A theme to be used for this object and its children.

        This sets a specific theme that will be used for the given object
        and any child objects it has. If ``th`` is None then the theme to be
        used is cleared and the object will inherit its theme from its
        parent (which ultimately will use the default theme if no specific
        themes are set).

        Use special themes with great care as this will annoy users and make
        configuration difficult. Avoid any custom themes at all if it can be
        helped.

        :type: :py:class:`Theme`

        """
        def __set__(self, Theme th):
            elm_object_theme_set(self.obj, th.th)
        def __get__(self):
            cdef Theme th = Theme()
            th.th = elm_object_theme_get(self.obj)
            return th

    # Tooltips
    def tooltip_show(self):
        """tooltip_show()

        Force show the tooltip and disable hide on mouse_out If another
        content is set as tooltip, the visible tooltip will hidden and
        showed again with new content.

        This can force show more than one tooltip at a time.

        """
        elm_object_tooltip_show(self.obj)

    def tooltip_hide(self):
        """tooltip_hide()

        Force hide tooltip of the object and (re)enable future mouse
        interactions.

        """
        elm_object_tooltip_hide(self.obj)

    def tooltip_text_set(self, text):
        """tooltip_text_set(unicode text)

        Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed. Internally, this
        method calls :py:func:`tooltip_content_cb_set`

        """
        elm_object_tooltip_text_set(self.obj, _cfruni(text))

    def tooltip_domain_translatable_text_set(self, domain, text):
        elm_object_tooltip_domain_translatable_text_set(self.obj, _cfruni(domain), _cfruni(text))

    def tooltip_translatable_text_set(self, text):
        elm_object_tooltip_translatable_text_set(self.obj, _cfruni(text))

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """tooltip_content_cb_set(func, *args, **kargs)

        Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. C{func(owner, tooltip,
        args, kargs)} will be called every time that need show the tooltip
        and it should return a valid Evas_Object. This object is then
        managed fully by tooltip system and is deleted when the tooltip is
        gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, args, kargs)
        Py_INCREF(data)
        cbdata = <void *>data
        elm_object_tooltip_content_cb_set(self.obj, _tooltip_content_create,
                                          cbdata, _tooltip_data_del_cb)

    def tooltip_unset(self):
        """tooltip_unset()

        Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set` the
        internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but no freed.

        """
        elm_object_tooltip_unset(self.obj)

    property tooltip_style:
        """The style for this object tooltip.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_tooltip_style_get(self.obj))
        def __set__(self, style):
            elm_object_tooltip_style_set(self.obj, _cfruni(style) if style is not None else NULL)

    def tooltip_style_set(self, style=None):
        elm_object_tooltip_style_set(self.obj, _cfruni(style) if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_object_tooltip_style_get(self.obj))

    property tooltip_window_mode:
        def __get__(self):
            return bool(elm_object_tooltip_window_mode_get(self.obj))
        def __set__(self, disable):
            #TODO: check rval
            elm_object_tooltip_window_mode_set(self.obj, disable)

    def tooltip_window_mode_set(self, disable):
        return bool(elm_object_tooltip_window_mode_set(self.obj, disable))
    def tooltip_window_mode_get(self):
        return bool(elm_object_tooltip_window_mode_get(self.obj))

    #Translatable text
    def domain_translatable_text_part_set(self, part, domain, text):
        """domain_translatable_text_part_set(unicode part, unicode domain, unicode text)

        Set the text for an objects' part, marking it as translatable.

        The string to set as ``text`` must be the original one. Do not pass the
        return of ``gettext()`` here. Elementary will translate the string
        internally and set it on the object using :py:func:`part_text_set()`,
        also storing the original string so that it can be automatically
        translated when the language is changed with :py:func:`language_set()`.

        The ``domain`` will be stored along to find the translation in the
        correct catalog. It can be None, in which case it will use whatever
        domain was set by the application with ``textdomain()``. This is useful
        in case you are building a library on top of Elementary that will have
        its own translatable strings, that should not be mixed with those of
        programs using the library.

        :param part: The name of the part to set
        :type part: string
        :param domain: The translation domain to use
        :type domain: string
        :param text: The original, non-translated text to set
        :type text: string

        """
        elm_object_domain_translatable_text_part_set(self.obj, _cfruni(part), _cfruni(domain), _cfruni(text))

    def domain_translatable_text_set(self, domain, text):
        """domain_translatable_text_set(unicode domain, unicode text)

        Convenience function"""
        elm_object_domain_translatable_text_set(self.obj, _cfruni(domain), _cfruni(text))

    def translatable_text_part_get(self, part):
        """domain_translatable_text_part_get(unicode part) -> unicode

        Gets the original string set as translatable for an object

        When setting translated strings, the function :py:func:`part_text_get()`
        will return the translation returned by *gettext()*. To get the
        original string use this function.

        :param part: The name of the part that was set
        :type part: string

        :return: The original, untranslated string
        :rtype: string

        """
        return _ctouni(elm_object_translatable_text_part_get(self.obj, _cfruni(part)))

    property translatable_text:
        def __get__(self):
            return _ctouni(elm_object_translatable_text_get(self.obj))
        def __set__(self, text):
            elm_object_translatable_text_set(self.obj, _cfruni(text))

    def translatable_text_set(self, text):
        elm_object_translatable_text_set(self.obj, _cfruni(text))
    def translatable_text_get(self):
        return _ctouni(elm_object_translatable_text_get(self.obj))

    # Callbacks
    #
    # XXX: Should these be internal only? (cdef)
    #      Or remove the individual widget callback_*_add/del methods and use just these.
    #
    def _callback_add_full(self, event, event_conv, func, *args, **kargs):
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

        @raise TypeError: if **func** is not callable.
        @raise TypeError: if **event_conv** is not callable or None.

        """
        if not callable(func):
            raise TypeError("func must be callable")
        if event_conv is not None and not callable(event_conv):
            raise TypeError("event_conv must be None or callable")

        if self._elmcallbacks is None:
            self._elmcallbacks = {}

        e = intern(event)
        lst = self._elmcallbacks.setdefault(e, [])
        if not lst:
            evas_object_smart_callback_add(self.obj, _fruni(event),
                                                  _object_callback, <void *>e)
        lst.append((event_conv, func, args, kargs))

    def _callback_del_full(self, event, event_conv, func):
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`_callback_add_full()`.

        :param event: event name
        :type event: string
        :param event_conv: same as registered with :py:func:`_callback_add_full()`
        :type event_conv: function
        :param func: what to callback, should have be previously registered.
        :type func: function

        @precond: **event**, **event_conv** and **func** must be used as
           parameter for :py:func:`_callback_add_full()`.

        @raise ValueError: if there was no **func** connected with this event.

        """
        try:
            lst = self._elmcallbacks[event]
        except KeyError as e:
            raise ValueError("Unknown event %r" % event)

        i = -1
        ec = None
        f = None
        for i, (ec, f, a, k) in enumerate(lst):
            if event_conv == ec and func == f:
                break

        if f != func or ec != event_conv:
            raise ValueError("Callback %s was not registered with event %r" %
                             (func, event))

        lst.pop(i)
        if lst:
            return
        self._elmcallbacks.pop(event)
        evas_object_smart_callback_del(self.obj, _fruni(event), _object_callback)

    def _callback_add(self, event, func, *args, **kargs):
        """Add a callback for the smart event specified by event.

        :param event: event name
        :type event: string
        :param func: what to callback. Should have the signature:
            *function(object, *args, **kargs)*
        :type func: function

        @raise TypeError: if **func** is not callable.

        """
        return self._callback_add_full(event, None, func, *args, **kargs)

    def _callback_del(self, event, func):
        """Remove a smart callback.

        Removes a callback that was added by :py:func:`_callback_add()`.

        :param event: event name
        :type event: string
        :param func: what to callback, should have be previously registered.
        :type func: function

        @precond: **event** and **func** must be used as parameter for
            :py:func:`_callback_add()`.

        @raise ValueError: if there was no **func** connected with this event.

        """
        return self._callback_del_full(event, None, func)

    def _get_obj_addr(self):
        """Return the address of the internal save Evas_Object

        :return: Address of saved Evas_Object

        """
        return <long>self.obj

