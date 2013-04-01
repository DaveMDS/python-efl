# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.


# TODO: remove me after usage is update to new buffer api
cdef extern from "Python.h":
    int PyObject_AsReadBuffer(obj, void **buffer, Py_ssize_t *buffer_len) except -1


# TODO needed? neem like the frong place to define fill/rotation stuff...
# def image_mask_fill(Image source, Image mask, Image surface, int x_mask, int y_mask, int x_surface, int y_surface):
#     evas_object_image_mask_fill(source.obj, mask.obj, surface.obj,
#                                 x_mask, y_mask, x_surface, y_surface)

cdef int _data_size_get(Evas_Object *obj):
    cdef int stride, h, bpp, cspace, have_alpha
    stride = evas_object_image_stride_get(obj)
    evas_object_image_size_get(obj, NULL, &h)
    cspace = evas_object_image_colorspace_get(obj)
    have_alpha = evas_object_image_alpha_get(obj)
    if cspace == EVAS_COLORSPACE_ARGB8888:
        bpp = 4
    elif cspace == EVAS_COLORSPACE_RGB565_A5P:
        if have_alpha == 0:
            bpp = 2
        else:
            bpp = 3
    else:
        return 0 # XXX not supported.

    return stride * h * bpp


cdef class Image(Object):
    """

    Image from file or buffer.

    .. rubric:: Introduction

    Image will consider the object's :py:func:`geometry<geometry_set()>`
    as the area to paint with tiles as described by :py:func:`fill_set()` and the
    real pixels (image data) will be stored as described by
    :py:func:`image_size<image_size_set()>`. This can be tricky to understand at
    first, but gives flexibility to do everything.

    If an image is loaded from file, it will have
    :py:func:`image_size<image_size_set()>` set to its original size, unless some
    other size was set with :py:func:`load_size_set()`, :py:func:`load_dpi_set()` or
    :py:func:`load_scale_down_set()`.

    Pixels will be scaled to match size specified by :py:func:`fill_set()`
    using either sampled or smooth methods, these can be specified with
    :py:func:`smooth_scale_set()`. The scale will consider borders as specified by
    :py:func:`border_set()` and :py:func:`border_center_fill_set()`, while the former specify
    the border dimensions (top and bottom will scale horizontally, while
    right and left will do vertically, corners are kept unscaled), the latter
    says whenever the center of the image will be used (useful to create
    frames).

    Contents will be tiled using :py::`fill_set()` information in order to paint
    :py:func:`geometry<Object.geometry_set()>`, so if you want an image to be drawn
    just once, you should match every :py:func:`geometry_set(x, y, w, h)` by a call
    to :py:func:`fill_set(0, 0, w, h)`. :py:class:`FilledImage` does that for you.

    .. rubric:: Pixel data and buffer API

    Images implement the Python Buffer API, so it's possible to use it
    where buffers are expected (ie: file.write()). Available data will
    depend on :py:func:`alpha<alpha_set()>`, :py:func:`colorspace<colorspace_set()>` and
    :py:func:`image_size<image_size_set()>`, lines should be considered multiple
    of :py:func:`stride<stride_get()>`, with the following considerations about
    colorspace:

    - **EVAS_COLORSPACE_ARGB8888:** This pixel format is a linear block of
        pixels, starting at the top-left row by row until the bottom right of
        the image or pixel region. All pixels are 32-bit unsigned int's with
        the high-byte being alpha and the low byte being blue in the format
        ARGB. Alpha may or may not be used by evas depending on the alpha flag
        of the image, but if not used, should be set to 0xff anyway.
        This colorspace uses premultiplied alpha. That means that R, G and B
        cannot exceed A in value. The conversion from non-premultiplied
        colorspace is::

            R = (r * a) / 255; G = (g * a) / 255; B = (b * a) / 255;

        So 50% transparent blue will be: 0x80000080. This will not be "dark" -
        just 50% transparent. Values are 0 == black, 255 == solid or full
        red, green or blue.
    - **EVAS_COLORSPACE_RGB565_A5P:** In the process of being implemented in
        1 engine only. This may change. This is a pointer to image data for
        16-bit half-word pixel data in 16bpp RGB 565 format (5 bits red,
        6 bits green, 5 bits blue), with the high-byte containing red and the
        low byte containing blue, per pixel. This data is packed row by row
        from the top-left to the bottom right. If the image has an alpha
        channel enabled there will be an extra alpha plane **after** the color
        pixel plane. If not, then this data will not exist and should not be
        accessed in any way. This plane is a set of pixels with 1 byte per
        pixel defining the alpha values of all pixels in the image from
        the top-left to the bottom right of the image, row by row. Even though
        the values of the alpha pixels can be 0 to 255, only values 0 through
        to 31 are used, 31 being solid and 0 being transparent.
        RGB values can be 0 to 31 for red and blue and 0 to 63 for green, with 0
        being black and 31 or 63 being full red, green or blue respectively.
        This colorspace is also pre-multiplied like EVAS_COLORSPACE_ARGB8888 so::

            R = (r * a) / 32; G = (g * a) / 32; B = (b * a) / 32;

    .. note:: if an image is resized it will **tile** it's contents respecting
        geometry set by :py:func:`fill_set()`, so if you want the contents to be
        **scaled** you need to call :py:func:`fill_set()` with ``x=0, y=0, w=new_width,
        h=new_height``, or you should use :py:class:`FilledImage` instead.

    :param canvas: Evas canvas for this object
    :type canvas: Canvas
    :keyword size: Width and height
    :type size: tuple of ints
    :keyword pos: X and Y
    :type pos: tuple of ints
    :keyword geometry: X, Y, width, height
    :type geometry: tuple of ints
    :keyword color: R, G, B, A
    :type color: tuple of ints
    :keyword name: Object name
    :type name: string
    :keyword file: File name
    :type file: string

    """
    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(evas_object_image_add(canvas.obj))
        self._set_common_params(**kargs)

    def _set_common_params(self, file=None, **kargs):
        if file:
            if isinstance(file, str):
                file = (file, None)
            self.file_set(*file)
        Object._set_common_params(self, **kargs)

    def file_set(self, filename, key=None):
        """Set the image to display a file.

        :param filename: file that contains the image.
        :type filename: string
        :param key: required for some file formats, like EET.
        :type key: string
        :raise EvasLoadError: on load error.

        """
        cdef int err
        if isinstance(filename, unicode): filename = filename.encode("UTF-8")
        if isinstance(key, unicode): key = key.encode("UTF-8")
        evas_object_image_file_set(self.obj,
            <const_char *>filename if filename is not None else NULL,
            <const_char *>key if key is not None else NULL)
        err = evas_object_image_load_error_get(self.obj)
        if err != EVAS_LOAD_ERROR_NONE:
            raise EvasLoadError(err, filename, key)

    def file_get(self):
        """:return: The filename of the image.
        :rtype: tuple of str

        """
        cdef const_char *file, *key
        evas_object_image_file_get(self.obj, &file, &key)
        return (_ctouni(file), _ctouni(key))

    property file:
        def __get__(self):
            return self.file_get()

        def __set__(self, value):
            if isinstance(value, str):
                value = (value, None)
            self.file_set(*value)

    def load_error_get(self):
        """:return: The load error.
        :rtype: int

        """
        return evas_object_image_load_error_get(self.obj)

    property load_error:
        def __get__(self):
            return self.load_error_get()

    def border_get(self):
        """:return: How much of each border is not to be scaled.
        :rtype: tuple of ints

        """
        cdef int left, right, top, bottom
        evas_object_image_border_get(self.obj, &left, &right, &top, &bottom)
        return (left, right, top, bottom)

    def border_set(self, int left, int right, int top, int bottom):
        """Sets how much of each border is not to be scaled.

        When rendering, the image may be scaled to fit the size of the
        image object.  This function sets what area around the border of
        the image is not to be scaled.  This sort of function is useful for
        widget theming, where, for example, buttons may be of varying
        sizes, but the border size must remain constant.

        :param left:
        :type left: int
        :param right:
        :type right: int
        :param top:
        :type top: int
        :param bottom:
        :type bottom: int

        """
        evas_object_image_border_set(self.obj, left, right, top, bottom)

    property border:
        def __get__(self):
            return self.border_get()

        def __set__(self, spec):
            self.border_set(*spec)

    def border_center_fill_get(self):
        """
        :return: Whether the center part of an image (not the border) should
            be drawn.

        :rtype: bool

        """
        return bool(evas_object_image_border_center_fill_get(self.obj))

    def border_center_fill_set(self, int value):
        """Sets if the center part of an image (not the border) should be drawn

        .. seealso:: :py:func:`border_set()`

        When rendering, the image may be scaled to fit the size of the
        image object.  This function sets if the center part of the scaled
        image is to be drawn or left completely blank. Very useful for frames
        and decorations.

        """
        evas_object_image_border_center_fill_set(self.obj, value)

    property border_center_fill:
        def __get__(self):
            return self.border_center_fill_get()

        def __set__(self, int value):
            self.border_center_fill_set(value)

    def fill_get(self):
        """:return: The rectangle that the image will be drawn to.
        :rtype: tuple of ints

        """
        cdef int x, y, w, h
        evas_object_image_fill_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    def fill_set(self, int x, int y, int w, int h):
        """Sets the rectangle that the image will be drawn to.

        Note that the image will be **tiled** around this one rectangle.
        To have only one copy of the image drawn, **x** and **y** must be
        0 and **w** and **h** need to be the width and height of the object
        respectively.

        The default values for the fill parameters is **x** = 0, **y** = 0,
        **w** = 1 and **h** = 1.

        :param x: X coordinate
        :param y: Y coordinate
        :param w: Width
        :param h: Height
        """
        evas_object_image_fill_set(self.obj, x, y, w, h)

    property fill:
        def __get__(self):
            return self.fill_get()

        def __set__(self, spec):
            self.fill_set(*spec)

    def image_size_get(self):
        """:rtype: tuple of ints
        :return: The original size of the image being displayed.

        """
        cdef int w, h
        evas_object_image_size_get(self.obj, &w, &h)
        return (w, h)

    def image_size_set(self, int w, int h):
        """Sets the size of the image to be displayed.

        This function will scale down or crop the image so that it is
        treated as if it were at the given size.  If the size given is
        smaller than the image, it will be cropped.  If the size given is
        larger, then the image will be treated as if it were in the upper
        left hand corner of a larger image that is otherwise transparent.

        This method will force pixels to be allocated if they weren't, so
        you should use this before accessing the image as a buffer in order
        to allocate the pixels.

        This method will recalculate :py:attr:`stride` (:py:func:`stride_get()`) based on
        width and the colorspace.

        :param w: Width
        :type w: int
        :param h: Height
        :type h: int

        """
        evas_object_image_size_set(self.obj, w, h)

    property image_size:
        def __get__(self):
            return self.image_size_get()

        def __set__(self, spec):
            self.image_size_set(*spec)

    def stride_get(self):
        """Get the row stride (in pixels) being used to draw this image.

        While image have logical dimension of width and height set by
        :py:func:`image_size_set()`, the line can be a bit larger than width to
        improve memory alignment.

        The amount of bytes will change based on colorspace, while using
        ARGB8888 it will be multiple of 4 bytes, with colors being laid
        out interleaved, RGB565_A5P will have the first part being RGB
        data using stride in multiple of 2 bytes and after that an
        alpha plane with data using stride in multiple of 1 byte.

        .. note:: This value can change after :py:func:`image_size_set()`.
        .. note:: Unit is pixels, not bytes.

        :return: The row stride (in pixels) being used to draw this image.
        :rtype: int

        """
        return evas_object_image_stride_get(self.obj)

    property stride:
        def __get__(self):
            return self.stride_get()

    def alpha_get(self):
        """:return: Enable or disable alpha channel.
        :rtype: bool

        """
        return bool(evas_object_image_alpha_get(self.obj))

    def alpha_set(self, value):
        """:param value: Enable or disable alpha channel.
        :type value: bool

        """
        evas_object_image_alpha_set(self.obj, value)

    property alpha:
        def __get__(self):
            return self.alpha_get()

        def __set__(self, int value):
            self.alpha_set(value)

    def smooth_scale_get(self):
        """:return: Enable or disable smooth scaling.
        :rtype: bool

        """
        return bool(evas_object_image_smooth_scale_get(self.obj))

    def smooth_scale_set(self, value):
        """:param value: Enable or disable smooth scaling.
        :type value: bool

        """
        evas_object_image_smooth_scale_set(self.obj, value)

    property smooth_scale:
        def __get__(self):
            return self.smooth_scale_get()

        def __set__(self, int value):
            self.smooth_scale_set(value)

    def pixels_dirty_get(self):
        """:return: Whether the pixels are marked as dirty.
        :rtype: bool

        """
        return bool(evas_object_image_pixels_dirty_get(self.obj))

    def pixels_dirty_set(self, value):
        """:param value: Mark or unmark pixels as dirty.
        :type value: bool

        """
        evas_object_image_pixels_dirty_set(self.obj, value)

    property pixels_dirty:
        def __get__(self):
            return self.pixels_dirty_get()

        def __set__(self, int value):
            self.pixels_dirty_set(value)

    def load_dpi_get(self):
        """:return: Dots-per-inch to be used at image load time.
        :rtype: float

        """
        return evas_object_image_load_dpi_get(self.obj)

    def load_dpi_set(self, double value):
        """:param value: Dots-per-inch to be used at image load time.
        :type value: double

        """
        evas_object_image_load_dpi_set(self.obj, value)

    property load_dpi:
        def __get__(self):
            return self.load_dpi_get()

        def __set__(self, int value):
            self.load_dpi_set(value)

    def load_size_get(self):
        """:return: The size you want the image to be loaded with.
        :rtype: tuple of ints

        """
        cdef int w, h
        evas_object_image_load_size_get(self.obj, &w, &h)
        return (w, h)

    def load_size_set(self, int w, int h):
        """Set size you want image loaded.

        Loads image to the desired size, saving memory when loading large
        files.

        :param w: Width
        :type w: int
        :param h: Height
        :type h: int

        """
        evas_object_image_load_size_set(self.obj, w, h)

    property load_size:
        def __get__(self):
            return self.load_size_get()

        def __set__(self, spec):
            self.load_size_set(*spec)

    def load_scale_down_get(self):
        """:return: Get the scale down value.
        :rtype: int

        """
        return evas_object_image_load_scale_down_get(self.obj)

    def load_scale_down_set(self, int value):
        """:param value: Set scale down loaded image by the given amount.
        :type value: int

        """
        evas_object_image_load_scale_down_set(self.obj, value)

    property load_scale_down:
        def __get__(self):
            return self.load_scale_down_get()

        def __set__(self, int value):
            self.load_scale_down_set(value)

    def colorspace_get(self):
        """:return: The colorspace of image data (pixels).
        :rtype: int

        """
        return evas_object_image_colorspace_get(self.obj)

    def colorspace_set(self, int value):
        """Set the colorspace of image data (pixels).

        May be one of (subject to engine implementation):

        - **EVAS_COLORSPACE_ARGB8888** ARGB 32 bits per pixel, high-byte is
            Alpha, accessed 1 32bit word at a time.
        - **EVAS_COLORSPACE_YCBCR422P601_PL** YCbCr 4:2:2 Planar, ITU.BT-601
            specifications. The data poitned to is just an array of row
            pointer, pointing to the Y rows, then the Cb, then Cr rows.
        - **EVAS_COLORSPACE_YCBCR422P709_PL** YCbCr 4:2:2 Planar, ITU.BT-709
            specifications. The data poitned to is just an array of row
            pointer, pointing to the Y rows, then the Cb, then Cr rows.
        - **EVAS_COLORSPACE_RGB565_A5P** 16bit rgb565 + Alpha plane at end -
            5 bits of the 8 being used per alpha byte.

        :param value: The colorspace of image data (pixels)
        :type value: Evas_Colorspace

        """
        evas_object_image_colorspace_set(self.obj, <Evas_Colorspace>value)

    property colorspace:
        def __get__(self):
            return self.colorspace_get()

        def __set__(self, int value):
            self.colorspace_set(value)

    def preload(self, int cancel=0):
        """Preload image data asynchronously.

        This will request Evas to create a thread to load image data
        from file, decompress and convert to pre-multiplied format
        used internally.

        This will emit EVAS_CALLBACK_IMAGE_PRELOADED event callback
        when it is done, see on_image_preloaded_add().

        If one calls this function with cancel=True, then preload will
        be canceled and load will happen when image is made visible.

        If image is required before preload is done (ie: pixels are
        retrieved by user or when drawing), then it will be
        automatically canceled and load will be synchronous.

        :param cancel: if True, will cancel preload request.
        :type cancel: bool

        @see: :py::`on_image_preloaded_add`

        """
        evas_object_image_preload(self.obj, cancel)


    def reload(self):
        """Force reload of image data."""
        evas_object_image_reload(self.obj)

    def save(self, const_char *filename, key=None, flags=None):
        """Save image to file.

        :param filename: where to save.
        :type filename: string
        :param key: some formats may require a key, EET for example.
        :type key: string
        :param flags: string of extra flags (separated by space), like
            "quality=85 compress=9".
        :type flags: string

        """
        cdef const_char *k, *f
        if key:
            k = key
        else:
            k = NULL

        if flags:
            f = flags
        else:
            f = NULL
        evas_object_image_save(self.obj, filename, k, f)

    def __getsegcount__(self, Py_ssize_t *p_len):
        if p_len == NULL:
            return 1

        p_len[0] = _data_size_get(self.obj)
        return 1

    def __getreadbuffer__(self, int segment, void **ptr):
        ptr[0] = evas_object_image_data_get(self.obj, 0)
        if ptr[0] == NULL:
            raise SystemError("image has no allocated buffer.")
        # XXX: keep Evas pixels_checked_out counter to 0 and allow
        # XXX: image to reload and unload its data.
        # XXX: may cause problems if buffer is used after these
        # XXX: functions are called, but buffers aren't expected to
        # XXX: live much.
        evas_object_image_data_set(self.obj, ptr[0])
        return _data_size_get(self.obj)

    def __getwritebuffer__(self, int segment, void **ptr):
        ptr[0] = evas_object_image_data_get(self.obj, 1)
        if ptr[0] == NULL:
            raise SystemError("image has no allocated buffer.")
        # XXX: keep Evas pixels_checked_out counter to 0 and allow
        # XXX: image to reload and unload its data.
        # XXX: may cause problems if buffer is used after these
        # XXX: functions are called, but buffers aren't expected to
        # XXX: live much.
        evas_object_image_data_set(self.obj, ptr[0])
        return _data_size_get(self.obj)

    def __getcharbuffer__(self, int segment, char **ptr):
        ptr[0] = <char *>evas_object_image_data_get(self.obj, 0)
        if ptr[0] == NULL:
            raise SystemError("image has no allocated buffer.")
        # XXX: keep Evas pixels_checked_out counter to 0 and allow
        # XXX: image to reload and unload its data.
        # XXX: may cause problems if buffer is used after these
        # XXX: functions are called, but buffers aren't expected to
        # XXX: live much.
        evas_object_image_data_set(self.obj, ptr[0])
        return _data_size_get(self.obj)

    def image_data_set(self, buf):
        """Sets the raw image data.

        The given buffer will be **copied**, so it's safe to give it a
        temporary object.

        .. note:: that the raw data must be of the same size and colorspace
            of the image. If data is None the current image data will be freed.

        :param buf: The buffer
        :type buf: data

        """
        cdef const_void *p_data
        cdef Py_ssize_t size, expected_size

        if buf is None:
            evas_object_image_data_set(self.obj, NULL)
            return

        # TODO: update to new buffer api
        PyObject_AsReadBuffer(buf, &p_data, &size)
        if p_data != NULL:
            expected_size = _data_size_get(self.obj)
            if size < expected_size:
                raise ValueError(("buffer size (%d) is smalled than expected "
                                  "(%d)!") % (size, expected_size))
        evas_object_image_data_set(self.obj,<void *> p_data)

    def image_data_update_add(self, x, y, w, h):
        """Mark a sub-region of the image to be redrawn.

        This function schedules a particular rectangular region
        to be updated (redrawn) at the next render.

        :param x: X coordinate
        :type x: int
        :param y: Y coordinate
        :type y: int
        :param w: Width
        :type w: int
        :param h: Height
        :type h: int

        """
        evas_object_image_data_update_add(self.obj, x, y, w, h)

    def on_image_preloaded_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_IMAGE_PRELOADED, ...)"""
        self.event_callback_add(EVAS_CALLBACK_IMAGE_PRELOADED, func, *a, **k)

    def on_image_preloaded_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_IMAGE_PRELOADED, ...)"""
        self.event_callback_del(EVAS_CALLBACK_IMAGE_PRELOADED, func)

    def on_image_unloaded_add(self, func, *a, **k):
        """Same as event_callback_add(EVAS_CALLBACK_IMAGE_UNLOADED, ...)"""
        self.event_callback_add(EVAS_CALLBACK_IMAGE_UNLOADED, func, *a, **k)

    def on_image_unloaded_del(self, func):
        """Same as event_callback_del(EVAS_CALLBACK_IMAGE_UNLOADED, ...)"""
        self.event_callback_del(EVAS_CALLBACK_IMAGE_UNLOADED, func)


_object_mapping_register("Evas_Object_Image", Image)


cdef void _cb_on_filled_image_resize(void *data, Evas *e,
                                     Evas_Object *obj,
                                     void *event_info) with gil:
    cdef int w, h
    evas_object_geometry_get(obj, NULL, NULL, &w, &h)
    evas_object_image_fill_set(obj, 0, 0, w, h)


cdef class FilledImage(Image):

    """

    Image that automatically resize it's contents to fit object size.

    This :py::`Image` subclass already calls :py::`Image.fill_set()` on resize so
    it will match and so be scaled to fill the whole area.

    :param canvas: The evas canvas for this object
    :type canvas: :py:class:`Canvas`
    :keyword size: Width and height
    :type size: tuple of ints
    :keyword pos: X and Y
    :type pos: tuple of ints
    :keyword geometry: X, Y, width, height
    :type geometry: tuple of ints
    :keyword color: R, G, B, A
    :type color: tuple of ints
    :keyword name: Object name
    :type name: string
    :keyword file: File name
    :type file: string

    """

    def __init__(self, Canvas canvas not None, **kargs):
        Image.__init__(self, canvas, **kargs)
        w, h = self.size_get()
        Image.fill_set(self, 0, 0, w, h)
        evas_object_event_callback_add(self.obj, EVAS_CALLBACK_RESIZE,
                                       _cb_on_filled_image_resize, NULL)

    def fill_set(self, int x, int y, int w, int h):
        """Not available for this class."""
        raise NotImplementedError("FilledImage doesn't support fill_set()")


_object_mapping_register("Evas_Object_FilledImage", FilledImage)

