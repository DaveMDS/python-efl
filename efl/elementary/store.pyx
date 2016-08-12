# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

"""

Store Elementary Store

Store is an abstracting API that is intended to farm off fetching of data
to threads running asynchronously from the mainloop that actually fetch
data needed for a genlist (or possibly future other widgets) so scrolling
never blocks waiting on IO (though normally this should be the users
job - if using genlist, to ensure all data genlist needs is in memory at
the time it needs it, and if it isn't to queue and defer a fetch and let
genlist know later when its ready. Store actually does this and implements
the infrastructure of this, leaving the actual fetch and convert up to
functions provided by the user).

It is possible for store to run inline without a thread, but this is
highly inadvisable. you can disable this with::

    st.fetch_thread = False

Store works first by creating a store, setting up functions to list items
and fetch items. Currently the only store type supported is the
filesystem store, which will list the files inside a directory (not
recursively) and then hand each file it finds (the file path) to the
list function for evaluation.

The list function may look at filename, may open the file or do
anything it likes to determine something about the file. Either it
filters it out (returns EINA_FALSE) and it is discarded or it
returns EINA_TRUE and also provides a "sort id" which is a string
store uses to figure out sorting. This string could be the filename, or
some data based on its contents. The strings are sorted alphabetically
like any normal ASCII strings, with case being important. As this listing
function runs in a thread, it can do blocking IO and parsing without
hurting the fluidity of the main loop and GUI. The list function also
returns information on how to map fields in the source file to elements
of the genlist item. For example, how the fetcher reads the private
data struct of the user (what memory offset in the struct the data is at)
and what type is there (it's a label of some sort, an icon, or with a
custom mapping function that figures it out itself and creates the
content needed for the genlist item).

Store then uses this sort id to build (over time) a sorted list of items
that then map 1:1 to genlist items. When these items are visible and
need content, Store calls the fetch function per item, which is responsible
for fetching the data from the given item and returning data to store
so it can map this to some item content. This function also runs in a
thread, and thus can do blocking IO work to later return the data. Sorting
is optional and can be enabled or disabled too.

When items are no longer needed, store will cal the unfetch function to
free data in memory about that item that is no longer needed. This function
is called in the mainloop and is expected to take minimal or almost no time
to simply free up memory resources.


Enumerations
------------

.. _Elm_Store_Item_Mapping_Type:

.. rubric:: Store item mapping types

.. data:: ELM_STORE_ITEM_MAPPING_NONE

    None

.. data:: ELM_STORE_ITEM_MAPPING_LABEL

    const char * -> label

.. data:: ELM_STORE_ITEM_MAPPING_STATE

    Eina_Bool -> state

.. data:: ELM_STORE_ITEM_MAPPING_ICON

    char * -> icon path

.. data:: ELM_STORE_ITEM_MAPPING_PHOTO

    char * -> photo path

.. data:: ELM_STORE_ITEM_MAPPING_CUSTOM

    item->custom(it->data, it, part) -> void * (-> any)

"""

from libc.string cimport strdup
from cpython cimport Py_INCREF, Py_DECREF
from efl.eo cimport _ctouni, _touni
from object_item cimport _object_item_to_python
from genlist cimport GenlistItemClass

import traceback

PyEval_InitThreads()

cdef Eina_Bool store_fs_item_list_cb(void *data, Elm_Store_Item_Info *info) with gil:
    """Function to call for listing an item (filesystem)"""
    cdef StoreItemInfoFilesystem ifs = StoreItemInfoFilesystem.__new__(StoreItemInfoFilesystem)
    ifs.info_fs = <Elm_Store_Item_Info_Filesystem *>info
    func, args, kwargs = <object>data
    try:
        ret = func(ifs, args, kwargs)
    except Exception:
        traceback.print_exc()

    ifs.info_fs = NULL

    if ret is not None:
        return bool(ret)
    else:
        return 0

cdef void store_item_fetch_cb(void *data, Elm_Store_Item *sti) with gil:
    """Function to call to fetch item data"""
    cdef StoreItem it = StoreItem.__new__(StoreItem)
    it.sti = sti
    func, args, kwargs = <object>data
    try:
        func(it, args, kwargs)
    except Exception:
        traceback.print_exc()

    it.sti = NULL

cdef void store_item_unfetch_cb(void *data, Elm_Store_Item *sti) with gil:
    """Function to call to un-fetch (free) an item"""
    cdef StoreItem it = StoreItem.__new__(StoreItem)
    it.sti = sti
    func, args, kwargs = <object>data
    try:
        func(it, args, kwargs)
    except Exception:
        traceback.print_exc()

    it.sti = NULL

cdef void *store_item_mapping_cb(void *data, Elm_Store_Item *sti, const char *part) with gil:
    """Custom mapping function to call"""
    pass

cimport enums

ELM_STORE_ITEM_MAPPING_NONE = enums.ELM_STORE_ITEM_MAPPING_NONE
ELM_STORE_ITEM_MAPPING_LABEL = enums.ELM_STORE_ITEM_MAPPING_LABEL
ELM_STORE_ITEM_MAPPING_STATE = enums.ELM_STORE_ITEM_MAPPING_STATE
ELM_STORE_ITEM_MAPPING_ICON = enums.ELM_STORE_ITEM_MAPPING_ICON
ELM_STORE_ITEM_MAPPING_PHOTO = enums.ELM_STORE_ITEM_MAPPING_PHOTO
ELM_STORE_ITEM_MAPPING_CUSTOM = enums.ELM_STORE_ITEM_MAPPING_CUSTOM

"""
struct _Elm_Store_Item_Mapping_Custom:
    Elm_Store_Item_Mapping_Cb func # The function called to do the custom mapping and return it

#define ELM_STORE_ITEM_MAPPING_END { ELM_STORE_ITEM_MAPPING_NONE, NULL, 0, { .empty = { EINA_TRUE } } } # Use this to end a list of mappings
#define ELM_STORE_ITEM_MAPPING_OFFSET(st, it) offsetof(st, it)
"""

include "store_item_mapping.pxi"

cdef class StoreItemInfo(object):

    cdef:
        Elm_Store_Item_Info *info

    property item_class:
        """The genlist item class that should be used for the item that has been
        listed

        :type: :py:class:`GenlistItemClass <efl.elementary.genlist.GenlistItemClass>`

        """
        def __set__(self, GenlistItemClass value):
            self.info.item_class = &value.cls

        def __get__(self):
            cdef GenlistItemClass ret = GenlistItemClass.__new__(GenlistItemClass)
            ret.cls = self.info.item_class[0]
            return ret

    # property mapping:
    #     """What kind of mappings do we use for the fields of this item to fill
    #     in the genlist item. Terminate array pointed to here with
    #     ELM_STORE_ITEM_MAPPING_END

    #     :type: StoreItemMapping

    #     """
    #     def __set__(self, value):
    #         self.info.mapping = value

    #     def __get__(self):
    #         cdef StoreItemMapping
    #         return self.info.mapping

    property data:
        """Pointer to pass to struct data in memory if its already there, or
        NULL if not.

        :type: object

        """
        def __set__(self, value):
            self.info.data = <void *>value

        def __get__(self):
            if not self.info.data == NULL:
                return <object>self.info.data

    property sort_id:
        """Sort ID string (strduped()) to know how to sort items, or NULL, if
        you don't care.

        :type: unicode

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.info.sort_id = strdup(value)

        def __get__(self):
            return _touni(self.info.sort_id)

cdef class StoreItemInfoFilesystem(object):

    cdef Elm_Store_Item_Info_Filesystem *info_fs

    property base:
        """Base information about an item

        :type: StoreItemInfo

        """
        def __get__(self):
            cdef StoreItemInfo ret = StoreItemInfo.__new__(StoreItemInfo)
            ret.info = &self.info_fs.base
            return ret

    property path:
        """Extra information specific to the filesystem store

        :type: unicode

        """
        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            self.info_fs.path = strdup(value)

        def __get__(self):
            return _touni(self.info_fs.path)


cdef class Store(object):
    """

    The class that holds the implementation of the widget.

    """

    cdef Elm_Store *st

    def __init__(self, store_type = None):
        self.st = elm_store_filesystem_new()

        if self.st == NULL:
            Py_DECREF(self)

    def delete(self):
        """Free the store object and all items it manages

        This frees the given store and all the items it manages. It will
        clear the List that it populated, but otherwise leave it alone. It will
        cancel background threads (and may have to wait for them to complete a
        pending operation to do this).

        """
        elm_store_free(self.st)

    property filesystem_directory:
        """The path to the directory to scan for a filesystem store

        This sets the directory to scan and begins scanning in the
        the background in threads (or not if threading is disabled with
        elm_store_fetch_thread_set()). Note that Listing is always done in a thread
        but fetching may not be if disabled here. This should be the last thing
        called after fetch, list and unfetch functions are set, as well as target
        genlist etc. You also should not change the directory once set. If you
        need a new directory scanned, create a new store.

        This gets the directory set by elm_store_filesystem_directory_set(). This
        string returned will be valid until elm_store_filesystem_directory_set()
        changes it or until the store is freed with elm_store_free().

        :type: unicode

        """
        def __set__(self, value):
            if isinstance(directory, unicode): directory = PyUnicode_AsUTF8String(directory)
            elm_store_filesystem_directory_set(self.st,
                <const char *>directory if directory is not None else NULL)

        def __get__(self):
            return _ctouni(elm_store_filesystem_directory_get(self.st))

    def filesystem_directory_set(self, directory):
        if isinstance(directory, unicode): directory = PyUnicode_AsUTF8String(directory)
        elm_store_filesystem_directory_set(self.st,
            <const char *>directory if directory is not None else NULL)

    def filesystem_directory_get(self):
        return _ctouni(elm_store_filesystem_directory_get(self.st))

    property target_genlist:
        """Set the target genlist to fill in from the store

        This tells the store the target genlist to use to fill in content from
        the store. Once a store starts "going" via elm_store_filesystem_directory_set()
        The target should never be changed again.

        :type: :py:class:`Genlist <efl.elementary.genlist.Genlist>`

        """
        def __set__(self, Genlist target):
            elm_store_target_genlist_set(self.st, target.obj)

    def target_genlist_set(self, Genlist target):
        elm_store_target_genlist_set(self.st, target.obj)

    property cache_size:
        """Set the maximum number of items that are not visible to keep cached

        Store may keep some items around for caching purposes that cannot be seen,
        so this controls the maximum number. The default is 128, but may change
        at any point in time in the future.

        :param max: The number of items to keep (should be greater than or equal to 0)

        """
        def __set__(self, int maximum):
            elm_store_cache_set(self.st, maximum)

        def __get__(self):
            return elm_store_cache_get(self.st)

    def cache_size_set(self, int maximum):
        elm_store_cache_set(self.st, maximum)

    def cache_size_get(self):
        return elm_store_cache_get(self.st)

    def fs_list_func_set(self, func, *args, **kwargs):
        """Set the function used to deal with listing of items

        This function is called per item that is found so it can examine the
        item and discard it (return EINA_FALSE to discard, or EINA_TRUE to
        accept), and work out some sorting ID (that may be filename or anything
        else based on content). This function is always called from a thread.

        :param func: The function to be called

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        data = (func, args, kwargs)
        Py_INCREF(data)

        elm_store_list_func_set(self.st, store_fs_item_list_cb,
            <const void *>data)

    def fetch_func_set(self, func, *args, **kwargs):
        """Set the function used to deal with fetching of items

        This function is called per item that needs data to be fetched when it
        becomes visible and such data is needed. This function is normally run
        from a thread (unless elm_store_fetch_thread_set() disables this). The
        fetch function is to read data from the source and fill a structure
        allocated for this item with fields and then rely on the mapping setup
        to tell Store how to take a field in the structure and apply it to a
        genlist item.

        :param func: The function to be called

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        data = (func, args, kwargs)
        Py_INCREF(data)

        elm_store_fetch_func_set(self.st, store_item_fetch_cb,
            <const void *>data)

    def unfetch_func_set(self, func, *args, **kwargs):
        """Set the function used to free the structure allocated for the item

        This function is called per item when it is not needed in memory anymore
        and should free the structure allocated in and filled in the function
        set by elm_store_fetch_func_set().

        :param func: The function to be called

        """
        if not callable(func):
            raise TypeError("func is not callable.")

        data = (func, args, kwargs)
        Py_INCREF(data)

        elm_store_unfetch_func_set(self.st, store_item_unfetch_cb,
            <const void *>data)

    property fetch_thread:
        """Enable or disable fetching in a thread for Store

        :type: bool

        """
        def __set__(self, bint use_thread):
            elm_store_fetch_thread_set(self.st, use_thread)

        def __get__(self):
            return bool(elm_store_fetch_thread_get(self.st))

    def fetch_thread_set(self, bint use_thread):
        elm_store_fetch_thread_set(self.st, use_thread)

    def fetch_thread_get(self):
        return bool(elm_store_fetch_thread_get(self.st))

    property items_sorted:
        """Set if items are to be sorted or not.

        By default items are not sorted, but read "in order" as they are found. If
        you want to sort, your list function set by elm_store_list_func_set() must
        provide a sort ID to sort by, and then Store will take care of sorting when
        it inserts items. You should set this up before you begin listing items
        in the store and then never change it again.

        :type: bool

        """
        def __set__(self, bint items_sorted):
            elm_store_sorted_set(self.st, items_sorted)

        def __get__(self):
            return bool(elm_store_sorted_get(self.st))

    def sorted_set(self, bint items_sorted):
        elm_store_sorted_set(self.st, items_sorted)

    def sorted_get(self):
        return bool(elm_store_sorted_get(self.st))

_object_mapping_register("Elm_Store", Store)

cdef class StoreItem(object):

    cdef Elm_Store_Item *sti

    property filesystem_path:
        """Get the path of a specific store item

        This returns the full path of a store item. This string is valid only
        during the list function set by elm_store_list_func_set() or during the
        fetch function set by elm_store_fetch_func_set() or during the unfetch
        function set by elm_store_unfetch_func_set().

        :param sti: The store item to get the path from
        :return: A full path in a string or NULL if none available

        """
        def __get__(self):
            return _ctouni(elm_store_item_filesystem_path_get(self.sti))

    def filesystem_path_get(self):
        return _ctouni(elm_store_item_filesystem_path_get(self.sti))

    property data:
        """Set the item data holding item fields to map to item values in genlist

        Once you decode an item, allocate a structure for it and fill the structure,
        you should set the item data with this function (eg in the fetch function).
        This item pointer is the base offset to use when mapping fields to item
        values. Once you unfetch, store will handle NULLing the data pointer for you.

        :param sti: The store item to set the data pointer of
        :param data: The data pointer to set.

        """
        def __set__(self, data):
            elm_store_item_data_set(self.sti, <void *>data)

        def __get__(self):
            cdef void *data = elm_store_item_data_get(self.sti)
            if data == NULL: return None
            return <object>data

    def data_set(self, data):
        elm_store_item_data_set(self.sti, <void *>data)

    def data_get(self):
        cdef void *data = elm_store_item_data_get(self.sti)
        if data == NULL: return None
        return <object>elm_store_item_data_get(self.sti)

    property store:
        """Fetch the store than a store item belongs to

        This fetches the store object that owns the store item.

        :param sti: The store item to query
        :return: The store the item belongs to

        """
        def __get__(self):
            cdef:
                Store ret
                Elm_Store *st = <Elm_Store *>elm_store_item_store_get(self.sti)

            if st == NULL:
                return None

            ret = Store.__new__()
            ret.st = st
            return ret

    def store_get(self):
        cdef:
            Store ret
            Elm_Store *st = <Elm_Store *>elm_store_item_store_get(self.sti)

        if st == NULL:
            return None

        ret = Store.__new__()
        ret.st = st
        return ret

    property genlist_item:
        """Fetch the genlist item that this store item controls

        :param sti: The store item to query
        :return: The genlist object item handle controlled by this store item

        """
        def __get__(self):
            return _object_item_to_python(<Elm_Object_Item *>elm_store_item_genlist_item_get(self.sti))

    def genlist_item_get(self):
        return _object_item_to_python(<Elm_Object_Item *>elm_store_item_genlist_item_get(self.sti))
