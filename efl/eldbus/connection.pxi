EDBUS_CONNECTION_TYPE_SESSION = enums.EDBUS_CONNECTION_TYPE_SESSION
EDBUS_CONNECTION_TYPE_SYSTEM = enums.EDBUS_CONNECTION_TYPE_SYSTEM
EDBUS_CONNECTION_TYPE_STARTER = enums.EDBUS_CONNECTION_TYPE_STARTER

EDBUS_CONNECTION_EVENT_DEL = enums.EDBUS_CONNECTION_EVENT_DEL
EDBUS_CONNECTION_EVENT_DISCONNECTED = enums.EDBUS_CONNECTION_EVENT_DISCONNECTED

cdef void edbus_connection_event_cb(void *data, EDBus_Connection *conn, void *event_info):
    pass

cdef void edbus_connection_free_cb(void *data, const void *deadptr):
    pass

cdef class Connection(object):
    """A connection object"""

    cdef EDBus_Connection *conn

    def __init__(self, EDBus_Connection_Type conn_type, private=False):
        if not private:
            """

            Establish a connection to bus and integrate it with the ecore main
            loop. If a connection of given type was already created before, its
            reference counter is incremented and the connection is returned.

            :param type: type of connection e.g EDBUS_CONNECTION_TYPE_SESSION,
            EDBUS_CONNECTION_TYPE_SYSTEM or EDBUS_CONNECTION_TYPE_STARTER

            :return: connection with bus

            """
            self.conn = edbus_connection_get(conn_type)
        else:
            """

            Always create and establish a new connection to bus and integrate it with
            the ecore main loop. Differently from edbus_connection_get(), this function
            guarantees to create a new connection to the D-Bus daemon and the connection
            is not shared by any means.

            :param type: type of connection e.g EDBUS_CONNECTION_TYPE_SESSION,
            EDBUS_CONNECTION_TYPE_SYSTEM or EDBUS_CONNECTION_TYPE_STARTER

            :return: connection with bus

            """
            self.conn = edbus_private_connection_get(conn_type)

    def ref(self):
        """

        Increment connection reference count.


        """
        # NOTE: returns EDBus_Connection *
        edbus_connection_ref(self.conn)
        return self

    def unref(self):
        """

        Decrement connection reference count.

        If reference count reaches 0, the connection to bus will be dropped and all
        its children will be invalidated.

        """
        edbus_connection_unref(self.conn)

    def free_cb_add(self):
        """

        Add a callback function to be called when connection is freed

        :param cb: callback to be called
        :param data: data passed to callback

        """
        edbus_connection_free_cb_add(self.conn, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def free_cb_del(self):
        """

        Remove callback registered in edbus_connection_free_cb_add().

        """
        edbus_connection_free_cb_del(self.conn, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def data_set(self, key, data):
        """

        Set an attached data pointer to an object with a given string key.

        :param key: to identify data
        :param data: data that will be stored

        """
        edbus_connection_data_set(self.conn, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    def data_get(self, key):
        """

        Get data stored in connection.

        :param key: key that identifies data

        :return: pointer to data if found otherwise NULL

        """
        void             *edbus_connection_data_get(self.conn, const char *key) EINA_ARG_NONNULL(1, 2)

    def data_del(self, key):
        """

        Del data stored in connection.

        :param key: that identifies data

        :return: pointer to data if found otherwise NULL

        """
        void             *edbus_connection_data_del(self.conn, const char *key) EINA_ARG_NONNULL(1, 2)

    def event_callback_add(self, event_type, cb, cb_data):
        """

        Add a callback function to be called when an event occurs of the
        type passed.

        """
        edbus_connection_event_callback_add(self.conn, EDBus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    def event_callback_del(self, event_type, cb, cb_data):
        """

        Remove callback registered in edbus_connection_event_callback_add().

        """
        edbus_connection_event_callback_del(self.conn, EDBus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    def send(self, msg, cb, cb_data, timeout):
        """

        Send a message.

        :param msg: message that will be sent
        :param cb: if msg is a method call a callback should be passed
        to be executed when a response arrives
        :param cb_data: data passed to callback
        :param timeout: timeout in milliseconds, -1 to use default internal value or
        EDBUS_TIMEOUT_INFINITE for no timeout

        """
        EDBus_Pending *edbus_connection_send(self.conn, EDBus_Message *msg, EDBus_Message_Cb cb, const void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)
