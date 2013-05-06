from libc.string cimport const_char

from enums cimport Eldbus_Connection_Type, Eldbus_Connection_Event_Type, \
    Eldbus_Object_Event_Type, Eldbus_Proxy_Event_Type

cdef extern from "Eldbus.h":
    #define ELDBUS_FDO_BUS "org.freedesktop.DBus"
    #define ELDBUS_FDO_PATH "/org/freedesktop/DBus"
    #define ELDBUS_FDO_INTERFACE EDBUS_FDO_BUS
    #define ELDBUS_FDO_INTERFACE_PROPERTIES "org.freedesktop.DBus.Properties"
    #define ELDBUS_FDO_INTERFACE_OBJECT_MANAGER "org.freedesktop.DBus.ObjectManager"
    #define ELDBUS_FDO_INTERFACE_INTROSPECTABLE "org.freedesktop.DBus.Introspectable"
    #define ELDBUS_FDO_INTEFACE_PEER "org.freedesktop.DBus.Peer"
    #define ELDBUS_ERROR_PENDING_CANCELED "org.enlightenment.DBus.Canceled"

    int eldbus_init()
    int eldbus_shutdown()

    ctypedef void                       (*Eldbus_Free_Cb)(void *data, const_void *deadptr)

    ctypedef _Eldbus_Connection       Eldbus_Connection
    ctypedef _Eldbus_Object           Eldbus_Object
    ctypedef _Eldbus_Proxy            Eldbus_Proxy
    ctypedef _Eldbus_Message          Eldbus_Message
    ctypedef _Eldbus_Message_Iter     Eldbus_Message_Iter
    ctypedef _Eldbus_Pending          Eldbus_Pending
    ctypedef _Eldbus_Signal_Handler   Eldbus_Signal_Handler

    ctypedef void (*Eldbus_Message_Cb)(void *data, const_Eldbus_Message *msg, EDBus_Pending *pending)
    ctypedef void (*Eldbus_Signal_Cb)(void *data, const_Eldbus_Message *msg)

    # eldbus_connection.h

    #define ELDBUS_TIMEOUT_INFINITE ((int) 0x7fffffff)
    Eldbus_Connection *eldbus_connection_get(Eldbus_Connection_Type type)
    Eldbus_Connection *eldbus_private_connection_get(Eldbus_Connection_Type type)
    Eldbus_Connection *eldbus_connection_ref(Eldbus_Connection *conn) EINA_ARG_NONNULL(1)
    void              eldbus_connection_unref(Eldbus_Connection *conn) EINA_ARG_NONNULL(1)
    void              eldbus_connection_free_cb_add(Eldbus_Connection *conn, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void              eldbus_connection_free_cb_del(Eldbus_Connection *conn, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void              eldbus_connection_data_set(Eldbus_Connection *conn, const_char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void             *eldbus_connection_data_get(const_Eldbus_Connection *conn, const char *key) EINA_ARG_NONNULL(1, 2)
    void             *eldbus_connection_data_del(Eldbus_Connection *conn, const_char *key) EINA_ARG_NONNULL(1, 2)

    ctypedef void (*Eldbus_Connection_Event_Cb)(void *data, Eldbus_Connection *conn, void *event_info)

    void                  eldbus_connection_event_callback_add(Eldbus_Connection *conn, Eldbus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)
    void                  eldbus_connection_event_callback_del(Eldbus_Connection *conn, Eldbus_Connection_Event_Type type, EDBus_Connection_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)
    Eldbus_Pending *eldbus_connection_send(Eldbus_Connection *conn, EDBus_Message *msg, EDBus_Message_Cb cb, const_void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)

    # eldbus_message.h

    Eldbus_Message        *eldbus_message_ref(Eldbus_Message *msg) EINA_ARG_NONNULL(1)

    void                  eldbus_message_unref(Eldbus_Message *msg) EINA_ARG_NONNULL(1)
    const_char           *eldbus_message_path_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_message_interface_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_message_member_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_message_destination_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_message_sender_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_message_signature_get(const Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    Eldbus_Message        *eldbus_message_method_call_new(const_char *dest, const char *path, const char *iface, const char *method) EINA_ARG_NONNULL(1, 2, 3, 4) EINA_WARN_UNUSED_RESULT EINA_MALLOC
    Eldbus_Message        *eldbus_message_error_new(const_Eldbus_Message *msg, const char *error_name, const char *error_msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eldbus_Message        *eldbus_message_method_return_new(const_Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool             eldbus_message_error_get(const_Eldbus_Message *msg, const char **name, const char **text) EINA_ARG_NONNULL(1)
    Eina_Bool             eldbus_message_arguments_get(const_Eldbus_Message *msg, const char *signature, ...) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eina_Bool             eldbus_message_arguments_vget(const_Eldbus_Message *msg, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eina_Bool             eldbus_message_arguments_append(Eldbus_Message *msg, const_char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool             eldbus_message_arguments_vappend(Eldbus_Message *msg, const_char *signature, va_list ap) EINA_ARG_NONNULL(1, 2)
    Eldbus_Message_Iter *eldbus_message_iter_container_new(Eldbus_Message_Iter *iter, int type, const_char* contained_signature) EINA_ARG_NONNULL(1, 3) EINA_WARN_UNUSED_RESULT
    Eina_Bool               eldbus_message_iter_basic_append(Eldbus_Message_Iter *iter, int type, ...) EINA_ARG_NONNULL(1, 3)
    Eina_Bool               eldbus_message_iter_arguments_append(Eldbus_Message_Iter *iter, const_char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool               eldbus_message_iter_arguments_vappend(Eldbus_Message_Iter *iter, const_char *signature, va_list ap) EINA_ARG_NONNULL(1, 2, 3)
    Eina_Bool               eldbus_message_iter_container_close(Eldbus_Message_Iter *iter, Eldbus_Message_Iter *sub) EINA_ARG_NONNULL(1, 2)
    Eldbus_Message_Iter *eldbus_message_iter_get(const_Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    void                    eldbus_message_iter_basic_get(Eldbus_Message_Iter *iter, void *value) EINA_ARG_NONNULL(1, 2)
    char                   *eldbus_message_iter_signature_get(Eldbus_Message_Iter *iter) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool               eldbus_message_iter_next(Eldbus_Message_Iter *iter) EINA_ARG_NONNULL(1)
    Eina_Bool               eldbus_message_iter_get_and_next(Eldbus_Message_Iter *iter, char type, ...) EINA_ARG_NONNULL(1, 2, 3)
    Eina_Bool eldbus_message_iter_fixed_array_get(Eldbus_Message_Iter *iter, int signature, void *value, int *n_elements) EINA_ARG_NONNULL(1, 3, 4)
    Eina_Bool               eldbus_message_iter_arguments_get(Eldbus_Message_Iter *iter, const_char *signature, ...) EINA_ARG_NONNULL(1, 2)
    Eina_Bool               eldbus_message_iter_arguments_vget(Eldbus_Message_Iter *iter, const_char *signature, va_list ap) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_message_iter_del(Eldbus_Message_Iter *iter) EINA_ARG_NONNULL(1)

    # eldbus_message_helper.h

    ctypedef void (*Eldbus_Dict_Cb_Get)(void *data, const_void *key, Eldbus_Message_Iter *var)
    void eldbus_message_iter_dict_iterate(Eldbus_Message_Iter *dict, const_char *signature, Eldbus_Dict_Cb_Get cb, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    # eldbus_message_eina_value.h

    Eina_Value *eldbus_message_to_eina_value(const_Eldbus_Message *msg) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Value *eldbus_message_iter_struct_like_to_eina_value(const_Eldbus_Message_Iter *iter)
    Eina_Bool eldbus_message_from_eina_value(const_char *signature, Eldbus_Message *msg, const Eina_Value *value) EINA_ARG_NONNULL(1, 2, 3)

    # eldbus_signal_handler.h

    Eldbus_Signal_Handler *eldbus_signal_handler_add(Eldbus_Connection *conn, const_char *sender, const char *path, const char *interface, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 6)
    Eldbus_Signal_Handler *eldbus_signal_handler_ref(Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    void                  eldbus_signal_handler_unref(Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    void                  eldbus_signal_handler_del(Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1)
    Eina_Bool             eldbus_signal_handler_match_extra_set(Eldbus_Signal_Handler *sh, ...) EINA_ARG_NONNULL(1) EINA_SENTINEL
    Eina_Bool             eldbus_signal_handler_match_extra_vset(Eldbus_Signal_Handler *sh, va_list ap) EINA_ARG_NONNULL(1)
    void                  eldbus_signal_handler_free_cb_add(Eldbus_Signal_Handler *handler, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_signal_handler_free_cb_del(Eldbus_Signal_Handler *handler, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    const_char           *eldbus_signal_handler_sender_get(const Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_signal_handler_path_get(const Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_signal_handler_interface_get(const Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_signal_handler_member_get(const Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_signal_handler_match_get(const Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    Eldbus_Connection     *eldbus_signal_handler_connection_get(const_Eldbus_Signal_Handler *handler) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    # eldbus_pending.h

    void                  eldbus_pending_data_set(Eldbus_Pending *pending, const_char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void                 *eldbus_pending_data_get(const_Eldbus_Pending *pending, const char *key) EINA_ARG_NONNULL(1, 2)
    void                 *eldbus_pending_data_del(Eldbus_Pending *pending, const_char *key) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_pending_cancel(Eldbus_Pending *pending) EINA_ARG_NONNULL(1)

    const_char           *eldbus_pending_destination_get(const Eldbus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_pending_path_get(const Eldbus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_pending_interface_get(const Eldbus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_pending_method_get(const Eldbus_Pending *pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    void                  eldbus_pending_free_cb_add(Eldbus_Pending *pending, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_pending_free_cb_del(Eldbus_Pending *pending, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    # eldbus_object.h

    Eldbus_Object *eldbus_object_get(Eldbus_Connection *conn, const_char *bus, const char *path) EINA_ARG_NONNULL(1, 2, 3) EINA_WARN_UNUSED_RESULT

    Eldbus_Object *eldbus_object_ref(Eldbus_Object *obj) EINA_ARG_NONNULL(1)
    void          eldbus_object_unref(Eldbus_Object *obj) EINA_ARG_NONNULL(1)
    void          eldbus_object_free_cb_add(Eldbus_Object *obj, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void          eldbus_object_free_cb_del(Eldbus_Object *obj, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    ctypedef struct Eldbus_Object_Event_Interface_Added:
        const_char  *interface;
        Eldbus_Proxy *proxy;

    ctypedef struct Eldbus_Object_Event_Interface_Removed:
        const_char *interface;

    ctypedef struct Eldbus_Object_Event_Property_Changed:
        const_char       *interface
        Eldbus_Proxy      *proxy
        const_char       *name
        const_Eina_Value *value

    ctypedef struct Eldbus_Object_Event_Property_Removed:
        const_char  *interface
        Eldbus_Proxy *proxy
        const_char  *name

    ctypedef void (*Eldbus_Object_Event_Cb)(void *data, Eldbus_Object *obj, void *event_info)

    void                  eldbus_object_event_callback_add(Eldbus_Object *obj, Eldbus_Object_Event_Type type, EDBus_Object_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)
    void                  eldbus_object_event_callback_del(Eldbus_Object *obj, Eldbus_Object_Event_Type type, EDBus_Object_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)

    Eldbus_Connection     *eldbus_object_connection_get(const_Eldbus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_object_bus_name_get(const Eldbus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_object_path_get(const Eldbus_Object *obj) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eldbus_Pending        *eldbus_object_send(Eldbus_Object *obj, EDBus_Message *msg, EDBus_Message_Cb cb, const_void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)
    Eldbus_Signal_Handler *eldbus_object_signal_handler_add(Eldbus_Object *obj, const_char *interface, const char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 4)
    Eldbus_Message *eldbus_object_method_call_new(Eldbus_Object *obj, const_char *interface, const char *member) EINA_ARG_NONNULL(1, 2, 3) EINA_WARN_UNUSED_RESULT

    # eldbus_proxy.h

    Eldbus_Proxy          *eldbus_proxy_get(Eldbus_Object *obj, const_char *interface) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eldbus_Proxy          *eldbus_proxy_ref(Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1)
    void                  eldbus_proxy_unref(Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1)

    Eldbus_Object         *eldbus_proxy_object_get(const_Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char           *eldbus_proxy_interface_get(const Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    void                  eldbus_proxy_data_set(Eldbus_Proxy *proxy, const_char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void                 *eldbus_proxy_data_get(const_Eldbus_Proxy *proxy, const char *key) EINA_ARG_NONNULL(1, 2)
    void                 *eldbus_proxy_data_del(Eldbus_Proxy *proxy, const_char *key) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_proxy_free_cb_add(Eldbus_Proxy *proxy, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    void                  eldbus_proxy_free_cb_del(Eldbus_Proxy *proxy, Eldbus_Free_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Message        *eldbus_proxy_method_call_new(Eldbus_Proxy *proxy, const_char *member) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    Eldbus_Pending        *eldbus_proxy_send(Eldbus_Proxy *proxy, EDBus_Message *msg, EDBus_Message_Cb cb, const_void *cb_data, double timeout) EINA_ARG_NONNULL(1, 2)
    Eldbus_Pending        *eldbus_proxy_call(Eldbus_Proxy *proxy, const_char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, ...) EINA_ARG_NONNULL(1, 2, 6)
    Eldbus_Pending        *eldbus_proxy_vcall(Eldbus_Proxy *proxy, const_char *member, EDBus_Message_Cb cb, const void *cb_data, double timeout, const char *signature, va_list ap) EINA_ARG_NONNULL(1, 2, 6)

    Eldbus_Signal_Handler *eldbus_proxy_signal_handler_add(Eldbus_Proxy *proxy, const_char *member, EDBus_Signal_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 3)

    ctypedef struct Eldbus_Proxy_Event_Property_Changed:
        const_char       *name;
        const_Eldbus_Proxy *proxy;
        const_Eina_Value *value;

    ctypedef struct Eldbus_Proxy_Event_Property_Removed:
        const_char  *interface
        const_Eldbus_Proxy *proxy
        const_char  *name

    ctypedef void (*Eldbus_Proxy_Event_Cb)(void *data, Eldbus_Proxy *proxy, void *event_info)

    void eldbus_proxy_event_callback_add(Eldbus_Proxy *proxy, Eldbus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)
    void eldbus_proxy_event_callback_del(Eldbus_Proxy *proxy, Eldbus_Proxy_Event_Type type, EDBus_Proxy_Event_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1, 3)

    # eldbus_freedesktop.h

    #define ELDBUS_NAME_REQUEST_FLAG_ALLOW_REPLACEMENT 0x1 /**< Allow another service to become the primary owner if requested */
    #define ELDBUS_NAME_REQUEST_FLAG_REPLACE_EXISTING  0x2 /**< Request to replace the current primary owner */
    #define ELDBUS_NAME_REQUEST_FLAG_DO_NOT_QUEUE      0x4 /**< If we can not become the primary owner do not place us in the queue */

    # Replies to request for a name */
    #define ELDBUS_NAME_REQUEST_REPLY_PRIMARY_OWNER    1 /**< Service has become the primary owner of the requested name */
    #define ELDBUS_NAME_REQUEST_REPLY_IN_QUEUE         2 /**< Service could not become the primary owner and has been placed in the queue */
    #define ELDBUS_NAME_REQUEST_REPLY_EXISTS           3 /**< Service is already in the queue */
    #define ELDBUS_NAME_REQUEST_REPLY_ALREADY_OWNER    4 /**< Service is already the primary owner */

    Eldbus_Pending *eldbus_name_request(Eldbus_Connection *conn, const_char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

    # Replies to releasing a name */
    #define ELDBUS_NAME_RELEASE_REPLY_RELEASED     1    /**< Service was released from the given name */
    #define ELDBUS_NAME_RELEASE_REPLY_NON_EXISTENT 2    /**< The given name does not exist on the bus */
    #define ELDBUS_NAME_RELEASE_REPLY_NOT_OWNER    3    /**< Service is not an owner of the given name */

    Eldbus_Pending *eldbus_name_release(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Pending *eldbus_name_owner_get(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Pending *eldbus_name_owner_has(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data)
    Eldbus_Pending *eldbus_names_list(Eldbus_Connection *conn, EDBus_Message_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1)
    Eldbus_Pending *eldbus_names_activatable_list(Eldbus_Connection *conn, EDBus_Message_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1)

    # Replies to service starts */
    #define ELDBUS_NAME_START_REPLY_SUCCESS         1 /**< Service was auto started */
    #define ELDBUS_NAME_START_REPLY_ALREADY_RUNNING 2 /**< Service was already running */

    Eldbus_Pending        *eldbus_name_start(Eldbus_Connection *conn, const_char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

    ctypedef void (*Eldbus_Name_Owner_Changed_Cb)(void *data, const_char *bus, const char *old_id, const char *new_id)

    void                  eldbus_name_owner_changed_callback_add(Eldbus_Connection *conn, const_char *bus, Eldbus_Name_Owner_Changed_Cb cb, const void *cb_data, Eina_Bool allow_initial_call) EINA_ARG_NONNULL(1, 2, 3)
    void                  eldbus_name_owner_changed_callback_del(Eldbus_Connection *conn, const_char *bus, Eldbus_Name_Owner_Changed_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2, 3)
    Eldbus_Pending        *eldbus_object_peer_ping(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Pending        *eldbus_object_peer_machine_id_get(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Pending        *eldbus_object_introspect(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    void eldbus_proxy_properties_monitor(Eldbus_Proxy *proxy, Eina_Bool enable) EINA_ARG_NONNULL(1)

    Eldbus_Pending        *eldbus_proxy_property_get(Eldbus_Proxy *proxy, const_char *name, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    Eldbus_Pending        *eldbus_proxy_property_set(Eldbus_Proxy *proxy, const_char *name, const char *sig, const void *value, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3, 4)
    Eldbus_Pending        *eldbus_proxy_property_get_all(Eldbus_Proxy *proxy, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)
    Eldbus_Signal_Handler *eldbus_proxy_properties_changed_callback_add(Eldbus_Proxy *proxy, EDBus_Signal_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    Eina_Value           *eldbus_proxy_property_local_get(Eldbus_Proxy *proxy, const_char *name) EINA_ARG_NONNULL(1, 2)
    const_Eina_Hash      *eldbus_proxy_property_local_get_all(Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1)
    Eldbus_Pending        *eldbus_object_managed_objects_get(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

    # eldbus_service.h

    #define ELDBUS_METHOD_FLAG_DEPRECATED 1
    #define ELDBUS_METHOD_FLAG_NOREPLY (1 << 1)

    #define ELDBUS_SIGNAL_FLAG_DEPRECATED 1

    #define ELDBUS_PROPERTY_FLAG_DEPRECATED 1

    ctypedef struct Eldbus_Arg_Info:
        const_char *signature
        const_char *name

    #define ELDBUS_ARGS(args...) (const_Eldbus_Arg_Info[]){ args, { NULL, NULL } }

    ctypedef struct _Eldbus_Service_Interface Eldbus_Service_Interface
    ctypedef Eldbus_Message * (*Eldbus_Method_Cb)(const_EDBus_Service_Interface *iface, const EDBus_Message *message)

    ctypedef Eina_Bool (*Eldbus_Property_Get_Cb)(const_Eldbus_Service_Interface *iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *request_msg, EDBus_Message **error)

    ctypedef Eldbus_Message *(*Eldbus_Property_Set_Cb)(const_EDBus_Service_Interface *iface, const char *propname, EDBus_Message_Iter *iter, const EDBus_Message *input_msg)

    ctypedef struct Eldbus_Method:
        const_char *member
        const_Eldbus_Arg_Info *in
        const_Eldbus_Arg_Info *out
        Eldbus_Method_Cb cb
        unsigned int flags

    ctypedef struct Eldbus_Signal:
        const_char *name
        const_Eldbus_Arg_Info *args
        unsigned int flags

    ctypedef struct Eldbus_Property:
        const_char *name
        const_char *type
        Eldbus_Property_Get_Cb get_func
        Eldbus_Property_Set_Cb set_func
        unsigned int flags

    ctypedef struct Eldbus_Service_Interface_Desc:
        const_char *interface #  interface name
        const_Eldbus_Method *methods #  array of the methods that should be registered in this interface, the last item of array should be filled with NULL
        const_Eldbus_Signal *signals #  array of signal that this interface send, the last item of array should be filled with NULL
        const_Eldbus_Property *properties #  array of property that this interface have, the last item of array should be filled with NULL
        const_Eldbus_Property_Get_Cb default_get #  default get function, if a property don't have a get function this will be used
        const_Eldbus_Property_Set_Cb default_set #  default set function, if a property don't have a set function this will be used

    Eldbus_Service_Interface *eldbus_service_interface_register(Eldbus_Connection *conn, const_char *path, const EDBus_Service_Interface_Desc *desc) EINA_ARG_NONNULL(1, 2, 3)
    void eldbus_service_interface_unregister(Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    void eldbus_service_object_unregister(Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    Eldbus_Connection *eldbus_service_connection_get(const_Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    const_char *eldbus_service_object_path_get(const Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    Eina_Bool eldbus_service_signal_emit(const_Eldbus_Service_Interface *iface, unsigned int signal_id, ...) EINA_ARG_NONNULL(1)
    Eldbus_Message *eldbus_service_signal_new(const_Eldbus_Service_Interface *iface, unsigned int signal_id) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT
    Eina_Bool eldbus_service_signal_send(const_Eldbus_Service_Interface *iface, Eldbus_Message *signal_msg) EINA_ARG_NONNULL(1, 2)
    void eldbus_service_object_data_set(Eldbus_Service_Interface *iface, const_char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)
    void *eldbus_service_object_data_get(const_Eldbus_Service_Interface *iface, const char *key) EINA_ARG_NONNULL(1, 2) EINA_WARN_UNUSED_RESULT
    void *eldbus_service_object_data_del(Eldbus_Service_Interface *iface, const_char *key) EINA_ARG_NONNULL(1, 2)

    Eina_Bool eldbus_service_property_changed(const_Eldbus_Service_Interface *iface, const char *name) EINA_ARG_NONNULL(1, 2)

    Eina_Bool eldbus_service_property_invalidate_set(const_Eldbus_Service_Interface *iface, const char *name, Eina_Bool is_invalidate) EINA_ARG_NONNULL(1, 2)
    Eina_Bool eldbus_service_object_manager_attach(Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1)
    Eina_Bool eldbus_service_object_manager_detach(Eldbus_Service_Interface *iface) EINA_ARG_NONNULL(1)
