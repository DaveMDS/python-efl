cdef void eldbus_object_event_cb(void *data, Eldbus_Object *obj, void *event_info):
    pass

cdef class Object(object):

    cdef Eldbus_Object *obj

    def __init__(self, Connection eldbus_conn not None, bus, path):
        """

        Get an object of the given bus and path.

        :param conn: connection where object belongs
        :param bus: name of bus or unique-id of who listens for calls of this object
        :param path: object path of this object

        """
        if isinstance(bus, unicode): bus = PyUnicode_AsUTF8String(bus)
        if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
        self.obj = eldbus_object_get(edbus_conn.conn, bus, path)

    def ref(self):
        """

        Increase object reference.

        """
        # NOTE: Returns Eldbus_Object *
        eldbus_object_ref(self.obj)
        return self

    def unref(self):
        """

        Decrease object reference.
        If reference == 0 object will be freed and all its children.

        """
        eldbus_object_unref(self.obj)

    def free_cb_add(self, cb, cb_data):
        """

        Add a callback function to be called when object will be freed.

        :param cb: callback that will be executed
        :param data: passed to callback

        """
        eldbus_object_free_cb_add(self.obj, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    def free_cb_del(self, cb, cb_data):
        """

        Remove callback registered in eldbus_object_free_cb_add().

        """
        eldbus_object_free_cb_del(self.obj, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    """
        typedef struct _Eldbus_Object_Event_Interface_Added
        {
           const_char  *interface;
           Eldbus_Proxy *proxy;
        } Eldbus_Object_Event_Interface_Added;

        typedef struct _Eldbus_Object_Event_Interface_Removed
        {
           const_char *interface;
        } Eldbus_Object_Event_Interface_Removed;

        typedef struct _Eldbus_Object_Event_Property_Changed
        {
           const_char       *interface;
           Eldbus_Proxy      *proxy;
           const_char       *name;
           const_Eina_Value *value;
        } Eldbus_Object_Event_Property_Changed;

        typedef struct _Eldbus_Object_Event_Property_Removed
        {
           const_char  *interface;
           Eldbus_Proxy *proxy;
           const_char  *name;
        } Eldbus_Object_Event_Property_Removed;
    """

    def event_callback_add(self, event_type, cb, cb_data):
        """

        Add a callback function to be called when an event of the specified
        type occurs.

        """
        eldbus_object_event_callback_add(self.obj, Eldbus_Object_Event_Type type, Eldbus_Object_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)

    def event_callback_del(self, event_type, cb, cb_data):
        """

        Remove callback registered in eldbus_object_event_callback_add().

        """
        eldbus_object_event_callback_del(self.obj, Eldbus_Object_Event_Type type, Eldbus_Object_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)

    property connection:
        def __get__(self):
            Eldbus_Connection     *eldbus_object_connection_get(self.obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property bus_name:
        def __get__(self):
            const_char           *eldbus_object_bus_name_get(self.obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property path:
        def __get__(self):
            const_char           *eldbus_object_path_get(self.obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    def send(self, msg, cb, cb_data, timeout):
        """

        Send a message.

        :param msg: message that will be sent
        :param cb: if msg is a method call a callback should be passed
            to be executed when a response arrives
        :param cb_data: data passed to callback
        :param timeout: timeout in milliseconds, -1 to default internal value or
            ELDBUS_TIMEOUT_INFINITE for no timeout

        """
        Eldbus_Pending        *eldbus_object_send(self.obj, Eldbus_Message *msg, EDBus_Message_Cb cb, const_void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)

    def signal_handler_add(self, interface, member, cb, cb_data):
        """

        Add a signal handler.

        :param obj: where the signal is emitted
        :param interface: of the signal
        :param member: name of the signal
        :param cb: callback that will be called when this signal is received
        :param cb_data: data that will be passed to callback

        """
        Eldbus_Signal_Handler *eldbus_object_signal_handler_add(self.obj, const_char *interface, const char *member, Eldbus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 4)

    def method_call_new(self, interface, member):
        Eldbus_Message *eldbus_object_method_call_new(self.obj, const_char *interface, const char *member) EINA_ARG_NONNULL(1, 2, 3) EINA_WARN_UNUSED_RESULT
