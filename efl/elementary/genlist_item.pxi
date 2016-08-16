cdef class GenlistItem(ObjectItem):
    """

    An item for the :py:class:`Genlist` widget.

    """

    cdef:
        readonly GenlistItemClass item_class
        Elm_Object_Item *parent_item
        int flags
        object comparison_func, item_data, func_data

    def __init__(self, GenlistItemClass item_class not None, item_data=None,
                 GenlistItem parent_item=None,
                 Elm_Genlist_Item_Type flags=enums.ELM_GENLIST_ITEM_NONE,
                 func=None, func_data=None, *args, **kwargs):
        """GenlistItem(...)

        :param item_data: Data that defines the model of this row.
            This value will be given to methods of ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`.

        :param item_class: a valid instance that defines the behavior of this
            row.
        :type item_class: :py:class:`GenlistItemClass`

        :param parent_item: If this is a tree child, then the
            parent item must be given here, otherwise it may be
            None. The parent must have the flag
            ``ELM_GENLIST_ITEM_SUBITEMS`` set.
        :type parent_item: :py:class:`GenlistItem`

        :param flags: defines special behavior of this item:
        :type flags: :ref:`Elm_Genlist_Item_Type`

        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :param func_data: This value will be passed to the callback.

        """

        self.item_class = item_class

        self.parent_item = _object_item_from_python(parent_item) if parent_item is not None else NULL

        self.flags = flags

        if func is not None:
            if not callable(func):
                raise TypeError("func is not None or callable")

        self.item_data = item_data
        self.cb_func = func
        self.func_data = func_data
        self.args = args
        self.kwargs = kwargs

    def __dealloc__(self):
        self.parent_item = NULL

    cdef int _set_obj(self, Elm_Object_Item *item) except 0:
        assert self.item == NULL, "Object must be clean"
        self.item = item
        Py_INCREF(self)
        return 1

    cdef int _unset_obj(self) except 0:
        assert self.item != NULL, "Object must wrap something"
        self.item = NULL
        Py_DECREF(self)
        return 1

    def __repr__(self):
        return ("<%s(%#x, refcount=%d, Elm_Object_Item=%#x, "
                "item_class=%s, func=%s, item_data=%r)>") % (
            type(self).__name__,
            <uintptr_t><void*>self,
            PY_REFCOUNT(self),
            <uintptr_t>self.item,
            type(self.item_class).__name__,
            self.cb_func,
            self.item_data
            )

    def append_to(self, Genlist genlist not None):
        """Append a new item (add as last row) to this genlist.

        :param genlist: The Genlist upon which this item is to be appended.
        :type genlist: :py:class:`Genlist`
        :rtype: :py:class:`GenlistItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_genlist_item_func

        item = elm_genlist_item_append(genlist.obj,
            self.item_class.cls, <void*>self,
            self.parent_item,
            <Elm_Genlist_Item_Type>self.flags,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def prepend_to(self, Genlist genlist not None):
        """Prepend a new item (add as first row) to this Genlist.

        :param genlist: The Genlist upon which this item is to be prepended.
        :type genlist: :py:class:`Genlist`
        :rtype: :py:class:`GenlistItem`

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_genlist_item_func

        item = elm_genlist_item_prepend(genlist.obj,
            self.item_class.cls, <void*>self,
            self.parent_item,
            <Elm_Genlist_Item_Type>self.flags,
            cb,  <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_before(self, GenlistItem before_item=None):
        """Insert a new item (row) before another item in this genlist.

        :param before_item: a reference item to use, the new item
            will be inserted before it.
        :type before_item: :py:class:`GenlistItem`
        :rtype: :py:class:`GenlistItem`

        """
        cdef:
            Elm_Object_Item *item
            Elm_Object_Item *before
            Genlist genlist = before_item.widget
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_genlist_item_func

        before = _object_item_from_python(before_item)

        item = elm_genlist_item_insert_before(genlist.obj,
            self.item_class.cls, <void*>self,
            self.parent_item, before,
            <Elm_Genlist_Item_Type>self.flags,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def insert_after(self, GenlistItem after_item=None):
        """Insert a new item (row) after another item in this genlist.

        :param after_item: a reference item to use, the new item
            will be inserted after it.
        :type after_item: :py:class:`GenlistItem`
        :rtype: :py:class:`GenlistItem`

        """
        cdef:
            Elm_Object_Item *item
            Elm_Object_Item *after
            Genlist genlist = after_item.widget
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_genlist_item_func

        after = _object_item_from_python(after_item)

        item = elm_genlist_item_insert_after(genlist.obj,
            self.item_class.cls, <void*>self,
            self.parent_item, after,
            <Elm_Genlist_Item_Type>self.flags,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    def sorted_insert(self, Genlist genlist not None, comparison_func):
        """Insert a new item into the sorted genlist object

        :param genlist: The Genlist object
        :type genlist: :py:class:`Genlist`
        :param comparison_func: The function called for the sort.
            This must be a callable and will be called
            to insert the item in the right position. The two arguments passed
            are two :py:class:`GenlistItem` to compare. The function must return
            1 if ``item1`` comes before ``item2``, 0 if the two items
            are equal or -1 otherwise.
            Signature is::

                func(item1, item2)->int

        :rtype: :py:class:`GenlistItem`

        This inserts an item in the genlist based on user defined comparison
        function. The two arguments passed to the function are genlist items
        to compare.

        """
        cdef:
            Elm_Object_Item *item
            Evas_Smart_Cb cb = NULL

        if self.cb_func is not None:
            cb = _py_elm_genlist_item_func

        if comparison_func is not None:
            if not callable(comparison_func):
                raise TypeError("func is not None or callable")
            self.comparison_func = comparison_func

        item = elm_genlist_item_sorted_insert(genlist.obj,
            self.item_class.cls, <void*>self,
            self.parent_item,
            <Elm_Genlist_Item_Type>self.flags,
            _py_elm_genlist_compare_func,
            cb, <void*>self)

        if item == NULL:
            raise RuntimeError("The item could not be added to the widget.")

        self._set_obj(item)
        self._set_properties_from_keyword_args(self.kwargs)
        return self

    property data:
        """User data (model) for the item.

        .. versionchanged:: 1.16
            Property is now also writable

        """
        def __get__(self):
            return self.item_data
        def __set__(self, data):
            self.item_data = data

    def data_get(self):
        return self.item_data
    def data_set(self, data):
        self.item_data = data

    property next:
        """This returns the item placed after the ``item``, on the container
        genlist.

        .. seealso:: :py:attr:`prev`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_next_get(self.item))

    def next_get(self):
        return _object_item_to_python(elm_genlist_item_next_get(self.item))

    property prev:
        """This returns the item placed before the ``item``, on the container
        genlist.

        .. seealso:: :py:attr:`next`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_prev_get(self.item))

    def prev_get(self):
        return _object_item_to_python(elm_genlist_item_prev_get(self.item))

    property selected:
        """This sets the selected state of an item. If multi selection is
        not enabled on the containing genlist and ``selected`` is ``True``,
        any other previously selected items will get unselected in favor of
        this new one.

        :type: bool

        """
        def __get__(self):
            cdef bint ret = elm_genlist_item_selected_get(self.item)
            return ret

        def __set__(self, bint selected):
            elm_genlist_item_selected_set(self.item, selected)

    def selected_set(self, bint selected):
        elm_genlist_item_selected_set(self.item, selected)
    def selected_get(self):
        cdef bint ret = elm_genlist_item_selected_get(self.item)
        return ret

    def show(self, scrollto_type=enums.ELM_GENLIST_ITEM_SCROLLTO_IN):
        """This causes genlist to jump to the item and show it (by
        jumping to that position), if it is not fully visible.

        :param scrollto_type: Where to position the item in the viewport.
        :type scrollto_type: :ref:`Elm_Genlist_Item_Scrollto_Type`

        .. seealso:: :py:func:`bring_in()`

        """
        elm_genlist_item_show(self.item, scrollto_type)

    def bring_in(self, scrollto_type=enums.ELM_GENLIST_ITEM_SCROLLTO_IN):
        """This causes genlist to jump to the item and show it (by
        animatedly scrolling), if it is not fully visible.
        This may use animation and take a some time to do so.

        :param scrollto_type: Where to position the item in the viewport.
        :type scrollto_type: :ref:`Elm_Genlist_Item_Scrollto_Type`

        .. seealso:: :py:func:`show()`

        """
        elm_genlist_item_bring_in(self.item, scrollto_type)

    def update(self):
        """This updates an item by calling all the item class functions again
        to get the contents, texts and states. Use this when the original
        item data has changed and the changes are desired to be reflected.

        Use elm_genlist_realized_items_update() to update all already realized
        items.

        .. seealso:: :py:func:`Genlist.realized_items_update()`

        """
        elm_genlist_item_update(self.item)

    def item_class_update(self, GenlistItemClass itc not None):
        """This sets another class of the item, changing the way that it is
        displayed. After changing the item class, elm_genlist_item_update() is
        called on the item.

        :type itc: :py:class:`GenlistItemClass`

        """
        elm_genlist_item_item_class_update(self.item, itc.cls)

    # TODO: def item_class_get(self):
    #     """This returns the Genlist_Item_Class for the given item. It can be
    #     used to examine the function pointers and item_style.
    #
    #     """
    #     return elm_genlist_item_item_class_get(self.item)

    property index:
        """Get the index of the item. It is only valid once displayed.

        :type: int

        """
        def __get__(self):
            return elm_genlist_item_index_get(self.item)

    def index_get(self):
        return elm_genlist_item_index_get(self.item)

    property parent:
        """This returns the item that was specified as parent of the item
        on elm_genlist_item_append() and insertion related functions.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_item_parent_get(self.item))

    def parent_get(self):
        return _object_item_to_python(elm_genlist_item_parent_get(self.item))

    def subitems_clear(self):
        """This removes all items that are children (and their descendants)
        of the item.

        """
        elm_genlist_item_subitems_clear(self.item)

    def subitems_count(self):
        """Get the number of subitems.

        :return: The number of subitems, 0 on error.
        :rtype: int

        .. versionadded:: 1.9

        """
        elm_genlist_item_subitems_count(self.item)

    def subitems_get(self):
        """Get the list of subitems.

        :return: The list of subitems.
        :rype: list of :py:class:`GenlistItem`

        .. versionadded:: 1.9

        """
        return _object_item_list_to_python(
            elm_genlist_item_subitems_get(self.item)
            )

    property expanded:
        """This function flags the item of type #ELM_GENLIST_ITEM_TREE as
        expanded or not.

        The theme will respond to this change visually, and a signal
        "expanded" or "contracted" will be sent from the genlist with a
        the item that has been expanded/contracted.

        Calling this function won't show or hide any child of this item (if
        it is a parent). You must manually delete and create them on the
        callbacks of the "expanded" or "contracted" signals.

        :type: bool

        """
        def __get__(self):
            cdef bint ret = elm_genlist_item_expanded_get(self.item)
            return ret

        def __set__(self, bint expanded):
            elm_genlist_item_expanded_set(self.item, expanded)

    def expanded_set(self, bint expanded):
        elm_genlist_item_expanded_set(self.item, expanded)
    def expanded_get(self):
        cdef bint ret = elm_genlist_item_expanded_get(self.item)
        return ret

    property expanded_depth:
        """Get the depth of expanded item.

        :type: int

        """
        def __get__(self):
            return elm_genlist_item_expanded_depth_get(self.item)

    def expanded_depth_get(self):
        return elm_genlist_item_expanded_depth_get(self.item)

    def all_contents_unset(self):
        """This instructs genlist to release references to contents in the
        item, meaning that they will no longer be managed by genlist and are
        floating "orphans" that can be re-used elsewhere if the user wants to.

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
        elm_genlist_item_all_contents_unset(self.item, &l)
        ret = eina_list_objects_to_python_list(l)
        eina_list_free(l)
        return ret

    def promote(self):
        """Promote an item to the top of the list"""
        elm_genlist_item_promote(self.item)

    def demote(self):
        """Demote an item to the end of the list"""
        elm_genlist_item_demote(self.item)

    def fields_update(self, parts, Elm_Genlist_Item_Field_Type itf):
        """This updates an item's part by calling item's fetching functions again
        to get the contents, texts and states. Use this when the original
        item data has changed and the changes are desired to be reflected.
        Parts argument is used for globbing to match '*', '?', and '.'
        It can be used at updating multi fields.

        Use elm_genlist_realized_items_update() to update an item's all
        property.

        :param parts: The name of item's part
        :type parts: unicode
        :param itf: The type of item's part type
        :type itf: :ref:`Elm_Genlist_Item_Field_Type`

        .. seealso:: :py:func:`update()`

        """
        if isinstance(parts, unicode): parts = PyUnicode_AsUTF8String(parts)
        elm_genlist_item_fields_update(self.item,
            <const char *>parts if parts is not None else NULL,
            itf)

    property decorate_mode:
        """A genlist mode is a different way of selecting an item. Once a
        mode is activated on an item, any other selected item is immediately
        unselected. This feature provides an easy way of implementing a new
        kind of animation for selecting an item, without having to entirely
        rewrite the item style theme. However, the Genlist.selected_*
        API can't be used to get what item is activate for a mode.

        The current item style will still be used, but applying a genlist
        mode to an item will select it using a different kind of animation.

        The current active item for a mode can be found at
        :py:attr:`Genlist.decorated_item`.

        The characteristics of genlist mode are:

        - Only one mode can be active at any time, and for only one item.
        - Genlist handles deactivating other items when one item is activated.
        - A mode is defined in the genlist theme (edc), and more modes can
          easily be added.
        - A mode style and the genlist item style are different things. They
          can be combined to provide a default style to the item, with some
          kind of animation for that item when the mode is activated.

        When a mode is activated on an item, a new view for that item is
        created. The theme of this mode defines the animation that will be
        used to transit the item from the old view to the new view. This
        second (new) view will be active for that item while the mode is
        active on the item, and will be destroyed after the mode is totally
        deactivated from that item.

        :type: (unicode **decorate_it_type**, bool **decorate_it_set**)

        .. seealso:: :py:attr:`Genlist.mode`

        """
        def __set__(self, value):
            decorate_it_type, decorate_it_set = value
            self.decorate_mode_set(decorate_it_type, decorate_it_set)

        def __get__(self):
            return self.decorate_mode_get()

    def decorate_mode_set(self, decorate_it_type, decorate_it_set):
        a1 = decorate_it_type
        if isinstance(a1, unicode): a1 = PyUnicode_AsUTF8String(a1)
        elm_genlist_item_decorate_mode_set(self.item,
            <const char *>a1 if a1 is not None else NULL,
            decorate_it_set)
    def decorate_mode_get(self):
        return _ctouni(elm_genlist_item_decorate_mode_get(self.item))

    property type:
        """This function returns the item's type. Normally the item's type.
        If it failed, return value is ELM_GENLIST_ITEM_MAX

        :type: :ref:`Elm_Genlist_Item_Type`

        """
        def __get__(self):
            cdef Elm_Genlist_Item_Type ittype = elm_genlist_item_type_get(self.item)
            return <Elm_Genlist_Item_Type>ittype

    def type_get(self):
        cdef Elm_Genlist_Item_Type ittype = elm_genlist_item_type_get(self.item)
        return <Elm_Genlist_Item_Type>ittype

    property flip:
        """The flip state of a given genlist item. Flip mode overrides
        current item object. It can be used for on-the-fly item replace.
        Flip mode can be used with/without decorate mode.

        :type: bool

        """
        def __set__(self, flip):
            elm_genlist_item_flip_set(self.item, flip)

        def __get__(self):
            cdef bint ret = elm_genlist_item_flip_get(self.item)
            return ret

    def flip_set(self, flip):
        elm_genlist_item_flip_set(self.item, flip)
    def flip_get(self):
        cdef bint ret = elm_genlist_item_flip_get(self.item)
        return ret

    property select_mode:
        """Item's select mode. Possible values are:

        :type: :ref:`Elm_Object_Select_Mode`

        """
        def __set__(self, mode):
            elm_genlist_item_select_mode_set(self.item, mode)

        def __get__(self):
            return elm_genlist_item_select_mode_get(self.item)

    def select_mode_set(self, mode):
        elm_genlist_item_select_mode_set(self.item, mode)
    def select_mode_get(self):
        return elm_genlist_item_select_mode_get(self.item)

