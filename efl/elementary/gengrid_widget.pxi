#include "cnp_callbacks.pxi"

cdef class Gengrid(Object):
    """

    This is the class that actually implements the widget.

    """

    def __init__(self, evasObject parent, *args, **kwargs):
        """Gengrid(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_gengrid_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    def clear(self):
        """Remove all items from a given gengrid widget."""
        elm_gengrid_clear(self.obj)

    property multi_select:
        """Multi-selection is the ability to have **more** than one
        item selected, on a given gengrid, simultaneously. When it is
        enabled, a sequence of clicks on different items will make them
        all selected, progressively. A click on an already selected item
        will unselect it. If interacting via the keyboard,
        multi-selection is enabled while holding the "Shift" key.

        .. note:: By default, multi-selection is **disabled** on gengrids.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_multi_select_get(self.obj))

        def __set__(self, multi):
            elm_gengrid_multi_select_set(self.obj, bool(multi))

    def multi_select_set(self, multi):
        elm_gengrid_multi_select_set(self.obj, bool(multi))
    def multi_select_get(self):
        return bool(elm_gengrid_multi_select_get(self.obj))


    property multi_select_mode:
        """Gengrid multi select mode.

        - ELM_OBJECT_MULTI_SELECT_MODE_DEFAULT : select/unselect items whenever each
          item is clicked.
        - ELM_OBJECT_MULTI_SELECT_MODE_WITH_CONTROL : Only one item will be selected
          although multi-selection is enabled, if clicked without pressing control
          key. This mode is only available with multi-selection.

        (If getting mode is failed, it returns ELM_OBJECT_MULTI_SELECT_MODE_MAX)

        :see: :py:attr:`multi_select`

        :type: :ref:`Elm_Gengrid_Object_Multi_Select_Mode`

        .. versionadded:: 1.10

        """
        def __set__(self, Elm_Object_Multi_Select_Mode mode):
            elm_gengrid_multi_select_mode_set(self.obj, mode)

        def __get__(self):
            return elm_gengrid_multi_select_mode_get(self.obj)

    property horizontal:
        """When in "horizontal mode" (``True``), items will be placed
        in **columns**, from top to bottom and, when the space for a
        column is filled, another one is started on the right, thus
        expanding the grid horizontally. When in "vertical mode"
        (``False``), though, items will be placed in **rows**, from left
        to right and, when the space for a row is filled, another one is
        started below, thus expanding the grid vertically.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_horizontal_get(self.obj))

        def __set__(self, setting):
            elm_gengrid_horizontal_set(self.obj, bool(setting))

    def horizontal_set(self, setting):
        elm_gengrid_horizontal_set(self.obj, bool(setting))
    def horizontal_get(self):
        return bool(elm_gengrid_horizontal_get(self.obj))

    property page_size:
        """Set a given gengrid widget's scrolling page size

        :type: (int h_pagesize, int v_pagesize)

        .. versionadded:: 1.10

        """
        def __set__(self, value):
            cdef Evas_Coord h_pagesize, v_pagesize
            h_pagesize, v_pagesize = value
            elm_gengrid_page_size_set(self.obj, h_pagesize, v_pagesize)

    def item_append(self, GengridItemClass item_class not None,
                    item_data, func=None):
        """Append a new item (add as last item) to this gengrid.

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
        return GengridItem(item_class, item_data, func, item_data)\
                          .append_to(self)

    def item_prepend(self, GengridItemClass item_class not None,
                     item_data, func=None):
        """Prepend a new item (add as first item) to this gengrid.

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
        return GengridItem(item_class, item_data, func, item_data)\
                          .prepend_to(self)

    def item_insert_before(self, GengridItemClass item_class not None,
                           item_data, GengridItem before_item=None,
                           func=None):
        """Insert a new item before another item in this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param before_item: a reference item to use, the new item
            will be inserted before it.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .insert_before(before_item)

    def item_insert_after(self, GengridItemClass item_class not None,
                          item_data, GengridItem after_item=None,
                          func=None):
        """Insert a new item after another item in this gengrid.

        :param item_class: a valid instance that defines the
            behavior of this item. See :py:class:`GengridItemClass`.
        :param item_data: some data that defines the model of this
            item. This value will be given to methods of
            ``item_class`` such as
            :py:func:`GengridItemClass.text_get()`. It will also be
            provided to ``func`` as its last parameter.
        :param after_item: a reference item to use, the new item
            will be inserted after it.
        :param func: if not None, this must be a callable to be
            called back when the item is selected. The function
            signature is::

                func(item, obj, item_data)

            Where ``item`` is the handle, ``obj`` is the Evas object
            that represents this item, and ``item_data`` is the
            value given as parameter to this function.
        """
        return GengridItem(item_class, item_data, func, item_data)\
                          .insert_before(after_item)

    # TODO: elm_gengrid_item_sorted_insert()

    property selected_item:
        """This returns the selected item. If multi selection is enabled
        (:py:attr:`multi_select`), only the first item in the list is selected,
        which might not be very useful. For that case, see
        :py:attr:`selected_items`.

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_selected_item_get(self.obj))

    def selected_item_get(self):
        return _object_item_to_python(elm_gengrid_selected_item_get(self.obj))

    property selected_items:
        """This returns a tuple of the selected items, in the order that they
        appear in the grid.

        .. seealso:: :py:attr:`selected_item`

        :type: tuple of :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_gengrid_selected_items_get(self.obj))

    def selected_items_get(self):
        return _object_item_list_to_python(elm_gengrid_selected_items_get(self.obj))

    property realized_items:
        """This returns a tuple of the realized items in the gengrid.

        .. seealso:: :py:func:`realized_items_update`

        :type: tuple of :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_list_to_python(elm_gengrid_realized_items_get(self.obj))

    def realized_items_get(self):
        return _object_item_list_to_python(elm_gengrid_realized_items_get(self.obj))

    def realized_items_update(self):
        """This updates all realized items by calling all the item class
        functions again to get the contents, texts and states. Use this when
        the original item data has changed and the changes are desired to be
        reflected.

        To update just one item, use :func:`GengridItem.update`

        .. seealso:: :py:attr:`realized_items` :py:func:`GengridItem.update()`

        """
        elm_gengrid_realized_items_update(self.obj)

    property first_item:
        """Get the first item in the gengrid widget.

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_first_item_get(self.obj))

    def first_item_get(self):
        return _object_item_to_python(elm_gengrid_first_item_get(self.obj))

    property last_item:
        """Get the last item in the gengrid widget.

        :type: :py:class:`GengridItem`

        """
        def __get__(self):
            return _object_item_to_python(elm_gengrid_last_item_get(self.obj))

    def last_item_get(self):
        return _object_item_to_python(elm_gengrid_last_item_get(self.obj))

    property wheel_disabled:
        """Enable or disable mouse wheel to be used to scroll the gengrid.

        Mouse wheel can be used for the user to scroll up and down the gengrid.

        It's enabled by default.

        :type: bool

        .. versionadded:: 1.10

        """
        def __set__(self, bint disabled):
            elm_gengrid_wheel_disabled_set(self.obj, disabled)

        def __get__(self):
            return bool(elm_gengrid_wheel_disabled_get(self.obj))

    property items_count:
        """Return how many items are currently in a list.

        :type: int

        """
        def __get__(self):
            return elm_gengrid_items_count(self.obj)

    property item_size:
        """A gengrid, after creation, has still no information on the size
        to give to each of its cells. So, you most probably will end up
        with squares one :ref:`finger <Fingers>` wide, the default
        size. Use this property to force a custom size for you items,
        making them as big as you wish.

        """
        def __get__(self):
            cdef Evas_Coord x, y
            elm_gengrid_item_size_get(self.obj, &x, &y)
            return (x, y)

        def __set__(self, value):
            w, h = value
            elm_gengrid_item_size_set(self.obj, w, h)

    def item_size_set(self, w, h):
        elm_gengrid_item_size_set(self.obj, w, h)
    def item_size_get(self):
        cdef Evas_Coord x, y
        elm_gengrid_item_size_get(self.obj, &x, &y)
        return (x, y)

    property group_item_size:
        """A gengrid, after creation, has still no information on the size
        to give to each of its cells. So, you most probably will end up
        with squares one "finger" wide, the default
        size. Use this function to force a custom size for you group items,
        making them as big as you wish.

        """
        def __get__(self):
            cdef Evas_Coord w, h
            elm_gengrid_group_item_size_get(self.obj, &w, &h)
            return (w, h)

        def __set__(self, value):
            w, h = value
            elm_gengrid_group_item_size_set(self.obj, w, h)

    def group_item_size_set(self, w, h):
        elm_gengrid_group_item_size_set(self.obj, w, h)
    def group_item_size_get(self):
        cdef Evas_Coord w, h
        elm_gengrid_group_item_size_get(self.obj, &w, &h)
        return (w, h)

    property align:
        """This sets the alignment of the whole grid of items of a gengrid
        within its given viewport. By default, those values are both
        0.5, meaning that the gengrid will have its items grid placed
        exactly in the middle of its viewport.

        .. note:: If given alignment values are out of the cited ranges,
            they'll be changed to the nearest boundary values on the valid
            ranges.

        :type: tuple of floats

        """
        def __get__(self):
            cdef double align_x, align_y
            elm_gengrid_align_get(self.obj, &align_x, &align_y)
            return (align_x, align_y)

        def __set__(self, value):
            align_x, align_y = value
            elm_gengrid_align_set(self.obj, align_x, align_y)

    def align_set(self, align_x, align_y):
        elm_gengrid_align_set(self.obj, align_x, align_y)
    def align_get(self):
        cdef double align_x, align_y
        elm_gengrid_align_get(self.obj, &align_x, &align_y)
        return (align_x, align_y)

    property reorder_mode:
        """If a gengrid is set to allow reordering, a click held for more
        than 0.5 over a given item will highlight it specially,
        signaling the gengrid has entered the reordering state. From
        that time on, the user will be able to, while still holding the
        mouse button down, move the item freely in the gengrid's
        viewport, replacing to said item to the locations it goes to.
        The replacements will be animated and, whenever the user
        releases the mouse button, the item being replaced gets a new
        definitive place in the grid.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_reorder_mode_get(self.obj))

        def __set__(self, mode):
            elm_gengrid_reorder_mode_set(self.obj, bool(mode))

    def reorder_mode_set(self, mode):
        elm_gengrid_reorder_mode_set(self.obj, bool(mode))
    def reorder_mode_get(self, mode):
        return bool(elm_gengrid_reorder_mode_get(self.obj))

    def reorder_mode_start(self, tween_mode):
        """Enable the gengrid widget mode reordered with keys.

        :param tween_mode: Position mappings for animation
        :type tween_mode: `efl.ecore.Ecore_Pos_Map`

        .. versionadded:: 1.10

        """
        elm_gengrid_reorder_mode_start(self.obj, tween_mode)

    def reorder_mode_stop(self):
        """Stop the gengrid widget mode reorder.

        .. versionadded:: 1.10

        """
        elm_gengrid_reorder_mode_stop(self.obj)


    property reorder_type:
        """ Set the order type.

        This affect the way items are moved (when in reorder mode) with the
        keyboard arrows.

        :type: :ref:`Elm_Gengrid_Reorder_Type`

        .. versionadded:: 1.11

        """
        def __set__(self, value):
            elm_gengrid_reorder_type_set(self.obj, value)

    def reorder_type_set(self, value):
        elm_gengrid_reorder_type_set(self.obj, value)

    property filled:
        """The fill state of the whole grid of items of a gengrid
        within its given viewport. By default, this value is False, meaning
        that if the first line of items grid's isn't filled, the items are
        centered with the alignment.

        :type: bool

        """
        def __get__(self):
            return bool(elm_gengrid_filled_get(self.obj))

        def __set__(self, fill):
            elm_gengrid_filled_set(self.obj, bool(fill))

    def filled_set(self, fill):
        elm_gengrid_filled_set(self.obj, bool(fill))
    def filled_get(self, fill):
        return bool(elm_gengrid_filled_get(self.obj))

    property page_relative:
        """Gengrid widget's scrolling page size, relative to its viewport size.

        :type: (float h_pagerel, float v_pagerel)

        .. versionadded:: 1.10

        """
        def __set__(self, value):
            cdef double h_pagerel, v_pagerel
            h_pagerel, v_pagerel = value
            elm_gengrid_page_relative_set(self.obj, h_pagerel, v_pagerel)

        def __get__(self):
            cdef double h_pagerel, v_pagerel
            elm_gengrid_page_relative_get(self.obj, &h_pagerel, &v_pagerel)
            return h_pagerel, v_pagerel

    property select_mode:
        """Item select mode in the gengrid widget. Possible values are:

        - ELM_OBJECT_SELECT_MODE_DEFAULT : Items will only call their
            selection func and callback when first becoming selected. Any
            further clicks will do nothing, unless you set always select mode.
        - ELM_OBJECT_SELECT_MODE_ALWAYS :  This means that, even if selected,
            every click will make the selected callbacks be called.
        - ELM_OBJECT_SELECT_MODE_NONE : This will turn off the ability to
            select items entirely and they will neither appear selected nor
            call selected callback functions.

        """
        def __get__(self):
            return elm_gengrid_select_mode_get(self.obj)

        def __set__(self, mode):
            elm_gengrid_select_mode_set(self.obj, mode)

    def select_mode_set(self, mode):
        elm_gengrid_select_mode_set(self.obj, mode)
    def select_mode_get(self):
        return elm_gengrid_select_mode_get(self.obj)

    property highlight_mode:
        """This will turn on/off the highlight effect when items are
        selected and they will or will not be highlighted. The selected and
        clicked callback functions will still be called.

        Highlight is enabled by default.

        """
        def __get__(self):
            return bool(elm_gengrid_highlight_mode_get(self.obj))

        def __set__(self, highlight):
            elm_gengrid_highlight_mode_set(self.obj, bool(highlight))

    def highlight_mode_set(self, highlight):
        elm_gengrid_highlight_mode_set(self.obj, bool(highlight))
    def highlight_mode_get(self, fill):
        return bool(elm_gengrid_highlight_mode_get(self.obj))

    def nth_item_get(self, unsigned int nth):
        """Get the nth item, in a given gengrid widget, placed at position
        ``nth``, in its internal items list

        :param nth: The number of the item to grab (0 being the first)

        :return: The item stored in the object at position ``nth`` or
            ``None``, if there's no item with that index (and on errors)

        .. versionadded:: 1.8

        """
        return _object_item_to_python(elm_gengrid_nth_item_get(self.obj, nth))

    def at_xy_item_get(self, int x, int y):
        """Get the item that is at the x, y canvas coords.

        :param x: The input x coordinate
        :param y: The input y coordinate
        :return: (:py:class:`GengridItem`, **int** xposret, **int** yposret)

        This returns the item at the given coordinates (which are canvas
        relative, not object-relative). If an item is at that coordinate,
        that item handle is returned, and if ``xposret`` is not None, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the left portion of that item (-1), on the
        middle section (0) or on the right part (1).
        if ``yposret`` is not None, the
        integer pointed to is set to a value of -1, 0 or 1, depending if
        the coordinate is on the upper portion of that item (-1), on the
        middle section (0) or on the lower part (1). If None is returned as
        an item (no item found there), then posret may indicate -1 or 1
        based if the coordinate is above or below all items respectively in
        the gengrid.

        .. versionadded:: 1.8

        """
        cdef:
            int xposret, yposret
            Elm_Object_Item *ret

        ret = elm_gengrid_at_xy_item_get(self.obj, x, y, &xposret, &yposret)
        return _object_item_to_python(ret), xposret, yposret


    def search_by_text_item_get(self, GengridItem item_to_search_from,
                                part_name, pattern, Elm_Glob_Match_Flags flags):
        """Search gengrid item by given string.

        This function uses globs (like "\*.jpg") for searching and takes
        search flags as last parameter. That is a bitfield with values
        to be ored together or 0 for no flags.

        :param item_to_search_from: item to start search from, or None to
            search from the first item.
        :type item_to_search_from: :py:class:`GengridItem`
        :param part_name: Name of the TEXT part of gengrid item to search
            string in (usually "elm.text").
        :type part_name: string
        :param pattern: The search pattern.
        :type pattern: string
        :param flags: Search flags
        :type flags: :ref:`Elm_Glob_Match_Flags`

        :return: The first item found
        :rtype: :py:class:`GengridItem`

        .. versionadded:: 1.11

        """
        cdef Elm_Object_Item *from_item = NULL

        if isinstance(part_name, unicode):
            part_name = PyUnicode_AsUTF8String(part_name)
        if isinstance(pattern, unicode):
            pattern = PyUnicode_AsUTF8String(pattern)
        if item_to_search_from is not None:
            from_item = _object_item_from_python(item_to_search_from)

        return _object_item_to_python(elm_gengrid_search_by_text_item_get(
                    self.obj, from_item,
                    <const char *>part_name if part_name is not None else NULL,
                    <const char *>pattern if pattern is not None else NULL,
                    flags))

    #
    # Drag and Drop
    # =============

    def drag_item_container_add(self,
        double tm_to_anim, double tm_to_drag,
        itemgetcb = None,
        data_get = None):
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
        self._callback_del_full("activated", _cb_object_item_conv, func)

    def callback_clicked_double_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked,double", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_clicked_double_del(self, func):
        self._callback_del_full("clicked,double", _cb_object_item_conv, func)

    def callback_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("clicked", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_clicked_del(self, func):
        self._callback_del_full("clicked", _cb_object_item_conv, func)

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
        self._callback_del_full("selected",  _cb_object_item_conv, func)

    def callback_unselected_add(self, func, *args, **kwargs):
        self._callback_add_full("unselected", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unselected_del(self, func):
        self._callback_del_full("unselected", _cb_object_item_conv, func)

    def callback_realized_add(self, func, *args, **kwargs):
        """This is called when the item in the gengrid
        has its implementing Evas object instantiated, de facto.
        ``event_info`` is the gengrid item that was created. The object
        may be deleted at any time, so it is highly advised to the
        caller **not** to use the object returned from
        :py:attr:`GengridItem.object`, because it may point to freed
        objects."""
        self._callback_add_full("realized", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_realized_del(self, func):
        self._callback_del_full("realized", _cb_object_item_conv, func)

    def callback_unrealized_add(self, func, *args, **kwargs):
        """This is called when the implementing Evas
        object for this item is deleted. ``event_info`` is the gengrid
        item that was deleted."""
        self._callback_add_full("unrealized", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unrealized_del(self, func):
        self._callback_del_full("unrealized", _cb_object_item_conv, func)

    def callback_changed_add(self, func, *args, **kwargs):
        """Called when an item is added, removed, resized
        or moved and when the gengrid is resized or gets "horizontal"
        property changes."""
        self._callback_add("changed", func, args, kwargs)

    def callback_changed_del(self, func):
        self._callback_del("changed", func)

    def callback_scroll_anim_start_add(self, func, *args, **kwargs):
        """This is called when scrolling animation has
        started."""
        self._callback_add("scroll,anim,start", func, args, kwargs)

    def callback_scroll_anim_start_del(self, func):
        self._callback_del("scroll,anim,start", func)

    def callback_scroll_anim_stop_add(self, func, *args, **kwargs):
        """This is called when scrolling animation has
        stopped."""
        self._callback_add("scroll,anim,stop", func, args, kwargs)

    def callback_scroll_anim_stop_del(self, func):
        self._callback_del("scroll,anim,stop", func)

    def callback_drag_start_up_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) up."""
        self._callback_add("drag,start,up", func, args, kwargs)

    def callback_drag_start_up_del(self, func):
        self._callback_del("drag,start,up", func)

    def callback_drag_start_down_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) down."""
        self._callback_add("drag,start,down", func, args, kwargs)

    def callback_drag_start_down_del(self, func):
        self._callback_del("drag,start,down", func)

    def callback_drag_start_left_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) left."""
        self._callback_add("drag,start,left", func, args, kwargs)

    def callback_drag_start_left_del(self, func):
        self._callback_del("drag,start,left", func)

    def callback_drag_start_right_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        been dragged (not scrolled) right."""
        self._callback_add("drag,start,right", func, args, kwargs)

    def callback_drag_start_right_del(self, func):
        self._callback_del("drag,start,right", func)

    def callback_drag_stop_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid has
        stopped being dragged."""
        self._callback_add("drag,stop", func, args, kwargs)

    def callback_drag_stop_del(self, func):
        self._callback_del("drag,stop", func)

    def callback_drag_add(self, func, *args, **kwargs):
        """Called when the item in the gengrid is being
        dragged."""
        self._callback_add("drag", func, args, kwargs)

    def callback_drag_del(self, func):
        self._callback_del("drag", func)

    def callback_scroll_add(self, func, *args, **kwargs):
        """called when the content has been scrolled
        (moved)."""
        self._callback_add("scroll", func, args, kwargs)

    def callback_scroll_del(self, func):
        self._callback_del("scroll", func)

    def callback_scroll_drag_start_add(self, func, *args, **kwargs):
        """called when dragging the content has
        started."""
        self._callback_add("scroll,drag,start", func, args, kwargs)

    def callback_scroll_drag_start_del(self, func):
        self._callback_del("scroll,drag,start", func)

    def callback_scroll_drag_stop_add(self, func, *args, **kwargs):
        """called when dragging the content has
        stopped."""
        self._callback_add("scroll,drag,stop", func, args, kwargs)

    def callback_scroll_drag_stop_del(self, func):
        self._callback_del("scroll,drag,stop", func)

    def callback_edge_top_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled until
        the top edge."""
        self._callback_add("edge,top", func, args, kwargs)

    def callback_edge_top_del(self, func):
        self._callback_del("edge,top", func)

    def callback_edge_bottom_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the bottom edge."""
        self._callback_add("edge,bottom", func, args, kwargs)

    def callback_edge_bottom_del(self, func):
        self._callback_del("edge,bottom", func)

    def callback_edge_left_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the left edge."""
        self._callback_add("edge,left", func, args, kwargs)

    def callback_edge_left_del(self, func):
        self._callback_del("edge,left", func)

    def callback_edge_right_add(self, func, *args, **kwargs):
        """This is called when the gengrid is scrolled
        until the right edge."""
        self._callback_add("edge,right", func, args, kwargs)

    def callback_edge_right_del(self, func):
        self._callback_del("edge,right", func)

    def callback_moved_add(self, func, *args, **kwargs):
        """This is called when a gengrid item is moved by a user
        interaction in a reorder mode. The %c event_info parameter is the item that
        was moved."""
        self._callback_add_full("moved", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_moved_del(self, func):
        self._callback_del_full("moved", _cb_object_item_conv, func)

    def callback_index_update_add(self, func, *args, **kwargs):
        """This is called when a gengrid item index is changed.
        Note that this callback is called while each item is being realized."""
        self._callback_add("index,update", func, args, kwargs)

    def callback_index_update_del(self, func):
        self._callback_del("index,update", func)

    def callback_highlighted_add(self, func, *args, **kwargs):
        """an item in the list is highlighted. This is called when
        the user presses an item or keyboard selection is done so the item is
        physically highlighted. The ``event_info`` parameter is the item that was
        highlighted."""
        self._callback_add_full("highlighted", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_highlighted_del(self, func):
        self._callback_del_full("highlighted", _cb_object_item_conv, func)

    def callback_unhighlighted_add(self, func, *args, **kwargs):
        """an item in the list is unhighlighted. This is called
        when the user releases an item or keyboard selection is moved so the item
        is physically unhighlighted. The ``event_info`` parameter is the item that
        was unhighlighted."""
        self._callback_add_full("unhighlighted", _cb_object_item_conv,
                                func, args, kwargs)

    def callback_unhighlighted_del(self, func):
        self._callback_del_full("unhighlighted", _cb_object_item_conv, func)

    def callback_item_focused_add(self, func, *args, **kwargs):
        """When the gengrid item has received focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,focused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_focused_del(self, func):
        self._callback_del_full("item,focused", _cb_object_item_conv, func)

    def callback_item_unfocused_add(self, func, *args, **kwargs):
        """When the gengrid item has lost focus.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,unfocused", _cb_object_item_conv, func, args, kwargs)

    def callback_item_unfocused_del(self, func):
        self._callback_del_full("item,unfocused", _cb_object_item_conv, func)

    def callback_item_reorder_anim_start_add(self, func, *args, **kwargs):
        """When a gengrid item movement has just started by keys.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,reorder,anim,start", _cb_object_item_conv, func, args, kwargs)

    def callback_item_reorder_anim_start_del(self, func):
        self._callback_del_full("item,reorder,anim,start", _cb_object_item_conv, func)

    def callback_item_reorder_anim_stop_add(self, func, *args, **kwargs):
        """When a gengrid item movement just stopped in reorder mode.

        .. versionadded:: 1.10

        """
        self._callback_add_full("item,reorder,anim,stop", _cb_object_item_conv, func, args, kwargs)

    def callback_item_reorder_anim_stop_del(self, func):
        self._callback_del_full("item,reorder,anim,stop", _cb_object_item_conv, func)

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

_object_mapping_register("Elm_Gengrid", Gengrid)
