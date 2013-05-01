#define EDBUS_METHOD_FLAG_DEPRECATED 1
#define EDBUS_METHOD_FLAG_NOREPLY (1 << 1)

#define EDBUS_SIGNAL_FLAG_DEPRECATED 1

#define EDBUS_PROPERTY_FLAG_DEPRECATED 1

typedef struct _EDBus_Arg_Info
{
   const char *signature;
   const char *name;
} EDBus_Arg_Info;


"""

@brief Used to insert complete types to signature of methods or signals.

Example: EDBUS_ARGS({"s", "interface"}, {"s", "property"})
The signature will be "ss" and each string will have a tag name on
introspect XML with the respective name.

"""
#define EDBUS_ARGS(args...) (const EDBus_Arg_Info[]){ args, { NULL, NULL } }

typedef struct _EDBus_Service_Interface EDBus_Service_Interface;
typedef EDBus_Message * (*EDBus_Method_Cb)(self.iface, const EDBus_Message *message);


cdef Eina_Bool edbus_property_get_cb(self.iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *request_msg, EDBus_Message **error):
    """

    Callback function to append property value to message.

    @param iface interface of property
    @param propname name of property
    @param iter variant iterator in which value must be appended
    @param request_msg message that request property
    @param error if a error happen you must set a message error to be send caller

    @return EINA_TRUE if success

    @note request_msg and error arguments are only different from NULL when a
    client request a property with Properties.Get or Properties.GetAll. Upon
    calls to edbus_service_property_changed(), this callback will also be called.
    It's a mistake to return an error in this case because if a property changed,
    it must have a new value set and it should be able to be read.

    """
    pass


cdef EDBus_Message *edbus_property_set_cb(self.iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *input_msg):
    """

    Callback function to set property value from message.

    @param iface interface of property
    @param propname name of property
    @param input_msg message call where you have to get value

    @return Message of response, could be a simple method_return, error or NULL to send response later.

    """
    pass

"""
typedef struct _EDBus_Method
{
   const char *member;
   const EDBus_Arg_Info *in;
   const EDBus_Arg_Info *out;
   EDBus_Method_Cb cb;
   unsigned int flags;
} EDBus_Method;

typedef struct _EDBus_Signal
{
   const char *name;
   const EDBus_Arg_Info *args;
   unsigned int flags;
} EDBus_Signal;

typedef struct _EDBus_Property
{
   const char *name;
   const char *type;
   EDBus_Property_Get_Cb get_func;
   EDBus_Property_Set_Cb set_func;
   unsigned int flags;
} EDBus_Property;

typedef struct _EDBus_Service_Interface_Desc
{
   const char *interface; /**< interface name */
   const EDBus_Method *methods; /**< array of the methods that should be registered in this interface, the last item of array should be filled with NULL */
   const EDBus_Signal *signals; /**< array of signal that this interface send, the last item of array should be filled with NULL */
   const EDBus_Property *properties; /**< array of property that this interface have, the last item of array should be filled with NULL  */
   const EDBus_Property_Get_Cb default_get; /**< default get function, if a property don't have a get function this will be used */
   const EDBus_Property_Set_Cb default_set; /**< default set function, if a property don't have a set function this will be used */
} EDBus_Service_Interface_Desc;
"""

cdef class ServiceInterface(object):

    cdef EDBus_Service_Interface *iface

    def __init__(self, conn, path, desc):
        """

        @brief Register an interface in the given path and connection.

        @param conn where the interface should listen
        @param path object path
        @param desc description of interface

        @return Interface

        """
        self.iface = edbus_service_interface_register(EDBus_Connection *conn, const char *path, const EDBus_Service_Interface_Desc *desc) EINA_ARG_NONNULL(1, 2, 3)

    def unregister(self):
        """

        @brief Unregister a interface.
        If this is the last interface of the object path, the object path will be
        removed too.

        """
        void edbus_service_interface_unregister(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)

    def object_unregister(self):
        """

        @brief Unregister all interfaces of the object path that this interface belongs
        and the object path.

        """
        void edbus_service_object_unregister(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)

    property connection:
        def __get__(self):
            EDBus_Connection *edbus_service_connection_get(self.iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property path:
        def __get__(self):
            const char *edbus_service_object_path_get(self.iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    def signal_emit(self, signal_id, *args):
        """

        @brief Emit a signal handler of the interface with non-complex types.
        Each signal handler have a internal id, the first signal handler of
        interface is = 0 the second = 1 and go on.

        @param iface interface of the signal
        @param signal_id id of signal
        @param ... values that will be send on signal

        """
        Eina_Bool edbus_service_signal_emit(self.iface, unsigned int signal_id, ...) EINA_ARG_NONNULL(1)

    def signal_new(self, signal_id):
        """

        @brief Create signal message.
        Each signal handler have a internal id, the first signal handler of
        interface is = 0 the second = 1 and go on.
        This function is used when the signal has complex types.

        @param iface interface of the signal
        @param signal_id id of signal

        """
        EDBus_Message *edbus_service_signal_new(self.iface, unsigned int signal_id) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    def signal_send(self, signal_msg):
        """

        @brief Send a signal message.

        On success this will call edbus_message_unref() on the @param signal_msg,
        which is the intended behavior in 99% of the cases. Remember to increment
        the refcount if you want to keep it alive.

        """
        Eina_Bool edbus_service_signal_send(self.iface, EDBus_Message *signal_msg) EINA_ARG_NONNULL(1, 2)

    def object_data_set(self, key, data):
        """

        @brief Store data at object path, this data can be obtained from all interfaces
        of the same object.

        @param iface interface that belong to the object path where data will
        be stored
        @param key to identify data
        @param data

        """
        void edbus_service_object_data_set(EDBus_Service_Interface *iface, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    def object_data_get(self, key):
        """

        @brief Get data stored in object path.

        @param iface interface that belongs to the object path where data are stored
        @param key that identify data

        @return pointer to data if found otherwise NULL

        """
        void *edbus_service_object_data_get(self.iface, const char *key) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT

    def object_data_del(self, key):
        """

        @brief Del data stored in object path.

        @param iface interface that belongs to the object path where data are stored
        @param key that identify data

        @return pointer to data if found otherwise NULL

        """
        void *edbus_service_object_data_del(EDBus_Service_Interface *iface, const char *key) EINA_ARG_NONNULL(1, 2)

    def property_changed(self, name):
        """

        @brief Add property to list of changed properties
        A DBus.PropertiesChanged signal will be sent in an idler with all properties
        that have changed.

        @param iface Interface containing the changed property
        @param name Property name

        """
        Eina_Bool edbus_service_property_changed(self.iface, const char *name) EINA_ARG_NONNULL(1, 2)


    def property_invalidate_set(self, name, is_invalidate):
        Eina_Bool edbus_service_property_invalidate_set(self.iface, const char *name, Eina_Bool is_invalidate) EINA_ARG_NONNULL(1, 2)

    def object_manager_attach(self):
        """

        Attach ObjectManager interface.

        @param iface ObjectManager will be attach in object path of this interface.
        @return EINA_TRUE if success

        """
        Eina_Bool edbus_service_object_manager_attach(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)

    def object_manager_detach(self):
        """

        Detach ObjectManager interface.

        @param iface ObjectManager of object path of this interface will be detach.
        @return EINA_TRUE if success

        """
        Eina_Bool edbus_service_object_manager_detach(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)
