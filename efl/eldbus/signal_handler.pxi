cdef class SignalHandler(object):

    cdef EDBus_Signal_Handler *handler

    def __init__(self, Connection edbus_conn not None, sender, path, interface, member, cb, cb_data):
        """

        Add a signal handler.

        :param conn: connection where the signal is emitted
        :param sender: bus name or unique id of where the signal is emitted
        :param path: path of remote object
        :param interface: that signal belongs
        :param member: name of the signal
        :param cb: callback that will be called when this signal is received
        :param cb_data: data that will be passed to callback

        """
        self.handler = edbus_signal_handler_add(edbus_conn.conn, const char *sender, const char *path, const char *interface, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 6)

    def ref(self):
        """

        Increase signal handler reference.

        """
        # NOTE: Returns EDBus_Signal_Handler *
        edbus_signal_handler_ref(self.handler)
        return self

    def unref(self):
        """

        Decrease signal handler reference.
        If reference == 0 signal handler will be freed.

        """
        edbus_signal_handler_unref(self.handler)

    def delete(self):
        """

        Decrease signal handler reference like edbus_signal_handler_unref()
        but if reference > 0 this signal handler will stop listening to signals. In other
        words it will be canceled but memory will not be freed.

        """
        edbus_signal_handler_del(self.handler)

    def match_extra_set(self, *args):
        """

        Add extra argument in match of signal handler to obtain specifics signals.

        Example:
        edbus_signal_handler_match_extra_set(sh, "arg0", "org.bansheeproject.Banshee", "arg1", "", NULL);
        With this extra arguments this signal handler callback only will be called
        when Banshee is started.

        @note For now only argX is supported.

        :param sh: signal handler
        :param ...: variadic of key and value and must be ended with a NULL

        @note For more information:
        http://dbus.freedesktop.org/doc/dbus-specification.html#message-bus-routing-match-rules

        """
        Eina_Bool             edbus_signal_handler_match_extra_set(self.handler, ...) EINA_ARG_NONNULL(1) EINA_SENTINEL

    def match_extra_vset(self, ap):
        """

        Add extra argument in match of signal handler to obtain specifics signals.

        Example:
        edbus_signal_handler_match_extra_set(sh, "arg0", "org.bansheeproject.Banshee", "arg1", "", NULL);
        With this extra arguments this signal handler callback only will be called
        when Banshee is started.

        @note For now is only supported argX.

        :param sh: signal handler
        :param ap: va_list with the keys and values, must be ended with a NULL

        @note To information:
        http://dbus.freedesktop.org/doc/dbus-specification.html#message-bus-routing-match-rules

        """
        Eina_Bool             edbus_signal_handler_match_extra_vset(self.handler, va_list ap) EINA_ARG_NONNULL(1)

    def free_cb_add(self, cb, cb_data):
        """

        Add a callback function to be called when signal handler will be freed.

        """
        void                  edbus_signal_handler_free_cb_add(self.handler, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def free_cb_del(self, cb, cb_data):
        """

        Remove callback registered in edbus_signal_handler_free_cb_add().

        """
        void                  edbus_signal_handler_free_cb_del(self.handler, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    property sender:
        def __get__(self):
            const char           *edbus_signal_handler_sender_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property path:
        def __get__(self):
            const char           *edbus_signal_handler_path_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property interface:
        def __get__(self):
            const char           *edbus_signal_handler_interface_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property member:
        def __get__(self):
            const char           *edbus_signal_handler_member_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property match:
        def __get__(self):
            const char           *edbus_signal_handler_match_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property connection:
        def __get__(self):
            EDBus_Connection     *edbus_signal_handler_connection_get(self.handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
