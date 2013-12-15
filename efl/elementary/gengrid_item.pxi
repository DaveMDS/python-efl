cdef class GengridItem(ObjectItem):

    """An item for the :py:class:`Gengrid` widget."""

    cdef:
        readonly GengridItemClass item_class
        Elm_Object_Item *parent_item
        int flags
        object item_data, func_data, compare_func

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef void _unset_obj(self):
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL

    def __init__(self, GengridItemClass item_class not None, item_data = None, \
        func = None, func_data = None, *args, **kwargs):
        """

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        """
        if func is not None:
            if not callable(func):
                raise TypeError("func is not None or callable")

        self.item_class = item_class
        self.cb_func = func
        self.item_data = item_data
        self.func_data = func_data
        self.args = args
        self.kwargs = kwargs

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)>") % \
               (type(self).__name__,
                <uintptr_t><void*>self,
                PY_REFCOUNT(self),
                <uintptr_t>self.item,
                type(self.item_class).__name__,
                self.cb_func,
                self.item_data)

    def append_to(self, Gengrid gengrid not None):
        """item_append(Gengrid gengrid) -> GengridItem

        Append a new item (add as last item) to this gengrid.

        .. versionadded:: 1.8

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_append(gengrid.obj,
            self.item_class.cls, <void*>self,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, Gengrid gengrid not None):
        """item_prepend(Gengrid gengrid) -> GengridItem

        Prepend a new item (add as first item) to this gengrid.

        .. versionadded:: 1.8

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_prepend(gengrid.obj, self.item_class.cls, <void*>self,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, GengridItem before not None):
        """insert_before(GengridItem before not None) -> GengridItem

        Insert a new item before another item in this gengrid.

        :param before: a reference item to use, the new item
            will be inserted before it.

        .. versionadded:: 1.8

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            Gengrid gengrid = before.widget

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_insert_before(gengrid.obj, self.item_class.cls,
            <void*>self, before.item, cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, GengridItem after not None):
        """insert_after(GengridItem after not None) -> GengridItem

        Insert a new item after another item in this gengrid.

        :param after: a reference item to use, the new item
            will be inserted after it.

        .. versionadded:: 1.8

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL
            Gengrid gengrid = after.widget

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_insert_after(gengrid.obj, self.item_class.cls,
            <void*>self, after.item, cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def sorted_insert(self, Gengrid gengrid not None, compare_func not None):
        """insert_after(GengridItem after not None) -> GengridItem

        Insert a new item after another item in this gengrid.

        :param after: a reference item to use, the new item
            will be inserted after it.

        .. versionadded:: 1.8

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        self.compare_func = compare_func

        if self.cb_func is not None:
            cb = _py_elm_gengrid_item_func

        item = elm_gengrid_item_sorted_insert(gengrid.obj, self.item_class.cls,
            <void*>self, _gengrid_compare_cb, cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property data:
        """User data for the item."""
        def __get__(self):
            return self.item_data

    def data_get(self):
        return self.item_data

    property next:
        """This returns the item placed after the item, on the container
        gengrid.

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_gengrid_item_next_get(self.item))

    property prev:
        """This returns the item placed before the item, on the container
        gengrid.

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_gengrid_item_prev_get(self.item))

    property index:
        """Get the index of the item. It is only valid once displayed.

        """
        def __get__(self):
            return elm_gengrid_item_index_get(self.item)

    def index_get(self):
        return elm_gengrid_item_index_get(self.item)

    def update(self):
        """update()

        This updates an item by calling all the item class functions
        again to get the contents, texts and states. Use this when the
        original item data has changed and you want the changes to be
        reflected.

        """
        elm_gengrid_item_update(self.item)

    property selected:
        """The selected state of an item. If multi-selection is
        not enabled on the containing gengrid and *selected* is ``True``,
        any other previously selected items will get unselected in favor of
        a new one.

        """
        def __get__(self):
            return bool(elm_gengrid_item_selected_get(self.item))

        def __set__(self, selected):
            elm_gengrid_item_selected_set(self.item, bool(selected))

    def selected_set(self, selected):
        elm_gengrid_item_selected_set(self.item, bool(selected))
    def selected_get(self):
        return bool(elm_gengrid_item_selected_get(self.item))

    def show(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """show(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes gengrid to **redraw** its viewport's contents to the
        region containing the given ``item``, if it is not fully
        visible.

        .. seealso:: :py:func:`bring_in()`

        :param type: Where to position the item in the viewport.

        """
        elm_gengrid_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN):
        """bring_in(int scrollto_type = ELM_GENLIST_ITEM_SCROLLTO_IN)

        This causes gengrid to jump to the item and show
        it (by scrolling), if it is not fully visible. This will use
        animation to do so and take a period of time to complete.

        .. seealso:: :py:func:`show()`

        :param type: Where to position the item in the viewport.

        """
        elm_gengrid_item_bring_in(self.item, scrollto_type)

    property pos:
        def __get__(self):
            cdef unsigned int x, y
            elm_gengrid_item_pos_get(self.item, &x, &y)
            return (x, y)

    def pos_get(self):
        cdef unsigned int x, y
        elm_gengrid_item_pos_get(self.item, &x, &y)
        return (x, y)

    # XXX TODO elm_gengrid_item_item_class_update

    # XXX TODO elm_gengrid_item_item_class_get

    property tooltip_text:
        """Set the text to be shown in the tooltip object

        Setup the text as tooltip object. The object can have only one
        tooltip, so any previous tooltip data is removed.
        Internally, this method calls :py:func:`tooltip_content_cb_set`

        """
        def __set__(self, text):
            if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
            elm_gengrid_item_tooltip_text_set(self.item,
                <const_char *>text if text is not None else NULL)

    def tooltip_text_set(self, text):
        # TODO: document this
        if isinstance(text, unicode): text = PyUnicode_AsUTF8String(text)
        elm_gengrid_item_tooltip_text_set(self.item,
            <const_char *>text if text is not None else NULL)

    def tooltip_content_cb_set(self, func, *args, **kargs):
        """tooltip_content_cb_set(func, *args, **kargs)

        Set the content to be shown in the tooltip object

        Setup the tooltip to object. The object can have only one tooltip,
        so any previews tooltip data is removed. ``func(args, kargs)`` will
        be called every time that need show the tooltip and it should return a
        valid Evas_Object. This object is then managed fully by tooltip system
        and is deleted when the tooltip is gone.

        :param func: Function to be create tooltip content, called when
            need show tooltip.

        """
        if not callable(func):
            raise TypeError("func must be callable")

        cdef void *cbdata

        data = (func, self, args, kargs)
        Py_INCREF(data)
        # FIXME: refleak?
        cbdata = <void *>data
        elm_gengrid_item_tooltip_content_cb_set(self.item,
                                                _tooltip_item_content_create,
                                                cbdata,
                                                _tooltip_item_data_del_cb)

    @DEPRECATED("1.8", "Use tooltip_unset() instead")
    def item_tooltip_unset(self):
        """item_tooltip_unset()"""
        elm_gengrid_item_tooltip_unset(self.item)

    def tooltip_unset(self):
        """item_tooltip_unset()

        Unset tooltip from object

        Remove tooltip from object. If used the :py:func:`tooltip_text_set`
        the internal copy of label will be removed correctly. If used
        :py:func:`tooltip_content_cb_set`, the data will be unreferred but
        no freed.

        """
        elm_gengrid_item_tooltip_unset(self.item)

    property tooltip_style:
        """Style for this object tooltip.

        .. note::: before you set a style you should define a tooltip with
            elm_gengrid_item_tooltip_content_cb_set() or
            elm_gengrid_item_tooltip_text_set()

        """
        def __get__(self):
            return _ctouni(elm_gengrid_item_tooltip_style_get(self.item))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_gengrid_item_tooltip_style_set(self.item,
                <const_char *>style if style is not None else NULL)

    def tooltip_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_gengrid_item_tooltip_style_set(self.item,
            <const_char *>style if style is not None else NULL)
    def tooltip_style_get(self):
        return _ctouni(elm_gengrid_item_tooltip_style_get(self.item))

    property tooltip_window_mode:
        # TODO: document this
        def __get__(self):
            return bool(elm_gengrid_item_tooltip_window_mode_get(self.item))

        def __set__(self, disable):
            elm_gengrid_item_tooltip_window_mode_set(self.item, bool(disable))

    def tooltip_window_mode_set(self, disable):
        elm_gengrid_item_tooltip_window_mode_set(self.item, bool(disable))
    def tooltip_window_mode_get(self):
        return bool(elm_gengrid_item_tooltip_window_mode_get(self.item))

    property cursor:
        """The cursor that will be displayed when mouse is over the item.
        The item can have only one cursor set to it, so if this property is
        set twice for an item, the previous one will be unset.

        """
        def __get__(self):
            return _ctouni(elm_gengrid_item_cursor_get(self.item))

        def __set__(self, cursor):
            if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
            elm_gengrid_item_cursor_set(self.item,
                <const_char *>cursor if cursor is not None else NULL)

        def __del__(self):
            elm_gengrid_item_cursor_unset(self.item)

    def cursor_set(self, cursor):
        if isinstance(cursor, unicode): cursor = PyUnicode_AsUTF8String(cursor)
        elm_gengrid_item_cursor_set(self.item,
            <const_char *>cursor if cursor is not None else NULL)
    def cursor_get(self):
        return _ctouni(elm_gengrid_item_cursor_get(self.item))
    def cursor_unset(self):
        elm_gengrid_item_cursor_unset(self.item)

    property cursor_style:
        # TODO: document this
        def __get__(self):
            return _ctouni(elm_gengrid_item_cursor_style_get(self.item))

        def __set__(self, style):
            if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
            elm_gengrid_item_cursor_style_set(self.item,
                <const_char *>style if style is not None else NULL)

    def cursor_style_set(self, style=None):
        if isinstance(style, unicode): style = PyUnicode_AsUTF8String(style)
        elm_gengrid_item_cursor_style_set(self.item,
            <const_char *>style if style is not None else NULL)
    def cursor_style_get(self):
        return _ctouni(elm_gengrid_item_cursor_style_get(self.item))

    property cursor_engine_only:
        # TODO: document this
        def __get__(self):
            return elm_gengrid_item_cursor_engine_only_get(self.item)

        def __set__(self, engine_only):
            elm_gengrid_item_cursor_engine_only_set(self.item, bool(engine_only))

    def cursor_engine_only_set(self, engine_only):
        elm_gengrid_item_cursor_engine_only_set(self.item, bool(engine_only))
    def cursor_engine_only_get(self):
        return elm_gengrid_item_cursor_engine_only_get(self.item)

    property select_mode:
        # TODO: document this
        def __get__(self):
            return elm_gengrid_item_select_mode_get(self.item)

        def __set__(self, mode):
            elm_gengrid_item_select_mode_set(self.item, mode)

    def select_mode_set(self, mode):
        elm_gengrid_item_select_mode_set(self.item, mode)
    def select_mode_get(self):
        return elm_gengrid_item_select_mode_get(self.item)

