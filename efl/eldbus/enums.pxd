cdef extern from "EDBus.h":
    ctypedef enum EDBus_Connection_Type:
        EDBUS_CONNECTION_TYPE_UNKNOWN
        EDBUS_CONNECTION_TYPE_SESSION
        EDBUS_CONNECTION_TYPE_SYSTEM
        EDBUS_CONNECTION_TYPE_STARTER
        EDBUS_CONNECTION_TYPE_LAST

    ctypedef enum EDBus_Connection_Event_Type:
        EDBUS_CONNECTION_EVENT_DEL
        EDBUS_CONNECTION_EVENT_DISCONNECTED
        EDBUS_CONNECTION_EVENT_LAST    # sentinel, not a real event type

    ctypedef enum EDBus_Object_Event_Type:
        EDBUS_OBJECT_EVENT_IFACE_ADDED # a parent path must have a ObjectManager interface
        EDBUS_OBJECT_EVENT_IFACE_REMOVED # a parent path must have a ObjectManager interface
        EDBUS_OBJECT_EVENT_PROPERTY_CHANGED
        EDBUS_OBJECT_EVENT_PROPERTY_REMOVED
        EDBUS_OBJECT_EVENT_DEL
        EDBUS_OBJECT_EVENT_LAST    # sentinel, not a real event type

    ctypedef enum EDBus_Proxy_Event_Type:
        EDBUS_PROXY_EVENT_PROPERTY_CHANGED
        EDBUS_PROXY_EVENT_PROPERTY_REMOVED
        EDBUS_PROXY_EVENT_DEL
        EDBUS_PROXY_EVENT_LAST    # sentinel, not a real event type
