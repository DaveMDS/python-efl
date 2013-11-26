cdef class GengridItemClass:
    """

    Defines the behavior of each grid item.

    This class should be created and handled to the Gengrid itself.

    It may be subclassed, in this case the methods :py:func:`text_get()`,
    :py:func:`content_get()`, :py:func:`state_get()` and ``delete()`` will be used.

    It may also be instantiated directly, given getters to override as
    constructor parameters.

    """
    cdef Elm_Gengrid_Item_Class obj
    cdef readonly object _item_style
    cdef readonly object _text_get_func
    cdef readonly object _content_get_func
    cdef readonly object _state_get_func
    cdef readonly object _del_func

    def __cinit__(self, *a, **ka):
        self._item_style = "default"
        self._text_get_func = None
        self._content_get_func = None
        self._state_get_func = None
        self._del_func = None

        self.obj.item_style = NULL
        self.obj.func.text_get = _py_elm_gengrid_item_text_get
        self.obj.func.content_get = _py_elm_gengrid_item_content_get
        self.obj.func.state_get = _py_elm_gengrid_item_state_get
        self.obj.func.del_ = _py_elm_gengrid_object_item_del

    def __init__(self, item_style=None, text_get_func=None,
                 content_get_func=None, state_get_func=None, del_func=None):
        """GengridItemClass constructor.

        :param item_style: the string that defines the gengrid item
            theme to be used. The corresponding edje group will
            have this as suffix.

        :param text_get_func: if provided will override the
            behavior defined by :py:func:`text_get()` in this class. Its
            purpose is to return the label string to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> str``

        :param content_get_func: if provided will override the behavior
            defined by :py:func:`content_get()` in this class. Its purpose is
            to return the icon object to be used (swalloed) by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> obj``

        :param state_get_func: if provided will override the
            behavior defined by :py:func:`state_get()` in this class. Its
            purpose is to return the boolean state to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> bool``

        :param del_func: if provided will override the behavior
            defined by ``delete()`` in this class. Its purpose is to be
            called when item is deleted, thus finalizing resources
            and similar. This function should have the signature:
            ``func(obj, item_data)``

        .. note:: In all these signatures, 'obj' means Gengrid and
            'item_data' is the value given to Gengrid item append/prepend
            methods, it should represent your item model as you want.
        """
        if text_get_func and not callable(text_get_func):
            raise TypeError("text_get_func is not callable!")
        elif text_get_func:
            self._text_get_func = text_get_func
        else:
            self._text_get_func = self.text_get

        if content_get_func and not callable(content_get_func):
            raise TypeError("content_get_func is not callable!")
        elif content_get_func:
            self._content_get_func = content_get_func
        else:
            self._content_get_func = self.content_get

        if state_get_func and not callable(state_get_func):
            raise TypeError("state_get_func is not callable!")
        elif state_get_func:
            self._state_get_func = state_get_func
        else:
            self._state_get_func = self.state_get

        if del_func and not callable(del_func):
            raise TypeError("del_func is not callable!")
        elif del_func:
            self._del_func = del_func
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

        a1 = item_style
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if a1 is not None:
            self._item_style = a1
        self.obj.item_style = <char *>self._item_style

    def __str__(self):
        return ("%s(item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    def __repr__(self):
        return ("%s(%#x, refcount=%d, Elm_Gengrid_Item_Class=%#x, "
                "item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, del_func=%s)") % \
               (self.__class__.__name__,
                <unsigned long><void *>self,
                PY_REFCOUNT(self),
                <unsigned long>&self.obj,
                self._item_style,
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._del_func)

    property item_style:
        def __get__(self):
            return self._item_style

    def text_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its label.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: label to be used.
        :rtype: str or None
        """
        return None

    def content_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its icon.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

    def state_get(self, evasObject obj, part, item_data):
        """To be called by Gengrid for each item to get its state.

        :param obj: the Gengrid instance
        :param part: the part that is being handled.
        :param item_data: the value given to gengrid append/prepend.

        :return: boolean state to be used.
        :rtype: bool or None
        """
        return False

