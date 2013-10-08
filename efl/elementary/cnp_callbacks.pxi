from efl.elementary.enums cimport Elm_Sel_Type, Elm_Sel_Format, \
    Elm_Xdnd_Action

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

    ctypedef Eina_Bool      (*Elm_Item_Container_Data_Get_Cb)(
        Evas_Object *obj,
        Elm_Object_Item *it,
        Elm_Drag_User_Info *info)

    Eina_Bool elm_drag_item_container_add(Evas_Object *obj, double tm_to_anim, double tm_to_drag, Elm_Xy_Item_Get_Cb itemgetcb, Elm_Item_Container_Data_Get_Cb data_get)
    Eina_Bool elm_drag_item_container_del(Evas_Object *obj)
    Eina_Bool elm_drop_item_container_add(Evas_Object *obj,
      Elm_Sel_Format format,
      Elm_Xy_Item_Get_Cb itemgetcb,
      Elm_Drag_State entercb, void *enterdata,
      Elm_Drag_State leavecb, void *leavedata,
      Elm_Drag_Item_Container_Pos poscb, void *posdata,
      Elm_Drop_Item_Container_Cb dropcb, void *cbdata)
    Eina_Bool elm_drop_item_container_del(Evas_Object *obj)

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
        """:type: :ref:`Elm_Selection_Format`"""
        def __get__(self):
            return self.sel_data.format

    property data:
        def __get__(self):
            # TODO: void *
            return None

    property len:
        """:type: size_t"""
        def __get__(self):
            return self.sel_data.len

    property action:
        """The action to perform with the data

        :type: :ref:`Elm_Xdnd_Action`
        :since: 1.8

        """
        def __get__(self):
            return self.sel_data.action

cdef Eina_Bool py_elm_drop_cb(void *data, Evas_Object *obj, Elm_Selection_Data *ev) with gil:
    """Callback invoked when the selected data is 'dropped' at its destination.

    :param data: Application specific data
    :param obj: The evas object where selected data is 'dropped'.
    :param ev: struct holding information about selected data

    """
    cdef:
        SelectionData sd = SelectionData.__new__(SelectionData)
        bint ret
    sd.sel_data = ev

    o = <object>data
    cb_func = o.cnp_drop_cb
    cb_data = o.cnp_drop_data

    ret = cb_func(o, sd, cb_data)

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
        int xpos2, ypos2
        ObjectItem it

    try:
        ret = o.data["xy_item_get_cb"](o, x, y)
        it, xpos1, ypos1 = ret
    except:
        traceback.print_exc()
        return NULL

    if xpos1 is not None:
        xpos2 = xpos1
        xposret = &xpos2
    if ypos1 is not None:
        ypos2 = ypos1
        yposret = &ypos2

    return it.item

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
    :since: 1.8

    """
    print("in drag_icon_create_cb")

cdef void py_elm_drag_state_cb(void *data, Evas_Object *obj) with gil:
    """Callback called when a drag is finished, enters, or leaves an object

    :param data: Application specific data
    :param obj: The object where the drag started
    :since: 1.8

    """
    print("in drag_state_cb")

cdef void py_elm_drag_accept_cb(void *data, Evas_Object *obj, Eina_Bool doaccept) with gil:
    """Callback called when a drag is responded to with an accept or deny

    :param data: Application specific data
    :param obj: The object where the drag started
    :param doaccept: A boolean as to if the target accepts the drag or not
    :since: 1.8

    """
    print("in drag_accept_cb")

cdef void py_elm_drag_pos_cb(void *data, Evas_Object *obj,
    Evas_Coord x, Evas_Coord y, Elm_Xdnd_Action action) with gil:
    """Callback called when a drag is over an object, and gives object-relative coordinates

    :param data: Application specific data
    :param obj: The object where the drag started
    :param x: The X coordinate relative to the top-left of the object
    :param y: The Y coordinate relative to the top-left of the object
    :since: 1.8

    """
    print("in drag_pos_cb")


cdef void py_elm_drag_item_container_pos(
    void *data, Evas_Object *cont, Elm_Object_Item *it,
    Evas_Coord x, Evas_Coord y, int xposret, int yposret,
    Elm_Xdnd_Action action) with gil:
    """

    Callback called when a drag is over an object

    :param data: Application specific data
    @param cont The container object where the drag started
    @param it The object item in container where mouse-over
    @param x The X coordinate relative to the top-left of the object
    @param y The Y coordinate relative to the top-left of the object
    @param xposret Position relative to item (left (-1), middle (0), right (1)
    @param yposret Position relative to item (upper (-1), middle (0), bottom (1)
    @param action The drag action to be done
    @since 1.8

    """
    print("in drag_item_container_pos")

cdef Eina_Bool py_elm_drop_item_container_cb(
    void *data, Evas_Object *obj, Elm_Object_Item *it,
    Elm_Selection_Data *ev, int xposret, int yposret) with gil:
    """

    Callback invoked in when the selected data is 'dropped' on container.

    @param data Application specific data
    @param obj The evas object where selected data is 'dropped'.
    @param it The item in container where drop-cords
    @param ev struct holding information about selected data
    @param xposret Position relative to item (left (-1), middle (0), right (1)
    @param yposret Position relative to item (upper (-1), middle (0), bottom (1)

    """
    print("in drop_item_container_cb")


cdef class DragUserInfo(object):
    """

    Structure describing user information for the drag process.

    @param format The drag formats supported by the data (output)
    @param data The drag data itself (a string) (output)
    @param icons if value not NULL, play default anim (output)
    @param action The drag action to be done (output)
    @param createicon Function to call to create a drag object, or NULL if not wanted (output)
    @param createdata Application data passed to @p createicon (output)
    @param dragpos Function called with each position of the drag,
        x, y being screen coordinates if possible, and action being the current action. (output)
    @param dragdata Application data passed to @p dragpos (output)
    @param acceptcb Function called indicating if drop target accepts
        (or does not) the drop data while dragging (output)
    @param acceptdata Application data passed to @p acceptcb (output)
    @param dragdone Function to call when drag is done (output)
    @param donecbdata Application data to pass to @p dragdone (output)

    """

    cdef Elm_Drag_User_Info *info

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


cdef Eina_Bool py_elm_item_container_data_get_cb(
    Evas_Object *obj, Elm_Object_Item *it, Elm_Drag_User_Info *info) with gil:
    """

    Callback invoked when starting to drag for a container.

    @param obj The container object
    @param it The Elm_Object_Item pointer where drag-start
    @return Returns EINA_TRUE, if successful, or EINA_FALSE if not.

    """
    print("in item_container_data_get_cb")
