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

from efl.eo cimport const_char_ptr, _ctouni, _cfruni
from efl.eo cimport object_from_instance, _object_mapping_register
from efl.evas cimport Evas_Object, Canvas
from efl.evas cimport Object as evasObject
from efl.evas cimport evas_object_smart_callback_add
from efl.evas cimport evas_object_smart_callback_del


# Emotion_Event:
EMOTION_EVENT_MENU1      = 0
EMOTION_EVENT_MENU2      = 1
EMOTION_EVENT_MENU3      = 2
EMOTION_EVENT_MENU4      = 3
EMOTION_EVENT_MENU5      = 4
EMOTION_EVENT_MENU6      = 5
EMOTION_EVENT_MENU7      = 6
EMOTION_EVENT_UP         = 7
EMOTION_EVENT_DOWN       = 8
EMOTION_EVENT_LEFT       = 9
EMOTION_EVENT_RIGHT      = 10
EMOTION_EVENT_SELECT     = 11
EMOTION_EVENT_NEXT       = 12
EMOTION_EVENT_PREV       = 13
EMOTION_EVENT_ANGLE_NEXT = 14
EMOTION_EVENT_ANGLE_PREV = 15
EMOTION_EVENT_FORCE      = 16
EMOTION_EVENT_0          = 17
EMOTION_EVENT_1          = 18
EMOTION_EVENT_2          = 19
EMOTION_EVENT_3          = 20
EMOTION_EVENT_4          = 21
EMOTION_EVENT_5          = 22
EMOTION_EVENT_6          = 23
EMOTION_EVENT_7          = 24
EMOTION_EVENT_8          = 25
EMOTION_EVENT_9          = 26
EMOTION_EVENT_10         = 27

# Emotion_Meta_Info:
EMOTION_META_INFO_TRACK_TITLE    = 0
EMOTION_META_INFO_TRACK_ARTIST   = 1
EMOTION_META_INFO_TRACK_ALBUM    = 2
EMOTION_META_INFO_TRACK_YEAR     = 3
EMOTION_META_INFO_TRACK_GENRE    = 4
EMOTION_META_INFO_TRACK_COMMENT  = 5
EMOTION_META_INFO_TRACK_DISC_ID  = 6
EMOTION_META_INFO_TRACK_COUNT    = 7

# Emotion_Channel_Settings:
EMOTION_CHANNEL_AUTO    = -1
EMOTION_CHANNEL_DEFAULT = 0

# Emotion_Aspect:
EMOTION_ASPECT_KEEP_NONE   = 0
EMOTION_ASPECT_KEEP_WIDTH  = 1
EMOTION_ASPECT_KEEP_HEIGHT = 2
EMOTION_ASPECT_KEEP_BOTH   = 3
EMOTION_ASPECT_CROP        = 4
EMOTION_ASPECT_CUSTOM      = 5

# Emotion_Suspend:
EMOTION_WAKEUP     = 0
EMOTION_SLEEP      = 1
EMOTION_DEEP_SLEEP = 2
EMOTION_HIBERNATE  = 3


cdef void _emotion_callback(void *data, Evas_Object *o, void *ei) with gil:
    cdef Emotion obj
    cdef object event
    obj = object_from_instance(o)
    event = <object>data
    lst = tuple(obj._emotion_callbacks[event])
    for func, args, kargs in lst:
        try:
            func(obj, *args, **kargs)
        except Exception, e:
            import traceback
            traceback.print_exc()


class EmotionModuleInitError(Exception):
    pass


def init():
    return emotion_init()


def shutdown():
    return emotion_shutdown()


cdef class Emotion(evasObject):
    """ The emotion object

    :see: :py:mod:`The documentation page<efl.emotion>`

    :param evas: The canvas where the object will be added to.
    :type evas: efl.evas.Canvas
    :param module_name: name of the engien to use (gstreamer, xine, vlc or generic)
    :param module_params: Extra parameters, module specific
    :param size: (w, h)
    :param pos: (x, y)
    :param geometry: (x, y, w, h)
    :param color: (r, g, b, a)
    :return: The emotion object instance just created.

    """
    def __cinit__(self, *a, **ka):
        self._emotion_callbacks = {}

    def __init__(self, Canvas canvas not None, **kargs):
        self._set_obj(emotion_object_add(canvas.obj))
        self._set_common_params(**kargs)

    def _set_common_params(self,
                           char *module_name="gstreamer",
                           module_params=None, size=None, pos=None,
                           geometry=None, color=None, name=None):
        evasObject._set_common_params(self, size=size, pos=pos, name=name,
                                      geometry=geometry, color=color)
        if emotion_object_init(self.obj, module_name) == 0:
            raise EmotionModuleInitError("failed to initialize module '%s'" %
                                         module_name)

        if isinstance(module_params, (tuple, list)):
            module_params = dict(module_params)
        if isinstance(module_params, dict):
            for opt, val in module_params.iteritems():
                emotion_object_module_option_set(self.obj, opt, val)

    def __str__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        name = self.name_get()
        if name:
            name_str = "name=%r, "
        else:
            name_str = ""
        return ("%s(%sfile=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%s, visible=%s)") % \
               (self.__class__.__name__, name_str, self.file_get(), x, y, w, h,
                r, g, b, a, self.layer_get(), self.clip_get(),
                self.visible_get())

    def __repr__(self):
        x, y, w, h = self.geometry_get()
        r, g, b, a = self.color_get()
        return ("%s(%#x, type=%r, name=%r, "
                "file=%r, geometry=(%d, %d, %d, %d), "
                "color=(%d, %d, %d, %d), layer=%s, clip=%r, visible=%s) %s") % \
               (self.__class__.__name__, <unsigned long><void *>self,
                self.type_get(), self.name_get(), self.file_get(),
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

        def __set__(self, char *value):
            emotion_object_file_set(self.obj, _cfruni(value))

    def file_get(self):
        return _ctouni(emotion_object_file_get(self.obj))
    def file_set(self, char *file_name):
        emotion_object_file_set(self.obj, _cfruni(file_name))

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
        ratio returned by :py:func:`ratio_get`, but sometimes the information
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
        cdef const_char_ptr info
        ret = dict()
        lst = (("title", EMOTION_META_INFO_TRACK_TITLE),
               ("artist", EMOTION_META_INFO_TRACK_ARTIST),
               ("album", EMOTION_META_INFO_TRACK_ALBUM),
               ("year", EMOTION_META_INFO_TRACK_YEAR),
               ("genre", EMOTION_META_INFO_TRACK_GENRE),
               ("comment", EMOTION_META_INFO_TRACK_COMMENT),
               ("disc_id", EMOTION_META_INFO_TRACK_DISC_ID),
               ("track_count", EMOTION_META_INFO_TRACK_COUNT))
        for n, i in lst:
            info = emotion_object_meta_info_get(self.obj, i)
            if info != NULL:
                ret[n] = info
                ret[i] = info
        return ret

    property meta_info_dict:
        def __get__(self):
            return self.meta_info_dict_get()

    def event_simple_send(self, int event_id):
        """ Send a named signal to the object.

        :param event_id: the signal to emit, one of EMOTION_EVENT_MENU1,
                         EMOTION_EVENT_MENU2, EMOTION_EVENT_UP, EMOTION_EVENT_1,
                         or any other EMOTION_EVENT_* definition
        :type event_id: Emotion_Event
        """
        emotion_object_event_simple_send(self.obj, <Emotion_Event>event_id)


    def callback_add(self, char *event, func, *args, **kargs):
        """ Add a new function (**func**) to be called on the specific **event**.

        The expected signature for **func** is::

            func(object, *args, **kwargs)

        .. note:: Any extra params givento the function (both positional
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
            evas_object_smart_callback_add(self.obj, event,
                                           _emotion_callback, <void *>e)
        lst.append((func, args, kargs))

    def callback_del(self, char *event, func):
        """ Stop the given function **func** to be called on **event**

        :see also: all the on_*_add() shortcut functions

        :param event: the name of the event
        :type event: str
        :param func: the function that was previously attached
        :type func: callable

        """
        try:
            lst = self._emotion_callbacks[event]
        except KeyError, e:
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
        evas_object_smart_callback_del(self.obj, event, _emotion_callback)

    def on_frame_decode_add(self, func, *args, **kargs):
        "Same as calling: callback_add('frame_decode', func, ...)"
        self.callback_add("frame_decode", func, *args, **kargs)

    def on_frame_decode_del(self, func):
        "Same as calling: callback_del('frame_decode', func)"
        self.callback_del("frame_decode", func)

    def on_frame_resize_add(self, func, *args, **kargs):
        "Same as calling: callback_add('frame_resize', func, ...)"
        self.callback_add("frame_resize", func, *args, **kargs)

    def on_frame_resize_del(self, func):
        "Same as calling: callback_del('frame_resize', func)"
        self.callback_del("frame_resize", func)

    def on_length_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('length_change', func, ...)"
        self.callback_add("length_change", func, *args, **kargs)

    def on_length_change_del(self, func):
        "Same as calling: callback_del('length_change', func)"
        self.callback_del("length_change", func)

    def on_decode_stop_add(self, func, *args, **kargs):
        "Same as calling: callback_add('decode_stop', func, ...)"
        self.callback_add("decode_stop", func, *args, **kargs)

    def on_decode_stop_del(self, func):
        "Same as calling: callback_del('decode_stop', func)"
        self.callback_del("decode_stop", func)

    def on_channels_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('channels_change', func, ...)"
        self.callback_add("channels_change", func, *args, **kargs)

    def on_channels_change_del(self, func):
        "Same as calling: callback_del('channels_change', func)"
        self.callback_del("channels_change", func)

    def on_title_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('title_change', func, ...)"
        self.callback_add("title_change", func, *args, **kargs)

    def on_title_change_del(self, func):
        "Same as calling: callback_del('title_change', func)"
        self.callback_del("title_change", func)

    def on_progress_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('progress_change', func, ...)"
        self.callback_add("progress_change", func, *args, **kargs)

    def on_progress_change_del(self, func):
        "Same as calling: callback_del('progress_change', func)"
        self.callback_del("progress_change", func)

    def on_ref_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('ref_change', func, ...)"
        self.callback_add("ref_change", func, *args, **kargs)

    def on_ref_change_del(self, func):
        "Same as calling: callback_del('ref_change', func)"
        self.callback_del("ref_change", func)

    def on_button_num_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('button_num_change', func, ...)"
        self.callback_add("button_num_change", func, *args, **kargs)

    def on_button_num_change_del(self, func):
        "Same as calling: callback_del('button_num_change', func)"
        self.callback_del("button_num_change", func)

    def on_button_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('button_change', func, ...)"
        self.callback_add("button_change", func, *args, **kargs)

    def on_button_change_del(self, func):
        "Same as calling: callback_del('button_change', func)"
        self.callback_del("button_change", func)

    def on_playback_finished_add(self, func, *args, **kargs):
        "Same as calling: callback_add('playback_finished', func, ...)"
        self.callback_add("playback_finished", func, *args, **kargs)

    def on_playback_finished_del(self, func):
        "Same as calling: callback_del('playback_finished', func)"
        self.callback_del("playback_finished", func)

    def on_audio_level_change_add(self, func, *args, **kargs):
        "Same as calling: callback_add('audio_level_change', func, ...)"
        self.callback_add("audio_level_change", func, *args, **kargs)

    def on_audio_level_change_del(self, func):
        "Same as calling: callback_del('audio_level_change', func)"
        self.callback_del("audio_level_change", func)


_object_mapping_register("Emotion_Object", Emotion)


init()
