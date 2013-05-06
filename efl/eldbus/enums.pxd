cdef extern from "Eldbus.h":
    ctypedef enum Eldbus_Connection_Type:
        ELDBUS_CONNECTION_TYPE_UNKNOWN
        ELDBUS_CONNECTION_TYPE_SESSION
        ELDBUS_CONNECTION_TYPE_SYSTEM
        ELDBUS_CONNECTION_TYPE_STARTER
        ELDBUS_CONNECTION_TYPE_LAST

    ctypedef enum Eldbus_Connection_Event_Type:
        ELDBUS_CONNECTION_EVENT_DEL
        ELDBUS_CONNECTION_EVENT_DISCONNECTED
        ELDBUS_CONNECTION_EVENT_LAST    # sentinel, not a real event type

    ctypedef enum Eldbus_Object_Event_Type:
        ELDBUS_OBJECT_EVENT_IFACE_ADDED # a parent path must have a ObjectManager interface
        ELDBUS_OBJECT_EVENT_IFACE_REMOVED # a parent path must have a ObjectManager interface
        ELDBUS_OBJECT_EVENT_PROPERTY_CHANGED
        ELDBUS_OBJECT_EVENT_PROPERTY_REMOVED
        ELDBUS_OBJECT_EVENT_DEL
        ELDBUS_OBJECT_EVENT_LAST    # sentinel, not a real event type

    ctypedef enum Eldbus_Proxy_Event_Type:
        ELDBUS_PROXY_EVENT_PROPERTY_CHANGED
        ELDBUS_PROXY_EVENT_PROPERTY_REMOVED
        ELDBUS_PROXY_EVENT_DEL
        ELDBUS_PROXY_EVENT_LAST    # sentinel, not a real event type
