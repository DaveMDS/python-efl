from efl.eo cimport _object_mapping_register, PY_REFCOUNT

#include "cnp_callbacks.pxi"

cdef class Genlist(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent not None, *args, **kwargs):
        """Genlist(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_genlist_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def __iter__(self):
        return GenlistIterator(self)

    def __len__(self):
        return elm_genlist_items_count(self.obj)

    def __contains__(self, GenlistItem x):
        cdef:
            Elm_Object_Item *current_item = elm_genlist_first_item_get(self.obj)
            int count = elm_genlist_items_count(self.obj)
            int i

        for i in range(count):
            if x.item == current_item:
                return 1
            else:
                current_item = elm_genlist_item_next_get(current_item)

        return 0

    def clear(self):
        """Remove all items from a given genlist widget."""
        elm_genlist_clear(self.obj)

    property multi_select:
        """This enables (``True``) or disables (``False``) multi-selection in
        the list. This allows more than 1 item to be selected. To retrieve
        the list of selected items, use elm_genlist_selected_items_get().

        :type: bool

        """
        def __set__(self, multi):
            elm_genlist_multi_select_set(self.obj, bool(multi))

        def __get__(self):
            return bool(elm_genlist_multi_select_get(self.obj))

    def multi_select_set(self, multi):
        elm_genlist_multi_select_set(self.obj, bool(multi))
    def multi_select_get(self):
        return bool(elm_genlist_multi_select_get(self.obj))

    property mode:
        """The mode used for sizing items horizontally.

        Default value is ``ELM_LIST_SCROLL``. This mode means that if items are too
        wide to fit, the scroller will scroll horizontally. Otherwise items are
        expanded to fill the width of the viewport of the scroller. If it is
        ``ELM_LIST_LIMIT``, items will be expanded to the viewport width and limited
        to that size. If it is ``ELM_LIST_COMPRESS``, the item width will be fixed
        (restricted to a minimum of) to the list width when calculating its size
        in order to allow the height to be calculated based on it. This allows,
        for instance, text block to wrap lines if the Edje part is configured
        with "text.min: 0 1".

        :type: :ref:`Elm_List_Mode`

        .. note:: ``ELM_LIST_COMPRESS`` will make list resize slower as it will
            have to recalculate every item height again whenever the list
            width changes!

        .. note:: With :attr:`homogeneous` mode all items in the genlist have the same
            width/height. With ``ELM_LIST_COMPRESS`` the genlist items have
            fast initializing. However there are no sub-objects in genlist
            which can be on-the-fly resizable (such as TEXTBLOCK), as some
            dynamic resizable objects would not be diplayed properly.

        """
        def __set__(self, mode):
            elm_genlist_mode_set(self.obj, mode)

        def __get__(self):
            return elm_genlist_mode_get(self.obj)

    def mode_set(self, mode):
        elm_genlist_mode_set(self.obj, mode)
    def mode_get(self):
        return elm_genlist_mode_get(self.obj)

    def item_append(self,
                    GenlistItemClass item_class not None,
                    item_data,
                    ObjectItem parent_item=None,
                    int flags=enums.ELM_GENLIST_ITEM_NONE,
                    func=None):
        """Append a new item (add as last row) to this genlist.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param parent_item: if this is a tree child, then the
            parent item must be given here, otherwise it may be
            None. The parent must have the flag
            ``ELM_GENLIST_ITEM_SUBITEMS`` set.
        :param flags: defines special behavior of this item, can be one of:
            ELM_GENLIST_ITEM_NONE, ELM_GENLIST_ITEM_TREE or
            ELM_GENLIST_ITEM_GROUP
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :rtype: :py:class:`GenlistItem`

        """
        return GenlistItem(item_class, item_data, parent_item, flags, func, item_data)\
                          .append_to(self)

    def item_prepend(   self,
                        GenlistItemClass item_class not None,
                        item_data,
                        ObjectItem parent_item=None,
                        int flags=enums.ELM_GENLIST_ITEM_NONE,
                        func=None):
        """Prepend a new item (add as first row) to this genlist.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param parent_item: if this is a tree child, then the
            parent item must be given here, otherwise it may be
            None. The parent must have the flag
            ``ELM_GENLIST_ITEM_SUBITEMS`` set.
        :param flags: defines special behavior of this item, can be one of:
            ELM_GENLIST_ITEM_NONE, ELM_GENLIST_ITEM_TREE or
            ELM_GENLIST_ITEM_GROUP
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :rtype: :py:class:`GenlistItem`

        """
        return GenlistItem(item_class, item_data, parent_item, flags, func, item_data)\
                          .prepend_to(self)

    def item_insert_before( self,
                            GenlistItemClass item_class not None,
                            item_data,
                            ObjectItem before_item=None,
                            int flags=enums.ELM_GENLIST_ITEM_NONE,
                            func=None
                            ):
        """Insert a new item before another item to this genlist.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param before_item: the new item will be inserted before this one.
        :param flags: defines special behavior of this item, can be one of:
            ELM_GENLIST_ITEM_NONE, ELM_GENLIST_ITEM_TREE or
            ELM_GENLIST_ITEM_GROUP
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :rtype: :py:class:`GenlistItem`

        """
        return GenlistItem(item_class, item_data, None, flags, func, item_data)\
                          .insert_before(before_item)

    def item_insert_after(  self,
                            GenlistItemClass item_class not None,
                            item_data,
                            ObjectItem after_item=None,
                            int flags=enums.ELM_GENLIST_ITEM_NONE,
                            func=None
                            ):
        """Insert a new item after another item to this genlist.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param after_item: the new item will be inserted after this one.
        :param flags: defines special behavior of this item, can be one of:
            ELM_GENLIST_ITEM_NONE, ELM_GENLIST_ITEM_TREE or
            ELM_GENLIST_ITEM_GROUP
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :rtype: :py:class:`GenlistItem`

        """
        return GenlistItem(item_class, item_data, None, flags, func, item_data)\
                          .insert_after(after_item)

    def item_sorted_insert( self,
                            GenlistItemClass item_class not None,
                            item_data,
                            comparison_func not None,
                            ObjectItem parent_item=None,
                            int flags=enums.ELM_GENLIST_ITEM_NONE,
                            func=None
                            ):
        """This inserts a new item in the genlist based on a user defined
        comparison function.

        :param item_class: a valid instance that defines the
            behavior of this row. See :py:class:`GenlistItemClass`.
        :param item_data: some data that defines the model of this
            row. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GenlistItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param comparison_func: The function called for the sort.
            this must be a callable and will be called
            to insert the item in the right position. The two arguments passed
            are two :py:class:`GenlistItem` to compare. The function must return
            1 if ``item1`` comes before ``item2``, 0 if the two items
            are equal or -1 otherwise.
            Signature is::

                func(item1, item2)->int

        :param parent_item: if this is a tree child, then the
            parent item must be given here, otherwise it may be
            None. The parent must have the flag
            ``ELM_GENLIST_ITEM_SUBITEMS`` set.
        :param flags: defines special behavior of this item, can be one of:
            ELM_GENLIST_ITEM_NONE, ELM_GENLIST_ITEM_TREE or
            ELM_GENLIST_ITEM_GROUP
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.

        :rtype: :py:class:`GenlistItem`

        """
        return GenlistItem(item_class, item_data, parent_item, flags, func, item_data)\
                          .sorted_insert(self, comparison_func)

    property selected_item:
        """This gets the selected item in the list (if multi-selection is
        enabled, only the item that was first selected in the list is
        returned - which is not very useful, so see
        elm_genlist_selected_items_get() for when multi-selection is used).

        If no item is selected, None is returned.

        .. seealso:: :py:attr:`selected_items`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_genlist_selected_item_get(self.obj))

    property selected_items:
        """It returns a list of the selected items. This list is
        only valid so long as the selection doesn't change (no items are
        selected or unselected, or unselected implicitly by deletion). The
        list contains genlist items. The order of the items in this
        list is the order which they were selected, i.e. the first item in
        this list is the first item that was selected, and so on.

        .. note:: If not in multi-select mode, consider using function
            :py:attr:`Genlist.selected_item` instead.

        .. seealso:: :py:attr:`multi_select` :py:attr:`selected_item`

        :type: tuple of :py:class:`GenlistItem`

        """
        def __get__(self):
            return tuple(_object_item_list_to_python(elm_genlist_selected_items_get(self.obj)))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_genlist_selected_items_get(self.obj))

    property realized_items:
        """This returns a list of the realized items in the genlist. The list
        contains genlist items. The list must be freed by the
        caller when done with eina_list_free(). The item pointers in the
        list are only valid so long as those items are not deleted or the
        genlist is not deleted.

        .. seealso:: :py:func:`realized_items_update()`

        :type: tuple of :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_genlist_realized_items_get(self.obj))
            # FIXME: Free the list! We could return a custom list-like object here
            #        that frees the C list in its __dealloc__

    def realized_items_get(self):
        return _object_item_list_to_python(elm_genlist_realized_items_get(self.obj))

    property first_item:
        """This returns the first item in the list.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_genlist_first_item_get(self.obj))

    property last_item:
        """This returns the last item in the list.

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_genlist_last_item_get(self.obj))


    def realized_items_update(self):
        """This updates all realized items by calling all the item class
        functions again to get the contents, texts and states. Use this when
        the original item data has changed and the changes are desired to be
        reflected.

        To update just one item, use :py:meth:`Genlist.item_update`.

        .. seealso:: :py:attr:`realized_items`

        """
        elm_genlist_realized_items_update(self.obj)

    def _items_count(self):
        return elm_genlist_items_count(self.obj)

    property items_count:
        """Return how many items are currently in a list

        :type: int

        """
        def __get__(self):
            count = elm_genlist_items_count(self.obj)
            return GenlistItemsCount(self, count)

    property homogeneous:
        """This will enable the homogeneous mode where items are of the same
        height and width so that genlist may do the lazy-loading at its
        maximum (which increases the performance for scrolling the list).

        .. seealso:: :py:attr:`mode`

        :type: bool

        """
        def __set__(self, bint homogeneous):
            elm_genlist_homogeneous_set(self.obj, homogeneous)

        def __get__(self):
            cdef bint ret = elm_genlist_homogeneous_get(self.obj)
            return ret

    def homogeneous_set(self, bint homogeneous):
        elm_genlist_homogeneous_set(self.obj, homogeneous)
    def homogeneous_get(self):
        cdef bint ret = elm_genlist_homogeneous_get(self.obj)
        return ret

    property block_count:
        """This will configure the block count to tune to the target with
        particular performance matrix.

        A block of objects will be used to reduce the number of operations
        due to many objects in the screen. It can determine the visibility,
        or if the object has changed, it theme needs to be updated, etc.
        doing this kind of calculation to the entire block, instead of per
        object.

        The default value for the block count is enough for most lists, so
        unless you know you will have a lot of objects visible in the screen
        at the same time, don't try to change this.

        """
        def __set__(self, int n):
            elm_genlist_block_count_set(self.obj, n)

        def __get__(self):
            return elm_genlist_block_count_get(self.obj)

    def block_count_set(self, int n):
        elm_genlist_block_count_set(self.obj, n)
    def block_count_get(self):
        return elm_genlist_block_count_get(self.obj)

    property longpress_timeout:
        """This option will change how long it takes to send an event
        "longpressed" after the mouse down signal is sent to the list. If
        this event occurs, no "clicked" event will be sent.

        .. warning:: If you set the longpress timeout value with this API,
            your genlist will not be affected by the longpress value of
            elementary config value later.

        """
        def __set__(self, timeout):
            elm_genlist_longpress_timeout_set(self.obj, timeout)

        def __get__(self):
            return elm_genlist_longpress_timeout_get(self.obj)

    def longpress_timeout_set(self, timeout):
        elm_genlist_longpress_timeout_set(self.obj, timeout)
    def longpress_timeout_get(self):
        return elm_genlist_longpress_timeout_get(self.obj)

    def at_xy_item_get(self, int x, int y):
        """Get the item that is at the x, y canvas coords.

        :param x: The input x coordinate
        :param y: The input y coordinate
        :param posret: The position relative to the item returned here
        :return: (:py:class:`ObjectItem<efl.elementary.object_item.ObjectItem>` it, **int** posret)

        This returns the item at the given coordinates (which are canvas
        relative, not object-relative). If an item is at that coordinate,
        that item handle is returned, and if ``posret`` is not None, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the upper portion of that item (-1), on the
        middle section (0) or on the lower part (1). If None is returned as
        an item (no item found there), then posret may indicate -1 or 1
        based if the coordinate is above or below all items respectively in
        the genlist.

        """
        cdef:
            int posret
            Elm_Object_Item *ret

        ret = elm_genlist_at_xy_item_get(self.obj, x, y, &posret)
        return _object_item_to_python(ret), posret

    property decorated_item:
        """This function returns the item that was activated with a mode, by
        the function elm_genlist_item_decorate_mode_set().

        .. seealso:: :py:attr:`GenlistItem.decorate_mode` :py:attr:`mode`

        :type: :py:class:`GenlistItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_genlist_decorated_item_get(self.obj))

    def decorated_item_get(self):
        return _object_item_to_python(elm_genlist_decorated_item_get(self.obj))

    property reorder_mode:
        """Reorder mode.

        :type: bool

        """
        def __set__(self, bint reorder_mode):
            elm_genlist_reorder_mode_set(self.obj, reorder_mode)

        def __get__(self):
            cdef bint ret = elm_genlist_reorder_mode_get(self.obj)
            return ret

    def reorder_mode_set(self, bint reorder_mode):
        elm_genlist_reorder_mode_set(self.obj, reorder_mode)
    def reorder_mode_get(self):
        cdef bint ret = elm_genlist_reorder_mode_get(self.obj)
        return ret

    property decorate_mode:
        """Genlist decorate mode for all items.

        :type: bool

        """
        def __set__(self, bint decorated):
            elm_genlist_decorate_mode_set(self.obj, decorated)

        def __get__(self):
            cdef bint ret = elm_genlist_decorate_mode_get(self.obj)
            return ret

    def decorate_mode_set(self, bint decorated):
        elm_genlist_decorate_mode_set(self.obj, decorated)
    def decorate_mode_get(self):
        cdef bint ret = elm_genlist_decorate_mode_get(self.obj)
        return ret

    property tree_effect_enabled:
        """Genlist tree effect.

        :type: bool

        """
        def __set__(self, bint enabled):
            elm_genlist_tree_effect_enabled_set(self.obj, enabled)

        def __get__(self):
            cdef bint ret = elm_genlist_tree_effect_enabled_get(self.obj)
            return ret

    def tree_effect_enabled_set(self, bint enabled):
        elm_genlist_tree_effect_enabled_set(self.obj, enabled)
    def tree_effect_enabled_get(self):
        cdef bint ret = elm_genlist_tree_effect_enabled_get(self.obj)
        return ret

    property highlight_mode:
        """Whether the item will, or will not highlighted on selection. The
        selected and clicked callback functions will still be called.

        Highlight is enabled by default.

        :type: bool

        """
        def __set__(self, bint highlight):
            elm_genlist_highlight_mode_set(self.obj, highlight)

        def __get__(self):
            cdef bint ret = elm_genlist_highlight_mode_get(self.obj)
            return ret

    def highlight_mode_set(self, bint highlight):
        elm_genlist_highlight_mode_set(self.obj, highlight)
    def highlight_mode_get(self):
        cdef bint ret = elm_genlist_highlight_mode_get(self.obj)
        return ret

    property select_mode:
        """Selection mode of the Genlist widget.

        - ELM_OBJECT_SELECT_MODE_DEFAULT : Items will only call their
            selection func and callback when first becoming selected. Any
            further clicks will do nothing, unless you set always select mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS :  This means that, even if selected,
            every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability to
            select items entirely and they will neither appear selected nor
            call selected callback functions.

        :type: :ref:`Elm_Object_Select_Mode`

        """
        def __set__(self, mode):
            elm_genlist_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_genlist_select_mode_get(self.obj)

    def select_mode_set(self, mode):
        elm_genlist_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_genlist_select_mode_get(self.obj)

    def nth_item_get(self, int nth):
        """

        Get the nth item, in a given genlist widget, placed at
        position ``nth``, in its internal items list

        :param nth: The number of the item to grab (0 being the first)

        :return: The item stored in the object at position ``nth`` or
            ``None``, if there's no item with that index (and on errors)

        .. versionadded:: 1.8

        """
        return _object_item_to_python(elm_genlist_nth_item_get(self.obj, nth))

    def search_by_text_item_get(self, GenlistItem item_to_search_from,
                                part_name, pattern, Elm_Glob_Match_Flags flags):
        """Search genlist item by given string.

        This function uses globs (like "\*.jpg") for searching and takes
        search flags as last parameter. That is a bitfield with values
        to be ored together or 0 for no flags.

        :param item_to_search_from: item to start search from, or None to
            search from the first item.
        :type item_to_search_from: :py:class:`GenlistItem`
        :param part_name: Name of the TEXT part of genlist item to search
            string in (usually "elm.text").
        :type part_name: string
        :param pattern: The search pattern.
        :type pattern: string
        :param flags: Search flags
        :type flags: :ref:`Elm_Glob_Match_Flags`

        :return: The first item found
        :rtype: :py:class:`GenlistItem`

        .. versionadded:: 1.11

        """
        cdef Elm_Object_Item *from_item = NULL

        if isinstance(part_name, unicode):
            part_name = PyUnicode_AsUTF8String(part_name)
        if isinstance(pattern, unicode):
            pattern = PyUnicode_AsUTF8String(pattern)
        if item_to_search_from is not None:
            from_item = _object_item_from_python(item_to_search_from)

        return _object_item_to_python(elm_genlist_search_by_text_item_get(
                    self.obj, from_item,
                    <const char *>part_name if part_name is not None else NULL,
                    <const char *>pattern if pattern is not None else NULL,
                    flags))

    property focus_on_selection:
        """

        Focus upon items selection mode

        :type: bool

        When enabled, every selection of an item inside the genlist will
        automatically set focus to its first focusable widget from the
        left. This is true of course if the selection was made by
        clicking an unfocusable area in an item or selecting it with a
        key movement. Clicking on a focusable widget inside an item will
        cause this particular item to get focus as usual.

        .. versionadded:: 1.8

        """
        def __set__(self, bint enabled):
            elm_genlist_focus_on_selection_set(self.obj, enabled)

        def __get__(self):
            return bool(elm_genlist_focus_on_selection_get(self.obj))

    property filter:
        """ Set filter mode with key.

        This initiates the filter mode of genlist with user/application
        provided key. If key is None, the filter mode is turned off.

        The given key will be passed back in the filter_get function of
        the GenlistItemClass

        :type: any python object

        .. versionadded:: 1.17

        """
        def __set__(self, object key):
            self.internal_data['__filterkeyref'] = key # keep a reference for key
            elm_genlist_filter_set(self.obj, <void *>key if key is not None else NULL)

        def __get__(self):
            return self.internal_data['__filterkeyref']

    def filter_set(self, key):
        self.internal_data['__filterkeyref'] = key
        elm_genlist_filter_set(self.obj, <void*>key if key is not None else NULL)
    def filter_get(self):
        return self.internal_data['__filterkeyref']

    def filtered_items_count(self):
        """Return how many items have passed the filter currently.

        This behaviour is O(1) and may or may not return the filtered count for
        complete genlist based on the timing of the call. To get complete
        count, call after "filter,done" callback.

        :return: The number of filtered items
        :rtype: int

        .. versionadded:: 1.18

        """
        return elm_genlist_filtered_items_count(self.obj)
    #
    # Drag and Drop
    # =============

    def drag_item_container_add(self, double tm_to_anim, double tm_to_drag, itemgetcb = None, data_get = None):
        """

        Set a item container (list, genlist, grid) as source of drag

        :param tm_to_anim: Time period to wait before start animation.
        :param tm_to_drag: Time period to wait before start dragging.
        :param itemgetcb: Callback to get Evas object for item at (x,y)
        :param data_get:  Callback to get drag info

        :raise RuntimeError: if setting drag source failed.

        .. versionadded:: 1.17

        """
        if itemgetcb is not None:
            if not callable(itemgetcb):
                raise TypeError("itemgetcb must be callable.")
            self.internal_data["xy_item_get_cb"] = itemgetcb

        self.internal_data["item_container_data_get_cb"] = data_get

        if not elm_drag_item_container_add(self.obj,
            tm_to_anim,
            tm_to_drag,
            <Elm_Xy_Item_Get_Cb>py_elm_xy_item_get_cb if itemgetcb is not None else NULL,
            <Elm_Item_Container_Data_Get_Cb>py_elm_item_container_data_get_cb if data_get is not None else NULL):
            raise RuntimeError

    def drag_item_container_del(self):
        """

        Deletes a item container from drag-source list

        :raise RuntimeError: if deleting drag source failed.

        .. versionadded:: 1.17

        """
        if not elm_drag_item_container_del(self.obj):
            raise RuntimeError

    def drop_item_container_add(self, Elm_Sel_Format format,
        itemgetcb = None, entercb = None, enterdata = None,
        leavecb = None, leavedata = None,
        poscb = None, posdata = None, dropcb = None, cbdata = None):
        """

        Set a item container (list, genlist, grid) as target for drop.

        :param format: The formats supported for dropping
        :param itemgetcb: Callback to get Evas object for item at (x,y)
        :param entercb: The function to call when the object is entered with a drag
        :param enterdata: The application data to pass to enterdata
        :param leavecb: The function to call when the object is left with a drag
        :param leavedata: The application data to pass to leavedata
        :param poscb: The function to call when the object has a drag over it
        :param posdata: The application data to pass to posdata
        :param dropcb: The function to call when a drop has occurred
        :param cbdata: The application data to pass to dropcb

        :raise RuntimeError: if setting drop target failed.

        .. versionadded:: 1.17

        """
        if itemgetcb is not None:
            if not callable(itemgetcb):
                raise TypeError("itemgetcb must be callable.")
            self.internal_data["xy_item_get_cb"] = itemgetcb

        self.internal_data["drag_item_container_pos"] = poscb
        self.internal_data["drop_item_container_cb"] = dropcb

        if not elm_drop_item_container_add(self.obj,
            format,
            <Elm_Xy_Item_Get_Cb>py_elm_xy_item_get_cb if itemgetcb is not None else NULL,
            <Elm_Drag_State>py_elm_drag_state_cb if entercb is not None else NULL,
            <void *>enterdata if enterdata is not None else NULL,
            <Elm_Drag_State>py_elm_drag_state_cb if leavecb is not None else NULL,
            <void *>leavedata if leavedata is not None else NULL,
            <Elm_Drag_Item_Container_Pos>py_elm_drag_item_container_pos if poscb is not None else NULL,
            <void *>posdata if posdata is not None else NULL,
            <Elm_Drop_Item_Container_Cb>py_elm_drop_item_container_cb if dropcb is not None else NULL,
            <void *>cbdata if cbdata is not None else NULL):
            raise RuntimeError

    def drop_item_container_del(self):
        """

        Removes a container from list of drop targets.

        :raise RuntimeError: if deleting drop target failed.

        .. versionadded:: 1.17

        """
        if not elm_drop_item_container_del(self.obj):
            raise RuntimeError


    def callback_activated_add(self, func, *args, **kwargs):
        self._callback_add_full("activated", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_activated_del(self, func):
        self._callback_del_full("activated",  _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double",  _cb_object_item_conv, func)

    def callback_clicked_right_add(self, func, *args, **kwargs):
        """The user has right-clicked an item.

        .. versionadded:: 1.13

        """
        self._callback_add_full("clicked,right", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_clicked_right_del(self, func):
        self._callback_del_full("clicked,right", _cb_object_item_conv, func)

    def callback_selected_add(self, func, *args, **kwargs):
        self._callback_add_full("selected", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_selected_del(self, func):
        self._callback_del_full("selected", _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected",  _cb_object_item_conv, func)

    def callback_expanded_add(self, func, *args, **kwargs):
        self._callback_add_full("expanded", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_expanded_del(self, func):
        self._callback_del_full("expanded",  _cb_object_item_conv, func)

    def callback_contracted_add(self, func, *args, **kwargs):
        self._callback_add_full("contracted", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_contracted_del(self, func):
        self._callback_del_full("contracted",  _cb_object_item_conv, func)

    def callback_expand_request_add(self, func, *args, **kwargs):
        self._callback_add_full("expand,request", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_expand_request_del(self, func):
        self._callback_del_full("expand,request",  _cb_object_item_conv, func)

    def callback_contract_request_add(self, func, *args, **kwargs):
        self._callback_add_full("contract,request", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_contract_request_del(self, func):
        self._callback_del_full("contract,request",  _cb_object_item_conv, func)

    def callback_realized_add(self, func, *args, **kwargs):
        self._callback_add_full("realized", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_realized_del(self, func):
        self._callback_del_full("realized",  _cb_object_item_conv, func)

    def callback_unrealized_add(self, func, *args, **kwargs):
        self._callback_add_full("unrealized", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unrealized_del(self, func):
        self._callback_del_full("unrealized",  _cb_object_item_conv, func)

    def callback_drag_start_up_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,up", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_start_up_del(self, func):
        self._callback_del_full("drag,start,up",  _cb_object_item_conv, func)

    def callback_drag_start_down_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,down", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_start_down_del(self, func):
        self._callback_del_full("drag,start,down",  _cb_object_item_conv, func)

    def callback_drag_start_left_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,left", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_start_left_del(self, func):
        self._callback_del_full("drag,start,left",  _cb_object_item_conv, func)

    def callback_drag_start_right_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,start,right", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_start_right_del(self, func):
        self._callback_del_full("drag,start,right",  _cb_object_item_conv, func)

    def callback_drag_stop_add(self, func, *args, **kwargs):
        self._callback_add_full("drag,stop", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_stop_del(self, func):
        self._callback_del_full("drag,stop",  _cb_object_item_conv, func)

    def callback_drag_add(self, func, *args, **kwargs):
        self._callback_add_full("drag", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_drag_del(self, func):
        self._callback_del_full("drag",  _cb_object_item_conv, func)

    def callback_longpressed_add(self, func, *args, **kwargs):
        self._callback_add_full("longpressed", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_longpressed_del(self, func):
        self._callback_del_full("longpressed", _cb_object_item_conv, func)


    def callback_multi_swipe_left_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,left", func, args, kwargs)

    def callback_multi_swipe_left_del(self, func):
        self._callback_del("multi,swipe,left", func)

    def callback_multi_swipe_right_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,right", func, args, kwargs)

    def callback_multi_swipe_right_del(self, func):
        self._callback_del("multi,swipe,right", func)

    def callback_multi_swipe_up_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,up", func, args, kwargs)

    def callback_multi_swipe_up_del(self, func):
        self._callback_del("multi,swipe,up", func)

    def callback_multi_swipe_down_add(self, func, *args, **kwargs):
        self._callback_add("multi,swipe,down", func, args, kwargs)

    def callback_multi_swipe_down_del(self, func):
        self._callback_del("multi,swipe,down", func)

    def callback_multi_pinch_out_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,out", func, args, kwargs)

    def callback_multi_pinch_out_del(self, func):
        self._callback_del("multi,pinch,out", func)

    def callback_multi_pinch_in_add(self, func, *args, **kwargs):
        self._callback_add("multi,pinch,in", func, args, kwargs)

    def callback_multi_pinch_in_del(self, func):
        self._callback_del("multi,pinch,in", func)

    def callback_swipe_add(self, func, *args, **kwargs):
        self._callback_add("swipe", func, args, kwargs)

    def callback_swipe_del(self, func):
        self._callback_del("swipe", func)

    def callback_moved_add(self, func, *args, **kwargs):
        self._callback_add_full("moved", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_moved_del(self, func):
        self._callback_del_full("moved",  _cb_object_item_conv, func)

    def callback_moved_after_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,after", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_moved_after_del(self, func):
        self._callback_del_full("moved,after",  _cb_object_item_conv, func)

    def callback_moved_before_add(self, func, *args, **kwargs):
        self._callback_add_full("moved,before", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_moved_before_del(self, func):
        self._callback_del_full("moved,before",  _cb_object_item_conv, func)

    def callback_tree_effect_finished_add(self, func, *args, **kwargs):
        self._callback_add("tree,effect,finished", func, args, kwargs)

    def callback_tree_effect_finished_del(self, func):
        self._callback_del("tree,effect,finished", func)

    def callback_highlighted_add(self, func, *args, **kwargs):
        """an item in the list is highlighted. This is called when
        the user presses an item or keyboard selection is done so the item is
        physically highlighted. The %c event_info parameter is the item that was
        highlighted."""
        self._callback_add_full("highlighted", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_highlighted_del(self, func):
        self._callback_del_full("highlighted", _cb_object_item_conv, func)

    def callback_unhighlighted_add(self, func, *args, **kwargs):
        """an item in the list is unhighlighted. This is called
        when the user releases an item or keyboard selection is moved so the item
        is physically unhighlighted. The %c event_info parameter is the item that
        was unhighlighted."""
        self._callback_add_full("unhighlighted", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unhighlighted_del(self, func):
        self._callback_del_full("unhighlighted", _cb_object_item_conv, func)

    def callback_item_focused_add(self, func, *args, **kwargs):
        """When the genlist item has received focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,focused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_focused_del(self, func):
        self._callback_del_full("item,focused", _cb_object_item_conv, func)

    def callback_item_unfocused_add(self, func, *args, **kwargs):
        """When the genlist item has lost focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,unfocused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_unfocused_del(self, func):
        self._callback_del_full("item,unfocused", _cb_object_item_conv, func)

    def callback_changed_add(self, func, *args, **kwargs):
        """Genlist is now changed their items and properties and all
           calculation is finished.

        .. versionadded:: 1.16
        """
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_filter_done_add(self, func, *args, **kwargs):
        """Genlist filter operation is completed.

        .. versionadded:: 1.17
        """
        self._callback_add("filter,done", func, args, kwargs)

    def callback_filter_done_del(self, func):
        self._callback_del("filter,done", func)

    property scroller_policy:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.scroller_policy_get()

        def __set__(self, value):
            cdef Elm_Scroller_Policy policy_h, policy_v
            policy_h, policy_v = value
            self.scroller_policy_set(policy_h, policy_v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_set(self, policy_h, policy_v):
        elm_scroller_policy_set(self.obj, policy_h, policy_v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def scroller_policy_get(self):
        cdef Elm_Scroller_Policy policy_h, policy_v
        elm_scroller_policy_get(self.obj, &policy_h, &policy_v)
        return (policy_h, policy_v)

    property bounce:
        """

        .. deprecated:: 1.8
            You should combine with Scrollable class instead.

        """
        def __get__(self):
            return self.bounce_get()
        def __set__(self, value):
            cdef Eina_Bool h, v
            h, v = value
            self.bounce_set(h, v)

    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_set(self, h, v):
        elm_scroller_bounce_set(self.obj, h, v)
    @DEPRECATED("1.8", "You should combine with Scrollable class instead.")
    def bounce_get(self):
        cdef Eina_Bool h, v
        elm_scroller_bounce_get(self.obj, &h, &v)
        return (h, v)

_object_mapping_register("Elm_Genlist", Genlist)
