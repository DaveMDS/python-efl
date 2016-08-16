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

:mod:`efl.ethumb_client` Module
###############################

.. versionadded:: 1.17


Classes
=======

.. toctree::

   class-ethumb_client.rst


Enumerations
============

.. _Ethumb_Client_Thumb_FDO_Size:

Ethumb_Thumb_FDO_Size
---------------------

.. data:: ETHUMB_THUMB_NORMAL

    128x128 as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_LARGE

    256x256 as defined by FreeDesktop.Org standard


.. _Ethumb_Client_Thumb_Format:

Ethumb_Thumb_Format
-------------------

.. data:: ETHUMB_THUMB_FDO

    PNG as defined by FreeDesktop.Org standard.

.. data:: ETHUMB_THUMB_JPEG

    JPEGs are often smaller and faster to read/write.

.. data:: ETHUMB_THUMB_EET

    EFL's own storage system, supports key parameter.


.. _Ethumb_Client_Thumb_Aspect:

Ethumb_Thumb_Aspect
-------------------

.. data:: ETHUMB_THUMB_KEEP_ASPECT

    Keep original proportion between width and height

.. data:: ETHUMB_THUMB_IGNORE_ASPECT

    Ignore aspect and foce it to match thumbnail's width and height

.. data:: ETHUMB_THUMB_CROP

    keep aspect but crop (cut) the largest dimension


.. _Ethumb_Client_Thumb_Orientation:

Ethumb_Thumb_Orientation
------------------------

.. data:: ETHUMB_THUMB_ORIENT_NONE

    Keep orientation as pixel data is

.. data:: ETHUMB_THUMB_ROTATE_90_CW

    Rotate 90° clockwise

.. data:: ETHUMB_THUMB_ROTATE_180

    Rotate 180°

.. data:: ETHUMB_THUMB_ROTATE_90_CCW

    Rotate 90° counter-clockwise

.. data:: ETHUMB_THUMB_FLIP_HORIZONTAL

    Flip horizontally

.. data:: ETHUMB_THUMB_FLIP_VERTICAL

    Flip vertically

.. data:: ETHUMB_THUMB_FLIP_TRANSPOSE

    Transpose

.. data:: ETHUMB_THUMB_FLIP_TRANSVERSE

    Transverse

.. data:: ETHUMB_THUMB_ORIENT_ORIGINAL

    Use orientation from metadata (EXIF-only currently)


Module level functions
======================

"""

from cpython cimport Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String
from libc.stdint cimport uintptr_t

import traceback
import atexit

from efl.utils.conversions cimport _ctouni, _touni
from efl.ethumb_client cimport Ethumb_Thumb_Orientation

cimport efl.ethumb.enums as enums

ETHUMB_THUMB_ORIENT_NONE = enums.ETHUMB_THUMB_ORIENT_NONE
ETHUMB_THUMB_ROTATE_90_CW = enums.ETHUMB_THUMB_ROTATE_90_CW
ETHUMB_THUMB_ROTATE_180 = enums.ETHUMB_THUMB_ROTATE_180
ETHUMB_THUMB_ROTATE_90_CCW = enums.ETHUMB_THUMB_ROTATE_90_CCW
ETHUMB_THUMB_FLIP_HORIZONTAL = enums.ETHUMB_THUMB_FLIP_HORIZONTAL
ETHUMB_THUMB_FLIP_VERTICAL = enums.ETHUMB_THUMB_FLIP_VERTICAL
ETHUMB_THUMB_FLIP_TRANSPOSE = enums.ETHUMB_THUMB_FLIP_TRANSPOSE
ETHUMB_THUMB_FLIP_TRANSVERSE = enums.ETHUMB_THUMB_FLIP_TRANSVERSE
ETHUMB_THUMB_ORIENT_ORIGINAL = enums.ETHUMB_THUMB_ORIENT_ORIGINAL

ETHUMB_THUMB_NORMAL = enums.ETHUMB_THUMB_NORMAL
ETHUMB_THUMB_LARGE = enums.ETHUMB_THUMB_LARGE

ETHUMB_THUMB_FDO = enums.ETHUMB_THUMB_FDO
ETHUMB_THUMB_JPEG = enums.ETHUMB_THUMB_JPEG
ETHUMB_THUMB_EET = enums.ETHUMB_THUMB_EET

ETHUMB_THUMB_KEEP_ASPECT = enums.ETHUMB_THUMB_KEEP_ASPECT
ETHUMB_THUMB_IGNORE_ASPECT = enums.ETHUMB_THUMB_IGNORE_ASPECT
ETHUMB_THUMB_CROP = enums.ETHUMB_THUMB_CROP


cdef void _connect_cb(void *data, Ethumb_Client *client, Eina_Bool success) with gil:
    cdef EthumbClient self = <EthumbClient>data
    s = bool(success)
    try:
        func, args, kargs = self._on_connect_callback
        func(self, s, *args, **kargs)
    except Exception:
        traceback.print_exc()

cdef void _on_server_die_cb(void *data, Ethumb_Client *client) with gil:
    cdef EthumbClient self = <EthumbClient>data
    if self._on_server_die_callback is not None:
        try:
            func, args, kargs = self._on_server_die_callback
            func(self, *args, **kargs)
        except Exception:
            traceback.print_exc()

    self.disconnect()

cdef void _generated_cb(void *data, Ethumb_Client *client, int id, const char *file, const char *key, const char *thumb_path, const char *thumb_key, Eina_Bool success) with gil:
    obj = <object>data
    (self, func, args, kargs) = obj
    status = bool(success != 0)
    try:
        func(self, id, _ctouni(file), _ctouni(key), _ctouni(thumb_path),
             _ctouni(thumb_key), status, *args, **kargs)
    except Exception:
        traceback.print_exc()

cdef void _generated_cb_free_data(void *data) with gil:
    obj = <object>data
    Py_DECREF(obj)

cdef void _thumb_exists_cb(void *data, Ethumb_Client *client, Ethumb_Exists *thread, Eina_Bool exists) with gil:
    #TODO
    print("Not implemented")


def init():
    """ Initialize the ethumb_client library.

    .. note:: You never need to call this function, it is automatically called
              on module import.

    """
    return ethumb_client_init()

def shutdown():
    """ Shutdown the ethumb_client library.

    .. note:: You never need to call this function, it is automatically called
              at exit.

    """
    ethumb_client_shutdown()


cdef class EthumbClient:
    """

    Client for Ethumbd server.

    .. versionadded:: 1.17

    This client is the recommended way to generate thumbnails with
    Ethumb. All you have to do is create a client instance, wait it to
    be connected to server, configure thumbnail parameters and then
    start feed it with file_set(), exists() generate(). Basic steps are:

    - instantiate EthumbClient, wait for func to be called with success.
    - set various parameters, like format and size.
    - loop on original files:

      - ``c.file_set(file)``
      - ``if not c.exists(): c.generate(generated_cb)``

    It is recommended explicit call to :py:func:`disconnect` function when
    you don't need the thumbnailer anymore.

    """

    def __init__(self, func, *args, **kargs):
        """ EthumbClient thumbnail generator.

        :param func: function to call when connection with server is
                     established.
        :param \*args: Any other parameters will be passed back in the
                      callback function
        :keyword \**kargs: Any other keyword parameters will be passed back
                           in the callback function

        Expected **func** signature::

            func(client, status, *args, **kargs)

        with status being **True** for successful connection or **False**
        on error.

        :raise TypeError: if **func** is not callable.
        :raise SystemError: if it was not possible to connect to
            server, allocate memory or use DBus.

        """
        if not callable(func):
            raise TypeError("Parameter 'func' must be callable")
        if self.obj == NULL:
            self._on_connect_callback = (func, args, kargs)
            self._on_server_die_callback = None
            self.obj = ethumb_client_connect(_connect_cb, <void*>self, NULL)
            if self.obj == NULL:
                raise SystemError("Error connecting to server.")
            else:
                ethumb_client_on_server_die_callback_set(
                    self.obj, _on_server_die_cb, <void*>self, NULL)

    def disconnect(self):
        """Explicitly request server disconnection.

        After this call object becomes shallow, that is operations
        will be void.

        """
        if self.obj != NULL:
            ethumb_client_disconnect(self.obj)
            self.obj = NULL
        self._on_connect_callback = None
        self._on_server_die_callback = None

    def __repr__(self):
        f, k = self.file
        tf, tk = self.thumb_path
        w, h = self.size

        format = ("FDO", "JPEG", "EET")[self.format]
        aspect = ("KEEP", "IGNORE", "CROP")[self.aspect]
        if self.aspect == 2:
            aspect = "CROP[%f, %f]" % self.crop
        return (
            "<%s(obj=%#x, file=(%r, %r), thumb=(%r, %r), "
            "size=%dx%d, format=%s, aspect=%s, quality=%d, compress=%d, "
            "dir_path=%r, category=%r)>"
            ) % (
            type(self).__name__, <uintptr_t><void *>self, f, k,
            tf, tk, w, h, format, aspect, self.quality, self.compress,
            self.dir_path, self.category
            )

    def on_server_die_callback_set(self, func, *args, **kargs):
        """Function to call when server dies.

        When server is dead there is nothing to do with this client
        anymore, just create a new one and start over, hope that
        server could be started and you could generate more
        thumbnails.

        :param func: function to call when server dies.
            Signature::

                func(client, *args, **kargs)

        :raise TypeError: if **func** is not callable or None.
        """
        if func is None:
            self._on_server_die_callback = None
        elif callable(func):
            self._on_server_die_callback = (func, args, kargs)
        else:
            raise TypeError("Parameter 'func' must be callable or None")

    def thumb_exists(self, callback=None, *args, **kwargs):
        """Checks if thumbnail already exists.

        If you want to avoid regenerating thumbnails, check if they
        already exist with this function.

        """
        cdef Ethumb_Client_Thumb_Exists_Cb cb = NULL
        cdef Ethumb_Exists *res

        if callback:
            if not callable(callback):
                raise TypeError("callback is not callable")
            cb = _thumb_exists_cb

            data = (args, kwargs)
            res = ethumb_client_thumb_exists(self.obj, cb, <void *>data)

        return False
        #TODO: handle return value

    def generate(self, func, *args, **kargs):
        """Ask EThumb server to generate the specified thumbnail.

        Thumbnail generation is asynchronous and depend on ecore main
        loop running. Given function will be called back with
        generation status if True is returned by this call. If False
        is returned, given function will not be called.

        Existing thumbnails will be overwritten with this call. Check
        if they already exist with :py:func:`exists` before calling.

        :param func: function to call on generation completion, even
            if failed or succeeded. Signature is::

                func(self, id, file, key, thumb_path, thumb_key, status, *args, **kargs)

            with status being True for successful generation or
            False on failure.

        :return: request identifier. Request can be canceled calling
            :py:func:`cancel` with given id. If an identifier is returned (>=
            0), then func is guaranteed to be called unless it is
            explicitly canceled.

        :raise TypeError: if **func** is not callable.
        :raise SystemError: if could not generate thumbnail, probably
           no :py:func:`file_set`.

        .. seealso:: :py:func:`cancel`, :py:func:`clear`, :py:func:`exists`
        """
        if not callable(func):
            raise TypeError("func must be callable")

        targs = (self, func, args, kargs)
        r = ethumb_client_generate(self.obj, _generated_cb, <void*>targs,
                                   _generated_cb_free_data)
        if r >= 0:
            Py_INCREF(targs)
            return r
        else:
            raise SystemError("could not generate thumbnail. "
                              "Did you set the file?")

    def generate_cancel(self, int id):
        """Cancel thumbnail request given its id.

        Calling this function aborts thumbnail generation and **func**
        given to :py:func:`generate` will not be called!

        :param id: identifier returned by :py:func:`generate`
        """
        ethumb_client_generate_cancel(self.obj, id, NULL, NULL, NULL)

    def generate_cancel_all(self):
        """Clear request queue, canceling all generation requests.

        This will abort all existing requests, no **func** given to
        :py:func:`generate` will be called.

        Same as calling :py:func:`cancel` in all exising requests.
        """
        ethumb_client_generate_cancel_all(self.obj)

    ## source file setup
    property file:
        """ The file to thumbnail.

        This is a tuple of 2 strings: ``path`` and ``key``.

        For convenience you can also assign a single string value (``path``),
        ignoring the key.

        :type: **str** or (**str**, **str**)

        :param path: path to thumbnail subject.
        :param key: path to key inside **path**, this is used to
           generate thumbnail of edje groups or images inside EET.

        :raise RuntimeError: on failure setting the property

        .. note:: setting this property will reset other thumbnail
            specifications. This is done to avoid one using the last thumb
            path for new images.

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                path, key = value
            else:
                path, key = value, None
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
            if ethumb_client_file_set(self.obj,
                    <const char *>path if path is not None else NULL,
                    <const char *>key if key is not None else NULL) == 0:
                raise RuntimeError("Cannot set file")

        def __get__(self):
            cdef:
                const char *path
                const char *key
            ethumb_client_file_get(self.obj, &path, &key)
            return (_ctouni(path), _ctouni(key))

    def file_free(self):
        """Zero/Reset file parameters.

        This call will reset file and thumb specifications.

        .. seealso:: :py:func:`file_set` and :py:func:`thumb_set`
        """
        ethumb_client_file_free(self.obj)

    property frame:
        """ The optional edje file used to generate a frame around the thumbnail

        This will create an edje object that will have image swallowed
        in. This can be used to simulate Polaroid or wood frames in
        the generated image. Remember it is bad to modify the original
        contents of thumbnails, but sometimes it's useful to have it
        composited and avoid runtime overhead.

        :type: (**str**, **str**, **str**) **writeonly**

        :param file: file path to edje.
        :param group: group inside edje to use.
        :param swallow: name of swallow part.

        :raise RuntimeError: on failure setting the property

        """
        def __set__(self, tuple value):
            theme, group, swallow = value
            if isinstance(theme, unicode): theme = PyUnicode_AsUTF8String(theme)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            if isinstance(swallow, unicode): swallow = PyUnicode_AsUTF8String(swallow)
            if ethumb_client_frame_set(self.obj,
                    <const char *>theme if theme is not None else NULL,
                    <const char *>group if group is not None else NULL,
                    <const char *>swallow if swallow is not None else NULL) == 0:
                raise RuntimeError("Cannot set frame")

    ## fine tune setup
    property fdo:
        """ Configure future requests to use FreeDesktop.Org preset.

        This is a preset to provide freedesktop.org (fdo) standard
        compliant thumbnails. That is, files are stored as JPEG under
        ~/.thumbnails/SIZE, with size being either normal (128x128) or
        large (256x256).

        :type: :ref:`Ethumb_Client_Thumb_FDO_Size` **writeonly**

        .. seealso:: :attr:`size`, :attr:`format`, :attr:`aspect`,
            :attr:`crop_align`, :attr:`category`, :attr:`dir_path`.

        """
        def __set__(self, Ethumb_Thumb_FDO_Size value):
            ethumb_client_fdo_set(self.obj, value)

    property size:
        """ The (custom) size of thumbnails.

        :type: (int **w**, int **w**)

        :param w: width, default is 128.
        :param h: height, default is 128.

        """
        def __set__(self, tuple value):
            w, h = value
            ethumb_client_size_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            ethumb_client_size_get(self.obj, &w, &h)
            return w, h

    property format:
        """ The fileformat for the thumbnails.

        Thumbnails are compressed; possible formats are PNG, JPEG and EET.

        :type: :ref:`Ethumb_Client_Thumb_Format`

        """
        def __set__(self, Ethumb_Thumb_Format value):
            ethumb_client_format_set(self.obj, value)

        def __get__(self):
            return ethumb_client_format_get(self.obj)

    property aspect:
        """ The aspect ratio policy.

        If aspect is kept (ETHUMB_THUMB_KEEP_ASPECT), then image will
        be rescaled so the largest dimension is not bigger than it's
        specified size (see :py:func:`size_get`) and the other dimension is
        resized in the same proportion. Example: size is 256x256,
        image is 1000x500, resulting thumbnail is 256x128.

        If aspect is ignored (ETHUMB_THUMB_IGNORE_ASPECT), then image
        will be distorted to match required thumbnail size. Example:
        size is 256x256, image is 1000x500, resulting thumbnail is
        256x256.

        If crop is required (ETHUMB_THUMB_CROP), then image will be
        cropped so the smallest dimension is not bigger than its
        specified size (see :py:func:`size_get`) and the other dimension
        will overflow, not being visible in the final image. How it
        will overflow is speficied by :py:func:`crop_set`
        alignment. Example: size is 256x256, image is 1000x500, crop
        alignment is 0.5, 0.5, resulting thumbnail is 256x256 with 250
        pixels from left and 250 pixels from right being lost, that is
        just the 500x500 central pixels of image will be considered
        for scaling.

        :type: :ref:`Ethumb_Client_Thumb_Aspect`

        """
        def __set__(self, Ethumb_Thumb_Aspect value):
            ethumb_client_aspect_set(self.obj, value)

        def __get__(self):
            return ethumb_client_aspect_get(self.obj)

    property orientation:
        """ The thumbnail rotation or flip.

        :type: :ref:`Ethumb_Client_Thumb_Orientation`

        """
        def __set__(self, Ethumb_Thumb_Orientation value):
            ethumb_client_orientation_set(self.obj, value)

        def __get__(self):
            return ethumb_client_orientation_get(self.obj)

    property crop_align:
        """ Crop alignment in use.

        :param x: horizontal alignment. 0.0 means left side will be
                  visible or right side is being lost. 1.0 means right side
                  will be visible or left side is being lost. 0.5 means just
                  center is visible, both sides will be lost. Default is 0.5.
        :param y: vertical alignment. 0.0 is top visible, 1.0 is
                  bottom visible, 0.5 is center visible. Default is 0.5

        :type: (float **x**, float **y**)

        """
        def __set__(self, tuple value):
            x, y = value
            ethumb_client_crop_align_set(self.obj, x, y)

        def __get__(self):
            cdef float x, y
            ethumb_client_crop_align_get(self.obj, &x, &y)
            return x, y

    property quality:
        """ The thumbnail compression quality.

        Value from 0 to 100, default is 80. The effect depends on the format
        being used, PNG will not use it.

        :type: int

        """
        def __set__(self, int value):
            ethumb_client_quality_set(self.obj, value)

        def __get__(self):
            return ethumb_client_quality_get(self.obj)

    property compress:
        """ The thumbnail compression rate.

        Value from 0 to 9, default is 9. The effect depends on the format being
        used, JPEG will not use it.

        :type: int

        """
        def __set__(self, int value):
            ethumb_client_compress_set(self.obj, value)

        def __get__(self):
            return ethumb_client_compress_get(self.obj)

    property dir_path:
        """ Configure where to store thumbnails in future requests.

        This is the base folder, a category folder is added to this path
        as a sub directory. Default is ``~/.thumbnails``

        :type: **str**

        """
        def __set__(self, path):
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            ethumb_client_dir_path_set(self.obj,
                    <const char *>path if path is not None else NULL)

        def __get__(self):
            cdef const char *path
            path = ethumb_client_dir_path_get(self.obj)
            return _ctouni(path)

    property category:
        """ Category directory to store thumbnails.

        Category sub directory to store thumbnail. Default is either "normal"
        or "large" for FDO compliant thumbnails or
        ``WIDTHxHEIGHT-ASPECT[-FRAMED]-FORMAT``. It can be a string or None to
        use auto generated names.

        :type: **str**

        """
        def __set__(self, cat):
            if isinstance(cat, unicode): cat = PyUnicode_AsUTF8String(cat)
            ethumb_client_category_set(self.obj,
                    <const char *>cat if cat is not None else NULL)

        def __get__(self):
            return _ctouni(ethumb_client_category_get(self.obj))

    property thumb_path:
        """ The complete path of the generated thumbnail.

        This is a tuple of 2 strings: ``path`` and ``key``.

        For convenience you can also assign a single string value (``path``),
        ignoring the key.

        :type: **str** or (**str**, **str**)

        :param path: path to generated thumbnail to use, this is an
           absolute path to file, overriding directory and category.
        :param key: path to key inside **path**, this is used to
           generate thumbnail inside EET files.

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                path, key = value
            else:
                path, key = value, None
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
            ethumb_client_thumb_path_set(self.obj,
                    <const char *>path if path is not None else NULL,
                    <const char *>key if key is not None else NULL)

        def __get__(self):
            cdef:
                const char *path
                const char *key
            ethumb_client_thumb_path_get(self.obj, &path, &key)
            return (_ctouni(path), _ctouni(key))

    ## video setup
    property video_time:
        """ The video time (duration) in seconds.

        :type: float  (**readonly**)

        """
        def __set__(self, float value):
            ethumb_client_video_time_set(self.obj, value)

    property video_start:
        """ The start point for video thumbnails.

        :type: float (from 0.0 to 1.0) (**readonly**)

        """
        def __set__(self, float value):
            ethumb_client_video_start_set(self.obj, value)

    property video_interval:
        """ The video frame interval, in seconds.

        This is useful for animated thumbnail and will define skip time before
        going to the next frame.

        .. note:: that video backends might not be able to
                  precisely skip that amount as it will depend on various
                  factors, including video encoding.

        :type: float (**readonly**)

        """
        def __set__(self, float value):
            ethumb_client_video_interval_set(self.obj, value)

    property video_ntimes:
        """ The number of times the video loops (if applicable).

        :type: int (**readonly**)

        """
        def __set__(self, int value):
            ethumb_client_video_ntimes_set(self.obj, value)

    property video_fps:
        """ The thumbnail framerate.

        Default to 10.

        :type: int (**readonly**)

        """
        def __set__(self, int value):
            ethumb_client_video_fps_set(self.obj, value)

    ## document setup
    property document_page:
        """ The page number to thumbnail in paged documents.

        :type: int

        """
        def __set__(self, int value):
            ethumb_client_document_page_set(self.obj, value)


init()
atexit.register(shutdown)
