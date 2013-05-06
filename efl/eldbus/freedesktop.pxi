#define ELDBUS_NAME_REQUEST_FLAG_ALLOW_REPLACEMENT 0x1 /**< Allow another service to become the primary owner if requested */
#define ELDBUS_NAME_REQUEST_FLAG_REPLACE_EXISTING  0x2 /**< Request to replace the current primary owner */
#define ELDBUS_NAME_REQUEST_FLAG_DO_NOT_QUEUE      0x4 /**< If we can not become the primary owner do not place us in the queue */

# Replies to request for a name
#define ELDBUS_NAME_REQUEST_REPLY_PRIMARY_OWNER    1 /**< Service has become the primary owner of the requested name */
#define ELDBUS_NAME_REQUEST_REPLY_IN_QUEUE         2 /**< Service could not become the primary owner and has been placed in the queue */
#define ELDBUS_NAME_REQUEST_REPLY_EXISTS           3 /**< Service is already in the queue */
#define ELDBUS_NAME_REQUEST_REPLY_ALREADY_OWNER    4 /**< Service is already the primary owner */

def name_request(conn, bus, flags, cb, cb_data):
    Eldbus_Pending *eldbus_name_request(Eldbus_Connection *conn, const_char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

# Replies to releasing a name
#define ELDBUS_NAME_RELEASE_REPLY_RELEASED     1    /**< Service was released from the given name */
#define ELDBUS_NAME_RELEASE_REPLY_NON_EXISTENT 2    /**< The given name does not exist on the bus */
#define ELDBUS_NAME_RELEASE_REPLY_NOT_OWNER    3    /**< Service is not an owner of the given name */

def name_release(conn, bus, cb, cb_data):
    Eldbus_Pending *eldbus_name_release(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

def name_owner_get(conn, bus, cb, cb_data):
    Eldbus_Pending *eldbus_name_owner_get(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)

def name_owner_has(conn, bus, cb, cb_data):
    Eldbus_Pending *eldbus_name_owner_has(Eldbus_Connection *conn, const_char *bus, EDBus_Message_Cb cb, const void *cb_data)

def names_list(conn, cb, cb_data):
    Eldbus_Pending *eldbus_names_list(Eldbus_Connection *conn, EDBus_Message_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1)

def names_activatable_list(conn, cb, cb_data):
    Eldbus_Pending *eldbus_names_activatable_list(Eldbus_Connection *conn, EDBus_Message_Cb cb, const_void *cb_data) EINA_ARG_NONNULL(1)

# Replies to service starts
#define ELDBUS_NAME_START_REPLY_SUCCESS         1 /**< Service was auto started */
#define ELDBUS_NAME_START_REPLY_ALREADY_RUNNING 2 /**< Service was already running */

def name_start(conn, bus, flags, cb, cb_data):
    Eldbus_Pending        *eldbus_name_start(Eldbus_Connection *conn, const_char *bus, unsigned int flags, EDBus_Message_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2)


typedef void (*Eldbus_Name_Owner_Changed_Cb)(void *data, const_char *bus, const char *old_id, const char *new_id);


def name_owner_changed_callback_add(conn, bus, cb, cb_data, allow_initial_call):
    """

    Add a callback to be called when unique id of a bus name changed.

    This function implicitly calls eldbus_name_owner_get() in order to be able to
    monitor the name. If the only interest is to receive notifications when the
    name in fact changes, pass EINA_FALSE to @param allow_initial_call so your
    callback will not be called on first retrieval of name owner. If the
    initial state is important, pass EINA_TRUE to this parameter.

    @param conn connection
    @param bus name of bus
    @param cb callback
    @param cb_data context data
    @param allow_initial_call allow call callback with actual id of the bus

    """
    void                  eldbus_name_owner_changed_callback_add(Eldbus_Connection *conn, const_char *bus, Eldbus_Name_Owner_Changed_Cb cb, const void *cb_data, Eina_Bool allow_initial_call) EINA_ARG_NONNULL(1, 2, 3)

def name_owner_changed_callback_del(conn, bus, cb, cb_data):
    """

    Remove callback added with eldbus_name_owner_changed_callback_add().

    @param conn connection
    @param bus name of bus
    @param cb callback
    @param cb_data context data

    """
    void                  eldbus_name_owner_changed_callback_del(Eldbus_Connection *conn, const_char *bus, Eldbus_Name_Owner_Changed_Cb cb, const void *cb_data) EINA_ARG_NONNULL(1, 2, 3)

def object_peer_ping(obj, cb, data):
    Eldbus_Pending        *eldbus_object_peer_ping(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

def object_peer_machine_id_get(obj, cb, data):
    Eldbus_Pending        *eldbus_object_peer_machine_id_get(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

def object_introspect(obj, cb, data):
    Eldbus_Pending        *eldbus_object_introspect(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

def proxy_properties_monitor(proxy, enable):
    """

    Enable or disable local cache of properties.

    After enable you can call eldbus_proxy_property_local_get() or
    eldbus_proxy_property_local_get_all() to get cached properties.

    @note After enable, it will asynchrony get the properties values.

    """
    void eldbus_proxy_properties_monitor(Eldbus_Proxy *proxy, Eina_Bool enable) EINA_ARG_NONNULL(1)

def proxy_property_get(proxy, name, cb, data):
    Eldbus_Pending        *eldbus_proxy_property_get(Eldbus_Proxy *proxy, const_char *name, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3)

def proxy_property_set(proxy, name, sig, value, cb, data):
    Eldbus_Pending        *eldbus_proxy_property_set(Eldbus_Proxy *proxy, const_char *name, const char *sig, const void *value, EDBus_Message_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2, 3, 4)

def proxy_property_get_add(proxy, cb, data):
    Eldbus_Pending        *eldbus_proxy_property_get_all(Eldbus_Proxy *proxy, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

def proxy_properties_changed_callback_add(proxy, cb, data):
    Eldbus_Signal_Handler *eldbus_proxy_properties_changed_callback_add(Eldbus_Proxy *proxy, EDBus_Signal_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

def proxy_property_local_get(proxy, name):
    """

    Return the cached value of property.
    This only work if you have enable eldbus_proxy_properties_monitor or
    if you have call eldbus_proxy_event_callback_add of type
    ELDBUS_PROXY_EVENT_PROPERTY_CHANGED and the property you want had changed.

    """
    Eina_Value           *eldbus_proxy_property_local_get(Eldbus_Proxy *proxy, const_char *name) EINA_ARG_NONNULL(1, 2)

def proxy_property_local_get_all(proxy):
    """

    Return a Eina_Hash with all cached properties.
    This only work if you have enable eldbus_proxy_properties_monitor or
    if you have call eldbus_proxy_event_callback_add of type
    ELDBUS_PROXY_EVENT_PROPERTY_CHANGED.

    """
    const_Eina_Hash      *eldbus_proxy_property_local_get_all(Eldbus_Proxy *proxy) EINA_ARG_NONNULL(1)


def object_managed_objects_get(obj, cb, data):
    Eldbus_Pending        *eldbus_object_managed_objects_get(Eldbus_Object *obj, EDBus_Message_Cb cb, const_void *data) EINA_ARG_NONNULL(1, 2)

