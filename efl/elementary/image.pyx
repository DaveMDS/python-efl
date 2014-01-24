# Copyright (C) 2007-2013 various contributors (see AUTHORS)
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
#

"""

Widget description
------------------

.. image:: /images/image-preview.png


An Elementary image object allows one to load and display an image
file on it, be it from a disk file or from a memory region.

Exceptionally, one may also load an Edje group as the contents of the
image. In this case, though, most of the functions of the image API will
act as a no-op.

One can tune various properties of the image, like:

- pre-scaling,
- smooth scaling,
- orientation,
- aspect ratio during resizes, etc.

An image object may also be made valid source and destination for drag
and drop actions by setting :py:attr:`~Image.editable`.

Signals that you can add callbacks for are:

- ``drop`` - This is called when a user has dropped an image
  typed object onto the object in question -- the
  event info argument is the path to that image file
- ``clicked`` - This is called when a user has clicked the image
- ``download,start`` - remote url download has started
- ``download,progress`` - url download in progress
- ``download,end`` - remote url download has finished
- ``download,error`` - remote url download has finished with errors

Enumerations
------------

.. _Elm_Image_Orient:

Image manipulation types
========================

.. data:: ELM_IMAGE_ORIENT_NONE

    No change

.. data:: ELM_IMAGE_ROTATE_90

    Rotate 90 degrees clockwise

.. data:: ELM_IMAGE_ROTATE_180

    Rotate 180 degrees clockwise

.. data:: ELM_IMAGE_ROTATE_270

    Rotate 270 degrees clockwise

.. data:: ELM_IMAGE_FLIP_HORIZONTAL

    Flip the image horizontally

.. data:: ELM_IMAGE_FLIP_VERTICAL

    Flip the image vertically

.. data:: ELM_IMAGE_FLIP_TRANSPOSE

    Flip the image along the y = (width - x) line (bottom-left to top-right)

.. data:: ELM_IMAGE_FLIP_TRANSVERSE

    Flip the image along the y = x line (top-left to bottom-right)

"""

from cpython cimport PyUnicode_AsUTF8String
from libc.stdint cimport uintptr_t

from efl.eo cimport _object_mapping_register, object_from_instance
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Object as evasObject

cimport enums

ELM_IMAGE_ORIENT_NONE = enums.ELM_IMAGE_ORIENT_NONE
ELM_IMAGE_ROTATE_90 = enums.ELM_IMAGE_ROTATE_90
ELM_IMAGE_ROTATE_180 = enums.ELM_IMAGE_ROTATE_180
ELM_IMAGE_ROTATE_270 = enums.ELM_IMAGE_ROTATE_270
ELM_IMAGE_FLIP_HORIZONTAL = enums.ELM_IMAGE_FLIP_HORIZONTAL
ELM_IMAGE_FLIP_VERTICAL = enums.ELM_IMAGE_FLIP_VERTICAL
ELM_IMAGE_FLIP_TRANSPOSE = enums.ELM_IMAGE_FLIP_TRANSPOSE
ELM_IMAGE_FLIP_TRANSVERSE = enums.ELM_IMAGE_FLIP_TRANSVERSE

def _cb_string_conv(uintptr_t addr):
    cdef const_char *s = <const_char *>addr
    return _ctouni(s) if s is not NULL else None

class ImageProgressInfo(object):
    """

    The info sent in the callback for the "download,progress" signals emitted
    by Image while downloading remote urls.

    :var now: The amount of data received so far.
    :var total: The total amount of data to download.

    .. versionadded:: 1.8

    """
    def __init__(self):
        self.now = 0
        self.total = 0

def _image_download_progress_conv(uintptr_t addr):
    cdef Elm_Image_Progress *ip = <Elm_Image_Progress *>addr
    ipi = ImageProgressInfo()
    ipi.now = ip.now
    ipi.total = ip.total
    return ipi

class ImageErrorInfo(object):
    """

    The info sent in the callback for the "download,error" signals emitted
    by Image when fail to download remote urls.

    :var status: The http error code (such as 401)
    :var open_error: TODO

    .. versionadded:: 1.8

    """
    def __init__(self):
        self.status = 0
        self.open_error = False

def _image_download_error_conv(uintptr_t addr):
    cdef Elm_Image_Error *ie = <Elm_Image_Error *>addr
    iei = ImageErrorInfo()
    iei.status = ie.status
    iei.open_error = ie.open_error
    return iei



cdef class Image(Object):

    """This is the class that actually implements the widget."""

    def __init__(self, evasObject parent, *args, **kwargs):
        self._set_obj(elm_image_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    #def memfile_set(self, img, size, format, key):
        # NOTE: remove _cfruni if this is implemented
        #return bool(elm_image_memfile_set(self.obj, img, size, _cfruni(format), _cfruni(key)))

    property file:
        """The file (and edje group) that will be used as the image's source.

        .. note:: Setting this will trigger the Edje file case based on the
            extension of the ``file`` string (expects ``".edj"``, for this
            case). If one wants to force this type of file independently of
            the extension, :py:attr:`file_edje` must be used, instead.

        :type: unicode **file** or (unicode **file**, unicode **group**)
        :raise RuntimeError: when setting the file fails

        .. versionchanged:: 1.8
            Raises RuntimeError when setting the file fails, instead of
            returning a bool.

        """
        def __set__(self, value):
            if isinstance(value, tuple):
                filename, group = value
            else:
                filename = value
                group = None
            if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
            if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
            if not elm_image_file_set(self.obj,
                <const_char *>filename if filename is not None else NULL,
                <const_char *>group if group is not None else NULL):
                    raise RuntimeError("Could not set file.")

        def __get__(self):
            cdef:
                const_char *filename
                const_char *group

            elm_image_file_get(self.obj, &filename, &group)
            return (_ctouni(filename), _ctouni(group))

    def file_set(self, filename, group = None):
        if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
        if isinstance(group, unicode): group = PyUnicode_AsUTF8String(group)
        if not elm_image_file_set(self.obj,
            <const_char *>filename if filename is not None else NULL,
            <const_char *>group if group is not None else NULL):
                raise RuntimeError("Could not set file.")
    def file_get(self):
        cdef:
            const_char *filename
            const_char *group

        elm_image_file_get(self.obj, &filename, &group)
        return (_ctouni(filename), _ctouni(group))

    property smooth:
        """The smooth effect for an image.

        The scaling algorithm to be used when scaling the image. Smooth
        scaling provides a better resulting image, but is slower.

        The smooth scaling should be disabled when making animations that
        change the image size, since it will be faster. Animations that
        don't require resizing of the image can keep the smooth scaling
        enabled (even if the image is already scaled, since the scaled image
        will be cached).

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_smooth_get(self.obj))

        def __set__(self, smooth):
            elm_image_smooth_set(self.obj, smooth)

    def smooth_set(self, smooth):
        elm_image_smooth_set(self.obj, smooth)
    def smooth_get(self):
        return bool(elm_image_smooth_get(self.obj))

    property object_size:
        """The current size of the image.

        This is the real size of the image, not the size of the object.

        :type: (int **width**, int **height**)

        """
        def __get__(self):
            cdef int width, height
            elm_image_object_size_get(self.obj, &width, &height)
            return (width, height)

    def object_size_get(self):
        cdef int width, height
        elm_image_object_size_get(self.obj, &width, &height)
        return (width, height)

    property no_scale:
        """Whether to disable scaling of this object.

        This disables scaling of the elm_image widget through the property
        :py:attr:`efl.elementary.object.Object.scale`. However, this does not
        affect the widget size/resize in any way. For that effect, take a look
        at :py:attr:`resizable`.

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_no_scale_get(self.obj))
        def __set__(self, no_scale):
            elm_image_no_scale_set(self.obj, no_scale)

    def no_scale_set(self, no_scale):
        elm_image_no_scale_set(self.obj, no_scale)
    def no_scale_get(self):
        return bool(elm_image_no_scale_get(self.obj))

    property resizable:
        """Whether the object is (up/down) resizable.

        This limits the image resize ability. If  set to *False*, the
        object can't have its height or width resized to a value higher than
        the original image size. Same is valid for *size_down*.

        :type: (bool **size_up**, bool **size_down**)

        """
        def __get__(self):
            cdef Eina_Bool size_up, size_down
            elm_image_resizable_get(self.obj, &size_up, &size_down)
            return (size_up, size_down)

        def __set__(self, value):
            size_up, size_down = value
            elm_image_resizable_set(self.obj, size_up, size_down)

    def resizable_set(self, size_up, size_down):
        elm_image_resizable_set(self.obj, size_up, size_down)
    def resizable_get(self):
        cdef Eina_Bool size_up, size_down
        elm_image_resizable_get(self.obj, &size_up, &size_down)
        return (size_up, size_down)

    property fill_outside:
        """Whether the image fills the entire object area, when keeping the
        aspect ratio.

        When the image should keep its aspect ratio even if resized to
        another aspect ratio, there are two possibilities to resize it: keep
        the entire image inside the limits of height and width of the object
        (*fill_outside* is *False*) or let the extra width or height go
        outside of the object, and the image will fill the entire object
        (*fill_outside* is *True*).

        .. note:: This option will have no effect if :py:attr:`aspect_fixed`
            is set to *False*.

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_fill_outside_get(self.obj))

        def __set__(self, fill_outside):
            elm_image_fill_outside_set(self.obj, fill_outside)

    def fill_outside_set(self, fill_outside):
        elm_image_fill_outside_set(self.obj, fill_outside)
    def fill_outside_get(self):
        return bool(elm_image_fill_outside_get(self.obj))

    property preload_disabled:
        """Enable or disable preloading of the image

        :type: bool

        """
        def __set__(self, disabled):
            elm_image_preload_disabled_set(self.obj, disabled)

    def preload_disabled_set(self, disabled):
        elm_image_preload_disabled_set(self.obj, disabled)

    property prescale:
        """The prescale size for the image

        This is the size for pixmap representation of the given image. It
        allows the image to be loaded already in the specified size,
        reducing the memory usage and load time when loading a big image
        with load size set to a smaller size.

        It's equivalent to the
        :py:attr:`efl.elementary.background.Background.load_size` property for bg.

        .. note:: this is just a hint, the real size of the pixmap may differ
            depending on the type of image being loaded, being bigger than
            requested.

        :type: int

        """
        def __get__(self):
            return elm_image_prescale_get(self.obj)
        def __set__(self, size):
            elm_image_prescale_set(self.obj, size)

    def prescale_set(self, size):
        elm_image_prescale_set(self.obj, size)
    def prescale_get(self):
        return elm_image_prescale_get(self.obj)

    property orient:
        """The image orientation.

        Setting this allows to rotate or flip the given image.

        :type: :ref:`Elm_Image_Orient`

        """
        def __get__(self):
            return elm_image_orient_get(self.obj)
        def __set__(self, orientation):
            elm_image_orient_set(self.obj, orientation)

    def orient_set(self, orientation):
        elm_image_orient_set(self.obj, orientation)
    def orient_get(self):
        return elm_image_orient_get(self.obj)

    property editable:
        """Whether the image is 'editable'.

        This means the image is a valid drag target for drag and drop, and
        can be cut or pasted too. Default is *False*.

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_editable_get(self.obj))
        def __set__(self, editable):
            elm_image_editable_set(self.obj, editable)

    def editable_set(self, editable):
        elm_image_editable_set(self.obj, editable)
    def editable_get(self):
        return bool(elm_image_editable_get(self.obj))

    property object:
        """Get the inlined image object of the image widget.

        This function allows one to get the underlying ``Evas_Object`` of
        type Image from this elementary widget. It can be useful to do
        things like get the pixel data, save the image to a file, etc.

        .. note:: Be careful to not manipulate it, as it is under control of
            elementary.

        :type: :py:class:`efl.evas.Image`

        """
        def __get__(self):
            return object_from_instance(elm_image_object_get(self.obj))

    def object_get(self):
        return object_from_instance(elm_image_object_get(self.obj))

    property aspect_fixed:
        """Whether the original aspect ratio of the image should be kept on
        resize.

        The original aspect ratio (width / height) of the image is usually
        distorted to match the object's size. Enabling this option will
        retain this original aspect, and the way that the image is fit into
        the object's area depends on the option set by
        :py:attr:`fill_outside`.

        .. seealso:: :py:attr:`fill_outside`

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_aspect_fixed_get(self.obj))
        def __set__(self, fixed):
            elm_image_aspect_fixed_set(self.obj, fixed)

    def aspect_fixed_set(self, fixed):
        elm_image_aspect_fixed_set(self.obj, fixed)
    def aspect_fixed_get(self):
        return bool(elm_image_aspect_fixed_get(self.obj))

    property animated_available:
        """Whether an image object supports animation or not.

        This returns if this Elementary image object's internal
        image can be animated. Currently Evas only supports GIF
        animation. If the return value is **False**, other
        ``animated_xxx`` API calls won't work.

        .. seealso:: :py:attr:`animated`

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_animated_available_get(self.obj))

    def animated_available_get(self):
        return bool(elm_image_animated_available_get(self.obj))

    property animated:
        """Whether an image object (which supports animation) is to
        animate itself or not.

        An image object, even if it supports animation, will be displayed
        by default without animation. Set this to ``True`` to enable its
        animation. To start or stop the
        animation, actually, use :py:attr:`animated_play`.

        .. seealso:: :py:attr:`animated_available` :py:attr:`animated_play`

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_animated_get(self.obj))
        def __set__(self, animated):
            elm_image_animated_set(self.obj, animated)

    def animated_set(self, animated):
        elm_image_animated_set(self.obj, animated)
    def animated_get(self):
        return bool(elm_image_animated_get(self.obj))

    property animated_play:
        """Start or stop an image object's animation.

        To actually start playing any image object's animation, if it
        supports it, one must do something like::

            if img.animated_available:
                img.animated = True
                img.animated_play = True

        :py:attr:`animated` will enable animation on the image, **but not start it yet**.
        This is the property one uses to start and stop animation on
        an image object or get whether it is animating or not.

        .. seealso:: :py:attr:`animated_available` :py:attr:`animated`

        :type: bool

        """
        def __get__(self):
            return bool(elm_image_animated_play_get(self.obj))
        def __set__(self, play):
            elm_image_animated_play_set(self.obj, play)

    def animated_play_set(self, play):
        elm_image_animated_play_set(self.obj, play)
    def animated_play_get(self):
        return bool(elm_image_animated_play_get(self.obj))

    def callback_clicked_add(self, func, *args, **kwargs):
        """This is called when a user has clicked the image."""
        self._callback_add("clicked", func, *args, **kwargs)

    def callback_clicked_del(self, func):
        self._callback_del("clicked", func)

    def callback_drop_add(self, func, *args, **kwargs):
        """This is called when a user has dropped an image typed object onto
        the object in question -- the event info argument is the path to that
        image file."""
        self._callback_add_full("drop", _cb_string_conv, func, *args, **kwargs)

    def callback_drop_del(self, func):
        self._callback_del_full("drop", _cb_string_conv, func)

    def callback_download_start_add(self, func, *args, **kwargs):
        """This is called when you set a remote url and the download start

        .. versionadded:: 1.8

        """
        self._callback_add("download,start", func, *args, **kwargs)

    def callback_download_start_del(self, func):
        self._callback_del("download,start", func)

    def callback_download_progress_add(self, func, *args, **kwargs):
        """This is called while a remote image download is in progress

        .. versionadded:: 1.8

        """
        self._callback_add_full("download,progress", _image_download_progress_conv, func, *args, **kwargs)

    def callback_download_progress_del(self, func):
        self._callback_del_full("download,progress", _image_download_progress_conv, func)

    def callback_download_done_add(self, func, *args, **kwargs):
        """This is called when you set a remote url and the download finish

        .. versionadded:: 1.8

        """
        self._callback_add("download,done", func, *args, **kwargs)

    def callback_download_done_del(self, func):
        self._callback_del("download,end", func)

    def callback_download_error_add(self, func, *args, **kwargs):
        """This is called in case a download has errors

        .. versionadded:: 1.8

        """
        self._callback_add_full("download,error", _image_download_error_conv, func, *args, **kwargs)

    def callback_download_error_del(self, func):
        self._callback_add_full("download,error", _image_download_error_conv, func)


_object_mapping_register("Elm_Image", Image)
