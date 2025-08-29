from efl cimport Eina_Bool
from efl.evas cimport Evas_Object
from enums cimport Elm_Icon_Lookup_Order, Elm_Store_Item_Mapping_Type
from genlist cimport Elm_Genlist_Item_Class
from object_item cimport Elm_Object_Item

cdef extern from "Python.h":
    void PyEval_InitThreads()


cdef extern from "Elementary.h":

    cpdef enum Elm_Store_Item_Mapping_Type:
        ELM_STORE_ITEM_MAPPING_NONE
        ELM_STORE_ITEM_MAPPING_LABEL
        ELM_STORE_ITEM_MAPPING_STATE
        ELM_STORE_ITEM_MAPPING_ICON
        ELM_STORE_ITEM_MAPPING_PHOTO
        ELM_STORE_ITEM_MAPPING_CUSTOM
        ELM_STORE_ITEM_MAPPING_LAST
    ctypedef enum Elm_Store_Item_Mapping_Type:
        pass


    struct _Elm_Store:
        pass

    struct _Elm_Store_Item:
        pass

    ctypedef _Elm_Store         Elm_Store # A store object
    ctypedef _Elm_Store         const Elm_Store
    ctypedef _Elm_Store_Item    Elm_Store_Item # A handle of a store item passed to store fetch/unfetch functions
    ctypedef _Elm_Store_Item    const Elm_Store_Item

    ctypedef void                                 (*Elm_Store_Item_Fetch_Cb)(void *data, Elm_Store_Item *sti) # Function to call to fetch item data
    ctypedef void                                 (*Elm_Store_Item_Unfetch_Cb)(void *data, Elm_Store_Item *sti) # Function to cal lto un-fetch (free) an item
    ctypedef void                                *(*Elm_Store_Item_Mapping_Cb)(void *data, Elm_Store_Item *sti, const char *part) # Custom mapping function to call

    struct _Elm_Store_Item_Mapping_Icon:
        int                   w, h # The desired icon size in addition to the file path returned from the mapping
        Elm_Icon_Lookup_Order lookup_order # The order in which to find the icon
        Eina_Bool             standard_name # Use a standard name to find it (EINA_TRUE) or not
        Eina_Bool             no_scale # EINA_TRUE is you don't want the icon scaled
        Eina_Bool             smooth # EINA_TRUE if icon is to be smooth scaled
        Eina_Bool             scale_up # EINA_TRUE if scaling up is allowed
        Eina_Bool             scale_down # EINA_TRUE if scaling down is allowed

    ctypedef _Elm_Store_Item_Mapping_Icon    Elm_Store_Item_Mapping_Icon # The data being mapped at the given address is an icon, so use these properties for finding it

    struct _Elm_Store_Item_Mapping_Empty:
        Eina_Bool dummy # dummy entry - set to anything you like

    ctypedef _Elm_Store_Item_Mapping_Empty   Elm_Store_Item_Mapping_Empty # An empty piece of mapping information. Useful for String labels as they get used directly

    struct _Elm_Store_Item_Mapping_Photo:
        int size # Photo size to use (see elm_photo_add()) with the given photo path

    ctypedef _Elm_Store_Item_Mapping_Photo   Elm_Store_Item_Mapping_Photo # The data is a photo, so use these parameters to find it

    struct _Elm_Store_Item_Mapping_Custom:
        Elm_Store_Item_Mapping_Cb func # The function called to do the custom mapping and return it

    ctypedef _Elm_Store_Item_Mapping_Custom  Elm_Store_Item_Mapping_Custom # The item needs a custom mapping which means calling a function and returning a string from it, as opposed to a static lookup. It should not be allocated, and should live in a buffer in memory that survives the return of this function if its a label, or an allocated icon object if its an icon needed etc.

    union _Elm_Store_Item_Mapping_Details:
        # Allowed to be one of these possible mapping types
        Elm_Store_Item_Mapping_Empty  empty
        Elm_Store_Item_Mapping_Icon   icon
        Elm_Store_Item_Mapping_Photo  photo
        Elm_Store_Item_Mapping_Custom custom
        # add more types here

    struct _Elm_Store_Item_Mapping:
        Elm_Store_Item_Mapping_Type type # what kind of mapping is this
        const char                 *part # what part name in the genlist item is this filling in
        int                         offset # offset in memory (in bytes) relative to base of structure for item data where the data for the mapping lives
        _Elm_Store_Item_Mapping_Details details

    ctypedef _Elm_Store_Item_Mapping        Elm_Store_Item_Mapping # A basic way of telling Store how to take your return data (string, or something else from your struct) and convert it into something genlist can use
    ctypedef _Elm_Store_Item_Mapping        const Elm_Store_Item_Mapping

    struct _Elm_Store_Item_Info:
        Elm_Genlist_Item_Class       *item_class # The genlist item class that should be used for the item that has been listed
        const Elm_Store_Item_Mapping *mapping # What kind of mappings do we use for the fields of this item to fill in the genlist item. Terminate array pointed to here with ELM_STORE_ITEM_MAPPING_END
        void                         *data # Pointer to pass to struct data in memory if its already there, of not, NULL
        char                         *sort_id # Sort ID string (strduped()) to know how to wort items, or NULL, if you don't care

    ctypedef _Elm_Store_Item_Info            Elm_Store_Item_Info # Basic information about a store item - always cast into a specific type like Elm_Store_Item_Info_Filesystem

    ctypedef Eina_Bool                            (*Elm_Store_Item_List_Cb)(void *data, Elm_Store_Item_Info *info) # Function to call for listing an item

    struct _Elm_Store_Item_Info_Filesystem:
        Elm_Store_Item_Info base # Base information about an item
        char               *path # Extra information specific to the filesystem store

    ctypedef _Elm_Store_Item_Info_Filesystem Elm_Store_Item_Info_Filesystem # Filesystem specific information about a store item

    #define ELM_STORE_ITEM_MAPPING_END { ELM_STORE_ITEM_MAPPING_NONE, NULL, 0, { .empty = { EINA_TRUE } } } # Use this to end a list of mappings
    #define ELM_STORE_ITEM_MAPPING_OFFSET(st, it) offsetof(st, it) # Use this to get the offset in bytes in memory for where the data for the mapping lives relative to the item data (a private struct pointed to owned by the user



    Elm_Store              *elm_store_filesystem_new()
    void                    elm_store_free(Elm_Store *st)
    void                    elm_store_filesystem_directory_set(Elm_Store *st, const char *dir)
    const char             *elm_store_filesystem_directory_get(const Elm_Store *st)
    const char             *elm_store_item_filesystem_path_get(const Elm_Store_Item *sti)
    void                    elm_store_target_genlist_set(Elm_Store *st, Evas_Object *obj)
    void                    elm_store_cache_set(Elm_Store *st, int max)
    int                     elm_store_cache_get(const Elm_Store *st)
    void                    elm_store_list_func_set(Elm_Store *st, Elm_Store_Item_List_Cb func, const void *data)
    void                    elm_store_fetch_func_set(Elm_Store *st, Elm_Store_Item_Fetch_Cb func, const void *data)
    void                    elm_store_unfetch_func_set(Elm_Store *st, Elm_Store_Item_Unfetch_Cb func, const void *data)
    void                    elm_store_fetch_thread_set(Elm_Store *st, Eina_Bool use_thread)
    Eina_Bool               elm_store_fetch_thread_get(const Elm_Store *st)
    void                    elm_store_sorted_set(Elm_Store *st, Eina_Bool sorted)
    Eina_Bool               elm_store_sorted_get(const Elm_Store *st)
    void                    elm_store_item_data_set(Elm_Store_Item *sti, void *data)
    void                   *elm_store_item_data_get(Elm_Store_Item *sti)
    const Elm_Store        *elm_store_item_store_get(const Elm_Store_Item *sti)
    const Elm_Object_Item  *elm_store_item_genlist_item_get(const Elm_Store_Item *sti)
