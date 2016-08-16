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

:mod:`efl.ethumb` Module
########################

.. versionadded:: 1.17


Classes
=======

.. toctree::

   class-ethumb.rst


Enumerations
============

.. _Ethumb_Thumb_FDO_Size:

Ethumb_Thumb_FDO_Size
---------------------

.. data:: ETHUMB_THUMB_NORMAL

    128x128 as defined by FreeDesktop.Org standard

.. data:: ETHUMB_THUMB_LARGE

    256x256 as defined by FreeDesktop.Org standard


.. _Ethumb_Thumb_Format:

Ethumb_Thumb_Format
-------------------

.. data:: ETHUMB_THUMB_FDO

    PNG as defined by FreeDesktop.Org standard.

.. data:: ETHUMB_THUMB_JPEG

    JPEGs are often smaller and faster to read/write.

.. data:: ETHUMB_THUMB_EET

    EFL's own storage system, supports key parameter.


.. _Ethumb_Thumb_Aspect:

Ethumb_Thumb_Aspect
-------------------

.. data:: ETHUMB_THUMB_KEEP_ASPECT

    Keep original proportion between width and height

.. data:: ETHUMB_THUMB_IGNORE_ASPECT

    Ignore aspect and foce it to match thumbnail's width and height

.. data:: ETHUMB_THUMB_CROP

    keep aspect but crop (cut) the largest dimension


.. _Ethumb_Thumb_Orientation:

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

from libc.stdint cimport uintptr_t
from cpython cimport Py_INCREF, Py_DECREF, PyUnicode_AsUTF8String

from efl.eina cimport Eina_Bool
from efl.utils.conversions cimport _ctouni
from efl.c_ethumb cimport Ethumb as cEthumb, Ethumb_Thumb_FDO_Size, \
    Ethumb_Thumb_Format, Ethumb_Thumb_Aspect, Ethumb_Thumb_Orientation, \
    ethumb_init, ethumb_shutdown, \
    ethumb_new, ethumb_free, ethumb_file_set, ethumb_file_get, ethumb_file_free, \
    ethumb_thumb_path_set, ethumb_thumb_path_get, ethumb_exists, ethumb_generate, \
    ethumb_frame_set, ethumb_frame_get, ethumb_thumb_dir_path_set, \
    ethumb_thumb_dir_path_get, ethumb_thumb_category_set, \
    ethumb_thumb_category_get, ethumb_thumb_fdo_set, ethumb_thumb_size_set, \
    ethumb_thumb_size_get, ethumb_thumb_format_set, ethumb_thumb_format_get, \
    ethumb_thumb_aspect_set, ethumb_thumb_aspect_get, ethumb_thumb_orientation_set, \
    ethumb_thumb_orientation_get, ethumb_thumb_crop_align_set, \
    ethumb_thumb_crop_align_get, ethumb_thumb_quality_set, ethumb_thumb_quality_get, \
    ethumb_thumb_compress_set, ethumb_thumb_compress_get, \
    ethumb_video_start_set, ethumb_video_start_get, ethumb_video_time_set, \
    ethumb_video_time_get, ethumb_video_interval_set, ethumb_video_interval_get, \
    ethumb_video_ntimes_set, ethumb_video_ntimes_get, ethumb_video_fps_set, \
    ethumb_video_fps_get, ethumb_document_page_set, ethumb_document_page_get

import atexit
import traceback

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


cdef void _generate_cb(void *data, cEthumb *e, Eina_Bool success) with gil:
    obj = <object>data
    (self, func, args, kargs) = obj
    try:
        func(self, bool(success), *args, **kargs)
    except Exception:
        traceback.print_exc()

cdef void _generate_free_cb(void *data) with gil:
    obj = <object>data
    Py_DECREF(obj)


def init():
    """ Initialize the ethumb library.

    .. note:: You never need to call this function, it is automatically called
              on module import.

    """
    return ethumb_init()

def shutdown():
    """ Shutdown the ethumb library.

    .. note:: You never need to call this function, it is automatically called
              at exit.

    """
    ethumb_shutdown()


cdef class Ethumb(object):
    """

    Ethumb thumbnail generator.

    .. versionadded:: 1.17

    Use this class to generate thumbnails in the local process.

    .. seealso:: :class:`~efl.ethumb_client.EthumbClient` to generate thumbnails
        using a server (recommended).

    """
    def __cinit__(self):
        self.obj = NULL

    def __init__(self):
        """ Ethumb constructor. """
        assert self.obj == NULL, "Object must be clean"
        self.obj = ethumb_new()
        if self.obj == NULL:
            raise SystemError("Error creating the ethumb object.")

    def __repr__(self):
        return ("<%s object at %#x (file='%s', thumb='%s')>") % (
            type(self).__name__, <uintptr_t><void *>self,
            self.file[0], self.thumb_path[0])

    def delete(self):
        """ Delete the underlying C object.

        .. note:: You MUST call this function when you don't need the object
                  anymore, as it will free all internal used resources.

        """
        ethumb_free(self.obj)

    def file_free(self):
        """ Reset the source file information. """
        ethumb_file_free(self.obj)

    def exists(self):
        """ Test if the thumbnail already exists.

        :return: ``True`` if thumbnail exists, ``False`` otherwise

        """
        return bool(ethumb_exists(self.obj))

    def generate(self, func, *args, **kargs):
        """ Generate the thumbnail.

        Thumbnail generation is asynchronous and depend on ecore main
        loop running. Given function will be called back with
        generation status if True is returned by this call. If False
        is returned, given function will not be called.

        Existing thumbnails will be overwritten with this call. Check
        if they already exist with :func:`exists` before calling.

        :param func: function to call on generation completion, even
            if failed or succeeded. Signature is::

                func(Ethumb, success, *args, **kargs)

            with success being ``True`` for successful generation or
            ``False`` on failure.

        :return: ``True`` on success and ``False`` on failure

        :raise TypeError: if **func** is not callable.

        """
        cdef:
            tuple func_data

        if not callable(func):
            raise TypeError("func must be callable")

        func_data = (self, func, args, kargs)
        if ethumb_generate(self.obj, _generate_cb, <void*>func_data,
                           _generate_free_cb) != 0:
            Py_INCREF(func_data)
            return True
        else:
            return False

    ## source file properties
    property file:
        """ The file to thumbnail.

        This is a tuple of 2 strings: ``path`` and ``key``.

        ``path``: Is the file to use.

        ``key``: If path allows storing multiple resources in a single file
        (EET or Edje for instance), this is the name used to locate the right
        resource inside the file.

        For convenience you can also assign a single string value (``path``),
        ignoring the key.

        :type: **str** or (**str**, **str**)

        :raise RuntimeError: on failure setting the property

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                path, key = value
            else:
                path, key = value, None
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
            if ethumb_file_set(self.obj,
                    <const char *>path if path is not None else NULL,
                    <const char *>key if key is not None else NULL) == 0:
                raise RuntimeError("Cannot set file")

        def __get__(self):
            cdef:
                const char *path
                const char *key
            ethumb_file_get(self.obj, &path, &key)
            return (_ctouni(path), _ctouni(key))

    property frame:
        """ The optional edje file used to generate a frame around the thumbnail

        This can be used to simulate frames (wood, polaroid, etc) in the
        generated thumbnails.

        :type: (**str**, **str**, **str**): (theme_file, group_name, swallow_name)

        :raise RuntimeError: on failure setting the property

        """
        def __set__(self, tuple value):
            theme, group, swallow = value
            if isinstance(theme, unicode): theme = PyUnicode_AsUTF8String(theme)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            if isinstance(swallow, unicode): swallow = PyUnicode_AsUTF8String(swallow)
            if ethumb_frame_set(self.obj,
                    <const char *>theme if theme is not None else NULL,
                    <const char *>group if group is not None else NULL,
                    <const char *>swallow if swallow is not None else NULL) == 0:
                raise RuntimeError("Cannot set frame")

        def __get__(self):
            cdef:
                const char *theme
                const char *group
                const char *swallow
            ethumb_frame_get(self.obj, &theme, &group, &swallow)
            return _ctouni(theme), _ctouni(group), _ctouni(swallow)

    # destination thumb properties
    property thumb_path:
        """ The complete path of the generated thumbnail.

        This is a tuple of 2 strings: ``path`` and ``key``.

        ``path``: Is the complete file path.

        ``key``: If path allows storing multiple resources in a single file
        (EET or Edje for instance), this is the name used to locate the right
        resource inside the file.

        For convenience you can also assign a single string value (``path``),
        ignoring the key.

        :type: **str** or (**str**, **str**)

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                path, key = value
            else:
                path, key = value, None
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            if isinstance(key, unicode): key = PyUnicode_AsUTF8String(key)
            ethumb_thumb_path_set(self.obj,
                    <const char *>path if path is not None else NULL,
                    <const char *>key if key is not None else NULL)

        def __get__(self):
            cdef:
                const char *path
                const char *key
            ethumb_thumb_path_get(self.obj, &path, &key)
            return (_ctouni(path), _ctouni(key))

    property thumb_dir_path:
        """ Destination folder for the thumbnails.

        This is the base folder, a category folder is added to this path
        as a sub directory. Default is ``~/.thumbnails``

        :type: **str**

        """
        def __set__(self, path):
            if isinstance(path, unicode): path = PyUnicode_AsUTF8String(path)
            ethumb_thumb_dir_path_set(self.obj,
                    <const char *>path if path is not None else NULL)

        def __get__(self):
            cdef const char *path
            path = ethumb_thumb_dir_path_get(self.obj)
            return _ctouni(path)

    property thumb_category:
        """ The thumbnails category

        Category sub directory to store thumbnail. Default is either "normal"
        or "large" for FDO compliant thumbnails or
        ``WIDTHxHEIGHT-ASPECT[-FRAMED]-FORMAT``. It can be a string or None to
        use auto generated names.

        :type: **str**

        """
        def __set__(self, cat):
            if isinstance(cat, unicode): cat = PyUnicode_AsUTF8String(cat)
            ethumb_thumb_category_set(self.obj,
                    <const char *>cat if cat is not None else NULL)

        def __get__(self):
            return _ctouni(ethumb_thumb_category_get(self.obj))

    property thumb_fdo:
        """ Set a standard FDO thumbnail size

        This is a preset to provide freedesktop.org (fdo) standard
        compliant thumbnails. That is, files are stored as JPEG under
        ~/.thumbnails/SIZE, with size being either normal (128x128) or
        large (256x256).

        :type: :ref:`Ethumb_Thumb_FDO_Size` **writeonly**

        """
        def __set__(self, Ethumb_Thumb_FDO_Size value):
            ethumb_thumb_fdo_set(self.obj, value)

    property thumb_size:
        """ The size of thumbnails.

        :type: (int **width**, int **height**)

        """
        def __set__(self, tuple value):
            w, h = value
            ethumb_thumb_size_set(self.obj, w, h)

        def __get__(self):
            cdef int w, h
            ethumb_thumb_size_get(self.obj, &w, &h)
            return w, h

    property thumb_format:
        """ The fileformat for the thumbnails.

        Thumbnails are compressed; possible formats are PNG, JPEG and EET.

        :type: :ref:`Ethumb_Thumb_Format`

        """
        def __set__(self, Ethumb_Thumb_Format value):
            ethumb_thumb_format_set(self.obj, value)

        def __get__(self):
            return ethumb_thumb_format_get(self.obj)

    property thumb_aspect:
        """ The aspect ratio policy.

        When the source and thumbnail aspect ratios don't match, this policy
        sets how to adapt from the former to the latter: resize keeping source
        aspect ratio, resize ignoring it or crop.

        :type: :ref:`Ethumb_Thumb_Aspect`

        """
        def __set__(self, Ethumb_Thumb_Aspect value):
            ethumb_thumb_aspect_set(self.obj, value)

        def __get__(self):
            return ethumb_thumb_aspect_get(self.obj)

    property thumb_orientation:
        """ The thumbnail rotation or flip.

        :type: :ref:`Ethumb_Thumb_Orientation`

        """
        def __set__(self, Ethumb_Thumb_Orientation value):
            ethumb_thumb_orientation_set(self.obj, value)

        def __get__(self):
            return ethumb_thumb_orientation_get(self.obj)

    property thumb_crop_align:
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
            ethumb_thumb_crop_align_set(self.obj, x, y)

        def __get__(self):
            cdef:
                float x
                float y
            ethumb_thumb_crop_align_get(self.obj, &x, &y)
            return x, y

    property thumb_quality:
        """ The thumbnail compression quality.

        Value from 0 to 100, default is 80. The effect depends on the format
        being used, PNG will not use it.

        :type: int

        """
        def __set__(self, int value):
            ethumb_thumb_quality_set(self.obj, value)

        def __get__(self):
            return ethumb_thumb_quality_get(self.obj)

    property thumb_compress:
        """ The thumbnail compression rate.

        Value from 0 to 9, default is 9. The effect depends on the format being
        used, JPEG will not use it.

        :type: int

        """
        def __set__(self, int value):
            ethumb_thumb_compress_set(self.obj, value)

        def __get__(self):
            return ethumb_thumb_compress_get(self.obj)

    ## video related
    property video_start:
        """ The start point for video thumbnails.

        :type: float (from 0.0 to 1.0)

        """
        def __set__(self, float value):
            ethumb_video_start_set(self.obj, value)

        def __get__(self):
            return ethumb_video_start_get(self.obj)

    property video_time:
        """ The video time (duration) in seconds.

        :type: float

        """
        def __set__(self, float value):
            ethumb_video_time_set(self.obj, value)

        def __get__(self):
            return ethumb_video_time_get(self.obj)

    property video_interval:
        """ The video frame interval, in seconds.

        This is useful for animated thumbnail and will define skip time before
        going to the next frame.

        .. note:: that video backends might not be able to
                  precisely skip that amount as it will depend on various
                  factors, including video encoding.

        :type: float

        """
        def __set__(self, float value):
            ethumb_video_interval_set(self.obj, value)

        def __get__(self):
            return ethumb_video_interval_get(self.obj)

    property video_ntimes:
        """ The number of times the video loops (if applicable).

        :type: int

        """
        def __set__(self, int value):
            ethumb_video_ntimes_set(self.obj, value)

        def __get__(self):
            return ethumb_video_ntimes_get(self.obj)

    property video_fps:
        """ The thumbnail framerate.

        Default to 10.

        :type: int

        """
        def __set__(self, int value):
            ethumb_video_fps_set(self.obj, value)

        def __get__(self):
            return ethumb_video_fps_get(self.obj)

    ## document
    property document_page:
        """ The page number to thumbnail in paged documents.

        :type: int

        """
        def __set__(self, int value):
            ethumb_document_page_set(self.obj, value)

        def __get__(self):
            return ethumb_document_page_get(self.obj)

init()
atexit.register(shutdown)
