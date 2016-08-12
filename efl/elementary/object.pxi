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

include "object_cdef.pxi"

include "cnp_callbacks.pxi"

cdef Evas_Object *_tooltip_content_create(void *data, Evas_Object *o, Evas_Object *t) with gil:
    cdef Object ret, obj, tooltip

    obj = object_from_instance(o)
    tooltip = object_from_instance(t)
    (func, args, kargs) = <object>data
    ret = func(obj, tooltip, *args, **kargs)
    if not ret:
        return NULL
    return ret.obj

cdef void _tooltip_data_del_cb(void *data, Evas_Object *o, void *event_info) with gil:
    Py_DECREF(<object>data)


cdef bint _event_dispatcher(Object obj, Object src, Evas_Callback_Type t,
    event_info):
    cdef bint ret
    for func, args, kargs in obj._elm_event_cbs:
        try:
            ret = func(obj, src, t, event_info, *args, **kargs)
        except Exception:
            traceback.print_exc()
        else:
            return ret
    return False

cdef Eina_Bool _event_callback(void *data, Evas_Object *o, \
    Evas_Object *src, Evas_Callback_Type t, void *event_info) with gil:

    cdef:
        Object obj = object_from_instance(o)
        Object src_obj = object_from_instance(src)
        bint ret = False
        EventKeyDown down_event
        EventKeyUp up_event

    if t == <int>EVAS_CALLBACK_KEY_DOWN:
        down_event = EventKeyDown()
        down_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, down_event)
        down_event._unset_obj()
    elif t == <int>EVAS_CALLBACK_KEY_UP:
        up_event = EventKeyUp()
        up_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, up_event)
        up_event._unset_obj()
    elif t == <int>EVAS_CALLBACK_MOUSE_WHEEL:
        wheel_event = EventMouseWheel()
        wheel_event._set_obj(event_info)
        ret = _event_dispatcher(obj, src_obj, t, wheel_event)
        wheel_event._unset_obj()
    else:
        EINA_LOG_DOM_DBG(
            PY_EFL_ELM_LOG_DOMAIN, "Unhandled elm input event of type %i", t)

    return ret

cdef void signal_callback(void *data, Evas_Object *obj,
                    const char *emission, const char *source) with gil:
    cdef Object self = object_from_instance(obj)
    lst = tuple(<object>data)
    for func, args, kargs in lst:
        try:
            func(self, _ctouni(emission), _ctouni(source), *args, **kargs)
        except Exception:
            traceback.print_exc()


cdef class Object(SmartObject):
    """

    An abstract class to manage object and callback handling.

    All widgets are based on this class.

    """

    cdef:
        list _elm_event_cbs, _elm_signal_cbs
        object cnp_drop_cb, cnp_drop_data
        object cnp_selection_loss_cb, cnp_selection_loss_data

    def __init__(self, *args, **kwargs):
        if type(self) is Object:
            raise TypeError("Must not instantiate Object, but subclasses")

    cdef int _set_obj(self, Evas_Object *obj) except 0:
        return evasObject._set_obj(self, obj)

    def part_text_set(self, part, text):
        """Sets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_get()`

        :param part: part name to set the text.
        :type part: string
        :param text: text to set.
        :type text: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_part_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>text if text is not None else NULL)

    def part_text_get(self, part):
        """Gets the text of a given part of this object.

        .. seealso:: :py:attr:`text` and :py:func:`part_text_set()`

        :param part: part name to get the text.
        :type part: string
        :return: the text of a part or None if nothing was set.
        :rtype: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_object_part_text_get(self.obj,
            <const char *>part if part is not None else NULL))

    property text:
        """The main text for this object.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_text_get(self.obj))

        def __set__(self, text):
            if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
            elm_object_text_set(self.obj,
                <const char *>text if text is not None else NULL)

    def text_set(self, text):
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_text_set(self.obj,
            <const char *>text if text is not None else NULL)
    def text_get(self):
        return _ctouni(elm_object_text_get(self.obj))

    def part_content_set(self, part, evasObject content not None):
        """Set a content of an object

        This sets a new object to a widget as a content object. If any
        object was already set as a content object in the same part,
        previous object will be deleted automatically.

        .. note:: Elementary objects may have many contents

        :param part: The content part name to set (None for the default content)
        :type part: string
        :param content: The new content of the object
        :type content: :py:class:`efl.evas.Object`

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        elm_object_part_content_set(self.obj,
            <const char *>part if part is not None else NULL, content.obj)

    def part_content_get(self, part):
        """Get a content of an object

        .. note:: Elementary objects may have many contents

        :param part: The content part name to get (None for the default content)
        :type part: string
        :return: content of the object or None for any error
        :rtype: :py:class:`efl.evas.Object`

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_object_part_content_get(self.obj,
            <const char *>part if part is not None else NULL))

    def part_content_unset(self, part):
        """Unset a content of an object

        .. note:: Elementary objects may have many contents

        :param part: The content part name to unset (None for the default
            content)
        :type part: string

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return object_from_instance(elm_object_part_content_unset(self.obj,
            <const char *>part if part is not None else NULL))

    property content:
        """Main content part for this object.

        :type: :py:class:`efl.evas.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_content_get(self.obj))

        def __set__(self, evasObject content):
            elm_object_content_set(self.obj, content.obj)

        def __del__(self):
            elm_object_content_unset(self.obj)

    def content_set(self, evasObject obj not None):
        elm_object_part_content_set(self.obj, NULL, obj.obj)
    def content_get(self):
        return object_from_instance(elm_object_content_get(self.obj))
    def content_unset(self):
        return object_from_instance(elm_object_content_unset(self.obj))

    # def access_info_set(self, txt):
    #     """access_info_set(unicode txt)

    #     Set the text to read out when in accessibility mode

    #     :param txt: The text that describes the widget to people with poor
    #         or no vision
    #     :type txt: string

    #     """
    #     if isinstance(txt, unicode): txt = PyUnicode_AsUTF8String(txt)
    #     elm_object_access_info_set(self.obj,
    #         <const char *>txt if txt is not None else NULL)

    def name_find(self, name not None, int recurse = 0):
        """Get a named object from the children

        This function searches the children (or recursively children of children
        and so on) of the given object looking for a child with the name of
        *name*. If the child is found the object is returned, or None is
        returned. You can set the name of an object with
        :py:attr:`name<efl.evas.Object.name>`. If the name is not unique within
        the child objects (or the tree is ``recurse`` is greater than 0) then it
        is undefined as to which child of that name is returned, so ensure the
        name is unique amongst children. If recurse is set to -1 it will recurse
        without limit.

        :param name: The name of the child to find
        :type name: string
        :param recurse: Set to the maximum number of levels to recurse (0 ==
            none, 1 is only look at 1 level of children etc.)
        :type recurse: int
        :return: The found object of that name, or None if none is found
        :rtype: :py:class:`~efl.elementary.object.Object`

        """
        if isinstance(name, unicode): name = PyUnicode_AsUTF8String(name)
        return object_from_instance(elm_object_name_find(self.obj,
            <const char *>name if name is not None else NULL,
            recurse))

    property style:
        """The style to be used by the widget

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_style_get(self.obj))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_style_set(self.obj,
                <const char *>style if style is not None else NULL)

    def style_set(self, style):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_style_set(self.obj,
            <const char *>style if style is not None else NULL)
    def style_get(self):
        return _ctouni(elm_object_style_get(self.obj))

    property disabled:
        """The disabled state of an Elementary object.

        Elementary objects can be **disabled**, in which state they won't
        receive input and, in general, will be themed differently from their
        normal state, usually greyed out. Useful for contexts where you don't
        want your users to interact with some of the parts of you interface.

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

    @DEPRECATED("1.8", "Use type(obj) instead.")
    def widget_check(self):
        """Check if the given Evas Object is an Elementary widget.

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

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_parent_widget_get(self.obj))

    def parent_widget_get(self):
        return object_from_instance(elm_object_parent_widget_get(self.obj))

    property top_widget:
        """The top level parent of an Elementary widget.
        This is a readonly property.

        :type: :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return object_from_instance(elm_object_top_widget_get(self.obj))

    def top_widget_get(self):
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
            return self.widget_type_get()

    @DEPRECATED("1.8", "Use type(obj) instead.")
    def widget_type_get(self):
        return elm_object_widget_type_get(self.obj)

    def signal_emit(self, emission, source):
        """Send a signal to the widget edje object.

        This function sends a signal to the edje object of the obj. An edje
        program can respond to a signal by specifying matching 'signal' and
        'source' fields.

        :param emission: The signal's name.
        :type emission: string
        :param source: The signal's source.
        :type source: string

        """
        if isinstance(emission, unicode):
            emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        elm_object_signal_emit(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL)

    def signal_callback_add(self, emission, source, func, *args, **kwargs):
        """Add a callback for a signal emitted by widget edje object.

        This function connects a callback function to a signal emitted by the
        edje object of the obj.
        Globs can occur in either the emission or source name.

        :param emission: The signal's name.
        :param source: The signal's source.
        :param func: The callback function to be executed when the signal is
            emitted.

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        d = self._elm_signal_cbs.setdefault(emission, {})
        lst = d.setdefault(source, [])
        if not lst:
            if isinstance(emission, unicode):
                emission = PyUnicode_AsUTF8String(emission)
            if isinstance(source, unicode):
                source = PyUnicode_AsUTF8String(source)
            elm_object_signal_callback_add(self.obj,
                <const char *>emission if emission is not None else NULL,
                <const char *>source if source is not None else NULL,
                signal_callback, <void*>lst)
        lst.append((func, args, kwargs))

    def signal_callback_del(self, emission, source, func):
        """Remove a signal-triggered callback from a widget edje object.

        :param emission: The signal's name.
        :param source: The signal's source.
        :param func: The callback function to be executed when the signal is
            emitted.

        This function removes the **last** callback, previously attached to
        a signal emitted by an underlying Edje object, whose
        parameters *emission*, *source* and *func* match exactly with
        those passed to a previous call to
        :py:func:`signal_callback_add`.

        """
        try:
            d = self._elm_signal_cbs[emission]
            lst = d[source]
        except KeyError:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        i = -1
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break
        else:
            raise ValueError(("function %s not associated with "
                              "emission %r, source %r") %
                             (func, emission, source))

        lst.pop(i)
        if lst:
            return
        d.pop(source)
        if not d:
            self._elm_signal_cbs.pop(emission)
        if isinstance(emission, unicode):
            emission = PyUnicode_AsUTF8String(emission)
        if isinstance(source, unicode): source = PyUnicode_AsUTF8String(source)
        elm_object_signal_callback_del(self.obj,
            <const char *>emission if emission is not None else NULL,
            <const char *>source if source is not None else NULL,
            signal_callback)

    #
    # TODO: Review this
    #
    # NOTE: name clash with evas event_callback_*
    def elm_event_callback_add(self, func, *args, **kargs):
        """Add a callback for input events (key up, key down, mouse wheel)
        on a given Elementary widget

        Every widget in an Elementary interface set to receive focus, with
        :py:attr:`focus_allow`, will propagate **all** of its key up,
        key down and mouse wheel input events up to its parent object, and
        so on. All of the focusable ones in this chain which had an event
        callback set, with this call, will be able to treat those events.
        There are two ways of making the propagation of these event upwards
        in the tree of widgets to **cease**:

        - Just return ``True`` on *func*. ``False`` will mean the event
            was **not** processed, so the propagation will go on.
        - The ``event_info`` passed to ``func`` will contain the
            event's structure and, if you OR its ``event_flags`` inner
            value to *EVAS_EVENT_FLAG_ON_HOLD*, you're telling
            Elementary one has already handled it, thus killing the
            event's propagation, too.

        .. note:: Your event callback will be issued on those events taking
            place only if no other child widget has consumed the event already.

        .. note:: Not to be confused with
            :py:meth:`efl.evas.Object.event_callback_add`,
            which will add event callbacks per type on general Evas objects
            (no event propagation infrastructure taken in account).

        .. note:: Not to be confused with :py:meth:`signal_callback_add()`,
            which will add callbacks to **signals** coming from a widget's
            theme, not input events.

        .. note:: Not to be confused with
            :py:meth:`efl.edje.Edje.signal_callback_add`,
            which does the same as :py:meth:`signal_callback_add()`, but
            directly on an Edje object.

        .. note:: Not to be confused with
            :py:meth:`efl.evas.Object.smart_callback_add`,
            which adds callbacks to smart objects' **smart events**, and not
            input events.

        .. seealso:: :py:meth:`elm_event_callback_del()`

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
        """Remove an event callback from a widget.

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


    property orientation_mode_disabled:
        """For disabling the orientation mode.

        Orientation mode is used by widgets to change their styles or to send
        signals whenever their window orientation is changed. If the orientation
        mode is enabled and the widget has different looks and styles for a
        window orientation (0, 90, 180, 270), it will apply a style that has
        been prepared for the new orientation, otherwise, it will send
        signals to its own edje to change its states.

        :type: bool

        .. versionadded:: 1.8

        """
        def __set__(self, bint disabled):
            elm_object_orientation_mode_disabled_set(self.obj, disabled)

        def __get__(self):
            return bool(elm_object_orientation_mode_disabled_get(self.obj))

    def orientation_mode_disabled_set(self, bint disabled):
        elm_object_orientation_mode_disabled_set(self.obj, disabled)

    def orientation_mode_disabled_get(self):
        return bool(elm_object_orientation_mode_disabled_get(self.obj))

    #
    # Smart event callbacks
    # =====================

    def callback_moved_add(self, func, *args, **kwargs):
        """ The Object change position.

        .. versionadded:: 1.17
        """
        self._callback_add("moved", func, args, kwargs)

    def callback_moved_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("moved", func)

    def callback_focused_add(self, func, *args, **kwargs):
        """ The Object has received focus.

        .. versionadded:: 1.8
        """
        self._callback_add("focused", func, args, kwargs)

    def callback_focused_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("focused", func)

    def callback_unfocused_add(self, func, *args, **kwargs):
        """ The Object has lost focus.

        .. versionadded:: 1.8
        """
        self._callback_add("unfocused", func, args, kwargs)

    def callback_unfocused_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("unfocused", func)

    def callback_language_changed_add(self, func, *args, **kwargs):
        """ The program's language changed

        .. versionadded:: 1.8.1
        """
        self._callback_add("language,changed", func, args, kwargs)

    def callback_language_changed_del(self, func):
        """ Delete a previously attached callback """
        self._callback_del("language,changed", func)

    #
    # Cursors
    # =======

    property cursor:
        """The cursor to be shown when mouse is over the object

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_cursor_get(self.obj))

        def __set__(self, cursor):
            if isinstance(cursor, unicode):
                cursor = PyUnicode_AsUTF8String(cursor)
            elm_object_cursor_set(self.obj,
                <const char *>cursor if cursor is not None else NULL)

        def __del__(self):
            elm_object_cursor_unset(self.obj)

    def cursor_set(self, cursor):
        if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
        elm_object_cursor_set(self.obj,
            <const char *>cursor if cursor is not None else NULL)
    def cursor_get(self):
        return _ctouni(elm_object_cursor_get(self.obj))
    def cursor_unset(self):
        elm_object_cursor_unset(self.obj)

    property cursor_style:
        """The style for this object cursor.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_cursor_style_get(self.obj))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_cursor_style_set(self.obj,
                <const char *>style if style is not None else NULL)

    def cursor_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_cursor_style_set(self.obj,
            <const char *>style if style is not None else NULL)
    def cursor_style_get(self):
        return _ctouni(elm_object_cursor_style_get(self.obj))

    property cursor_theme_search_enabled:
        """Whether cursor engine only usage is enabled for this object.

        :type: bool

        .. note:: before you set engine only usage you should define a
            cursor with :py:attr:`cursor`

        """
        def __get__(self):
            return elm_object_cursor_theme_search_enabled_get(self.obj)

        def __set__(self, engine_only):
            elm_object_cursor_theme_search_enabled_set(
                self.obj, bool(engine_only)
                )

    def cursor_theme_search_enabled_set(self, engine_only):
        elm_object_cursor_theme_search_enabled_set(self.obj, bool(engine_only))
    def cursor_theme_search_enabled_get(self):
        return elm_object_cursor_theme_search_enabled_get(self.obj)

    #
    # Focus
    # =====

    property focus:
        """Set/unset focus to a given Elementary object.

        .. note:: When you set focus to this object, if it can handle focus,
            will take the focus away from the one who had it previously and
            will, for now on, be the one receiving input events. Unsetting
            focus will remove the focus from the object, passing it back to
            the previous element in the focus chain list.

        :type: bool

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

        :type: list of :py:class:`~efl.elementary.object.Object`

        """
        def __get__(self):
            return eina_list_objects_to_python_list(
                elm_object_focus_custom_chain_get(self.obj)
                )

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
        return eina_list_objects_to_python_list(
            elm_object_focus_custom_chain_get(self.obj)
            )

    def focus_custom_chain_append(self, Object child not None,
        Object relative_child=None):
        """Append object to custom focus chain.

        .. note:: If relative_child equal to None or not in custom chain, the
            object will be added in end.

        .. note:: On focus cycle, only will be evaluated children of this
            container.

        :param child: The child to be added in custom chain
        :type child: :py:class:`~efl.elementary.object.Object`
        :param relative_child: The relative object to position the child
        :type relative_child: :py:class:`~efl.elementary.object.Object`

        """
        cdef Evas_Object *rel = NULL
        if relative_child is not None:
            rel = relative_child.obj
        elm_object_focus_custom_chain_append(self.obj, child.obj, rel)

    def focus_custom_chain_prepend(self, Object child not None,
        Object relative_child=None):
        """Prepend object to custom focus chain.

        .. note:: If relative_child equal to None or not in custom chain, the
            object will be added in begin.

        .. note:: On focus cycle, only will be evaluated children of this
            container.

        :param child: The child to be added in custom chain
        :type child: :py:class:`~efl.elementary.object.Object`
        :param relative_child: The relative object to position the child
        :type relative_child: :py:class:`~efl.elementary.object.Object`

        """
        cdef Evas_Object *rel = NULL
        if relative_child is not None:
            rel = relative_child.obj
        elm_object_focus_custom_chain_prepend(self.obj, child.obj, rel)

    def focus_next(self, Elm_Focus_Direction direction):
        """Give focus to next object in object tree.

        Give focus to next object in focus chain of one object sub-tree. If
        the last object of chain already have focus, the focus will go to the
        first object of chain.

        :param dir: Direction to move the focus
        :type dir: :ref:`Elm_Object_Focus_Direction`

        """
        elm_object_focus_next(self.obj, direction)

    def focus_next_object_get(self, Elm_Focus_Direction direction):
        """Get next object which was set with specific focus direction.

        Get next object which was set by elm_object_focus_next_object_set
        with specific focus direction.

        :param dir: Focus direction
        :type dir: :ref:`Elm_Object_Focus_Direction`
        :return: Focus next object or None, if there is no focus next object.

        :see: :py:func:`focus_next`

        .. versionadded:: 1.8

        """
        return object_from_instance(
            elm_object_focus_next_object_get(self.obj, direction)
            )

    def focus_next_object_set(self, evasObject next,
        Elm_Focus_Direction direction):
        """Set next object with specific focus direction.

        When focus next object is set with specific focus direction, this object
        will be the first candidate when finding next focusable object. Focus
        next object can be registered with six directions that are previous,
        next, up, down, right, and left.

        :param next: Focus next object
        :param dir: Focus direction
        :type dir: :ref:`Elm_Object_Focus_Direction`

        :see: :py:func:`focus_next`

        .. versionadded:: 1.8

        """
        elm_object_focus_next_object_set(self.obj, next.obj, direction)

    property focused_object:
        """The focused object in an object tree.

        :return: Current focused or None, if there is no focused object.

        .. versionadded:: 1.8

        """
        def __get__(self):
            return object_from_instance(elm_object_focused_object_get(self.obj))

    def focused_object_get(self):
        return object_from_instance(elm_object_focused_object_get(self.obj))

    def focus_next_item_get(self, Elm_Focus_Direction direction):
        """Get next object item which was set with specific focus direction.

        Get next object item which was set by :func:`focus_next_item_set`
        with specific focus direction.

        :return: Focus next object item or ``None``, if there is no focus next
                 object item.
        :rtype: :class:`ObjectItem`

        .. versionadded:: 1.16

        """
        return _object_item_to_python(
                        elm_object_focus_next_item_get(self.obj, direction))

    def focus_next_item_set(self, ObjectItem next,
                            Elm_Focus_Direction direction):
        """ Set next object item with specific focus direction.

        When focus next object item is set with specific focus direction, this
        object item will be the first candidate when finding next focusable
        object or item. If the focus next object item is set, it is preference
        to focus next object. Focus next object item can be registered with six
        directions that are previous, next, up, down, right, and left.

        :param next: Focus next object item
        :type next: :class:`ObjectItem`
        :param dir: Focus direction
        :type dir: :ref:`Elm_Focus_Direction`

        :see: :py:func:`focus_next_item_get`

        .. versionadded:: 1.16

        """
        elm_object_focus_next_item_set(self.obj, next.item, direction)

    property focused_item:
        """The focused object item in an object tree.

        :return: Current focused item or None, if there is no focused item.

        .. versionadded:: 1.10

        """
        def __get__(self):
            return _object_item_to_python(elm_object_focused_item_get(self.obj))

    def focused_item_get(self):
        return _object_item_to_python(elm_object_focused_item_get(self.obj))


    property focus_highlight_style:
        """The focus highlight style name to be used.

        :type: string

        .. note:: This overrides the style which is set by
                  :py:func:`Win.focus_highlight_style_set()`.

        .. versionadded:: 1.9

        """
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_focus_highlight_style_set(self.obj,
                    <const char *>style if style is not None else NULL)
        def __get__(self):
            return elm_object_focus_highlight_style_get(self.obj)

    def focus_highlight_style_set(self, style):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_focus_highlight_style_set(self.obj,
                <const char *>style if style is not None else NULL)
    def focus_highlight_style_get(self):
        return elm_object_focus_highlight_style_get(self.obj)

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

    property focus_move_policy:
        """The focus movement policy for the object.

        :type: :ref:`Elm_Focus_Move_Policy`

        .. versionadded:: 1.15

        .. seealso:: :attr:`focus_move_policy_automatic`

        """
        def __get__(self):
            return elm_object_focus_move_policy_get(self.obj)

        def __set__(self, Elm_Focus_Move_Policy policy):
            elm_object_focus_move_policy_set(self.obj, policy)

    def focus_move_policy_get(self):
        return elm_object_focus_move_policy_get(self.obj)
    def focus_move_policy_set(self, Elm_Focus_Move_Policy policy):
        elm_object_focus_move_policy_set(self.obj, policy)

    property focus_move_policy_automatic:
        """The widget's focus movement policy mode setting.

        When widget in automatic mode, it follows the system focus movement
        policy mode set by :attr:`efl.elementary.Configuration.focus_move_policy`.

        :type: bool

        .. versionadded:: 1.18

        .. seealso::
            :attr:`focus_move_policy`

            :attr:`efl.elementary.Configuration.focus_move_policy`

        """
        def __get__(self):
            return bool(elm_object_focus_move_policy_automatic_get(self.obj))
        def __set__(self, bint automatic):
            elm_object_focus_move_policy_automatic_set(self.obj, automatic)

    def focus_move_policy_automatic_get(self):
        return bool(elm_object_focus_move_policy_automatic_get(self.obj))
    def focus_move_policy_automatic_set(self, bint automatic):
        elm_object_focus_move_policy_automatic_set(self.obj, automatic)


    property focus_region_show_mode:
        """The focus movement policy for the object.

        When the focus is move to the object in scroller, it is scrolled to
        show the focus region as a widget. If the focus region want to be shown
        as an item, set the mode ELM_FOCUS_REGION_SHOW_ITEM. If then, it will
        be scrolled as an item.

        :type: :ref:`Elm_Focus_Region_Show_Mode`

        .. versionadded:: 1.16

        """
        def __get__(self):
            return elm_object_focus_region_show_mode_get(self.obj)

        def __set__(self, Elm_Focus_Region_Show_Mode mode):
            elm_object_focus_region_show_mode_set(self.obj, mode)

    def focus_region_show_mode_get(self):
        return elm_object_focus_region_show_mode_get(self.obj)
    def focus_region_show_mode_set(self, Elm_Focus_Region_Show_Mode mode):
        elm_object_focus_region_show_mode_set(self.obj, mode)

    #
    # Mirroring
    # =========

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
        mode, it follows the system mirrored mode set by
        :py:attr:`efl.elementary.configuration.Configuration.mirrored`.

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

    #
    # Scaling
    # =======

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

    #
    # Scrollhints
    # ===========

    def scroll_hold_push(self):
        """Push the scroll hold by 1

        This increments the scroll hold count by one. If it is more
        than 0 it will take effect on the parents of the indicated
        object.

        """
        elm_object_scroll_hold_push(self.obj)

    def scroll_hold_pop(self):
        """Pop the scroll hold by 1

        This decrements the scroll hold count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_hold_pop(self.obj)

    property scroll_hold:
        """The scroll hold count.

        :type: int

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_object_scroll_hold_get(self.obj)

    def scroll_hold_get(self):
        return elm_object_scroll_hold_get(self.obj)

    def scroll_freeze_push(self):
        """Push the scroll freeze by 1

        This increments the scroll freeze count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_freeze_push(self.obj)

    def scroll_freeze_pop(self):
        """Pop the scroll freeze by 1

        This decrements the scroll freeze count by one. If it is more than 0
        it will take effect on the parents of the indicated object.

        """
        elm_object_scroll_freeze_pop(self.obj)

    property scroll_freeze:
        """The scroll freeze count.

        :type: int

        .. versionadded:: 1.8

        """
        def __get__(self):
            return elm_object_scroll_freeze_get(self.obj)

    def scroll_freeze_get(self):
        return elm_object_scroll_freeze_get(self.obj)

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

    property scroll_item_loop_enabled:
        """Enable item loop feature of the given widget

        If this is True, item selection/focus will loop internally.
        This means if arrow keys are pressed at end of scroller's item,
        screen is moved to opposite side.

        :type: bool

        .. versionadded:: 1.10

        """
        def __get__(self):
            return bool(elm_object_scroll_item_loop_enabled_get(self.obj))

        def __set__(self, enable):
            elm_object_scroll_item_loop_enabled_set(self.obj, enable)

    def scroll_item_loop_enabled_set(self, enable):
        elm_object_scroll_item_loop_enabled_set(self.obj, enable)
    def scroll_item_loop_enabled_get(self):
        return bool(elm_object_scroll_item_loop_enabled_get(self.obj))


    #
    # Theme
    # =====

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

        :type: :py:class:`~efl.elementary.theme.Theme`

        """
        def __set__(self, Theme th):
            elm_object_theme_set(self.obj,
                th.th if th is not None else NULL
                )

        def __get__(self):
            cdef Theme th = Theme.__new__(Theme)
            th.th = elm_object_theme_get(self.obj)
            return th

    #
    # Tooltips
    # ========

    def tooltip_show(self):
        """Force show the tooltip and disable hide on mouse_out If another
        content is set as tooltip, the visible tooltip will hidden and
        showed again with new content.

        This can force show more than one tooltip at a time.

        """
        elm_object_tooltip_show(self.obj)

    def tooltip_hide(self):
        """Force hide tooltip of the object and (re)enable future mouse
        interactions.

        """
        elm_object_tooltip_hide(self.obj)

    def tooltip_text_set(self, text):
        """Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed. Internally, this
        method calls :py:func:`tooltip_content_cb_set`

        """
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_tooltip_text_set(self.obj,
            <const char *>text if text is not None else NULL)

    def tooltip_domain_translatable_text_set(self, domain, text):
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_tooltip_domain_translatable_text_set(self.obj,
            <const char *>domain if domain is not None else NULL,
            <const char *>text if text is not None else NULL)

    def tooltip_translatable_text_set(self, text):
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_tooltip_translatable_text_set(self.obj,
            <const char *>text if text is not None else NULL)

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. ``func(owner, tooltip,
        args, kargs)`` will be called every time that need show the tooltip
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
        """Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set` the
        internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but no
        freed.

        """
        elm_object_tooltip_unset(self.obj)

    property tooltip_style:
        """The style for this object tooltip.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_object_tooltip_style_get(self.obj))
        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_object_tooltip_style_set(self.obj,
                <const char *>style if style is not None else NULL)

    def tooltip_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_object_tooltip_style_set(self.obj,
            <const char *>style if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_object_tooltip_style_get(self.obj))

    property tooltip_orient:
        """The orientation of the tooltip around the owner region.

        :type: :ref:`Elm_Tooltip_Orient`

        .. versionadded:: 1.16

        """
        def __get__(self):
            return elm_object_tooltip_orient_get(self.obj)
        def __set__(self, Elm_Tooltip_Orient orient):
            elm_object_tooltip_orient_set(self.obj, orient)

    def tooltip_orient_set(self, Elm_Tooltip_Orient orient):
        elm_object_tooltip_orient_set(self.obj, orient)
    def tooltip_orient_get(self):
        return elm_object_tooltip_orient_get(self.obj)

    property tooltip_window_mode:
        def __get__(self):
            return bool(elm_object_tooltip_window_mode_get(self.obj))
        def __set__(self, disable):
            if not elm_object_tooltip_window_mode_set(self.obj, disable):
                raise RuntimeError("Could not set tooltip_window_mode.")

    def tooltip_window_mode_set(self, disable):
        return bool(elm_object_tooltip_window_mode_set(self.obj, disable))
    def tooltip_window_mode_get(self):
        return bool(elm_object_tooltip_window_mode_get(self.obj))

    def tooltip_move_freeze_push(self):
        """This increments the tooltip movement freeze count by one. If the count
        is more than 0, the tooltip position will be fixed.

        .. versionadded:: 1.9

        """
        elm_object_tooltip_move_freeze_push(self.obj)

    def tooltip_move_freeze_pop(self):
        """This decrements the tooltip freeze count by one. If the count
        is more than 0, the tooltip position will be fixed.

        .. versionadded:: 1.9

        """
        elm_object_tooltip_move_freeze_pop(self.obj)

    def tooltip_move_freeze_get(self):
        """Get the movement freeze count of the object

        .. versionadded:: 1.9

        """
        return elm_object_tooltip_move_freeze_get(self.obj)


    #Translatable text
    @DEPRECATED("1.8", "Use :py:func:`domain_translatable_part_text_set` instead.")
    def domain_translatable_text_part_set(self, part, domain, text):
        """domain_translatable_text_part_set(part, domain, text)"""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_domain_translatable_part_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>domain if domain is not None else NULL,
            <const char *>text if text is not None else NULL)

    def domain_translatable_part_text_set(self, part = None, domain = None,
        text = None):
        """Set the text for an object's part, marking it as translatable.

        The string to set as ``text`` must be the original one. Do not pass the
        return of ``gettext()`` here. Elementary will translate the string
        internally and set it on the object using :py:func:`part_text_set`,
        also storing the original string so that it can be automatically
        translated when the language is changed with
        :py:func:`efl.elementary.general.language_set`.

        The ``domain`` will be stored along to find the translation in the
        correct catalog. It can be None, in which case it will use whatever
        domain was set by the application with ``textdomain()``. This is useful
        in case you are building a library on top of Elementary that will have
        its own translatable strings, that should not be mixed with those of
        programs using the library.

        :param part: The name of the part to set
        :param domain: The translation domain to use
        :param text: The original, non-translated text to set

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_domain_translatable_part_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>domain if domain is not None else NULL,
            <const char *>text if text is not None else NULL)


    def domain_translatable_text_set(self, domain, text):
        """A convenience function."""
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_domain_translatable_text_set(self.obj,
            <const char *>domain if domain is not None else NULL,
            <const char *>text if text is not None else NULL)

    def translatable_part_text_set(self, part, text):
        """A convenience function."""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_translatable_part_text_set(self.obj,
            <const char *>part if part is not None else NULL,
            <const char *>text if text is not None else NULL)

    @DEPRECATED("1.8", "Use :py:func:`translatable_part_text_get` instead.")
    def translatable_text_part_get(self, part):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_object_translatable_part_text_get(self.obj,
            <const char *>part if part is not None else NULL))


    def translatable_part_text_get(self, part = None):
        """Gets the original string set as translatable for an object

        When setting translated strings, the function :py:func:`part_text_get`
        will return the translation returned by ``gettext()``. To get the
        original string use this function.

        :param part: The name of the part that was set
        :type part: unicode

        :return: The original, untranslated string
        :rtype: unicode

        :see: :py:func:`translatable_part_text_set`

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        return _ctouni(elm_object_translatable_part_text_get(self.obj,
            <const char *>part if part is not None else NULL))

    def domain_part_text_translatable_set(self, part not None, domain not None,
        bint translatable):
        """Mark the part text to be translatable or not.

        Once you mark the part text to be translatable, the text will be translated
        internally regardless of :py:meth:`part_text_set` and
        :py:meth:`domain_translatable_part_text_set`. In other case, if you set the
        Elementary policy that all text will be translatable in default, you can set
        the part text to not be translated by calling this API.

        :param part: The part name of the translatable text
        :param domain: The translation domain to use
        :param translatable: ``True``, the part text will be translated
            internally. ``False``, otherwise.

        :seealso: :py:func:`efl.elementary.general.policy_set`

        .. versionadded:: 1.8

        """
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        elm_object_domain_part_text_translatable_set(self.obj,
            <const char *>part,
            <const char *>domain,
            translatable)

    def part_text_translatable_set(self, part, bint translatable):
        """A convenience function."""
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        elm_object_part_text_translatable_set(self.obj,
            part, translatable)

    def domain_text_translatable_set(self, domain, bint translatable):
        """A convenience function."""
        if isinstance(domain, unicode): domain = PyUnicode_AsUTF8String(domain)
        elm_object_domain_text_translatable_set(self.obj, domain, translatable)

    property translatable_text:
        """Translatable text for the main text part of the widget."""
        def __get__(self):
            return self.translatable_text_get()
        def __set__(self, text):
            self.translatable_text_set(text)

    def translatable_text_set(self, text):
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_object_translatable_text_set(self.obj,
            <const char *>text if text is not None else NULL)
    def translatable_text_get(self):
        return _ctouni(elm_object_translatable_text_get(self.obj))


    #
    # Copy and Paste
    # ==============

    def cnp_selection_set(self, Elm_Sel_Type selection, Elm_Sel_Format format,
        buf):
        """Set copy data for a widget.

        Set copy data and take ownership of selection. Format is used for
        specifying the selection type, and this is used during pasting.

        :param selection: Selection type for copying and pasting
        :type selection: :ref:`Elm_Object_Sel_Type`
        :param format: Selection format
        :type format: :ref:`Elm_Object_Sel_Format`
        :param buf: The data selected
        :type buf: An object that supports the new buffer interface

        :return bool: Whether setting cnp data was successful or not.

        """
        cdef:
            Py_buffer view
            bint ret

        if isinstance(buf, unicode): buf = PyUnicode_AsUTF8String(buf)
        if not PyObject_CheckBuffer(buf):
            raise TypeError(
                "The provided object does not support buffer interface."
                )
        PyObject_GetBuffer(buf, &view, PyBUF_SIMPLE)
        ret = elm_cnp_selection_set(self.obj, selection, format,
            <const void *>view.buf, view.itemsize)
        PyBuffer_Release(&view)
        return ret

    def cnp_selection_get(self, selection, format, datacb, udata = None):
        """Retrieve data from a widget that has a selection.

        Gets the current selection data from a widget. The widget input here
        will usually be elm_entry, in which case ``datacb`` and ``udata`` can be
        None. If a different widget is passed, ``datacb`` and ``udata`` are used
        for retrieving data.

        :param selection: Selection type for copying and pasting
        :param format: Selection format
        :param datacb: The user data callback if the target widget isn't elm_entry
        :param udata: The user data for ``datacb``

        :return bool: Whether getting cnp data was successful or not.

        """
        if not callable(datacb):
            raise TypeError("datacb is not callable.")
        self.cnp_drop_cb = datacb
        self.cnp_drop_data = udata
        return bool(elm_cnp_selection_get(self.obj, selection, format,
            py_elm_drop_cb, <void *>self))

    def cnp_selection_clear(self, Elm_Sel_Type selection):
        """Clear the selection data of a widget.

        Clear all data from the selection which is owned by a widget.

        :param selection: Selection type for copying and pasting
        :type selection: :ref:`Elm_Object_Sel_Type`

        :return bool: Whether clearing cnp data was successful or not.

        """
        return bool(elm_object_cnp_selection_clear(self.obj, selection))

    def cnp_selection_loss_callback_set(self, Elm_Sel_Type selection, func,
        data = None):
        """Set a function to be called when a selection is lost

        The function ``func`` is set of be called when selection ``selection``
        is lost to another process or when :py:meth:`cnp_selection_set` is
        called. If ``func`` is None then it is not called. ``data`` is passed as
        the data parameter to the callback functions and selection is passed in
        as the selection that has been lost.

        :py:meth:`cnp_selection_set` and :py:meth:`cnp_selection_clear`
        automatically set this loss callback to NULL when called. If you wish to
        take the selection and then be notified of loss please do this
        (for example)::

            obj.cnp_selection_set(ELM_SEL_TYPE_PRIMARY, ELM_SEL_FORMAT_TEXT, "hello")
            obj.cnp_selection_loss_callback_set(ELM_SEL_TYPE_PRIMARY, loss_cb)

        :param selection: Selection to be notified of for loss
        :param func: The function to call
        :param data: The data passed to the function.

        """
        if not callable(func):
            raise TypeError("func is not callable.")
        self.cnp_selection_loss_cb = func
        self.cnp_selection_loss_data = data
        elm_cnp_selection_loss_callback_set(
            self.obj, selection, py_elm_selection_loss_cb, <const void *>data)

    #
    # Drag n Drop
    # ===========

    def drop_target_add(self, Elm_Sel_Format fmt,
        entercb=None, enterdata=None, leavecb=None, leavedata=None,
        poscb=None, posdata=None, dropcb=None, dropdata=None):
        """Set the given object as a target for drops for drag-and-drop

        :param format: The formats supported for dropping
        :param entercb: The function to call when the object is entered with a drag
        :param enterdata: The application data to pass to enterdata
        :param leavecb: The function to call when the object is left with a drag
        :param leavedata: The application data to pass to leavecb
        :param poscb: The function to call when the object has a drag over it
        :param posdata: The application data to pass to poscb
        :param dropcb: The function to call when a drop has occurred
        :param cbdata: The application data to pass to dropcb
        :raise RuntimeError: if adding as drop target fails.

        .. versionadded:: 1.17

        """
        if entercb:
            if not callable(entercb):
                raise TypeError("A callback passed is not callable.")
            enter = (entercb, enterdata)
            Py_INCREF(enter)
        if leavecb:
            if not callable(leavecb):
                raise TypeError("A callback passed is not callable.")
            leave = (leavecb, leavedata)
            Py_INCREF(leave)
        if poscb:
            if not callable(poscb):
                raise TypeError("A callback passed is not callable.")
            pos = (poscb, posdata)
            Py_INCREF(pos)
        if dropcb:
            if not callable(dropcb):
                raise TypeError("A callback passed is not callable.")
            drop = (dropcb, dropdata)
            Py_INCREF(drop)

        if not elm_drop_target_add(
            self.obj, fmt,
            <Elm_Drag_State>py_elm_drag_state_cb if entercb else NULL, <void *>enter if entercb else NULL,
            <Elm_Drag_State>py_elm_drag_state_cb if leavecb else NULL, <void *>leave if leavecb else NULL,
            <Elm_Drag_Pos>py_elm_drag_pos_cb if poscb else NULL, <void *>pos if poscb else NULL,
            <Elm_Drop_Cb>py_elm_drop_cb if dropcb else NULL, <void *>drop if dropcb else NULL
            ):
            raise RuntimeError("Could not add drop target.")

    def drop_target_del(self, Elm_Sel_Format fmt,
        entercb=None, enterdata=None, leavecb=None, leavedata=None,
        poscb=None, posdata=None, dropcb=None, dropdata=None):
        """Deletes the drop target status of an object

        :param format: The formats supported for dropping
        :param entercb: The function to call when the object is entered with a drag
        :param enterdata: The application data to pass to enterdata
        :param leavecb: The function to call when the object is left with a drag
        :param leavedata: The application data to pass to leavedata
        :param poscb: The function to call when the object has a drag over it
        :param posdata: The application data to pass to posdata
        :param dropcb: The function to call when a drop has occurred
        :param dropdata: The application data to pass to dropcb
        :raise RuntimeError: if drop target cannot be deleted

        .. versionadded:: 1.17

        """
        if entercb:
            if not callable(entercb):
                raise TypeError("A callback passed is not callable.")
            enter = (entercb, enterdata)
            Py_INCREF(enter)
        if leavecb:
            if not callable(leavecb):
                raise TypeError("A callback passed is not callable.")
            leave = (leavecb, leavedata)
            Py_INCREF(leave)
        if poscb:
            if not callable(poscb):
                raise TypeError("A callback passed is not callable.")
            pos = (poscb, posdata)
            Py_INCREF(pos)
        if dropcb:
            if not callable(dropcb):
                raise TypeError("A callback passed is not callable.")
            drop = (dropcb, dropdata)
            Py_INCREF(drop)

        if not elm_drop_target_del(
            self.obj, fmt,
            <Elm_Drag_State>py_elm_drag_state_cb if entercb else NULL, <void *>enter if entercb else NULL,
            <Elm_Drag_State>py_elm_drag_state_cb if leavecb else NULL, <void *>leave if leavecb else NULL,
            <Elm_Drag_Pos>py_elm_drag_pos_cb if poscb else NULL, <void *>pos if poscb else NULL,
            <Elm_Drop_Cb>py_elm_drop_cb if dropcb else NULL, <void *>drop if dropcb else NULL
            ):
            raise RuntimeError("Could not del drop target.")

    def drag_start(self, Elm_Sel_Format format,
        data, Elm_Xdnd_Action action, createicon=None, createdata=None,
        dragpos=None, dragdata=None, acceptcb=None, acceptdata=None, dragdone=None, donecbdata=None):
        """Begins a drag given a source object

        :param format: The drag formats supported by the data
        :param data: The drag data itself (a string)
        :param action: The drag action to be done
        :param createicon: Function to call to create a drag object,
            or NULL if not wanted
        :param createdata: Application data passed to ``createicon``
        :param dragpos: Function called with each position of the drag,
            x, y being screen coordinates if possible, and action being
            the current action.
        :param dragdata: Application data passed to ``dragpos``
        :param acceptcb: Function called indicating if drop target accepts
            (or does not) the drop data while dragging

        :param acceptdata: Application data passed to ``acceptcb``
        :param dragdone: Function to call when drag is done
        :param donecbdata: Application data to pass to ``dragdone``
        :raise RuntimeError: if starting drag fails.

        .. versionadded:: 1.17

        """
        if createicon:
            if not callable(createicon):
                raise TypeError("A callback passed is not callable.")
            create = (createicon, createdata)
            Py_INCREF(create)
        if dragpos:
            if not callable(dragpos):
                raise TypeError("A callback passed is not callable.")
            pos = (dragpos, dragdata)
            Py_INCREF(pos)
        if acceptcb:
            if not callable(acceptcb):
                raise TypeError("A callback passed is not callable.")
            accept = (acceptcb, acceptdata)
            Py_INCREF(accept)
        if dragdone:
            if not callable(dragdone):
                raise TypeError("A callback passed is not callable.")
            done = (dragdone, donecbdata)
            Py_INCREF(done)

        if not elm_drag_start(self.obj, format,
            <const char *>data, action,
            <Elm_Drag_Icon_Create_Cb>py_elm_drag_icon_create_cb if createicon is not None else NULL,
            <void *>create if createicon is not None else NULL,
            <Elm_Drag_Pos>py_elm_drag_pos_cb if dragpos is not None else NULL,
            <void *>pos if dragpos is not None else NULL,
            <Elm_Drag_Accept>py_elm_drag_accept_cb if acceptcb is not None else NULL,
            <void *>accept if acceptcb is not None else NULL,
            <Elm_Drag_State>py_elm_drag_state_cb if dragdone is not None else NULL,
            <void *>done if dragdone is not None else NULL
            ):
            raise RuntimeError("Could not start drag.")

    def drag_action_set(self, Elm_Xdnd_Action action):
        """Changes the current drag action

        :param action: The drag action to be done
        :raise RuntimeError: if changing drag action fails.

        .. versionadded:: 1.17

        """
        if not elm_drag_action_set(self.obj, action):
            raise RuntimeError("Could not set cnp xdnd action.")


    #
    # Access (TODO)
    # =============

    # def unregister(self):
    #     """Unregister accessible object.

    #     :since: 1.8

    #     """
    #     elm_access_object_unregister(self.obj)

    # property access_object:
    #     """Get an accessible object of the evas object.

    #     :since: 1.8

    #     :type: Object

    #     """
    #     def __get__(self):
    #         return object_from_instance(elm_access_object_get(self.obj))

    # def access_highlight_set(self):
    #     """Give the highlight to the object directly.

    #     :since: 1.8

    #     The object should be an elementary object or an access object.

    #     """
    #     elm_access_highlight_set(self.obj)

# FIXME: Check if this is used correctly here
_object_mapping_register("Elm_Widget", Object)
