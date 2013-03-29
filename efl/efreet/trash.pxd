from libc.string cimport const_char
from efl.efreet.efreet cimport Efreet_Uri
from efl cimport Eina_List

cdef extern from "Efreet_Trash.h":
    int         efreet_trash_init()
    int         efreet_trash_shutdown()
    const_char *efreet_trash_dir_get(const_char *for_file)
    int         efreet_trash_delete_uri(Efreet_Uri *uri, int force_delete)
    Eina_List  *efreet_trash_ls()
    int         efreet_trash_is_empty()
    int         efreet_trash_empty_trash()
