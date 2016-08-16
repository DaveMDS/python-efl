cdef class GengridItem(ObjectItem):
    """

    An item for the :py:class:`Gengrid` widget.

    """

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
        """GengridItem(..)

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
        """Append a new item (add as last item) to this gengrid.

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
        """Prepend a new item (add as first item) to this gengrid.

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
        """Insert a new item before another item in this gengrid.

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
        """Insert a new item after another item in this gengrid.

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
        """Insert a new item after another item in this gengrid.

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
        """This updates an item by calling all the item class functions
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

    def show(self, scrollto_type=enums.ELM_GENGRID_ITEM_SCROLLTO_IN):
        """This causes gengrid to **redraw** its viewport's contents to the
        region containing the given ``item``, if it is not fully
        visible.

        .. seealso:: :py:func:`bring_in()`

        :param scrollto_type: Where to position the item in the viewport.
        :type scrollto_type: :ref:`Elm_Gengrid_Item_Scrollto_Type`

        """
        elm_gengrid_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type=enums.ELM_GENGRID_ITEM_SCROLLTO_IN):
        """This causes gengrid to jump to the item and show
        it (by scrolling), if it is not fully visible. This will use
        animation to do so and take a period of time to complete.

        .. seealso:: :py:func:`show()`

        :param scrollto_type: Where to position the item in the viewport.
        :type scrollto_type: :ref:`Elm_Gengrid_Item_Scrollto_Type`

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

    # TODO: elm_gengrid_item_item_class_update

    # TODO: elm_gengrid_item_item_class_get

    property select_mode:
        """Item's select mode. Possible values are:

        :type: :ref:`Elm_Object_Select_Mode`
        """
        def __get__(self):
            return elm_gengrid_item_select_mode_get(self.item)

        def __set__(self, mode):
            elm_gengrid_item_select_mode_set(self.item, mode)

    def select_mode_set(self, mode):
        elm_gengrid_item_select_mode_set(self.item, mode)
    def select_mode_get(self):
        return elm_gengrid_item_select_mode_get(self.item)

    def all_contents_unset(self):
        """Unset all contents fetched by the item class

        This instructs gengrid to release references to contents in the item,
        meaning that they will no longer be managed by gengrid and are
        floating "orphans" that can be re-used elsewhere.

        :return: The list of now orphans objects
        :rtype: list

        .. versionadded:: 1.18

        .. warning:: Don't forget to do something with the returned objects,
            they are hidden in the canvas, but still alive. You should
            at least delete them if you don't need to reuse.

        """
        cdef:
            Eina_List *l = NULL
            list ret
        elm_gengrid_item_all_contents_unset(self.item, &l)
        ret = eina_list_objects_to_python_list(l)
        eina_list_free(l)
        return ret

