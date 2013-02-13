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


cdef class Video(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_video_add(parent.obj))

    def file_set(self, filename):
        return bool(elm_video_file_set(self.obj, _cfruni(filename)))

    property file:
        def __set__(self, filename):
            # TODO: check return value
            elm_video_file_set(self.obj, _cfruni(filename))

    def emotion_get(self):
        return object_from_instance(elm_video_emotion_get(self.obj))

    property emotion:
        def __get__(self):
            return object_from_instance(elm_video_emotion_get(self.obj))

    def play(self):
        elm_video_play(self.obj)

    def pause(self):
        elm_video_pause(self.obj)

    def stop(self):
        elm_video_stop(self.obj)

    def is_playing_get(self):
        return bool(elm_video_is_playing_get(self.obj))

    property is_playing:
        def __get__(self):
            return self.is_playing_get()

    def is_seekable_get(self):
        return bool(elm_video_is_seekable_get(self.obj))

    property is_seekable:
        def __get__(self):
            return self.is_seekable_get()

    def audio_mute_get(self):
        return bool(elm_video_audio_mute_get(self.obj))

    def audio_mute_set(self, mute):
        elm_video_audio_mute_set(self.obj, mute)

    property audio_mute:
        def __get__(self):
            return self.audio_mute_get()
        def __set__(self, mute):
            self.audio_mute_set(mute)

    def audio_level_get(self):
        return elm_video_audio_level_get(self.obj)

    def audio_level_set(self, double volume):
        elm_video_audio_level_set(self.obj, volume)

    property audio_level:
        def __get__(self):
            return self.audio_level_get()
        def __set__(self, volume):
            self.audio_level_set(volume)

    def play_position_get(self):
        return elm_video_play_position_get(self.obj)

    def play_position_set(self, double position):
        elm_video_play_position_set(self.obj, position)

    property play_position:
        def __get__(self):
            return self.play_position_get()
        def __set__(self, position):
            self.play_position_set(position)

    def play_length_get(self):
        return elm_video_play_length_get(self.obj)

    property play_length:
        def __get__(self):
            return self.play_length_get()

    def remember_position_set(self, remember):
        elm_video_remember_position_set(self.obj, remember)

    def remember_position_get(self):
        return bool(elm_video_remember_position_get(self.obj))

    property remember_position:
        def __get__(self):
            return self.remember_position_get()
        def __set__(self, remember):
            self.remember_position_set(remember)

    def title_get(self):
        return _ctouni(elm_video_title_get(self.obj))

    property title:
        def __get__(self):
            return self.title_get()


_object_mapping_register("elm_video", Video)


cdef class Player(LayoutClass):

    def __init__(self, evasObject parent):
        self._set_obj(elm_player_add(parent.obj))

    def callback_forward_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("forward,clicked", func, *args, **kwargs)

    def callback_forward_clicked_del(self, func):
        self._callback_del_full("forward,clicked", func)

    def callback_info_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("info,clicked", func, *args, **kwargs)

    def callback_info_clicked_del(self, func):
        self._callback_del_full("info,clicked", func)

    def callback_next_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("next,clicked", func, *args, **kwargs)

    def callback_next_clicked_del(self, func):
        self._callback_del_full("next,clicked", func)

    def callback_pause_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("pause,clicked", func, *args, **kwargs)

    def callback_pause_clicked_del(self, func):
        self._callback_del_full("pause,clicked", func)

    def callback_play_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("play,clicked", func, *args, **kwargs)

    def callback_play_clicked_del(self, func):
        self._callback_del_full("play,clicked", func)

    def callback_prev_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("prev,clicked", func, *args, **kwargs)

    def callback_prev_clicked_del(self, func):
        self._callback_del_full("prev,clicked", func)

    def callback_rewind_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("rewind,clicked", func, *args, **kwargs)

    def callback_rewind_clicked_del(self, func):
        self._callback_del_full("rewind,clicked", func)

    def callback_stop_clicked_add(self, func, *args, **kwargs):
        self._callback_add_full("stop,clicked", func, *args, **kwargs)

    def callback_stop_clicked_del(self, func):
        self._callback_del_full("stop,clicked", func)


_object_mapping_register("elm_player", Player)
