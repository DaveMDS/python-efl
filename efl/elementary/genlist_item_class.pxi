cdef class GenlistItemClass(object):
    """

    Defines the behavior of each list item.

    This class should be created and handled to the Genlist itself.

    It may be subclassed, in this case the methods :py:func:`text_get()`,
    :py:func:`content_get()`, :py:func:`state_get()` and ``delete()`` will
    be used.

    It may also be instantiated directly, given getters to override as
    constructor parameters.

    """

    cdef:
        Elm_Genlist_Item_Class *cls
        object _text_get_func
        object _content_get_func
        object _reusable_content_get_func
        object _state_get_func
        object _filter_get_func
        object _del_func
        object _item_style
        object _decorate_item_style
        object _decorate_all_item_style

    def __cinit__(self):
        self.cls = elm_genlist_item_class_new()
        self.cls.func.text_get = _py_elm_genlist_item_text_get
        self.cls.func.content_get = _py_elm_genlist_item_content_get
        self.cls.func.reusable_content_get = _py_elm_genlist_item_reusable_content_get
        self.cls.func.state_get = _py_elm_genlist_item_state_get
        self.cls.func.filter_get = _py_elm_genlist_item_filter_get
        # In C the struct member is del but we rename it to del_ in pxd
        self.cls.func.del_ = _py_elm_genlist_object_item_del

    def __dealloc__(self):
        elm_genlist_item_class_free(self.cls)
        self.cls = NULL

    def __init__(self, item_style=None, text_get_func=None,
                 content_get_func=None, state_get_func=None, del_func=None,
                 decorate_item_style=None, decorate_all_item_style=None,
                 filter_get_func=None, reusable_content_get_func=None,
                 *args, **kwargs):

        """GenlistItemClass constructor.

        :param item_style: the string that defines the genlist item
            theme to be used. The corresponding edje group will
            have this as suffix.

        :param text_get_func: if provided will override the
            behavior defined by :py:func:`text_get()` in this class. Its
            purpose is to return the label string to be used by a
            given part and row. This function should have the
            signature:
            ``func(obj, part, item_data) -> string``

        :param content_get_func: if provided will override the behavior
            defined by :py:func:`content_get()` in this class. Its purpose is
            to return the icon object to be used (swallowed) by a
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
            called when row is deleted, thus finalizing resources
            and similar. This function should have the signature:
            ``func(obj, part, item_data)``

        :param reusable_content_get_func: if provided will override the behavior
            defined by :py:func:`reusable_content_get()` in this class.
            Its purpose is to return the icon object to be used (swallowed) by a
            given part and row. This can be used to reuse (cache) contents
            (since 1.18)
            This function should have the signature:
            ``func(obj, part, item_data, old_content) -> obj``

        .. note:: In all these signatures, 'obj' means Genlist and
            'item_data' is the value given to Genlist item append/prepend
            methods, it should represent your row model as you want.
        """
        #
        # Use argument if found, else a function that was defined by child
        # class, or finally the fallback function defined in this class.
        #
        if text_get_func is not None:
            if callable(text_get_func):
                self._text_get_func = text_get_func
            else:
                raise TypeError("text_get_func is not callable!")
        else:
            self._text_get_func = self.text_get

        if content_get_func is not None:
            if callable(content_get_func):
                self._content_get_func = content_get_func
            else:
                raise TypeError("content_get_func is not callable!")
        else:
            self._content_get_func = self.content_get

        if reusable_content_get_func is not None:
            if callable(reusable_content_get_func):
                self._reusable_content_get_func = reusable_content_get_func
            else:
                raise TypeError("reusable_content_get_func is not callable!")
        else:
            self._reusable_content_get_func = self.reusable_content_get

        if state_get_func is not None:
            if callable(state_get_func):
                self._state_get_func = state_get_func
            else:
                raise TypeError("state_get_func is not callable!")
        else:
            self._state_get_func = self.state_get

        if filter_get_func is not None:
            if callable(filter_get_func):
                self._filter_get_func = filter_get_func
            else:
                raise TypeError("filter_get_func is not callable!")
        else:
            self._filter_get_func = self.filter_get

        if del_func is not None:
            if callable(del_func):
                self._del_func = del_func
            else:
                raise TypeError("del_func is not callable!")
        else:
            try:
                self._del_func = self.delete
            except AttributeError:
                pass

        a1 = item_style
        a2 = decorate_item_style
        a3 = decorate_all_item_style

        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        if isinstance(a2, unicode): a2 = PyUnicode_AsUTF8String(a2)
        if isinstance(a3, unicode): a3 = PyUnicode_AsUTF8String(a3)

        self._item_style = a1
        self._decorate_item_style = a2
        self._decorate_all_item_style = a3

        self.cls.item_style = <char *>self._item_style if self._item_style is not None else NULL
        self.cls.decorate_item_style = <char *>self._decorate_item_style if self._decorate_item_style is not None else NULL
        self.cls.decorate_all_item_style = <char *>self._decorate_all_item_style if self._decorate_all_item_style is not None else NULL

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Genlist_Item_Class=%#x, "
                "item_style=%r, text_get_func=%s, content_get_func=%s, "
                "state_get_func=%s, filter_get_func=%s, del_func=%s)>") % \
               (type(self).__name__,
                <uintptr_t><void *>self,
                PY_REFCOUNT(self),
                <uintptr_t>self.cls,
                _ctouni(self.cls.item_style),
                self._text_get_func,
                self._content_get_func,
                self._state_get_func,
                self._filter_get_func,
                self._del_func)

    def ref(self):
        """Increase the C level reference count.

        .. versionadded:: 1.8

        """
        elm_genlist_item_class_ref(self.cls)

    def unref(self):
        """Decrease the C level reference count.

        .. versionadded:: 1.8

        """
        elm_genlist_item_class_unref(self.cls)

    def free(self):
        """Free the C level struct.

        .. versionadded:: 1.8

        """
        elm_genlist_item_class_free(self.cls)

    property item_style:
        """The style of this item class."""
        def __get__(self):
            return self._item_style.decode("UTF-8")

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            self._item_style = style
            self.cls.item_style = <char *>style if style is not None else NULL

    property decorate_item_style:
        """The decoration style of this item class."""
        def __get__(self):
            return self._decorate_item_style.decode("UTF-8")

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            self._decorate_item_style = style
            self.cls.decorate_item_style = <char *>style if style is not None else NULL

    property decorate_all_item_style:
        """Decorate all style of this item class."""
        def __get__(self):
            return self._decorate_all_item_style.decode("UTF-8")

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            self._decorate_all_item_style = style
            self.cls.decorate_all_item_style = <char *>style if style is not None else NULL

    def text_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its label.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: label to be used.
        :rtype: str or None
        """
        return None

    def content_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its icon.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

    def reusable_content_get(self, evasObject obj, part, item_data, old_content):
        """To be called by Genlist for each row to get its icon.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.
        :param old_content: the old (if available) content that can be used
            instead of creating a new object every time.

        :return: icon object to be used and swallowed.
        :rtype: evas Object or None
        """
        return None

    def state_get(self, evasObject obj, part, item_data):
        """To be called by Genlist for each row to get its state.

        :param obj: the Genlist instance
        :param part: the part that is being handled.
        :param item_data: the value given to genlist append/prepend.

        :return: state to be used.
        :rtype: bool or None
        """
        return False

    def filter_get(self, evasObject obj, key, item_data):
        """To be called by Genlist for each row when filter is enabled.

        :param obj: the Genlist instance
        :param key: the filter key given in the filter_set function
        :param item_data: the value given to genlist append/prepend.

        :return: Wheter the item should be visible or not
        :rtype: bool
        """
        return True

