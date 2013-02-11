# Copyright (C) 2007-2008 Gustavo Sverzut Barbieri, Caio Marcelo de Oliveira Filho, Ulisses Furquim
#
# This file is part of Python-Evas.
#
# Python-Evas is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-Evas is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-Evas.  If not, see <http://www.gnu.org/licenses/>.

# This file is included verbatim by c_evas.pyx

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
        cdef int err
        evas_object_image_file_set(self.obj, _cfruni(filename), _cfruni(key))
        err = evas_object_image_load_error_get(self.obj)
        if err != EVAS_LOAD_ERROR_NONE:
            raise EvasLoadError(err, filename, key)

    def file_get(self):
        cdef const_char_ptr file, key
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
        return evas_object_image_load_error_get(self.obj)

    property load_error:
        def __get__(self):
            return self.load_error_get()

    def border_get(self):
        cdef int left, right, top, bottom
        evas_object_image_border_get(self.obj, &left, &right, &top, &bottom)
        return (left, right, top, bottom)

    def border_set(self, int left, int right, int top, int bottom):
        evas_object_image_border_set(self.obj, left, right, top, bottom)

    property border:
        def __get__(self):
            return self.border_get()

        def __set__(self, spec):
            self.border_set(*spec)

    def border_center_fill_get(self):
        return bool(evas_object_image_border_center_fill_get(self.obj))

    def border_center_fill_set(self, int value):
        evas_object_image_border_center_fill_set(self.obj, value)

    property border_center_fill:
        def __get__(self):
            return self.border_center_fill_get()

        def __set__(self, int value):
            self.border_center_fill_set(value)

    def fill_get(self):
        cdef int x, y, w, h
        evas_object_image_fill_get(self.obj, &x, &y, &w, &h)
        return (x, y, w, h)

    def fill_set(self, int x, int y, int w, int h):
        evas_object_image_fill_set(self.obj, x, y, w, h)

    property fill:
        def __get__(self):
            return self.fill_get()

        def __set__(self, spec):
            self.fill_set(*spec)

    def image_size_get(self):
        cdef int w, h
        evas_object_image_size_get(self.obj, &w, &h)
        return (w, h)

    def image_size_set(self, int w, int h):
        evas_object_image_size_set(self.obj, w, h)

    property image_size:
        def __get__(self):
            return self.image_size_get()

        def __set__(self, spec):
            self.image_size_set(*spec)

    def stride_get(self):
        return evas_object_image_stride_get(self.obj)

    property stride:
        def __get__(self):
            return self.stride_get()

    def alpha_get(self):
        return bool(evas_object_image_alpha_get(self.obj))

    def alpha_set(self, value):
        evas_object_image_alpha_set(self.obj, value)

    property alpha:
        def __get__(self):
            return self.alpha_get()

        def __set__(self, int value):
            self.alpha_set(value)

    def smooth_scale_get(self):
        return bool(evas_object_image_smooth_scale_get(self.obj))

    def smooth_scale_set(self, value):
        evas_object_image_smooth_scale_set(self.obj, value)

    property smooth_scale:
        def __get__(self):
            return self.smooth_scale_get()

        def __set__(self, int value):
            self.smooth_scale_set(value)

    def pixels_dirty_get(self):
        return bool(evas_object_image_pixels_dirty_get(self.obj))

    def pixels_dirty_set(self, value):
        evas_object_image_pixels_dirty_set(self.obj, value)

    property pixels_dirty:
        def __get__(self):
            return self.pixels_dirty_get()

        def __set__(self, int value):
            self.pixels_dirty_set(value)

    def load_dpi_get(self):
        return evas_object_image_load_dpi_get(self.obj)

    def load_dpi_set(self, double value):
        evas_object_image_load_dpi_set(self.obj, value)

    property load_dpi:
        def __get__(self):
            return self.load_dpi_get()

        def __set__(self, int value):
            self.load_dpi_set(value)

    def load_size_get(self):
        cdef int w, h
        evas_object_image_load_size_get(self.obj, &w, &h)
        return (w, h)

    def load_size_set(self, int w, int h):
        evas_object_image_load_size_set(self.obj, w, h)

    property load_size:
        def __get__(self):
            return self.load_size_get()

        def __set__(self, spec):
            self.load_size_set(*spec)

    def load_scale_down_get(self):
        return evas_object_image_load_scale_down_get(self.obj)

    def load_scale_down_set(self, int value):
        evas_object_image_load_scale_down_set(self.obj, value)

    property load_scale_down:
        def __get__(self):
            return self.load_scale_down_get()

        def __set__(self, int value):
            self.load_scale_down_set(value)

    def colorspace_get(self):
        return evas_object_image_colorspace_get(self.obj)

    def colorspace_set(self, int value):
        evas_object_image_colorspace_set(self.obj, <Evas_Colorspace>value)

    property colorspace:
        def __get__(self):
            return self.colorspace_get()

        def __set__(self, int value):
            self.colorspace_set(value)

    def preload(self, int cancel=0):
        evas_object_image_preload(self.obj, cancel)


    def reload(self):
        evas_object_image_reload(self.obj)

    def save(self, const_char_ptr filename, key=None, flags=None):
        cdef const_char_ptr k, f
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
        evas_object_image_data_update_add(self.obj, x, y, w, h)

    def on_image_preloaded_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_IMAGE_PRELOADED, func, *a, **k)

    def on_image_preloaded_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_IMAGE_PRELOADED, func)

    def on_image_unloaded_add(self, func, *a, **k):
        self.event_callback_add(EVAS_CALLBACK_IMAGE_UNLOADED, func, *a, **k)

    def on_image_unloaded_del(self, func):
        self.event_callback_del(EVAS_CALLBACK_IMAGE_UNLOADED, func)


_object_mapping_register("Evas_Object_Image", Image)


cdef void _cb_on_filled_image_resize(void *data, Evas *e,
                                     Evas_Object *obj,
                                     void *event_info) with gil:
    cdef int w, h
    evas_object_geometry_get(obj, NULL, NULL, &w, &h)
    evas_object_image_fill_set(obj, 0, 0, w, h)


cdef class FilledImage(Image):

    def __init__(self, Canvas canvas not None, **kargs):
        Image.__init__(self, canvas, **kargs)
        w, h = self.size_get()
        Image.fill_set(self, 0, 0, w, h)
        evas_object_event_callback_add(self.obj, EVAS_CALLBACK_RESIZE,
                                       _cb_on_filled_image_resize, NULL)

    def fill_set(self, int x, int y, int w, int h):
        raise NotImplementedError("FilledImage doesn't support fill_set()")


_object_mapping_register("Evas_Object_FilledImage", FilledImage)

