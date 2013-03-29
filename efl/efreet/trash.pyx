"""

Contains the methods used to support the FDO trash specification.

"""

from efl cimport eina_list_free, Eina_Stringshare, eina_stringshare_del
from efl.eo cimport convert_eina_list_strings_to_python_list
from efl.eo cimport _ctouni, _cfruni
from efl.efreet.efreet cimport Uri
import atexit

efreet_trash_init()

def _shutdown():
    """Don't call this directly, it will be called when the module is exit."""
    return bool(efreet_trash_shutdown())

atexit.register(_shutdown)

def dir_get(for_file):
    """dir_get(unicode for_file) -> unicode

    Retrieves the XDG Trash local directory

    :return: The XDG Trash local directory or None on errors.
        Return value must be freed with eina_stringshare_del.
    """
    cdef const_char *s = efreet_trash_dir_get(_cfruni(for_file))
    ret = _ctouni(s)
    eina_stringshare_del(s)
    return ret

def delete_uri(Uri uri, force_delete):
    """delete_uri(efl.efreet.EfreetUri uri, bool force_delete) -> bool

    This function try to move the given uri to the trash. Files on different
    filesystem can't be moved to trash. If force_delete is False than
    non-local files will be ignored and -1 is returned, if you set
    force_delete to True non-local files will be deleted without asking.

    :param uri: The local uri to move in the trash
    :param force_delete: If you set this to True than files on different
        filesystems will be deleted permanently
    :return: 1 on success, 0 on failure or -1 in case the uri is
        not on the same filesystem and force_delete is not set.

    """
    return int(efreet_trash_delete_uri(uri.uri, force_delete))

def ls():
    """ls() -> list

    List all the files and directory currently inside the trash.

    :return: A list of strings with filename (remember to free the list
    when you don't need anymore).

    """
    cdef Eina_List *lst = efreet_trash_ls()
    ret = convert_eina_list_strings_to_python_list(lst)
    eina_list_free(lst)
    return ret

def is_empty():
    """is_empty() -> bool

    Check if the trash is currently empty

    :return: True if the trash is empty or False if some file are in.

    """
    return bool(efreet_trash_is_empty())

def empty_trash():
    """empty_trash() -> bool

    Delete all the files inside the trash.

    :return: True on success or False on failure.

    """
    return bool(efreet_trash_empty_trash())
