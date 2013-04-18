cdef class StoreItemMapping(object):

    cdef Elm_Store_Item_Mapping mapping

    property mapping_type:
        """What kind of mapping is this

        :type: :ref:`Mapping type <Elm_Store_Item_Mapping_Type>`

        """
        def __set__(self, value):
            self.mapping.type = value

        def __get__(self):
            return self.mapping.type

    property part:
        """What part name in the genlist item is this filling in

        :type: unicode

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.mapping.part = strdup(value)

        def __get__(self):
            return _ctouni(self.mapping.part)

    property offset:
        """Offset in memory (in bytes) relative to base of structure for item
        data where the data for the mapping lives.

        :type: int

        """
        def __set__(self, value):
            self.mapping.offset = value

        def __get__(self):
            return self.mapping.offset



cdef class StoreItemMappingIcon(StoreItemMapping):

    cdef Elm_Store_Item_Mapping_Icon details

    property w:
        """The desired icon size in addition to the file path returned from
        the mapping

        :type: int

        """
        def __set__(self, int value):
            self.details.w = value

        def __get__(self):
            return self.details.w

    property h:
        """The desired icon size in addition to the file path returned from
        the mapping

        :type: int

        """
        def __set__(self, int value):
            self.details.h = value

        def __get__(self):
            return self.details.h

    property lookup_order:
        """The order in which to find the icon

        :type: Elm_Icon_Lookup_Order

        """
        def __set__(self, Elm_Icon_Lookup_Order value):
            self.details.lookup_order = value

        def __get__(self):
            return self.details.lookup_order

    property standard_name:
        """Use a standard name to find it (EINA_TRUE) or not

        :type: bool

        """
        def __set__(self, bint value):
            self.details.standard_name = value

        def __get__(self):
            return bool(self.details.standard_name)

    property no_scale:
        """EINA_TRUE is you don't want the icon scaled

        :type: bool

        """
        def __set__(self, bint value):
            self.details.no_scale = value

        def __get__(self):
            return bool(self.details.no_scale)

    property smooth:
        """EINA_TRUE if icon is to be smooth scaled

        :type: bool

        """
        def __set__(self, bint value):
            self.details.smooth = value

        def __get__(self):
            return bool(self.details.smooth)

    property scale_up:
        """EINA_TRUE if scaling up is allowed

        :type: bool

        """
        def __set__(self, bint value):
            self.details.scale_up = value

        def __get__(self):
            return bool(self.details.scale_up)

    property scale_down:
        """EINA_TRUE if scaling down is allowed

        :type: bool

        """
        def __set__(self, bint value):
            self.details.scale_down = value

        def __get__(self):
            return bool(self.details.scale_down)



cdef class StoreItemMappingEmpty(StoreItemMapping):

    cdef Elm_Store_Item_Mapping_Empty details

    def __cinit__(self):
        self.details.dummy = 1
        self.mapping.details.empty = self.details

cdef class StoreItemMappingNone(StoreItemMappingEmpty):
    def __init__(self, part, data):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        self.mapping.type = enums.ELM_STORE_ITEM_MAPPING_NONE
        self.mapping.part = part
        self.mapping.offset = 0

cdef class StoreItemMappingLabel(StoreItemMappingEmpty):
    def __init__(self, part, data):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        self.mapping.type = enums.ELM_STORE_ITEM_MAPPING_LABEL
        self.mapping.part = part
        self.mapping.offset = 0

cdef class StoreItemMappingState(StoreItemMappingEmpty):
    def __init__(self, part, data):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        self.mapping.type = enums.ELM_STORE_ITEM_MAPPING_STATE
        self.mapping.part = part
        self.mapping.offset = 0



cdef class StoreItemMappingPhoto(StoreItemMapping):

    cdef Elm_Store_Item_Mapping_Photo details

    def __init__(self, part, data, size):
        if isinstance(part, unicode): part = PyUnicode_AsUTF8String(part)
        self.mapping.type = enums.ELM_STORE_ITEM_MAPPING_PHOTO
        self.mapping.part = part
        self.mapping.offset = 0
        self.details.size = size
        self.mapping.details.photo = self.details

    property size:
        """Photo size to use (see elm_photo_add()) with the given photo path

        :type: int

        """
        def __set__(self, value):
            self.mapping.details.photo.size = value

        def __get__(self):
            return self.mapping.details.photo.size
