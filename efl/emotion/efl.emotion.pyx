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

from efl.eo cimport const_char_ptr
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

    def file_get(self):
        cdef const_char_ptr f
        f = emotion_object_file_get(self.obj)
        if f != NULL:
            return f

    def file_set(self, char *value):
        emotion_object_file_set(self.obj, value)

    property file:
        def __get__(self):
            return self.file_get()

        def __set__(self, char *value):
            self.file_set(value)

    def play_get(self):
        return bool(emotion_object_play_get(self.obj))

    def play_set(self, int value):
        emotion_object_play_set(self.obj, value)

    property play:
        def __get__(self):
            return self.play_get()

        def __set__(self, int value):
            self.play_set(value)

    def position_get(self):
        return emotion_object_position_get(self.obj)

    def position_set(self, double value):
        emotion_object_position_set(self.obj, value)

    property position:
        def __get__(self):
            return self.position_get()

        def __set__(self, double value):
            self.position_set(value)

    def buffer_size_get(self):
        return emotion_object_buffer_size_get(self.obj)

    property buffer_size:
        def __get__(self):
            return self.buffer_size_get()

    def video_handled_get(self):
        return bool(emotion_object_video_handled_get(self.obj))

    property video_handled:
        def __get__(self):
            return self.video_handled_get()

    def audio_handled_get(self):
        return bool(emotion_object_audio_handled_get(self.obj))

    property audio_handled:
        def __get__(self):
            return self.audio_handled_get()

    def seekable_get(self):
        return bool(emotion_object_seekable_get(self.obj))

    property seekable:
        def __get__(self):
            return self.seekable_get()

    def play_length_get(self):
        return emotion_object_play_length_get(self.obj)

    property play_length:
        def __get__(self):
            return self.play_length_get()

    def image_size_get(self):
        cdef int w, h
        emotion_object_size_get(self.obj, &w, &h)
        return (w, h)

    property image_size:
        def __get__(self):
            return self.image_size_get()

    def smooth_scale_get(self):
        return bool(emotion_object_smooth_scale_get(self.obj))

    def smooth_scale_set(self, int value):
        emotion_object_smooth_scale_set(self.obj, value)

    property smooth_scale:
        def __get__(self):
            return self.smooth_scale_get()

        def __set__(self, int value):
            self.smooth_scale_set(value)

    def ratio_get(self):
        return emotion_object_ratio_get(self.obj)

    property ratio:
        def __get__(self):
            return self.ratio_get()

    def event_simple_send(self, int event_id):
        emotion_object_event_simple_send(self.obj, <Emotion_Event>event_id)

    def audio_volume_get(self):
        return emotion_object_audio_volume_get(self.obj)

    def audio_volume_set(self, double value):
        emotion_object_audio_volume_set(self.obj, value)

    property audio_volume:
        def __get__(self):
            return self.audio_volume_get()

        def __set__(self, double value):
            self.audio_volume_set(value)

    def audio_mute_get(self):
        return emotion_object_audio_mute_get(self.obj)

    def audio_mute_set(self, int value):
        emotion_object_audio_mute_set(self.obj, value)

    property audio_mute:
        def __get__(self):
            return self.audio_mute_get()

        def __set__(self, int value):
            self.audio_mute_set(value)

    def audio_channel_count(self):
        return emotion_object_audio_channel_count(self.obj)

    def audio_channel_name_get(self, int channel):
        cdef const_char_ptr n
        n = emotion_object_audio_channel_name_get(self.obj, channel)
        if n != NULL:
            return n

    def audio_channel_get(self):
        return emotion_object_audio_channel_get(self.obj)

    def audio_channel_set(self, int channel):
        emotion_object_audio_channel_set(self.obj, channel)

    property audio_channel:
        def __get__(self):
            return self.audio_channel_get()

        def __set__(self, int value):
            self.audio_channel_set(value)

    def video_mute_get(self):
        return emotion_object_video_mute_get(self.obj)

    def video_mute_set(self, int value):
        emotion_object_video_mute_set(self.obj, value)

    property video_mute:
        def __get__(self):
            return self.video_mute_get()

        def __set__(self, int value):
            self.video_mute_set(value)

    def video_channel_count(self):
        return emotion_object_video_channel_count(self.obj)

    def video_channel_name_get(self, int channel):
        cdef const_char_ptr n
        n = emotion_object_video_channel_name_get(self.obj, channel)
        if n != NULL:
            return n

    def video_channel_get(self):
        return emotion_object_video_channel_get(self.obj)

    def video_channel_set(self, int value):
        emotion_object_video_channel_set(self.obj, value)

    property video_channel:
        def __get__(self):
            return self.video_channel_get()

        def __set__(self, int value):
            self.video_channel_set(value)

    def spu_mute_get(self):
        return emotion_object_spu_mute_get(self.obj)

    def spu_mute_set(self, int value):
        emotion_object_spu_mute_set(self.obj, value)

    property spu_mute:
        def __get__(self):
            return self.spu_mute_get()

        def __set__(self, int value):
            self.spu_mute_set(value)

    def spu_channel_count(self):
        return emotion_object_spu_channel_count(self.obj)

    def spu_channel_name_get(self, int channel):
        cdef const_char_ptr n
        n = emotion_object_spu_channel_name_get(self.obj, channel)
        if n != NULL:
            return n

    def spu_channel_get(self):
        return emotion_object_spu_channel_get(self.obj)

    def spu_channel_set(self, int value):
        emotion_object_spu_channel_set(self.obj, value)

    def spu_button_count_get(self):
        return emotion_object_spu_button_count_get(self.obj)

    property spu_button_count:
        def __get__(self):
            return self.spu_button_count_get()

    def spu_button_get(self):
        return emotion_object_spu_button_get(self.obj)

    property spu_button:
        def __get__(self):
            return self.spu_button_get()

    property spu_channel:
        def __get__(self):
            return self.spu_channel_get()

        def __set__(self, int value):
            self.spu_channel_set(value)

    def chapter_count(self):
        return emotion_object_chapter_count(self.obj)

    def chapter_name_get(self, int channel):
        cdef const_char_ptr n
        n = emotion_object_chapter_name_get(self.obj, channel)
        if n != NULL:
            return n

    def chapter_get(self):
        return emotion_object_chapter_get(self.obj)

    def chapter_set(self, int value):
        emotion_object_chapter_set(self.obj, value)

    property chapter:
        def __get__(self):
            return self.chapter_get()

        def __set__(self, int value):
            self.chapter_set(value)

    def play_speed_get(self):
        return emotion_object_play_speed_get(self.obj)

    def play_speed_set(self, double value):
        emotion_object_play_speed_set(self.obj, value)

    property play_speed:
        def __get__(self):
            return self.play_speed_get()

        def __set__(self, double value):
            self.play_speed_set(value)

    def eject(self):
        emotion_object_eject(self.obj)

    def title_get(self):
        cdef const_char_ptr t
        t = emotion_object_title_get(self.obj)
        if t != NULL:
            return t

    property title:
        def __get__(self):
            return self.title_get()

    def progress_info_get(self):
        cdef const_char_ptr s
        s = emotion_object_progress_info_get(self.obj)
        if s != NULL:
            return s

    property progress_info:
        def __get__(self):
            return self.progress_info_get()

    def progress_status_get(self):
        return emotion_object_progress_status_get(self.obj)

    property progress_status:
        def __get__(self):
            return self.progress_status_get()

    def ref_file_get(self):
        cdef const_char_ptr s
        s = emotion_object_ref_file_get(self.obj)
        if s != NULL:
            return s

    property ref_file:
        def __get__(self):
            return self.ref_file_get()

    def ref_num_get(self):
        return emotion_object_ref_num_get(self.obj)

    property ref_num:
        def __get__(self):
            return self.ref_num_get()

    def meta_info_get(self, int meta_id):
        cdef const_char_ptr s
        s = emotion_object_meta_info_get(self.obj, <Emotion_Meta_Info>meta_id)
        if s != NULL:
            return s

    def meta_info_dict_get(self):
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

    def callback_add(self, char *event, func, *args, **kargs):
        e = intern(event)
        lst = self._emotion_callbacks.setdefault(e, [])
        if not lst:
            evas_object_smart_callback_add(self.obj, event,
                                           _emotion_callback, <void *>e)
        lst.append((func, args, kargs))

    def callback_del(self, char *event, func):
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
        self.callback_add("frame_decode", func, *args, **kargs)

    def on_frame_decode_del(self, func):
        self.callback_del("frame_decode", func)

    def on_frame_resize_add(self, func, *args, **kargs):
        self.callback_add("frame_resize", func, *args, **kargs)

    def on_frame_resize_del(self, func):
        self.callback_del("frame_resize", func)

    def on_length_change_add(self, func, *args, **kargs):
        self.callback_add("length_change", func, *args, **kargs)

    def on_length_change_del(self, func):
        self.callback_del("length_change", func)

    def on_decode_stop_add(self, func, *args, **kargs):
        self.callback_add("decode_stop", func, *args, **kargs)

    def on_decode_stop_del(self, func):
        self.callback_del("decode_stop", func)

    def on_channels_change_add(self, func, *args, **kargs):
        self.callback_add("channels_change", func, *args, **kargs)

    def on_channels_change_del(self, func):
        self.callback_del("channels_change", func)

    def on_title_change_add(self, func, *args, **kargs):
        self.callback_add("title_change", func, *args, **kargs)

    def on_title_change_del(self, func):
        self.callback_del("title_change", func)

    def on_progress_change_add(self, func, *args, **kargs):
        self.callback_add("progress_change", func, *args, **kargs)

    def on_progress_change_del(self, func):
        self.callback_del("progress_change", func)

    def on_ref_change_add(self, func, *args, **kargs):
        self.callback_add("ref_change", func, *args, **kargs)

    def on_ref_change_del(self, func):
        self.callback_del("ref_change", func)

    def on_button_num_change_add(self, func, *args, **kargs):
        self.callback_add("button_num_change", func, *args, **kargs)

    def on_button_num_change_del(self, func):
        self.callback_del("button_num_change", func)

    def on_button_change_add(self, func, *args, **kargs):
        self.callback_add("button_change", func, *args, **kargs)

    def on_button_change_del(self, func):
        self.callback_del("button_change", func)

    def on_playback_finished_add(self, func, *args, **kargs):
        self.callback_add("playback_finished", func, *args, **kargs)

    def on_playback_finished_del(self, func):
        self.callback_del("playback_finished", func)

    def on_audio_level_change_add(self, func, *args, **kargs):
        self.callback_add("audio_level_change", func, *args, **kargs)

    def on_audio_level_change_del(self, func):
        self.callback_del("audio_level_change", func)


_object_mapping_register("Emotion_Object", Emotion)


init()
