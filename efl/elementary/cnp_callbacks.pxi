from efl.utils.conversions cimport python_list_objects_to_eina_list

cdef extern from "Elementary.h":
    struct _Elm_Selection_Data:
        Evas_Coord       x, y
        Elm_Sel_Format   format
        void            *data
        size_t           len
        Elm_Xdnd_Action  action

    ctypedef _Elm_Selection_Data Elm_Selection_Data

    ctypedef Eina_Bool       (*Elm_Drop_Cb)                 (void *data, Evas_Object *obj, Elm_Selection_Data *ev)
    ctypedef Elm_Object_Item *(*Elm_Xy_Item_Get_Cb)         (Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *xposret, int *yposret)
    ctypedef void            (*Elm_Selection_Loss_Cb)       (void *data, Elm_Sel_Type selection)
    ctypedef Evas_Object    *(*Elm_Drag_Icon_Create_Cb)     (void *data, Evas_Object *win, Evas_Coord *xoff, Evas_Coord *yoff)
    ctypedef void            (*Elm_Drag_State)              (void *data, Evas_Object *obj)
    ctypedef void            (*Elm_Drag_Done)               (void *data, Evas_Object *obj, Eina_Bool accepted)
    ctypedef void            (*Elm_Drag_Accept)             (void *data, Evas_Object *obj, Eina_Bool doaccept)
    ctypedef void            (*Elm_Drag_Pos)                (void *data, Evas_Object *obj, Evas_Coord x, Evas_Coord y, Elm_Xdnd_Action action)
    ctypedef void            (*Elm_Drag_Start)              (void *data, Evas_Object *obj)
    ctypedef void            (*Elm_Drag_Item_Container_Pos) (void *data, Evas_Object *cont, Elm_Object_Item *it, Evas_Coord x, Evas_Coord y, int xposret, int yposret, Elm_Xdnd_Action action)
    ctypedef Eina_Bool       (*Elm_Drop_Item_Container_Cb)  (void *data, Evas_Object *obj, Elm_Object_Item *it, Elm_Selection_Data *ev, int xposret, int yposret)

    struct _Elm_Drag_User_Info:
        Elm_Sel_Format format
        const char *data
        Eina_List *icons
        Elm_Xdnd_Action action
        Elm_Drag_Icon_Create_Cb createicon
        void *createdata
        Elm_Drag_Pos dragpos
        void *dragdata
        Elm_Drag_Accept acceptcb
        void *acceptdata
        Elm_Drag_Done dragdone
        void *donecbdata

    ctypedef _Elm_Drag_User_Info Elm_Drag_User_Info

    ctypedef Eina_Bool       (*Elm_Item_Container_Data_Get_Cb)(Evas_Object *obj, Elm_Object_Item *it, Elm_Drag_User_Info *info)

    Eina_Bool               elm_cnp_selection_set(Evas_Object *obj, Elm_Sel_Type selection, Elm_Sel_Format format, const void *buf, size_t buflen)
    Eina_Bool               elm_cnp_selection_get(Evas_Object *obj, Elm_Sel_Type selection, Elm_Sel_Format format, Elm_Drop_Cb datacb, void *udata)
    Eina_Bool               elm_object_cnp_selection_clear(Evas_Object *obj, Elm_Sel_Type selection)
    void                    elm_cnp_selection_loss_callback_set(Evas_Object *obj, Elm_Sel_Type selection, Elm_Selection_Loss_Cb func, const void *data)
    Eina_Bool               elm_drop_target_add(Evas_Object *obj, Elm_Sel_Format format, Elm_Drag_State entercb, void *enterdata, Elm_Drag_State leavecb, void *leavedata, Elm_Drag_Pos poscb, void *posdata, Elm_Drop_Cb dropcb, void *dropdata)
    Eina_Bool               elm_drop_target_del(Evas_Object *obj, Elm_Sel_Format format, Elm_Drag_State entercb, void *enterdata, Elm_Drag_State leavecb, void *leavedata, Elm_Drag_Pos poscb, void *posdata, Elm_Drop_Cb dropcb, void *dropdata)
    Eina_Bool               elm_drag_start(Evas_Object *obj, Elm_Sel_Format format, const char *data, Elm_Xdnd_Action action, Elm_Drag_Icon_Create_Cb createicon, void *createdata, Elm_Drag_Pos dragpos, void *dragdata, Elm_Drag_Accept acceptcb, void *acceptdata, Elm_Drag_State dragdone, void *donecbdata)
    Eina_Bool               elm_drag_cancel(Evas_Object *obj)
    Eina_Bool               elm_drag_action_set(Evas_Object *obj, Elm_Xdnd_Action action)
    Eina_Bool               elm_drag_item_container_add(Evas_Object *obj, double tm_to_anim, double tm_to_drag, Elm_Xy_Item_Get_Cb itemgetcb, Elm_Item_Container_Data_Get_Cb data_get)
    Eina_Bool               elm_drag_item_container_del(Evas_Object *obj)
    Eina_Bool               elm_drop_item_container_add(Evas_Object *obj, Elm_Sel_Format format, Elm_Xy_Item_Get_Cb itemgetcb, Elm_Drag_State entercb, void *enterdata, Elm_Drag_State leavecb, void *leavedata, Elm_Drag_Item_Container_Pos poscb, void *posdata, Elm_Drop_Item_Container_Cb dropcb, void *dropdata)
    Eina_Bool               elm_drop_item_container_del(Evas_Object *obj)


cdef class SelectionData(object):

    """Structure holding the info about selected data."""

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
        """:type: :ref:`Elm_Object_Sel_Format`"""
        def __get__(self):
            return self.sel_data.format

    property data:
        def __get__(self):
            # TODO: check if this can have anything other than text data
            return _ctouni(<const char *>self.sel_data.data)

    property len:
        """:type: size_t"""
        def __get__(self):
            return self.sel_data.len

    property action:
        """The action to perform with the data

        :type: :ref:`Elm_Object_Xdnd_Action`

        .. versionadded:: 1.8

        """
        def __get__(self):
            return self.sel_data.action


cdef Eina_Bool py_elm_drop_cb(void *data, Evas_Object *obj, Elm_Selection_Data *ev) with gil:
    """Callback invoked when the selected data is 'dropped' at its destination.

    :param data: Application specific data
    :param obj: The evas object where selected data is 'dropped'.
    :param ev: struct holding information about selected data

    """
    assert data != NULL, "data is NULL"
    cdef:
        SelectionData sd = SelectionData.__new__(SelectionData)
        bint ret
        evasObject o = object_from_instance(obj)
    sd.sel_data = ev

    cb_func, cb_data = <object>data

    try:
        ret = cb_func(o, sd, cb_data)
    except Exception:
        traceback.print_exc()
        return 0

    sd.sel_data = NULL
    return ret

cdef Elm_Object_Item *py_elm_xy_item_get_cb(Evas_Object *obj, Evas_Coord x, Evas_Coord y, int *xposret, int *yposret) with gil:
    """Callback invoked to find out what object is under (x,y) coords

    :param obj: The container object
    :param x: cord to check
    :param y: cord to check
    :param xposret: Position relative to item (left (-1), middle (0), right (1)
    :param yposret: Position relative to item (upper (-1), middle (0), bottom (1)
    :return: object under x,y cords or NULL if not found.

    """
    assert obj != NULL, "obj is NULL"

    cdef:
        evasObject o = object_from_instance(obj)
        object xpos1, ypos1
        ObjectItem it

    try:
        ret = o.internal_data["xy_item_get_cb"](o, x, y)
        it, xpos1, ypos1 = ret
    except Exception:
        traceback.print_exc()
        return NULL

    if xpos1 is not None:
        xposret[0] = <int>xpos1
    if ypos1 is not None:
        yposret[0] = <int>ypos1

    if it:
        return it.item
    else:
        return NULL

cdef void py_elm_selection_loss_cb(void *data, Elm_Sel_Type selection) with gil:
    """Callback invoked when the selection ownership for a given selection is lost.

    :param data: Application specific data
    :param selection: The selection that is lost

    """
    o = <object>data
    cb_func = o.cnp_selection_loss_cb
    cb_data = o.cnp_selection_loss_data

    cb_func(selection, cb_data)

cdef Evas_Object *py_elm_drag_icon_create_cb(
    void *data, Evas_Object *win, Evas_Coord *xoff, Evas_Coord *yoff) with gil:
    """Callback called to create a drag icon object

    :param data: Application specific data
    :param win: The window to create the objects relative to
    :param xoff: A return coordinate for the X offset at which to place
        the drag icon object relative to the source drag object
    :param yoff: A return coordinate for the Y offset at which to place
        the drag icon object relative to the source drag object
    :return: An object to fill the drag window with or NULL if not needed

    """
    assert data != NULL, "data is NULL"

    cdef:
        evasObject win1 = object_from_instance(win)
        evasObject icon
        object xoff1 = None, yoff1 = None

    createicon, createdata = <object>data

    if xoff != NULL:
        xoff1 = xoff[0]
    if yoff != NULL:
        yoff1 = yoff[0]

    try:
        ret = createicon(win1, xoff1, yoff1, createdata)
    except Exception:
        traceback.print_exc()
        return NULL

    if ret is None:
        return NULL

    icon, xoff1, yoff1 = ret

    if xoff1 is not None:
        xoff[0] = <Evas_Coord>xoff1
    if yoff1 is not None:
        yoff[0] = <Evas_Coord>yoff1

    return icon.obj

cdef void py_elm_drag_state_cb(void *data, Evas_Object *obj) with gil:
    """Callback called when a drag is finished, enters, or leaves an object

    :param data: Application specific data
    :param obj: The object where the drag started

    """
    assert data != NULL, "data is NULL"

    cdef:
        evasObject o = object_from_instance(obj)

    statecb, statedata = <object>data

    try:
        statecb(o, statedata)
    except Exception:
        traceback.print_exc()

cdef void py_elm_drag_done_cb(void *data, Evas_Object *obj, Eina_Bool accepted) with gil:
    """Callback called when a drag is finished.

    :param data: Application specific data
    :param obj: The object where the drag started
    :param accepted: TRUE if the dropped-data is accepted on drop

    """
    assert data != NULL, "data is NULL"

    cdef:
        evasObject o = object_from_instance(obj)

    donecb, donedata = <object>data

    try:
        donecb(o, <bint>accepted, donedata)
    except Exception:
        traceback.print_exc()

cdef void py_elm_drag_accept_cb(void *data, Evas_Object *obj, Eina_Bool doaccept) with gil:
    """Callback called when a drag is responded to with an accept or deny

    :param data: Application specific data
    :param obj: The object where the drag started
    :param doaccept: A boolean as to if the target accepts the drag or not

    """
    assert data != NULL, "data is NULL"

    cdef:
        evasObject o = object_from_instance(obj)

    acceptcb, acceptdata = <object>data

    try:
        acceptcb(o, <bint>doaccept, acceptdata)
    except Exception:
        traceback.print_exc()

cdef void py_elm_drag_pos_cb(void *data, Evas_Object *obj,
    Evas_Coord x, Evas_Coord y, Elm_Xdnd_Action action) with gil:
    """Callback called when a drag is over an object, and gives object-relative coordinates

    :param data: Application specific data
    :param obj: The object where the drag started
    :param x: The X coordinate relative to the top-left of the object
    :param y: The Y coordinate relative to the top-left of the object

    """
    assert data != NULL, "data is NULL"

    cdef:
        evasObject o = object_from_instance(obj)

    dragpos, dragdata = <object>data

    try:
        dragpos(o, x, y, action, dragdata)
    except Exception:
        traceback.print_exc()

cdef void py_elm_drag_item_container_pos(
    void *data, Evas_Object *cont, Elm_Object_Item *it,
    Evas_Coord x, Evas_Coord y, int xposret, int yposret,
    Elm_Xdnd_Action action) with gil:
    """

    Callback called when a drag is over an object

    :param data: Application specific data
    :param cont: The container object where the drag started
    :param it: The object item in container where mouse-over
    :param x: The X coordinate relative to the top-left of the object
    :param y: The Y coordinate relative to the top-left of the object
    :param xposret: Position relative to item (left (-1), middle (0), right (1)
    :param yposret: Position relative to item (upper (-1), middle (0), bottom (1)
    :param action: The drag action to be done

    """
    cdef:
        evasObject o = object_from_instance(cont)
        ObjectItem item = _object_item_to_python(it)

    try:
        o.internal_data["drag_item_container_pos"](o, item, x, y, xposret, yposret, action, <object>data if data is not NULL else None)
    except Exception:
        traceback.print_exc()

cdef Eina_Bool py_elm_drop_item_container_cb(
    void *data, Evas_Object *obj, Elm_Object_Item *it,
    Elm_Selection_Data *ev, int xposret, int yposret) with gil:
    """

    Callback invoked in when the selected data is 'dropped' on container.

    :param data: Application specific data
    :param obj: The evas object where selected data is 'dropped'.
    :param it: The item in container where drop-cords
    :param ev: struct holding information about selected data
    :param xposret: Position relative to item (left (-1), middle (0), right (1)
    :param yposret: Position relative to item (upper (-1), middle (0), bottom (1)

    """
    assert obj != NULL, "obj is NULL"

    cdef:
        evasObject o = object_from_instance(obj)
        ObjectItem item
        SelectionData evdata = SelectionData.__new__(SelectionData)
        object cbdata = None

    item = _object_item_to_python(it)

    evdata.sel_data = ev

    cb = o.internal_data["drop_item_container_cb"]

    if data != NULL:
        cbdata = <object>data

    try:
        ret = cb(o, item, evdata, xposret, yposret, cbdata)
    except Exception:
        traceback.print_exc()
        return 0

    return ret


cdef class DragUserInfo(object):
    """

    Structure describing user information for the drag process.

    :param format: The drag formats supported by the data (output)
    :param data: The drag data itself (a string) (output)
    :param icons: if value not NULL, play default anim (output)
    :param action: The drag action to be done (output)
    :param createicon: Function to call to create a drag object, or NULL if not wanted (output)
    :param createdata: Application data passed to @p createicon (output)
    :param dragpos: Function called with each position of the drag,
        x, y being screen coordinates if possible, and action being the current action. (output)
    :param dragdata: Application data passed to @p dragpos (output)
    :param acceptcb: Function called indicating if drop target accepts
        (or does not) the drop data while dragging (output)
    :param acceptdata: Application data passed to @p acceptcb (output)
    :param dragdone: Function to call when drag is done (output)
    :param donecbdata: Application data to pass to @p dragdone (output)

    """
    # Elm_Sel_Format format;
    # const char *data;
    # Eina_List *icons;
    # Elm_Xdnd_Action action;
    # Elm_Drag_Icon_Create_Cb createicon;
    # void *createdata;
    # Elm_Drag_Pos dragpos;
    # void *dragdata;
    # Elm_Drag_Accept acceptcb;
    # void *acceptdata;
    # Elm_Drag_Done dragdone;
    # void *donecbdata;
    cdef:
        public Elm_Sel_Format format
        public Elm_Xdnd_Action action
        public list icons
        public object createicon, createdata, dragpos, dragdata
        public object acceptcb, acceptdata, dragdone, donecbdata
        const char *_data

    property data:
        def __get__(self):
            return _ctouni(self._data)

        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self._data = value


cdef Eina_Bool py_elm_item_container_data_get_cb(
    Evas_Object *obj, Elm_Object_Item *it, Elm_Drag_User_Info *info) with gil:
    """

    Callback invoked when starting to drag for a container.

    :param obj: The container object
    :param it: The Elm_Object_Item pointer where drag-start
    :return: Returns EINA_TRUE, if successful, or EINA_FALSE if not.

    """
    cdef:
        DragUserInfo pyinfo = DragUserInfo.__new__(DragUserInfo)
        evasObject o = object_from_instance(obj)
        ObjectItem item = _object_item_to_python(it)
        bint ret

    try:
        func = o.internal_data["item_container_data_get_cb"]
        ret = func(o, item, pyinfo)
    except Exception:
        traceback.print_exc()
        return 0

    if ret:
        info.format = pyinfo.format
        info.data = strdup(pyinfo._data)
        info.icons = python_list_objects_to_eina_list(pyinfo.icons)
        if pyinfo.createicon is not None:
            info.createicon = py_elm_drag_icon_create_cb
            createdata = (pyinfo.createicon, pyinfo.createdata)
            Py_INCREF(createdata)
            info.createdata = <void *>createdata
        if pyinfo.dragpos is not None:
            info.dragpos = py_elm_drag_pos_cb
            dragdata = (pyinfo.dragpos, pyinfo.dragdata)
            Py_INCREF(dragdata)
            info.dragdata = <void *>dragdata
        if pyinfo.acceptcb is not None:
            info.acceptcb = py_elm_drag_accept_cb
            acceptdata = (pyinfo.acceptcb, pyinfo.acceptdata)
            Py_INCREF(acceptdata)
            info.acceptdata = <void *>acceptdata
        if pyinfo.dragdone is not None:
            info.dragdone =py_elm_drag_done_cb
            donecbdata = (pyinfo.dragdone, pyinfo.donecbdata)
            Py_INCREF(donecbdata)
            info.donecbdata = <void *>donecbdata
        return 1
    else:
        return 0
