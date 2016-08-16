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

:mod:`efl.emotion` Module
#########################

Classes
=======

.. toctree::

   class-emotion.rst


Module level functions
======================

"""
from cpython cimport PyUnicode_AsUTF8String
from libc.stdint cimport uintptr_t

from efl.eo cimport object_from_instance, _object_mapping_register, \
    _register_decorated_callbacks
from efl.utils.conversions cimport _ctouni
from efl.evas cimport Canvas, evas_object_smart_callback_add, \
    evas_object_smart_callback_del

import atexit

cimport efl.emotion.enums as enums

EMOTION_CHANNEL_AUTO = enums.EMOTION_CHANNEL_AUTO
EMOTION_CHANNEL_DEFAULT = enums.EMOTION_CHANNEL_DEFAULT

EMOTION_EVENT_MENU1 = enums.EMOTION_EVENT_MENU1
EMOTION_EVENT_MENU2 = enums.EMOTION_EVENT_MENU2
EMOTION_EVENT_MENU3 = enums.EMOTION_EVENT_MENU3
EMOTION_EVENT_MENU4 = enums.EMOTION_EVENT_MENU4
EMOTION_EVENT_MENU5 = enums.EMOTION_EVENT_MENU5
EMOTION_EVENT_MENU6 = enums.EMOTION_EVENT_MENU6
EMOTION_EVENT_MENU7 = enums.EMOTION_EVENT_MENU7
EMOTION_EVENT_UP = enums.EMOTION_EVENT_UP
EMOTION_EVENT_DOWN = enums.EMOTION_EVENT_DOWN
EMOTION_EVENT_LEFT = enums.EMOTION_EVENT_LEFT
EMOTION_EVENT_RIGHT = enums.EMOTION_EVENT_RIGHT
EMOTION_EVENT_SELECT = enums.EMOTION_EVENT_SELECT
EMOTION_EVENT_NEXT = enums.EMOTION_EVENT_NEXT
EMOTION_EVENT_PREV = enums.EMOTION_EVENT_PREV
EMOTION_EVENT_ANGLE_NEXT = enums.EMOTION_EVENT_ANGLE_NEXT
EMOTION_EVENT_ANGLE_PREV = enums.EMOTION_EVENT_ANGLE_PREV
EMOTION_EVENT_FORCE = enums.EMOTION_EVENT_FORCE
EMOTION_EVENT_0 = enums.EMOTION_EVENT_0
EMOTION_EVENT_1 = enums.EMOTION_EVENT_1
EMOTION_EVENT_2 = enums.EMOTION_EVENT_2
EMOTION_EVENT_3 = enums.EMOTION_EVENT_3
EMOTION_EVENT_4 = enums.EMOTION_EVENT_4
EMOTION_EVENT_5 = enums.EMOTION_EVENT_5
EMOTION_EVENT_6 = enums.EMOTION_EVENT_6
EMOTION_EVENT_7 = enums.EMOTION_EVENT_7
EMOTION_EVENT_8 = enums.EMOTION_EVENT_8
EMOTION_EVENT_9 = enums.EMOTION_EVENT_9
EMOTION_EVENT_10 = enums.EMOTION_EVENT_10

EMOTION_META_INFO_TRACK_TITLE = enums.EMOTION_META_INFO_TRACK_TITLE
EMOTION_META_INFO_TRACK_ARTIST = enums.EMOTION_META_INFO_TRACK_ARTIST
EMOTION_META_INFO_TRACK_ALBUM = enums.EMOTION_META_INFO_TRACK_ALBUM
EMOTION_META_INFO_TRACK_YEAR = enums.EMOTION_META_INFO_TRACK_YEAR
EMOTION_META_INFO_TRACK_GENRE = enums.EMOTION_META_INFO_TRACK_GENRE
EMOTION_META_INFO_TRACK_COMMENT = enums.EMOTION_META_INFO_TRACK_COMMENT
EMOTION_META_INFO_TRACK_DISC_ID = enums.EMOTION_META_INFO_TRACK_DISC_ID
EMOTION_META_INFO_TRACK_COUNT = enums.EMOTION_META_INFO_TRACK_COUNT

EMOTION_ASPECT_KEEP_NONE = enums.EMOTION_ASPECT_KEEP_NONE
EMOTION_ASPECT_KEEP_WIDTH = enums.EMOTION_ASPECT_KEEP_WIDTH
EMOTION_ASPECT_KEEP_HEIGHT = enums.EMOTION_ASPECT_KEEP_HEIGHT
EMOTION_ASPECT_KEEP_BOTH = enums.EMOTION_ASPECT_KEEP_BOTH
EMOTION_ASPECT_CROP = enums.EMOTION_ASPECT_CROP
EMOTION_ASPECT_CUSTOM = enums.EMOTION_ASPECT_CUSTOM

EMOTION_WAKEUP = enums.EMOTION_WAKEUP
EMOTION_SLEEP = enums.EMOTION_SLEEP
EMOTION_DEEP_SLEEP = enums.EMOTION_DEEP_SLEEP
EMOTION_HIBERNATE = enums.EMOTION_HIBERNATE

EMOTION_VIS_NONE = enums.EMOTION_VIS_NONE
EMOTION_VIS_GOOM = enums.EMOTION_VIS_GOOM
EMOTION_VIS_LIBVISUAL_BUMPSCOPE = enums.EMOTION_VIS_LIBVISUAL_BUMPSCOPE
EMOTION_VIS_LIBVISUAL_CORONA = enums.EMOTION_VIS_LIBVISUAL_CORONA
EMOTION_VIS_LIBVISUAL_DANCING_PARTICLES = enums.EMOTION_VIS_LIBVISUAL_DANCING_PARTICLES
EMOTION_VIS_LIBVISUAL_GDKPIXBUF = enums.EMOTION_VIS_LIBVISUAL_GDKPIXBUF
EMOTION_VIS_LIBVISUAL_G_FORCE = enums.EMOTION_VIS_LIBVISUAL_G_FORCE
EMOTION_VIS_LIBVISUAL_GOOM = enums.EMOTION_VIS_LIBVISUAL_GOOM
EMOTION_VIS_LIBVISUAL_INFINITE = enums.EMOTION_VIS_LIBVISUAL_INFINITE
EMOTION_VIS_LIBVISUAL_JAKDAW = enums.EMOTION_VIS_LIBVISUAL_JAKDAW
EMOTION_VIS_LIBVISUAL_JESS = enums.EMOTION_VIS_LIBVISUAL_JESS
EMOTION_VIS_LIBVISUAL_LV_ANALYSER = enums.EMOTION_VIS_LIBVISUAL_LV_ANALYSER
EMOTION_VIS_LIBVISUAL_LV_FLOWER = enums.EMOTION_VIS_LIBVISUAL_LV_FLOWER
EMOTION_VIS_LIBVISUAL_LV_GLTEST = enums.EMOTION_VIS_LIBVISUAL_LV_GLTEST
EMOTION_VIS_LIBVISUAL_LV_SCOPE = enums.EMOTION_VIS_LIBVISUAL_LV_SCOPE
EMOTION_VIS_LIBVISUAL_MADSPIN = enums.EMOTION_VIS_LIBVISUAL_MADSPIN
EMOTION_VIS_LIBVISUAL_NEBULUS = enums.EMOTION_VIS_LIBVISUAL_NEBULUS
EMOTION_VIS_LIBVISUAL_OINKSIE = enums.EMOTION_VIS_LIBVISUAL_OINKSIE
EMOTION_VIS_LIBVISUAL_PLASMA = enums.EMOTION_VIS_LIBVISUAL_PLASMA
EMOTION_VIS_LAST = enums.EMOTION_VIS_LAST


cdef void _emotion_callback(void *data, Evas_Object *o, void *ei) with gil:
    cdef Emotion obj
    cdef object event
    obj = object_from_instance(o)
    event = <object>data
    lst = tuple(obj._emotion_callbacks[event])
    for func, args, kargs in lst:
        try:
            func(obj, *args, **kargs)
        except Exception:
            import traceback
            traceback.print_exc()


class EmotionModuleInitError(Exception):
    pass


def init():
    return emotion_init()

def shutdown():
    return emotion_shutdown()


def webcams_get():
    """Get a list of active and available webcam.

    :return: the list of tuple (webcam name, webcam device)

    .. versionadded:: 1.8

    """
    cdef:
        const Eina_List *lst
        const Eina_List *itr
        Emotion_Webcam *cam
        const char *name
        const char *device

    ret = []
    lst = emotion_webcams_get()
    itr = lst
    while itr:
        cam = <Emotion_Webcam*>itr.data
        name = emotion_webcam_name_get(cam)
        device = emotion_webcam_device_get(cam)
        ret.append((_ctouni(name), _ctouni(device)))
        itr = itr.next
    return ret

def extension_may_play_get(filename):
    """Do we have a chance to play that file?

    This just actually look at the extention of the file, it doesn't check
    the mime-type nor if the file is actually sane. So this is just an
    hint for your application.

    :param filename: A filename that we want to know if Emotion can play.
    :type filename: str

    .. versionadded:: 1.8

    """
    if isinstance(filename, unicode): filename = PyUnicode_AsUTF8String(filename)
    return bool(emotion_object_extension_may_play_get(
        <const char *>filename if filename is not None else NULL))


cdef class Emotion(evasObject):
    """

    The Emotion object

    .. versionchanged:: 1.8
        Keyword argument module_filename was renamed to module_name.

    """
    def __cinit__(self, *a, **ka):
        self._emotion_callbacks = {}

    def __init__(self, Canvas canvas not None, module_name="gstreamer",
                 module_params=None, **kwargs):
        """Emotion(...)

        :param canvas: Evas canvas for this object
        :type canvas: :py:class:`~efl.evas.Canvas`
        :keyword module_name: name of the engine to use
        :type module_name: string
        :keyword module_params: Extra parameters, module specific
        :keyword \**kwargs: All the remaining keyword arguments are interpreted
                            as properties of the instance

        """

        self._set_obj(emotion_object_add(canvas.obj))
        _register_decorated_callbacks(self)

        if isinstance(module_name, unicode):
            module_name = PyUnicode_AsUTF8String(module_name)
        if emotion_object_init(self.obj,
            <const char *>module_name if module_name is not None else NULL) == 0:
            raise EmotionModuleInitError("failed to initialize module '%s'" %
                                         module_name)

        if isinstance(module_params, (tuple, list)):
            module_params = dict(module_params)
        if isinstance(module_params, dict):
            for opt, val in module_params.iteritems():
                emotion_object_module_option_set(self.obj, opt, val)

        self._set_properties_from_keyword_args(kwargs)

    def __repr__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        return ("<%s(%#x, name=%r, file=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%r, visible=%s) %s>") % \
               (self.__class__.__name__, <uintptr_t><void *>self,
                self.name_get(), self.file_get(),
                x, y, w, h, r, g, b, a,
                self.layer_get(), self.clip_get(), self.visible_get(),
                evasObject.__repr__(self))

    property file:
        """ The filename of the file associated with the emotion object.

        The file to be used with this emotion object. If the
        object already has another file set, this file will be unset and unloaded,
        and the new file will be loaded to this emotion object. The seek position
        will be set to 0, and the emotion object will be paused, instead of playing.

        If there was already a filename set, and it's the same as the one being set
        now, setting the property does nothing

        Set to *None* if you want to unload the current file but don't
        want to load anything else.

        :type: str
        """
        def __get__(self):
            return _ctouni(emotion_object_file_get(self.obj))

        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            emotion_object_file_set(self.obj,
                <const char *> value if value is not None else NULL)

    def file_get(self):
        return _ctouni(emotion_object_file_get(self.obj))
    def file_set(self, file_name):
        if isinstance(file_name, unicode): file_name = PyUnicode_AsUTF8String(file_name)
        emotion_object_file_set(self.obj,
            <const char *> file_name if file_name is not None else NULL)

    property play:
        """ The play/pause state of the emotion object.

        :type: bool
        """
        def __get__(self):
            return bool(emotion_object_play_get(self.obj))

        def __set__(self, int value):
            emotion_object_play_set(self.obj, value)

    def play_get(self):
        return bool(emotion_object_play_get(self.obj))
    def play_set(self, int value):
        emotion_object_play_set(self.obj, value)

    property position:
        """ The position in the media file.

        The current position of the media file to *sec*, this
        only works on seekable streams. Setting the position doesn't change the
        playing state of the media file.

        :type: float
        """
        def __get__(self):
            return emotion_object_position_get(self.obj)

        def __set__(self, double value):
            emotion_object_position_set(self.obj, value)

    def position_get(self):
        return emotion_object_position_get(self.obj)
    def position_set(self, double value):
        emotion_object_position_set(self.obj, value)

    property border:
        """ The borders for the emotion object.

        This represent the borders for the emotion video object (just when a video is
        present). The value is a tuple of 4 int: (left, right, top, bottom).

        When positive values are given to one of the parameters, a border
        will be added to the respective position of the object, representing that
        size on the original video size. However, if the video is scaled up or down
        (i.e. the emotion object size is different from the video size), the borders
        will be scaled respectively too.

        If a negative value is given to one of the parameters, instead of a border,
        that respective side of the video will be cropped.

        .. note:: It's possible to set a color for the added borders (default is
                  transparent) with the :py:attr:`bg_color` attribute. By
                  default, an Emotion object doesn't have any border.

        :type: tuple of int (l, r, t, b)

        .. versionadded:: 1.8

        """
        def __get__(self):
            cdef int l, r, t, b
            emotion_object_border_get(self.obj, &l, &r, &t, &b)
            return  (l, r, t, b)

        def __set__(self, value):
            cdef int l, r, t, b
            l, r, t, b = value
            emotion_object_border_set(self.obj, l, r, t, b)

    def border_get(self):
        cdef int l, r, t, b
        emotion_object_border_get(self.obj, &l, &r, &t, &b)
        return  (l, r, t, b)
    def border_set(self, int l, int r, int t, int b):
        emotion_object_border_set(self.obj, l, r, t, b)

    property bg_color:
        """ The color for the background of this emotion object.

        This is useful when a border is added to any side of the Emotion object.
        The area between the edge of the video and the edge of the object
        will be filled with the specified color.

        The default color is (0, 0, 0, 0)

        :type: tuple of int (r, g, b, a)

        .. versionadded:: 1.8

        """
        def __get__(self):
            cdef int r, g, b, a
            emotion_object_bg_color_get(self.obj, &r, &g, &b, &a)
            return  (r, g, b, a)

        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            emotion_object_bg_color_set(self.obj, r, g, b, a)

    def bg_color_get(self):
        cdef int r, g, b, a
        emotion_object_bg_color_get(self.obj, &r, &g, &b, &a)
        return  (r, g, b, a)
    def bg_color_set(self, int r, int g, int b, int a):
        emotion_object_bg_color_set(self.obj, r, g, b, a)

    property keep_aspect:
        """ Whether emotion should keep the aspect ratio of the video.

        Instead of manually calculating the required border to set with
        emotion_object_border_set(), and using this to fix the aspect ratio of the
        video when the emotion object has a different aspect, it's possible to just
        set the policy to be used.

        The options are:

        - ``EMOTION_ASPECT_KEEP_NONE`` ignore the video aspect ratio, and reset any
          border set to 0, stretching the video inside the emotion object area. This
          option is similar to EVAS_ASPECT_CONTROL_NONE size hint.
        - ``EMOTION_ASPECT_KEEP_WIDTH`` respect the video aspect ratio, fitting the
          video width inside the object width. This option is similar to
          EVAS_ASPECT_CONTROL_HORIZONTAL size hint.
        - ``EMOTION_ASPECT_KEEP_HEIGHT`` respect the video aspect ratio, fitting
          the video height inside the object height. This option is similar to
          EVAS_ASPECT_CONTROL_VERTICAL size hint.
        - ``EMOTION_ASPECT_KEEP_BOTH`` respect the video aspect ratio, fitting both
          its width and height inside the object area. This option is similar to
          EVAS_ASPECT_CONTROL_BOTH size hint. It's the effect called letterboxing.
        - ``EMOTION_ASPECT_CROP`` respect the video aspect ratio, fitting the width
          or height inside the object area, and cropping the exceding areas of the
          video in height or width. It's the effect called pan-and-scan.
        - ``EMOTION_ASPECT_CUSTOM`` ignore the video aspect ratio, and use the
          current set from emotion_object_border_set().

        .. note:: Calling this function with any value except
                  EMOTION_ASPECT_CUSTOM will invalidate the borders set with
                  the :py:attr:`border` attribute

        .. note:: Using the :py:attr:`border` attribute will automatically
                  set the aspect policy to #EMOTION_ASPECT_CUSTOM.

        :type: Emotion_Aspect

        .. versionadded:: 1.8

        """
        def __get__(self):
            return emotion_object_keep_aspect_get(self.obj)
        def __set__(self, value):
            emotion_object_keep_aspect_set(self.obj, <Emotion_Aspect>value)

    def keep_aspect_get(self):
        return emotion_object_keep_aspect_get(self.obj)
    def keep_aspect_set(self, Emotion_Aspect a):
        emotion_object_keep_aspect_set(self.obj, a)

    property video_subtitle_file:
        """ The video's subtitle file path (i.e an .srt file)

        For supported subtitle formats consult the backend's documentation.

        :type: str

        .. versionadded:: 1.8

        """
        def __get__(self):
            return _ctouni(emotion_object_video_subtitle_file_get(self.obj))

        def __set__(self, value):
            if isinstance(value, unicode): value = PyUnicode_AsUTF8String(value)
            emotion_object_video_subtitle_file_set(self.obj,
                <const char *>value if value is not None else NULL)

    def video_subtitle_file_get(self):
        return _ctouni(emotion_object_video_subtitle_file_get(self.obj))
    def video_subtitle_file_set(self, file_name):
        if isinstance(file_name, unicode): file_name = PyUnicode_AsUTF8String(file_name)
        emotion_object_video_subtitle_file_set(self.obj,
            <const char *>file_name if file_name is not None else NULL)

    property priority:
        """ Raise the priority of an object so it will have a privileged
        access to hardware resource.

        Hardware have a few dedicated hardware pipeline that process the video
        at no cost for the CPU. Especially on SoC, you mostly have one (on
        mobile phone SoC) or two (on Set Top Box SoC) when Picture in Picture
        is needed. And most application just have a few video stream that really
        deserve high frame rate, high quality output. That's why this call is for.

        .. note:: If Emotion can't acquire a privileged hardware resource,
                  it will fallback to the no-priority path. This work on the
                  first asking first get basis system.

        *True* means high priority.

        :type: bool

        .. versionadded:: 1.8

        """
        def __get__(self):
            return bool(emotion_object_priority_get(self.obj))

        def __set__(self, value):
            emotion_object_priority_set(self.obj, bool(value))

    def priority_get(self):
        return bool(emotion_object_priority_get(self.obj))
    def priority_set(self, value):
        emotion_object_priority_set(self.obj, bool(value))

    property suspend:
        """ The state of an object pipeline.

        Changing the state of a pipeline should help preserve the battery of
        an embedded device. But it will only work sanely if the pipeline
        is not playing at the time you change its state. Depending on the
        engine all state may be not implemented.

        The options are:

        - ``EMOTION_WAKEUP`` pipeline is up and running
        - ``EMOTION_SLEEP`` turn off hardware resource usage like overlay
        - ``EMOTION_DEEP_SLEEP`` destroy the pipeline, but keep full resolution
          pixels output around
        - ``EMOTION_HIBERNATE`` destroy the pipeline, and keep half resolution
          or object resolution if lower

        :type: Emotion_Suspend

        .. versionadded:: 1.8

        """
        def __get__(self):
            return emotion_object_suspend_get(self.obj)
        def __set__(self, value):
            emotion_object_suspend_set(self.obj, <Emotion_Suspend>value)

    def suspend_get(self):
        return emotion_object_suspend_get(self.obj)
    def suspend_set(self, Emotion_Suspend a):
        emotion_object_suspend_set(self.obj, a)

    property buffer_size:
        """ The percentual size of the buffering cache.

        The buffer size is given as a number between 0.0 and 1.0, 0.0 means
        the buffer if empty, 1.0 means full.
        If no buffering is in progress 1.0 is returned. In all other cases (maybe
        the backend don't support buffering) 1.0 is returned, thus you can always
        check for buffer_size < 1.0 to know if buffering is in progress.

        :type: float
        """
        def __get__(self):
            return emotion_object_buffer_size_get(self.obj)

    def buffer_size_get(self):
        return emotion_object_buffer_size_get(self.obj)

    property video_handled:
        """ True if the loaded stream contain at least one video track

        :type: bool
        """
        def __get__(self):
            return bool(emotion_object_video_handled_get(self.obj))

    def video_handled_get(self):
        return bool(emotion_object_video_handled_get(self.obj))

    property audio_handled:
        """ True if the loaded stream contain at least one audio track

        :type: bool
        """
        def __get__(self):
            return bool(emotion_object_audio_handled_get(self.obj))

    def audio_handled_get(self):
        return bool(emotion_object_audio_handled_get(self.obj))

    property seekable:
        """ Whether the media file is seekable.

        :rtype: bool
        """
        def __get__(self):
            return bool(emotion_object_seekable_get(self.obj))

    def seekable_get(self):
        return bool(emotion_object_seekable_get(self.obj))

    property play_length:
        """ The length of play for the media file.

        The total length of the media file in seconds.

        :type: float
        """
        def __get__(self):
            return emotion_object_play_length_get(self.obj)

    def play_length_get(self):
        return emotion_object_play_length_get(self.obj)

    property play_speed:
        """ The play speed of the media file.

        This sets the speed with which the media file will be played. 1.0
        represents the normal speed, 2 double speed, 0.5 half speed and so on.

        :type: float

        .. versionadded:: 1.8

        """
        def __get__(self):
            return emotion_object_play_speed_get(self.obj)

        def __set__(self, double value):
            emotion_object_play_speed_set(self.obj, value)

    def play_speed_get(self):
        return emotion_object_play_speed_get(self.obj)
    def play_speed_set(self, double value):
        emotion_object_play_speed_set(self.obj, value)

    property image_size:
        """ The video size of the loaded file.

        This is the reported size of the loaded video file. If a file
        that doesn't contain a video channel is loaded, then this size can be
        ignored.
        The value reported by this function should be consistent with the aspect
        ratio returned by :py:attr:`ratio`, but sometimes the information
        stored in the file is wrong. So use the ratio size reported by
        py:func:`ratio_get()`, since it is more likely going to be accurate.

        :type: tuple of int (w, h)
        """
        def __get__(self):
            return self.image_size_get()

    def image_size_get(self):
        cdef int w, h
        emotion_object_size_get(self.obj, &w, &h)
        return (w, h)

    property smooth_scale:
        """ Whether to use of high-quality image scaling algorithm
        of the given video object.

        When enabled, a higher quality video scaling algorithm is used when
        scaling videos to sizes other than the source video. This gives
        better results but is more computationally expensive.

        :type: bool
        """
        def __get__(self):
            return self.smooth_scale_get()

        def __set__(self, int value):
            self.smooth_scale_set(value)

    def smooth_scale_get(self):
        return bool(emotion_object_smooth_scale_get(self.obj))
    def smooth_scale_set(self, int value):
        emotion_object_smooth_scale_set(self.obj, value)

    property ratio:
        """ The video aspect ratio of the media file loaded.

        This function returns the video aspect ratio (width / height) of the file
        loaded. It can be used to adapt the size of the emotion object in the canvas,
        so the aspect won't be changed (by wrongly resizing the object). Or to crop
        the video correctly, if necessary.

        The described behavior can be applied like following. Consider a given
        emotion object that we want to position inside an area, which we will
        represent by *w* and *h*. Since we want to position this object either
        stretching, or filling the entire area but overflowing the video, or just
        adjust the video to fit inside the area without keeping the aspect ratio, we
        must compare the video aspect ratio with the area aspect ratio::

            w = 200; h = 300; # an arbitrary value which represents the area where
                              # the video would be placed
            obj = Emotion(...)
            r = w / h
            vr = obj.ratio

        Now, if we want to make the video fit inside the area, the following code
        would do it::

            if vr > r:  # the video is wider than the area
                vw = w
                vh = w / vr
            else:       # the video is taller than the area
                vh = h
                vw = h * vr
            obj.size = (vw, vh)

        And for keeping the aspect ratio but making the video fill the entire area,
        overflowing the content which can't fit inside it, we would do::

            if vr > r: # the video is wider than the area
                vh = h
                vw = h * vr
            else:      # the video is taller than the area
                vw = w
                vh = w / vr
            obj.size = (vw, vh)

        Finally, by just resizing the video to the video area, we would have the
        video stretched::

            vw = w
            vh = h
            obj.size = (vw, vh)

        .. note:: This function returns the aspect ratio that the video *should* be, but
                  sometimes the reported size from emotion_object_size_get() represents a
                  different aspect ratio. You can safely resize the video to respect the aspect
                  ratio returned by *this* function.

        :type: float
        """
        def __get__(self):
            return emotion_object_ratio_get(self.obj)

    def ratio_get(self):
        return emotion_object_ratio_get(self.obj)

    property audio_volume:
        """ The audio volume.

        The current value for the audio volume level. Range is from 0.0 to 1.0.

        Sets the audio volume of the stream being played. This has nothing to do with
        the system volume. This volume will be multiplied by the system volume. e.g.:
        if the current volume level is 0.5, and the system volume is 50%, it will be
        * 0.5 * 0.5 = 0.25.

        .. note:: The default value depends on the module used. This value
                  doesn't get changed when another file is loaded.

        :type: float
        """
        def __get__(self):
            return emotion_object_audio_volume_get(self.obj)

        def __set__(self, double value):
            emotion_object_audio_volume_set(self.obj, value)

    def audio_volume_get(self):
        return emotion_object_audio_volume_get(self.obj)
    def audio_volume_set(self, double value):
        emotion_object_audio_volume_set(self.obj, value)

    property audio_mute:
        """ The mute audio option for this object.

        :type: bool
        """
        def __get__(self):
            return bool(emotion_object_audio_mute_get(self.obj))

        def __set__(self, int value):
            emotion_object_audio_mute_set(self.obj, bool(value))

    def audio_mute_get(self):
        return emotion_object_audio_mute_get(self.obj)
    def audio_mute_set(self, int value):
        emotion_object_audio_mute_set(self.obj, value)

    property video_mute:
        """ The mute video option for this object.

        :type: bool
        """
        def __get__(self):
            return emotion_object_video_mute_get(self.obj)

        def __set__(self, int value):
            emotion_object_video_mute_set(self.obj, value)

    def video_mute_get(self):
        return emotion_object_video_mute_get(self.obj)
    def video_mute_set(self, int value):
        emotion_object_video_mute_set(self.obj, value)

    property spu_mute:
        """ The SPU muted state.

        :type: bool
        """
        def __get__(self):
            return bool(emotion_object_spu_mute_get(self.obj))

        def __set__(self, int value):
            emotion_object_spu_mute_set(self.obj, bool(value))

    def spu_mute_get(self):
        return bool(emotion_object_spu_mute_get(self.obj))
    def spu_mute_set(self, int value):
        emotion_object_spu_mute_set(self.obj, bool(value))

    def audio_channel_count(self):
        """ Get the number of audio channels available in the loaded media.

        :return: the number of channels
        :rtype: int
        """
        return emotion_object_audio_channel_count(self.obj)

    def audio_channel_name_get(self, int channel):
        """ Get the name of the given channel.

        :return: the name
        :rtype: str
        """
        return _ctouni(emotion_object_audio_channel_name_get(self.obj, channel))

    property audio_channel:
        """ The currently selected audio channel.

        :type: int
        """
        def __get__(self):
            return emotion_object_audio_channel_get(self.obj)

        def __set__(self, int value):
            emotion_object_audio_channel_set(self.obj, value)

    def audio_channel_get(self):
        return emotion_object_audio_channel_get(self.obj)
    def audio_channel_set(self, int channel):
        emotion_object_audio_channel_set(self.obj, channel)

    def video_channel_count(self):
        """ Get the number of video channels available in the loaded media.

        :return: the number of channels
        :rtype: int
        """
        return emotion_object_video_channel_count(self.obj)

    def video_channel_name_get(self, int channel):
        """ Get the name of the given channel.

        :return: the name
        :rtype: str
        """
        return _ctouni(emotion_object_video_channel_name_get(self.obj, channel))

    property video_channel:
        """ The currently selected video channel.

        :type: int
        """
        def __get__(self):
            return emotion_object_video_channel_get(self.obj)

        def __set__(self, int value):
            emotion_object_video_channel_set(self.obj, value)

    def video_channel_get(self):
        return emotion_object_video_channel_get(self.obj)
    def video_channel_set(self, int value):
        emotion_object_video_channel_set(self.obj, value)

    def spu_channel_count(self):
        """ Get the number of SPU channels available in the loaded media.

        :return: the number of channels
        :rtype: int
        """
        return emotion_object_spu_channel_count(self.obj)

    def spu_channel_name_get(self, int channel):
        """ Get the name of the given channel.

        :return: the name
        :rtype: str
        """
        return _ctouni(emotion_object_spu_channel_name_get(self.obj, channel))

    property spu_channel:
        """ The currently selected SPU channel.

        :type: int
        """
        def __get__(self):
            return emotion_object_spu_channel_get(self.obj)

        def __set__(self, int value):
            emotion_object_spu_channel_set(self.obj, value)

    def spu_channel_get(self):
        return emotion_object_spu_channel_get(self.obj)
    def spu_channel_set(self, int value):
        emotion_object_spu_channel_set(self.obj, value)

    property spu_button_count:
        """ SPU button count

        :type: int
        """
        def __get__(self):
            return self.spu_button_count_get()

    def spu_button_count_get(self):
        return emotion_object_spu_button_count_get(self.obj)

    property spu_button:
        """ SPU button

        :type: int
        """
        def __get__(self):
            return self.spu_button_get()

    def spu_button_get(self):
        return emotion_object_spu_button_get(self.obj)

    def chapter_count(self):
        """ Return the number of chapters in the stream.

        :rtype: int
        """
        return emotion_object_chapter_count(self.obj)

    def chapter_name_get(self, int chapter):
        """ Get the name of the given chapter.

        :param chapter: the chapter number
        :type chapter: int
        :return: the name of the chapter
        :rtype: str
        """
        return _ctouni(emotion_object_chapter_name_get(self.obj, chapter))

    property chapter:
        """ The currently selected chapter.

        :type: int
        """
        def __get__(self):
            return emotion_object_chapter_get(self.obj)

        def __set__(self, int value):
            emotion_object_chapter_set(self.obj, value)

    def chapter_get(self):
        return emotion_object_chapter_get(self.obj)
    def chapter_set(self, int value):
        emotion_object_chapter_set(self.obj, value)

    def eject(self):
        """ Eject the media """
        emotion_object_eject(self.obj)

    property title:
        """ The dvd title from this emotion object.

        .. note:: This function is only useful when playing a DVD.

        :type: str
        """
        def __get__(self):
            return _ctouni(emotion_object_title_get(self.obj))

    def title_get(self):
        return _ctouni(emotion_object_title_get(self.obj))

    property progress_info:
        """ How much of the file has been played.

        ..  warning:: gstreamer xine backends don't implement this(will return None).

        :type: str
        """
        def __get__(self):
            return _ctouni(emotion_object_progress_info_get(self.obj))

    def progress_info_get(self):
        return _ctouni(emotion_object_progress_info_get(self.obj))

    property progress_status:
        """ How much of the file has been played.

        The progress in playing the file, the value is in the [0, 1] range.

        ..  warning:: gstreamer xine backends don't implement this(will return 0).

        :type: float
        """
        def __get__(self):
            return emotion_object_progress_status_get(self.obj)

    def progress_status_get(self):
        return emotion_object_progress_status_get(self.obj)

    property ref_file:
        """ ref file

        :type: str
        """
        def __get__(self):
            return _ctouni(emotion_object_ref_file_get(self.obj))

    def ref_file_get(self):
        return _ctouni(emotion_object_ref_file_get(self.obj))

    property ref_num:
        """ ref number

        :type: int
        """
        def __get__(self):
            return emotion_object_ref_num_get(self.obj)

    def ref_num_get(self):
        return emotion_object_ref_num_get(self.obj)

    def meta_info_get(self, int meta_id):
        """ Retrieve meta information from this file being played.

        This function retrieves information about the file loaded. It can retrieve
        the track title, artist name, album name, etc.

        :param meta_id: The type of meta information that will be extracted.
        :type meta_id: int
        :return: The info or None
        :rtype: str

        :see also: meta_info_dict_get().
        :see also: Emotion_Meta_Info for all the possibilities.
        """
        return _ctouni(emotion_object_meta_info_get(self.obj, <Emotion_Meta_Info>meta_id))

    def meta_info_dict_get(self):
        """ Get a python dictionary with all the know info.

        :return: all the know meta info for the media file
        :rtype: dict
        """
        cdef const char *info
        ret = dict()
        lst = (("title", enums.EMOTION_META_INFO_TRACK_TITLE),
               ("artist", enums.EMOTION_META_INFO_TRACK_ARTIST),
               ("album", enums.EMOTION_META_INFO_TRACK_ALBUM),
               ("year", enums.EMOTION_META_INFO_TRACK_YEAR),
               ("genre", enums.EMOTION_META_INFO_TRACK_GENRE),
               ("comment", enums.EMOTION_META_INFO_TRACK_COMMENT),
               ("disc_id", enums.EMOTION_META_INFO_TRACK_DISC_ID),
               ("track_count", enums.EMOTION_META_INFO_TRACK_COUNT))
        for n, i in lst:
            info = emotion_object_meta_info_get(self.obj, i)
            if info != NULL:
                ret[n] = info
                ret[i] = info
        return ret

    property meta_info_dict:
        def __get__(self):
            return self.meta_info_dict_get()

    def last_position_load(self):
        """ Load the last known position if available

        By using Xattr, Emotion is able, if the system permits it, to store
        and retrieve the latest position. It should trigger some smart
        callback to let the application know when it succeed or fail.
        Every operation is fully asynchronous and not linked to the actual
        engine used to play the video.

        .. versionadded:: 1.8

        """
        emotion_object_last_position_load(self.obj)

    def last_position_save(self):
        """ Save the last position if possible

        :see: :py:meth:`last_position_load`

        .. versionadded:: 1.8

        """
        emotion_object_last_position_save(self.obj)

    def image_get(self):
        """ Get the actual image object (:py:class:`efl.evas.Object`) of the
        emotion object.

        This function is useful when you want to get a direct access to the pixels.

        .. versionadded:: 1.8

        """
        return object_from_instance(emotion_object_image_get(self.obj))

    property vis:
        # TODO: document this
        def __get__(self):
            return emotion_object_vis_get(self.obj)

        def __set__(self, Emotion_Vis vis):
            emotion_object_vis_set(self.obj, vis)

    def vis_get(self):
        return emotion_object_vis_get(self.obj)
    def vis_set(self, Emotion_Vis vis):
        emotion_object_vis_set(self.obj, vis)
    def vis_supported(self, Emotion_Vis vis):
        return emotion_object_vis_supported(self.obj, vis)

    def event_simple_send(self, int event_id):
        """ Send a named signal to the object.

        :param event_id: the signal to emit, one of EMOTION_EVENT_MENU1,
                         EMOTION_EVENT_MENU2, EMOTION_EVENT_UP, EMOTION_EVENT_1,
                         or any other EMOTION_EVENT_* definition
        :type event_id: Emotion_Event
        """
        emotion_object_event_simple_send(self.obj, <Emotion_Event>event_id)

    def callback_add(self, event, func, *args, **kargs):
        """ Add a new function (**func**) to be called on the specific **event**.

        The expected signature for **func** is::

            func(object, *args, **kwargs)

        .. note:: Any extra params given to the function (both positional
                  and keyword arguments) will be passed back in the
                  callback function.

        :see also: All the on_*_add() shortcut functions

        :param event: the name of the event
        :type event: str
        :param func: the function to call
        :type func: callable

        """
        e = intern(event)
        lst = self._emotion_callbacks.setdefault(e, [])
        if not lst:
            if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)
            evas_object_smart_callback_add(self.obj,
                <const char *>event if event is not None else NULL,
                _emotion_callback, <void *>e)
        lst.append((func, args, kargs))

    def callback_del(self, event, func):
        """ Stop the given function **func** to be called on **event**

        :see also: all the on_*_add() shortcut functions

        :param event: the name of the event
        :type event: str
        :param func: the function that was previously attached
        :type func: callable

        """
        try:
            lst = self._emotion_callbacks[event]
        except KeyError:
            raise ValueError("function %s not associated with event %r" %
                             (func, event))

        i = -1
        for i, (f, a, k) in enumerate(lst):
            if func == f:
                break
        else:
            raise ValueError("function %s not associated with event %r" %
                             (func, event))
        lst.pop(i)
        if lst:
            return
        self._emotion_callbacks.pop(event)
        if isinstance(event, unicode): event = PyUnicode_AsUTF8String(event)
        evas_object_smart_callback_del(self.obj,
            <const char *>event if event is not None else NULL,
            _emotion_callback)

    def on_frame_decode_add(self, func, *args, **kargs):
        """Same as calling: callback_add('frame_decode', func, ...)"""
        self.callback_add("frame_decode", func, *args, **kargs)

    def on_frame_decode_del(self, func):
        """Same as calling: callback_del('frame_decode', func)"""
        self.callback_del("frame_decode", func)

    def on_frame_resize_add(self, func, *args, **kargs):
        """Same as calling: callback_add('frame_resize', func, ...)"""
        self.callback_add("frame_resize", func, *args, **kargs)

    def on_frame_resize_del(self, func):
        """Same as calling: callback_del('frame_resize', func)"""
        self.callback_del("frame_resize", func)

    def on_length_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('length_change', func, ...)"""
        self.callback_add("length_change", func, *args, **kargs)

    def on_length_change_del(self, func):
        """Same as calling: callback_del('length_change', func)"""
        self.callback_del("length_change", func)

    def on_decode_stop_add(self, func, *args, **kargs):
        """Same as calling: callback_add('decode_stop', func, ...)"""
        self.callback_add("decode_stop", func, *args, **kargs)

    def on_decode_stop_del(self, func):
        """Same as calling: callback_del('decode_stop', func)"""
        self.callback_del("decode_stop", func)

    def on_channels_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('channels_change', func, ...)"""
        self.callback_add("channels_change", func, *args, **kargs)

    def on_channels_change_del(self, func):
        """Same as calling: callback_del('channels_change', func)"""
        self.callback_del("channels_change", func)

    def on_title_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('title_change', func, ...)"""
        self.callback_add("title_change", func, *args, **kargs)

    def on_title_change_del(self, func):
        """Same as calling: callback_del('title_change', func)"""
        self.callback_del("title_change", func)

    def on_progress_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('progress_change', func, ...)"""
        self.callback_add("progress_change", func, *args, **kargs)

    def on_progress_change_del(self, func):
        """Same as calling: callback_del('progress_change', func)"""
        self.callback_del("progress_change", func)

    def on_ref_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('ref_change', func, ...)"""
        self.callback_add("ref_change", func, *args, **kargs)

    def on_ref_change_del(self, func):
        """Same as calling: callback_del('ref_change', func)"""
        self.callback_del("ref_change", func)

    def on_button_num_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('button_num_change', func, ...)"""
        self.callback_add("button_num_change", func, *args, **kargs)

    def on_button_num_change_del(self, func):
        """Same as calling: callback_del('button_num_change', func)"""
        self.callback_del("button_num_change", func)

    def on_button_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('button_change', func, ...)"""
        self.callback_add("button_change", func, *args, **kargs)

    def on_button_change_del(self, func):
        """Same as calling: callback_del('button_change', func)"""
        self.callback_del("button_change", func)

    def on_playback_finished_add(self, func, *args, **kargs):
        """Same as calling: callback_add('playback_finished', func, ...)"""
        self.callback_add("playback_finished", func, *args, **kargs)

    def on_playback_finished_del(self, func):
        """Same as calling: callback_del('playback_finished', func)"""
        self.callback_del("playback_finished", func)

    def on_audio_level_change_add(self, func, *args, **kargs):
        """Same as calling: callback_add('audio_level_change', func, ...)"""
        self.callback_add("audio_level_change", func, *args, **kargs)

    def on_audio_level_change_del(self, func):
        """Same as calling: callback_del('audio_level_change', func)"""
        self.callback_del("audio_level_change", func)

    def on_position_update_add(self, func, *args, **kargs):
        """Same as calling: callback_add('position_update', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("position_update", func, *args, **kargs)

    def on_position_update_del(self, func):
        """Same as calling: callback_del('position_update', func)

           .. versionadded:: 1.11 """
        self.callback_del("position_update", func)

    def on_playback_started_add(self, func, *args, **kargs):
        """Same as calling: callback_add('playback_started', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("playback_started", func, *args, **kargs)

    def on_playback_started_del(self, func):
        """Same as calling: callback_del('playback_started', func)

           .. versionadded:: 1.11 """
        self.callback_del("playback_started", func)

    def on_open_done_add(self, func, *args, **kargs):
        """Same as calling: callback_add('open_done', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("open_done", func, *args, **kargs)

    def on_open_done_del(self, func):
        """Same as calling: callback_del('open_done', func)

           .. versionadded:: 1.11 """
        self.callback_del("open_done", func)

    def on_position_save_succeed_add(self, func, *args, **kargs):
        """Same as calling: callback_add('position_save,succeed', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("position_save,succeed", func, *args, **kargs)

    def on_position_save_succeed_del(self, func):
        """Same as calling: callback_del('position_save,succeed', func)

           .. versionadded:: 1.11 """
        self.callback_del("position_save,succeed", func)

    def on_position_save_failed_add(self, func, *args, **kargs):
        """Same as calling: callback_add('position_save,failed', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("position_save,failed", func, *args, **kargs)

    def on_position_save_failed_del(self, func):
        """Same as calling: callback_del('position_save,failed', func)

           .. versionadded:: 1.11 """
        self.callback_del("position_save,failed", func)

    def on_position_load_succeed_add(self, func, *args, **kargs):
        """Same as calling: callback_add('position_load,succeed', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("position_load,succeed", func, *args, **kargs)

    def on_position_load_succeed_del(self, func):
        """Same as calling: callback_del('position_load,succeed', func)

           .. versionadded:: 1.11 """
        self.callback_del("position_load,succeed", func)

    def on_position_load_failed_add(self, func, *args, **kargs):
        """Same as calling: callback_add('position_load,failed', func, ...)

           .. versionadded:: 1.11 """
        self.callback_add("position_load,failed", func, *args, **kargs)

    def on_position_load_failed_del(self, func):
        """Same as calling: callback_del('position_load,failed', func)

            .. versionadded:: 1.11 """
        self.callback_del("position_load,failed", func)


# decorator
def on_event(event_name):
    def decorator(func):
        if not hasattr(func, "__decorated_callbacks__"):
            func.__decorated_callbacks__ = list()
        func.__decorated_callbacks__.append(("callback_add", event_name, func))
        return func
    return decorator


_object_mapping_register("Emotion_Object", Emotion)


init()
atexit.register(shutdown)
