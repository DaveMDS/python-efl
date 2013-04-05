from libc.string cimport const_char

from enums cimport EDBus_Connection_Type, EDBus_Connection_Event_Type, \
    EDBus_Object_Event_Type, EDBus_Proxy_Event_Type

cdef extern from "EDBus.h":
    #define EDBUS_FDO_BUS "org.freedesktop.DBus"
    #define EDBUS_FDO_PATH "/org/freedesktop/DBus"
    #define EDBUS_FDO_INTERFACE EDBUS_FDO_BUS
    #define EDBUS_FDO_INTERFACE_PROPERTIES "org.freedesktop.DBus.Properties"
    #define EDBUS_FDO_INTERFACE_OBJECT_MANAGER "org.freedesktop.DBus.ObjectManager"
    #define EDBUS_FDO_INTERFACE_INTROSPECTABLE "org.freedesktop.DBus.Introspectable"
    #define EDBUS_FDO_INTEFACE_PEER "org.freedesktop.DBus.Peer"
    #define EDBUS_ERROR_PENDING_CANCELED "org.enlightenment.DBus.Canceled"

    ctypedef struct _EDBus_Connection       EDBus_Connection
    ctypedef struct _EDBus_Object           EDBus_Object
    ctypedef struct _EDBus_Proxy            EDBus_Proxy
    ctypedef struct _EDBus_Message          EDBus_Message
    ctypedef struct _EDBus_Message_Iter     EDBus_Message_Iter
    ctypedef struct _EDBus_Pending          EDBus_Pending
    ctypedef struct _EDBus_Signal_Handler   EDBus_Signal_Handler

    ctypedef void (*EDBus_Message_Cb)(void *data, const EDBus_Message *msg, EDBus_Pending *pending)
    ctypedef void (*EDBus_Signal_Cb)(void *data, const EDBus_Message *msg)

    int edbus_init()
    int edbus_shutdown()

    # edbus_connection.h

    #define EDBUS_TIMEOUT_INFINITE ((int) 0x7fffffff)
    EDBus_Connection *edbus_connection_get(EDBus_Connection_Type type)
    EDBus_Connection *edbus_private_connection_get(EDBus_Connection_Type type)
    EDBus_Connection *edbus_connection_ref(EDBus_Connection *conn) EINA_ARG_NONNULL(1)
    void              edbus_connection_unref(EDBus_Connection *conn) EINA_ARG_NONNULL(1)
    void              edbus_connection_free_cb_add(EDBus_Connection *conn, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void              edbus_connection_free_cb_del(EDBus_Connection *conn, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void              edbus_connection_data_set(EDBus_Connection *conn, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void             *edbus_connection_data_get(const EDBus_Connection *conn, const char *key) EINA_ARG_NONNULL(1, 2)
    void             *edbus_connection_data_del(EDBus_Connection *conn, const char *key) EINA_ARG_NONNULL(1, 2)

    ctypedef void (*EDBus_Connection_Event_Cb)(void *data, EDBus_Connection *conn, void *event_info)

    void                  edbus_connection_event_callback_add(EDBus_Connection *conn, EDBus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)
    void                  edbus_connection_event_callback_del(EDBus_Connection *conn, EDBus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)
    EDBus_Pending *edbus_connection_send(EDBus_Connection *conn, EDBus_Message *msg, EDBus_Message_Cb cb, const void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)

    # edbus_message.h

    EDBus_Message        *edbus_message_ref(EDBus_Message *msg) EINA_ARG_NONNULL(1)

    void                  edbus_message_unref(EDBus_Message *msg) EINA_ARG_NONNULL(1)
    const char           *edbus_message_path_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_message_interface_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_message_member_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_message_destination_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_message_sender_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_message_signature_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    EDBus_Message        *edbus_message_method_call_new(const char *dest, const char *path, const char *iface, const char *method) EINA_ARG_NONNULL(1, 2, 3, 4) EINA_WARN_UNUSED_RESULT EINA_MALLOC
    EDBus_Message        *edbus_message_error_new(const EDBus_Message *msg, const char *error_name, const char *error_msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    EDBus_Message        *edbus_message_method_return_new(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool             edbus_message_error_get(const EDBus_Message *msg, const char **name, const char **text) EINA_ARG_NONNULL(1)
    Eina_Bool             edbus_message_arguments_get(const EDBus_Message *msg, const char *signature, ...) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eina_Bool             edbus_message_arguments_vget(const EDBus_Message *msg, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eina_Bool             edbus_message_arguments_append(EDBus_Message *msg, const char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool             edbus_message_arguments_vappend(EDBus_Message *msg, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2)
    EDBus_Message_Iter *edbus_message_iter_container_new(EDBus_Message_Iter *iter, int type, const char* contained_signature) EINA_ARG_NONNULL(1, 3) EINA_WARN_UNUSED_RESULT
    Eina_Bool               edbus_message_iter_basic_append(EDBus_Message_Iter *iter, int type, ...) EINA_ARG_NONNULL(1, 3)
    Eina_Bool               edbus_message_iter_arguments_append(EDBus_Message_Iter *iter, const char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool               edbus_message_iter_arguments_vappend(EDBus_Message_Iter *iter, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2, 3)
    Eina_Bool               edbus_message_iter_container_close(EDBus_Message_Iter *iter, EDBus_Message_Iter *sub) EINA_ARG_NONNULL(1, 2)
    EDBus_Message_Iter *edbus_message_iter_get(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    void                    edbus_message_iter_basic_get(EDBus_Message_Iter *iter, void *value) EINA_ARG_NONNULL(1, 2)
    char                   *edbus_message_iter_signature_get(EDBus_Message_Iter *iter) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool               edbus_message_iter_next(EDBus_Message_Iter *iter) EINA_ARG_NONNULL(1)
    Eina_Bool               edbus_message_iter_get_and_next(EDBus_Message_Iter *iter, char type, ...) EINA_ARG_NONNULL(1, 2, 3)
    Eina_Bool edbus_message_iter_fixed_array_get(EDBus_Message_Iter *iter, int signature, void *value, int *n_elements) EINA_ARG_NONNULL(1, 3, 4)
    Eina_Bool               edbus_message_iter_arguments_get(EDBus_Message_Iter *iter, const char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool               edbus_message_iter_arguments_vget(EDBus_Message_Iter *iter, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2)
    void                  edbus_message_iter_del(EDBus_Message_Iter *iter) EINA_ARG_NONNULL(1)

    # edbus_message_helper.h

    ctypedef void (*EDBus_Dict_Cb_Get)(void *data, const void *key, EDBus_Message_Iter *var)
    void edbus_message_iter_dict_iterate(EDBus_Message_Iter *dict, const char *signature, EDBus_Dict_Cb_Get cb, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    # edbus_message_eina_value.h

    Eina_Value *edbus_message_to_eina_value(const EDBus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Value *edbus_message_iter_struct_like_to_eina_value(const EDBus_Message_Iter *iter)
    Eina_Bool edbus_message_from_eina_value(const char *signature, EDBus_Message *msg, const Eina_Value *value) EINA_ARG_NONNULL(1, 2, 3)

    # edbus_signal_handler.h

    EDBus_Signal_Handler *edbus_signal_handler_add(EDBus_Connection *conn, const char *sender, const char *path, const char *interface, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 6)
    EDBus_Signal_Handler *edbus_signal_handler_ref(EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    void                  edbus_signal_handler_unref(EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    void                  edbus_signal_handler_del(EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    Eina_Bool             edbus_signal_handler_match_extra_set(EDBus_Signal_Handler *sh, ...) EINA_ARG_NONNULL(1) EINA_SENTINEL
    Eina_Bool             edbus_signal_handler_match_extra_vset(EDBus_Signal_Handler *sh, va_list ap) EINA_ARG_NONNULL(1)
    void                  edbus_signal_handler_free_cb_add(EDBus_Signal_Handler *handler, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void                  edbus_signal_handler_free_cb_del(EDBus_Signal_Handler *handler, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    const char           *edbus_signal_handler_sender_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_signal_handler_path_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_signal_handler_interface_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_signal_handler_member_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_signal_handler_match_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    EDBus_Connection     *edbus_signal_handler_connection_get(const EDBus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    # edbus_pending.h

    void                  edbus_pending_data_set(EDBus_Pending *pending, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void                 *edbus_pending_data_get(const EDBus_Pending *pending, const char *key) EINA_ARG_NONNULL(1, 2)
    void                 *edbus_pending_data_del(EDBus_Pending *pending, const char *key) EINA_ARG_NONNULL(1, 2)
    void                  edbus_pending_cancel(EDBus_Pending *pending) EINA_ARG_NONNULL(1)

    const char           *edbus_pending_destination_get(const EDBus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_pending_path_get(const EDBus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_pending_interface_get(const EDBus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_pending_method_get(const EDBus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    void                  edbus_pending_free_cb_add(EDBus_Pending *pending, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void                  edbus_pending_free_cb_del(EDBus_Pending *pending, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    # edbus_object.h

    EDBus_Object *edbus_object_get(EDBus_Connection *conn, const char *bus, const char *path) EINA_ARG_NONNULL(1, 2, 3) EINA_WARN_UNUSED_RESULT

    EDBus_Object *edbus_object_ref(EDBus_Object *obj) EINA_ARG_NONNULL(1)
    void          edbus_object_unref(EDBus_Object *obj) EINA_ARG_NONNULL(1)
    void          edbus_object_free_cb_add(EDBus_Object *obj, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void          edbus_object_free_cb_del(EDBus_Object *obj, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    ctypedef struct EDBus_Object_Event_Interface_Added:
        const char  *interface;
        EDBus_Proxy *proxy;

    ctypedef struct EDBus_Object_Event_Interface_Removed:
        const char *interface;

    ctypedef struct EDBus_Object_Event_Property_Changed:
        const char       *interface
        EDBus_Proxy      *proxy
        const char       *name
        const Eina_Value *value

    ctypedef struct EDBus_Object_Event_Property_Removed:
        const char  *interface
        EDBus_Proxy *proxy
        const char  *name

    ctypedef void (*EDBus_Object_Event_Cb)(void *data, EDBus_Object *obj, void *event_info)

    void                  edbus_object_event_callback_add(EDBus_Object *obj, EDBus_Object_Event_Type type, EDBus_Object_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)
    void                  edbus_object_event_callback_del(EDBus_Object *obj, EDBus_Object_Event_Type type, EDBus_Object_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    EDBus_Connection     *edbus_object_connection_get(const EDBus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_object_bus_name_get(const EDBus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_object_path_get(const EDBus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    EDBus_Pending        *edbus_object_send(EDBus_Object *obj, EDBus_Message *msg, EDBus_Message_Cb cb, const void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)
    EDBus_Signal_Handler *edbus_object_signal_handler_add(EDBus_Object *obj, const char *interface, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 4)
    EDBus_Message *edbus_object_method_call_new(EDBus_Object *obj, const char *interface, const char *member) EINA_ARG_NONNULL(1, 2, 3) EINA_WARN_UNUSED_RESULT

    # edbus_proxy.h

    EDBus_Proxy          *edbus_proxy_get(EDBus_Object *obj, const char *interface) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    EDBus_Proxy          *edbus_proxy_ref(EDBus_Proxy *proxy) EINA_ARG_NONNULL(1)
    void                  edbus_proxy_unref(EDBus_Proxy *proxy) EINA_ARG_NONNULL(1)

    EDBus_Object         *edbus_proxy_object_get(const EDBus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char           *edbus_proxy_interface_get(const EDBus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    void                  edbus_proxy_data_set(EDBus_Proxy *proxy, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void                 *edbus_proxy_data_get(const EDBus_Proxy *proxy, const char *key) EINA_ARG_NONNULL(1, 2)
    void                 *edbus_proxy_data_del(EDBus_Proxy *proxy, const char *key) EINA_ARG_NONNULL(1, 2)
    void                  edbus_proxy_free_cb_add(EDBus_Proxy *proxy, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    void                  edbus_proxy_free_cb_del(EDBus_Proxy *proxy, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    EDBus_Message        *edbus_proxy_method_call_new(EDBus_Proxy *proxy, const char *member) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    EDBus_Pending        *edbus_proxy_send(EDBus_Proxy *proxy, EDBus_Message *msg, EDBus_Message_Cb cb, const void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)
    EDBus_Pending        *edbus_proxy_call(EDBus_Proxy *proxy, const char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, ...) EINA_ARG_NONNULL(1, 2, 6)
    EDBus_Pending        *edbus_proxy_vcall(EDBus_Proxy *proxy, const char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2, 6)

    EDBus_Signal_Handler *edbus_proxy_signal_handler_add(EDBus_Proxy *proxy, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    ctypedef struct EDBus_Proxy_Event_Property_Changed:
        const char       *name;
        const EDBus_Proxy *proxy;
        const Eina_Value *value;

    ctypedef struct EDBus_Proxy_Event_Property_Removed:
        const char  *interface
        const EDBus_Proxy *proxy
        const char  *name

    ctypedef void (*EDBus_Proxy_Event_Cb)(void *data, EDBus_Proxy *proxy, void *event_info)

    void edbus_proxy_event_callback_add(EDBus_Proxy *proxy, EDBus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)
    void edbus_proxy_event_callback_del(EDBus_Proxy *proxy, EDBus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    # edbus_freedesktop.h

    #define EDBUS_NAME_REQUEST_FLAG_ALLOW_REPLACEMENT 0x1 /**< Allow another service to become the primary owner if requested */
    #define EDBUS_NAME_REQUEST_FLAG_REPLACE_EXISTING  0x2 /**< Request to replace the current primary owner */
    #define EDBUS_NAME_REQUEST_FLAG_DO_NOT_QUEUE      0x4 /**< If we can not become the primary owner do not place us in the queue */

    # Replies to request for a name */
    #define EDBUS_NAME_REQUEST_REPLY_PRIMARY_OWNER    1 /**< Service has become the primary owner of the requested name */
    #define EDBUS_NAME_REQUEST_REPLY_IN_QUEUE         2 /**< Service could not become the primary owner and has been placed in the queue */
    #define EDBUS_NAME_REQUEST_REPLY_EXISTS           3 /**< Service is already in the queue */
    #define EDBUS_NAME_REQUEST_REPLY_ALREADY_OWNER    4 /**< Service is already the primary owner */

    EDBus_Pending *edbus_name_request(EDBus_Connection *conn, const char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

    # Replies to releasing a name */
    #define EDBUS_NAME_RELEASE_REPLY_RELEASED     1    /**< Service was released from the given name */
    #define EDBUS_NAME_RELEASE_REPLY_NON_EXISTENT 2    /**< The given name does not exist on the bus */
    #define EDBUS_NAME_RELEASE_REPLY_NOT_OWNER    3    /**< Service is not an owner of the given name */

    EDBus_Pending *edbus_name_release(EDBus_Connection *conn, const char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)
    EDBus_Pending *edbus_name_owner_get(EDBus_Connection *conn, const char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)
    EDBus_Pending *edbus_name_owner_has(EDBus_Connection *conn, const char *bus, EDBus_Message_Cb cb, const void *cb_data)
    EDBus_Pending *edbus_names_list(EDBus_Connection *conn, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1)
    EDBus_Pending *edbus_names_activatable_list(EDBus_Connection *conn, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1)

    # Replies to service starts */
    #define EDBUS_NAME_START_REPLY_SUCCESS         1 /**< Service was auto started */
    #define EDBUS_NAME_START_REPLY_ALREADY_RUNNING 2 /**< Service was already running */

    EDBus_Pending        *edbus_name_start(EDBus_Connection *conn, const char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

    ctypedef void (*EDBus_Name_Owner_Changed_Cb)(void *data, const char *bus, const char *old_id, const char *new_id)

    void                  edbus_name_owner_changed_callback_add(EDBus_Connection *conn, const char *bus, EDBus_Name_Owner_Changed_Cb cb, const void *cb_data, Eina_Bool allow_initial_call) EINA_ARG_NONNULL(1, 2, 3)
    void                  edbus_name_owner_changed_callback_del(EDBus_Connection *conn, const char *bus, EDBus_Name_Owner_Changed_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2, 3)
    EDBus_Pending        *edbus_object_peer_ping(EDBus_Object *obj, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    EDBus_Pending        *edbus_object_peer_machine_id_get(EDBus_Object *obj, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    EDBus_Pending        *edbus_object_introspect(EDBus_Object *obj, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    void edbus_proxy_properties_monitor(EDBus_Proxy *proxy, Eina_Bool enable) EINA_ARG_NONNULL(1)

    EDBus_Pending        *edbus_proxy_property_get(EDBus_Proxy *proxy, const char *name, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    EDBus_Pending        *edbus_proxy_property_set(EDBus_Proxy *proxy, const char *name, const char *sig, const void *value, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3, 4)
    EDBus_Pending        *edbus_proxy_property_get_all(EDBus_Proxy *proxy, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
    EDBus_Signal_Handler *edbus_proxy_properties_changed_callback_add(EDBus_Proxy *proxy, EDBus_Signal_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    Eina_Value           *edbus_proxy_property_local_get(EDBus_Proxy *proxy, const char *name) EINA_ARG_NONNULL(1, 2)
    const Eina_Hash      *edbus_proxy_property_local_get_all(EDBus_Proxy *proxy) EINA_ARG_NONNULL(1)
    EDBus_Pending        *edbus_object_managed_objects_get(EDBus_Object *obj, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    # edbus_service.h

    #define EDBUS_METHOD_FLAG_DEPRECATED 1
    #define EDBUS_METHOD_FLAG_NOREPLY (1 << 1)

    #define EDBUS_SIGNAL_FLAG_DEPRECATED 1

    #define EDBUS_PROPERTY_FLAG_DEPRECATED 1

    ctypedef struct EDBus_Arg_Info:
        const char *signature
        const char *name

    #define EDBUS_ARGS(args...) (const EDBus_Arg_Info[]){ args, { NULL, NULL } }

    ctypedef struct _EDBus_Service_Interface EDBus_Service_Interface
    ctypedef EDBus_Message * (*EDBus_Method_Cb)(const EDBus_Service_Interface *iface, const EDBus_Message *message)

    ctypedef Eina_Bool (*EDBus_Property_Get_Cb)(const EDBus_Service_Interface *iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *request_msg, EDBus_Message **error)

    ctypedef EDBus_Message *(*EDBus_Property_Set_Cb)(const EDBus_Service_Interface *iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *input_msg)

    ctypedef struct EDBus_Method:
        const char *member
        const EDBus_Arg_Info *in
        const EDBus_Arg_Info *out
        EDBus_Method_Cb cb
        unsigned int flags

    ctypedef struct EDBus_Signal:
        const char *name
        const EDBus_Arg_Info *args
        unsigned int flags

    ctypedef struct EDBus_Property:
        const char *name
        const char *type
        EDBus_Property_Get_Cb get_func
        EDBus_Property_Set_Cb set_func
        unsigned int flags

    ctypedef struct EDBus_Service_Interface_Desc:
        const char *interface #  interface name
        const EDBus_Method *methods #  array of the methods that should be registered in this interface, the last item of array should be filled with NULL
        const EDBus_Signal *signals #  array of signal that this interface send, the last item of array should be filled with NULL
        const EDBus_Property *properties #  array of property that this interface have, the last item of array should be filled with NULL
        const EDBus_Property_Get_Cb default_get #  default get function, if a property don't have a get function this will be used
        const EDBus_Property_Set_Cb default_set #  default set function, if a property don't have a set function this will be used

    EDBus_Service_Interface *edbus_service_interface_register(EDBus_Connection *conn, const char *path, const EDBus_Service_Interface_Desc *desc) EINA_ARG_NONNULL(1, 2, 3)
    void edbus_service_interface_unregister(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    void edbus_service_object_unregister(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    EDBus_Connection *edbus_service_connection_get(const EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const char *edbus_service_object_path_get(const EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    Eina_Bool edbus_service_signal_emit(const EDBus_Service_Interface *iface, unsigned int signal_id, ...) EINA_ARG_NONNULL(1)
    EDBus_Message *edbus_service_signal_new(const EDBus_Service_Interface *iface, unsigned int signal_id) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool edbus_service_signal_send(const EDBus_Service_Interface *iface, EDBus_Message *signal_msg) EINA_ARG_NONNULL(1, 2)
    void edbus_service_object_data_set(EDBus_Service_Interface *iface, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void *edbus_service_object_data_get(const EDBus_Service_Interface *iface, const char *key) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    void *edbus_service_object_data_del(EDBus_Service_Interface *iface, const char *key) EINA_ARG_NONNULL(1, 2)

    Eina_Bool edbus_service_property_changed(const EDBus_Service_Interface *iface, const char *name) EINA_ARG_NONNULL(1, 2)

    Eina_Bool edbus_service_property_invalidate_set(const EDBus_Service_Interface *iface, const char *name, Eina_Bool is_invalidate) EINA_ARG_NONNULL(1, 2)
    Eina_Bool edbus_service_object_manager_attach(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    Eina_Bool edbus_service_object_manager_detach(EDBus_Service_Interface *iface) EINA_ARG_NONNULL(1)
