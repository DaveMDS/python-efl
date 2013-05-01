EDBUS_PROXY_EVENT_PROPERTY_CHANGED
EDBUS_PROXY_EVENT_PROPERTY_REMOVED
EDBUS_PROXY_EVENT_DEL


cdef class Proxy(object):

    cdef EDBus_Proxy *proxy

    def __init__(self, Object edbus_object not None, interface):
        """

        Get a proxy of the following interface name in a EDBus_Object.

        """
        self.proxy = edbus_proxy_get(edbus_object.obj, const char *interface) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT

    def ref(self):
        """

        Increase proxy reference.

        """
        # NOTE: Returns EDBus_Proxy *
        edbus_proxy_ref(self.proxy)
        return self

    def unref(self):
        """

        Decrease proxy reference.
        If reference == 0 proxy will be freed and all your children.

        """
        void                  edbus_proxy_unref(self.proxy) EINA_ARG_NONNULL(1)

    property object:
        def __get__(self):
            EDBus_Object         *edbus_proxy_object_get(const EDBus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property interface:
            const char           *edbus_proxy_interface_get(const EDBus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    def data_set(self, key, data):
        void                  edbus_proxy_data_set(self.proxy, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    def data_get(self, key):
        void                 *edbus_proxy_data_get(const EDBus_Proxy *proxy, const char *key) EINA_ARG_NONNULL(1, 2)

    def data_del(self, key):
        void                 *edbus_proxy_data_del(self.proxy, const char *key) EINA_ARG_NONNULL(1, 2)

    def free_cb_add(self, cb, cb_data):
        """

        Add a callback function to be called when occurs a event of the
        type passed.

        """
        edbus_proxy_free_cb_add(self.proxy, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def free_cb_del(self, cb, cb_data):
        """

        Remove callback registered in edbus_proxy_free_cb_add().

        """
        edbus_proxy_free_cb_del(self.proxy, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def method_call_new(self, member):
        """

        Constructs a new message to invoke a method on a remote interface.

        """
        EDBus_Message        *edbus_proxy_method_call_new(self.proxy, const char *member) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT

    def send(self, msg, cb, cb_data, timeout):
        """

        Send a message.

        :param msg: message that will be send
        :param cb: if msg is a method call a callback should be passed
        :param cb_data: data passed to callback
        :param timeout: timeout in milliseconds, -1 to default internal value or
        EDBUS_TIMEOUT_INFINITE for no timeout

        """
        EDBus_Pending        *edbus_proxy_send(self.proxy, EDBus_Message *msg, EDBus_Message_Cb cb, const void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)

    def call(self, member, cb, cb_data, timeout, signature, *args):
        """

        Call a method in proxy.
        Send a method call to interface that proxy belong with data.

        :param member: method name
        :param cb: if msg is a method call a callback should be passed
        to be execute when response arrive
        :param cb_data: data passed to callback
        :param timeout: timeout in milliseconds, -1 to default internal value or
        EDBUS_TIMEOUT_INFINITE for no timeout
        :param signature: of data that will be send
        @param ... data value

        @note This function only support basic type to complex types use
        edbus_message_iter_* functions.

        """
        EDBus_Pending        *edbus_proxy_call(self.proxy, const char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, ...) EINA_ARG_NONNULL(1, 2, 6)

    def vcall(self, member, cb, cb_data, timeout, signature, ap):
        """

        Call a method in proxy.
        Send a method call to interface that proxy belong with data.

        :param member: method name
        :param cb: callback that will be called when response arrive.
        :param cb_data: data passed to callback
        :param timeout: timeout in milliseconds, -1 to default internal value or
        EDBUS_TIMEOUT_INFINITE for no timeout
        :param signature: of data that will be send
        :param ap: va_list of data value

        @note This function only support basic type to complex types use
        edbus_message_iter_* functions.

        """
        EDBus_Pending        *edbus_proxy_vcall(self.proxy, const char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2, 6)

    def signal_handler_add(self, member, cb, cb_data):
        """

        Add a signal handler.

        :param proxy: interface where the signal is emitted
        :param member: name of the signal
        :param cb: callback that will be called when this signal is received
        :param cb_data: data that will be passed to callback

        """
        EDBus_Signal_Handler *edbus_proxy_signal_handler_add(self.proxy, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

        """
        typedef struct _EDBus_Proxy_Event_Property_Changed
        {
           const char       *name;
           const EDBus_Proxy *proxy;
           const Eina_Value *value;
        } EDBus_Proxy_Event_Property_Changed;

        typedef struct _EDBus_Proxy_Event_Property_Removed
        {
           const char  *interface;
           const EDBus_Proxy *proxy;
           const char  *name;
        } EDBus_Proxy_Event_Property_Removed;

        typedef void (*EDBus_Proxy_Event_Cb)(void *data, EDBus_Proxy *proxy, void *event_info);
        """

    def event_callback_add(self, event_type, cb, cb_data):
        """

        Add a callback function to be called when occurs a event of the
        type passed.

        """
        void edbus_proxy_event_callback_add(self.proxy, EDBus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    def event_callback_add(self, event_type, cb, cb_data):
        """

        Remove callback registered in edbus_proxy_event_callback_add().

        """
        void edbus_proxy_event_callback_del(self.proxy, EDBus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)


