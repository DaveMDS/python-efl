"""Structure holding the info about selected data.

"""
cdef class SelectionData(object):
    cdef Elm_Selection_Data *sel_data

    property x:
        """:type: int"""
        def __get__(self):
            return self.sel_data.x

    property y:
        """:type: int"""
        def __get__(self):
            return self.sel_data.y

    property format:
        """:type: Elm_Selection_Format"""
        def __get__(self):
            return self.sel_data.format

    property data:
        def __get__(self):
            # TODO
            return None

    property len:
        """:type: size_t"""
        def __get__(self):
            return self.sel_data.len

    property action:
        """The action to perform with the data

        :type: Elm_Xdnd_Action
        :since: 1.8

        """
        def __get__(self):
            return self.sel_data.action

cdef Eina_Bool elm_drop_cb(void *data, Evas_Object *obj, Elm_Selection_Data *ev):
    """Callback invoked in when the selected data is 'dropped' at its destination.

    :param data: Application specific data
    :param obj: The evas object where selected data is 'dropped'.
    :param ev: struct holding information about selected data

    """
    pass

cdef void elm_selection_loss_cb(void *data, Elm_Sel_Type selection):
    """Callback invoked in when the selection ownership for a given selection is lost.

    :param data: Application specific data
    :param selection: The selection that is lost

    """
    pass

cdef Evas_Object *elm_drag_icon_create_cb(void *data, Evas_Object *win, Evas_Coord *xoff, Evas_Coord *yoff):
    """Callback called to create a drag icon object

    :param data: Application specific data
    :param win: The window to create the objects relative to
    :param xoff: A return coordinate for the X offset at which to place the drag icon object relative to the source drag object
    :param yoff: A return coordinate for the Y offset at which to place the drag icon object relative to the source drag object
    :return: An object to fill the drag window with or NULL if not needed
    :since: 1.8

    """
    pass

cdef void elm_drag_state(void *data, Evas_Object *obj):
    """Callback called when a drag is finished, enters, or leaves an object

    :param data: Application specific data
    :param obj: The object where the drag started
    :since: 1.8

    """
    pass

cdef void elm_drag_accept(void *data, Evas_Object *obj, Eina_Bool doaccept):
    """Callback called when a drag is responded to with an accept or deny

    :param data: Application specific data
    :param obj: The object where the drag started
    :param doaccept: A boolean as to if the target accepts the drag or not
    :since: 1.8

    """
    pass

cdef void elm_drag_pos(void *data, Evas_Object *obj, Evas_Coord x, Evas_Coord y, Elm_Xdnd_Action action):
    """Callback called when a drag is over an object, and gives object-relative coordinates

    :param data: Application specific data
    :param obj: The object where the drag started
    :param x: The X coordinate relative to the top-left of the object
    :param y: The Y coordinate relative to the top-left of the object
    :since: 1.8

    """
    pass
