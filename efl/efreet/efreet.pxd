from libc.string cimport const_char

from efl cimport Eina_List, Eina_Bool, Eina_Stringshare, \
    eina_stringshare_add, eina_stringshare_del

from efl.efreet.enums cimport Efreet_Menu_Entry_Type, Efreet_Icon_Theme_Context, \
    Efreet_Icon_Size_Type

cdef extern from "Eina.h":
    ctypedef struct Eina_Hash

cdef extern from "Efreet.h":
    ctypedef struct Efreet_Desktop:
        int type                # type of desktop file

        int ref                 # reference count - internal

        char *version           # version of spec file conforms to

        char *orig_path         # original path to .desktop file
        long long load_time     # modified time of .desktop on disk

        char *name              # Specific name of the application
        char *generic_name      # Generic name of the application
        char *comment           # Tooltip for the entry
        char *icon              # Icon to display in file manager, menus, etc
        char *try_exec          # Binary to determine if app is installed
        char *executable "exec" # Program to execute
        char *path              # Working directory to run app in
        char *startup_wm_class  # If specified will map at least one window with
                                # the given string as it's WM class or WM name
        char *url               # URL to access if type is EFREET_TYPE_LINK

        Eina_List  *only_show_in    # list of environments that should
                                    # display the icon
        Eina_List  *not_show_in     # list of environments that shoudn't
                                    # display the icon
        Eina_List  *categories      # Categories in which item should be shown
        Eina_List  *mime_types      # The mime types supppored by this app

        unsigned char no_display        # Don't display this application in menus
        unsigned char hidden            # User delete the item
        unsigned char terminal          # Does the program run in a terminal
        unsigned char startup_notify    # The starup notify settings of the app
        unsigned char eet               # The desktop file is in eet cache

        Eina_Hash *x    # Keep track of all user extensions, keys that begin with X-
        void *type_data # Type specific data for custom types

    #ctypedef icon_theme_name icon_theme_name

    #ctypedef Efreet_Icon_Theme Efreet_Icon_Theme

    ctypedef struct Efreet_Icon_Theme:
        # TODO: name *name

        const_char *comment        # String describing the theme
        const_char *example_icon   # Icon to use as an example of the theme

        # An icon theme can have multiple directories that store it's icons. We
        # need to be able to find a search each one.

        Eina_List *paths           # The paths
        Eina_List *inherits        # Icon themes we inherit from
        Eina_List *directories     # List of subdirectories for this theme

    struct size: # The size settings for the icon theme */
        unsigned int normal        # The size for this directory */
        unsigned int min           # The minimum size for this directory */
        unsigned int max           # The maximum size for this directory */
        unsigned int threshold     # Size difference threshold */

    ctypedef size icon_theme_directory_size

    ctypedef struct Efreet_Icon_Theme_Directory:
        icon_theme_directory_size *size
        const_char *name               # The directory name */
        Efreet_Icon_Theme_Context context  # The type of icons in the dir */
        Efreet_Icon_Size_Type type     # The size type for the icons */

    struct embedded_text_rectangle: # Rectangle where text can be displayed on the icon */
        int x0             # x0 position */
        int y0             # y0 position */
        int x1             # x1 position */
        int y1             # y1 position */

    ctypedef embedded_text_rectangle icon_rectangle

    ctypedef struct Efreet_Icon:
        # TODO: icon_rectangle embedded_text_rectangle
        const_char *path       # Full path to the icon */
        const_char *name       # Translated UTF8 string that can be used for the icon name */

        Eina_List *attach_points # List of points to be used as anchor points for emblems/overlays */

        unsigned int ref_count    # References to this icon */
        unsigned char has_embedded_text_rectangle # Has the embedded rectangle set */

    ctypedef struct Efreet_Icon_Point:
        int x          # x coord */
        int y          # y coord */

    struct Efreet_Ini:
        Eina_Hash *data     # Hash of string => (Hash of string => string)
        Eina_Hash *section  # currently selected section

    ctypedef struct Efreet_Menu:
        Efreet_Menu_Entry_Type type
        const_char *id   # File-id for desktop and relative name for menu

        const_char *name # Name this entry should show
        const_char *icon # Icon for this entry

        Efreet_Desktop *desktop   # The desktop we refer too
        Eina_List      *entries   # The menu items

    ctypedef struct Efreet_Uri:
        const_char *protocol   # The protocol used (usually 'file')
        const_char *hostname   # The name of the host if any, or NULL
        const_char *path       # The full file path whitout protocol nor host

    # Callbacks
    ctypedef void *(*Efreet_Desktop_Command_Cb) (void *data, Efreet_Desktop *desktop, char *command, int remaining)
    ctypedef int (*Efreet_Desktop_Progress_Cb) (void *data, Efreet_Desktop *desktop, char *uri, long int total, long int current)
    ctypedef void *(*Efreet_Desktop_Type_Parse_Cb) (Efreet_Desktop *desktop, Efreet_Ini *ini)
    ctypedef void (*Efreet_Desktop_Type_Save_Cb) (Efreet_Desktop *desktop, Efreet_Ini *ini)
    ctypedef void *(*Efreet_Desktop_Type_Free_Cb) (void *data)

    # Functions
    int             efreet_init()
    int             efreet_shutdown()
    void            efreet_lang_reset()

    # Base
    const_char *    efreet_data_home_get()
    Eina_List *     efreet_data_dirs_get()
    const_char *    efreet_config_home_get()
    const_char *    efreet_desktop_dir_get()
    const_char *    efreet_download_dir_get()
    const_char *    efreet_templates_dir_get()
    const_char *    efreet_public_share_dir_get()
    const_char *    efreet_documents_dir_get()
    const_char *    efreet_music_dir_get()
    const_char *    efreet_pictures_dir_get()
    const_char *    efreet_videos_dir_get()
    Eina_List *     efreet_config_dirs_get()
    const_char *    efreet_cache_home_get()
    const_char *    efreet_runtime_dir_get()
    const_char *    efreet_hostname_get()

    # Desktop
    Efreet_Desktop *    efreet_desktop_get(const_char *file)
    int                 efreet_desktop_ref(Efreet_Desktop *desktop)
    Efreet_Desktop *    efreet_desktop_empty_new(const_char *file)
    Efreet_Desktop *    efreet_desktop_new(const_char *file)
    Efreet_Desktop *    efreet_desktop_uncached_new(const_char *file)
    void                efreet_desktop_free(Efreet_Desktop *desktop)
    int                 efreet_desktop_save(Efreet_Desktop *desktop)
    int                 efreet_desktop_save_as(Efreet_Desktop *desktop, const_char *file)
    #TODO: void                efreet_desktop_exec(Efreet_Desktop *desktop, Eina_List *files, void *data)
    void                efreet_desktop_environment_set(const_char *environment)
    const_char *        efreet_desktop_environment_get()
    #TODO: void *              efreet_desktop_command_progress_get(Efreet_Desktop *desktop, Eina_List *files, Efreet_Desktop_Command_Cb cb_command, Efreet_Desktop_Progress_Cb cb_prog, void *data)
    #TODO: void *              efreet_desktop_command_get(Efreet_Desktop *desktop, Eina_List *files, Efreet_Desktop_Command_Cb func, void *data)
    Eina_List *         efreet_desktop_command_local_get(Efreet_Desktop *desktop, Eina_List *files)
    unsigned int        efreet_desktop_category_count_get(Efreet_Desktop *desktop)
    void                efreet_desktop_category_add(Efreet_Desktop *desktop, const_char *category)
    int                 efreet_desktop_category_del(Efreet_Desktop *desktop, const_char *category)
    #TODO: int                 efreet_desktop_type_add(const_char *type, Efreet_Desktop_Type_Parse_Cb parse_func, Efreet_Desktop_Type_Save_Cb save_func, Efreet_Desktop_Type_Free_Cb free_func)
    int                 efreet_desktop_type_alias (int from_type, const_char *alias)
    #TODO: void *              efreet_desktop_type_data_get(Efreet_Desktop *desktop)
    Eina_List *         efreet_desktop_string_list_parse(const_char *string)
    char *              efreet_desktop_string_list_join(Eina_List *list)
    Eina_Bool           efreet_desktop_x_field_set(Efreet_Desktop *desktop, const_char *key, const_char *data)
    const_char *        efreet_desktop_x_field_get(Efreet_Desktop *desktop, const_char *key)
    Eina_Bool           efreet_desktop_x_field_del(Efreet_Desktop *desktop, const_char *key)

    # Icon
    const_char        *efreet_icon_user_dir_get()
    const_char        *efreet_icon_deprecated_user_dir_get()
    void               efreet_icon_extension_add(const_char *ext)
    Eina_List        **efreet_icon_extra_list_get()
    Eina_List         *efreet_icon_extensions_list_get()
    Eina_List         *efreet_icon_theme_list_get()
    Efreet_Icon_Theme *efreet_icon_theme_find(const_char *theme_name)
    Efreet_Icon       *efreet_icon_find(const_char *theme_name, const_char *icon, unsigned int size)
    const_char        *efreet_icon_list_find(const_char *theme_name, Eina_List *icons, unsigned int size)
    const_char        *efreet_icon_path_find(const_char *theme_name, const_char *icon, unsigned int size)
    void               efreet_icon_free(Efreet_Icon *icon)

    # Ini
    Efreet_Ini *    efreet_ini_new(const_char *file)
    void            efreet_ini_free(Efreet_Ini *ini)
    int             efreet_ini_save(Efreet_Ini *ini, const_char *path)
    int             efreet_ini_section_set(Efreet_Ini *ini, const_char *section)
    void            efreet_ini_section_add(Efreet_Ini *ini, const_char *section)
    const_char *    efreet_ini_string_get(Efreet_Ini *ini, const_char *key)
    void            efreet_ini_string_set(Efreet_Ini *ini, const_char *key, const_char *value)
    const_char *    efreet_ini_localestring_get(Efreet_Ini *ini, const_char *key)
    void            efreet_ini_localestring_set(Efreet_Ini *ini, const_char *key, const_char *value)
    unsigned int    efreet_ini_boolean_get(Efreet_Ini *ini, const_char *key)
    void            efreet_ini_boolean_set(Efreet_Ini *ini, const_char *key, unsigned int value)
    int             efreet_ini_int_get(Efreet_Ini *ini, const_char *key)
    void            efreet_ini_int_set(Efreet_Ini *ini, const_char *key, int value)
    double          efreet_ini_double_get(Efreet_Ini *ini, const_char *key)
    void            efreet_ini_double_set(Efreet_Ini *ini, const_char *key, double value)
    void            efreet_ini_key_unset(Efreet_Ini *ini, const_char *key)

    # Menu
    int              efreet_menu_kde_legacy_init()
    Efreet_Menu     *efreet_menu_new(const_char *name)
    void             efreet_menu_file_set(const_char *file)
    Efreet_Menu     *efreet_menu_get()
    Efreet_Menu     *efreet_menu_parse(const_char *path)
    int              efreet_menu_save(Efreet_Menu *menu, const_char *path)
    void             efreet_menu_free(Efreet_Menu *menu)
    int              efreet_menu_desktop_insert(Efreet_Menu *menu, Efreet_Desktop *desktop, int pos)
    int              efreet_menu_desktop_remove(Efreet_Menu *menu, Efreet_Desktop *desktop)
    void             efreet_menu_dump(Efreet_Menu *menu, const_char *indent)

    # URI
    const_char *efreet_uri_encode(Efreet_Uri *uri)
    Efreet_Uri *efreet_uri_decode(const_char *val)
    void        efreet_uri_free(Efreet_Uri *uri)

    # Utils


cdef class Uri(object):
    cdef Efreet_Uri *uri
