from efl.eo cimport _ctouni, _strings_to_python

def data_home_get():
    """

    Retrieves the XDG Data Home directory
    :return: Returns the XDG Data Home directory

    """
    return _ctouni(efreet_data_home_get())

def data_dirs_get():
    """

    Returns the Eina_List of preference ordered extra data directories
    :return: Returns the Eina_List of preference ordered extra data directories

    .. note:: The returned list is static inside Efreet. If you add/remove from the
    list then the next call to efreet_data_dirs_get() will return your
    modified values. DO NOT free this list.

    """
    return _strings_to_python(efreet_data_dirs_get())

def config_home_get():
    """

    Retrieves the XDG Config Home directory
    :return: Returns the XDG Config Home directory

    """
    return _ctouni(efreet_config_home_get())

def desktop_dir_get():
    """

    Retrieves the XDG Desktop directory
    :return: Returns the XDG Desktop directory

    """
    return _ctouni(efreet_desktop_dir_get())

def download_dir_get():
    """

    Retrieves the XDG Download directory

    This is where user-specific download files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    It's meant for large download or in-progress downloads, it's
    private for the user but may be shared among different
    machines. It's not automatically cleaned up.

    @see efreet_cache_home_get()
    @see efreet_runtime_dir_get()
    @see http://0pointer.de/blog/projects/tmp.html

    @return Returns the XDG Download directory

    """
    return _ctouni(efreet_download_dir_get())

def templates_dir_get():
    """

    Retrieves the XDG Templates directory

    This is where user-specific template files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    @return Returns the XDG Templates directory

    """
    return _ctouni(efreet_templates_dir_get())

def public_share_dir_get():
    """

    Retrieves the XDG Public Share directory

    This is where user-specific public shareable files should be
    located. It's localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    Usually local file servers should look here (Apache, Samba, FTP).

    @return Returns the XDG Public Share directory

    """
    return _ctouni(efreet_public_share_dir_get())

def documents_dir_get():
    """

    @return Returns the XDG Documents directory
    @brief Retrieves the XDG Documents directory

    This is where user-specific documents files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    """
    return _ctouni(efreet_documents_dir_get())

def music_dir_get():
    """

    @return Returns the XDG Music directory
    @brief Retrieves the XDG Music directory

    This is where user-specific music files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    """
    return _ctouni(efreet_music_dir_get())

def pictures_dir_get():
    """

    @return Returns the XDG Pictures directory
    @brief Retrieves the XDG Pictures directory

    This is where user-specific pictures files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    """
    return _ctouni(efreet_pictures_dir_get())

def videos_dir_get():
    """

    @return Returns the XDG Videos directory
    @brief Retrieves the XDG Videos directory

    This is where user-specific video files should be located. It's
    localized (translated) to current user locale
    (~/.config/user-dirs.locale and ~/.config/user-dirs.dirs).

    """
    return _ctouni(efreet_videos_dir_get())

def config_dirs_get():
    """

    Returns the Eina_List of preference ordered extra config
    directories
    :return: Returns the Eina_List of preference ordered extra config directories

    .. note:: The returned list is static inside Efreet. If you add/remove from the
    list then the next call to efreet_config_dirs_get() will return your
    modified values. DO NOT free this list.

    """
    return _strings_to_python(efreet_config_dirs_get())

def cache_home_get():
    """

    Retrieves the XDG Cache Home directory
    :return: Returns the XDG Cache Home directory

    """
    return _ctouni(efreet_cache_home_get())

def runtime_dir_get():
    """

    @return Returns the XDG User Runtime directory.
    @brief Retrieves the XDG User Runtime directory.

    This is the base directory relative to which user-specific
    non-essential runtime files and other file objects (such as
    sockets, named pipes, ...) should be stored. The directory @b must
    be owned by the user, and he @b must be the only one having read
    and write access to it. Its Unix access mode @b must be 0700.

    The lifetime of this directory @b must be bound to the user being
    logged in. It @b must be created when the user first logs in and if
    the user fully logs out the directory @b must be removed. If the
    user logs in more than once he should get pointed to the same
    directory, and it is mandatory that the directory continues to
    exist from his first login to his last logout on the system, and
    not removed in between. Files in the directory @b must not survive
    reboot or a full logout/login cycle.

    The directory @b must be on a local file system and not shared with
    any other system. The directory @b must by fully-featured by the
    standards of the operating system. More specifically, on Unix-like
    operating systems AF_UNIX sockets, symbolic links, hard links,
    proper permissions, file locking, sparse files, memory mapping,
    file change notifications, a reliable hard link count must be
    supported, and no restrictions on the file name character set
    should be imposed. Files in this directory @b may be subjected to
    periodic clean-up. To ensure that your files are not removed, they
    should have their access time timestamp modified at least once
    every 6 hours of monotonic time or the 'sticky' bit should be set
    on the file.

    If @c NULL applications should fall back to a replacement directory
    with similar capabilities and print a warning message. Applications
    should use this directory for communication and synchronization
    purposes and should not place larger files in it, since it might
    reside in runtime memory and cannot necessarily be swapped out to
    disk.

    @note this directory is similar to @c /run and is often created in
    tmpfs (memory-only/RAM filesystem). It is created, managed and
    cleaned automatically by systemd.

    """
    return _ctouni(efreet_runtime_dir_get())

def hostname_get():
    """

    Returns the current hostname or empty string if not found
    :return: Returns the current hostname

    """
    return _ctouni(efreet_hostname_get())
