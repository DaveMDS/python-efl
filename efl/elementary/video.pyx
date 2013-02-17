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

include "widget_header.pxi"

from layout_class cimport LayoutClass

cdef class Video(LayoutClass):

    """

    Display a video by using Emotion.

    It embeds the video inside an Edje object, so you can do some
    animation depending on the video state change. It also implements a
    resource management policy to remove this burden from the application.

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_video_add(parent.obj))

    property file:
        """Define the file or URI that will be the video source.

        Setting this property will explicitly define a file or URI as a source
        for the video of the Elm_Video object.

        Local files can be specified using file:// or by using full file
        paths. URI could be remote source of video, like http:// or
        local source like WebCam (v4l2://). (You can use Emotion API to
        request and list the available Webcam on your system).

        :type: string

        """
        def __set__(self, filename):
            # TODO: check return value
            elm_video_file_set(self.obj, _cfruni(filename))

    def file_set(self, filename):
        return bool(elm_video_file_set(self.obj, _cfruni(filename)))

    property emotion:
        """The underlying Emotion object.

        :type: emotion.Object

        """
        def __get__(self):
            return object_from_instance(elm_video_emotion_get(self.obj))

    def emotion_get(self):
        return object_from_instance(elm_video_emotion_get(self.obj))

    def play(self):
        """play()

        Start to play the video and cancel all suspend state."""
        elm_video_play(self.obj)

    def pause(self):
        """pause()

        Pause the video and start a timer to trigger suspend mode."""
        elm_video_pause(self.obj)

    def stop(self):
        """stop()

        Stop the video and put the emotion in deep sleep mode."""
        elm_video_stop(self.obj)

    property is_playing:
        """Is the video actually playing.

        You should consider watching event on the object instead of polling
        the object state.

        :type: bool

        """
        def __get__(self):
            return bool(elm_video_is_playing_get(self.obj))

    def is_playing_get(self):
        return bool(elm_video_is_playing_get(self.obj))

    property is_seekable:
        """Is it possible to seek inside the video.

        :type: bool

        """
        def __get__(self):
            return bool(elm_video_is_seekable_get(self.obj))

    def is_seekable_get(self):
        return bool(elm_video_is_seekable_get(self.obj))

    property audio_mute:
        """Is the audio muted.

        :type: bool

        """
        def __get__(self):
            return bool(elm_video_audio_mute_get(self.obj))

        def __set__(self, mute):
            elm_video_audio_mute_set(self.obj, mute)

    def audio_mute_get(self):
        return bool(elm_video_audio_mute_get(self.obj))
    def audio_mute_set(self, mute):
        elm_video_audio_mute_set(self.obj, mute)

    property audio_level:
        """The audio level of the current video.

        :type: float

        """
        def __get__(self):
            return elm_video_audio_level_get(self.obj)

        def __set__(self, volume):
            elm_video_audio_level_set(self.obj, volume)

    def audio_level_get(self):
        return elm_video_audio_level_get(self.obj)
    def audio_level_set(self, double volume):
        elm_video_audio_level_set(self.obj, volume)

    property play_position:
        """Get the current position (in seconds) being played in the Video
        object.

        :type: float

        """
        def __get__(self):
            return elm_video_play_position_get(self.obj)

        def __set__(self, position):
            elm_video_play_position_set(self.obj, position)

    def play_position_get(self):
        return elm_video_play_position_get(self.obj)
    def play_position_set(self, double position):
        elm_video_play_position_set(self.obj, position)

    property play_length:
        """The total playing time (in seconds) of the Video object.

        :type: float

        """
        def __get__(self):
            return elm_video_play_length_get(self.obj)

    def play_length_get(self):
        return elm_video_play_length_get(self.obj)

    property remember_position:
        """Whether the object can remember the last played position.

        .. note:: This API only serves as indication. System support is required.

        :type: bool

        """
        def __get__(self):
            return bool(elm_video_remember_position_get(self.obj))

        def __set__(self, remember):
            elm_video_remember_position_set(self.obj, remember)

    def remember_position_set(self, remember):
        elm_video_remember_position_set(self.obj, remember)
    def remember_position_get(self):
        return bool(elm_video_remember_position_get(self.obj))

    property title:
        """The title (for instance DVD title) from this emotion object.

        This property is only useful when playing a DVD.

        .. note:: Don't change or free the string returned by this function.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_video_title_get(self.obj))

    def title_get(self):
        return _ctouni(elm_video_title_get(self.obj))



_object_mapping_register("elm_video", Video)
cdef class Player(LayoutClass):

    """

    Player is a video player that need to be linked with a :py:class:`Video`.

    It takes care of updating its content according to Emotion events and
    provides a way to theme itself. It also automatically raises the priority of
    the linked :py:class:`Video` so it will use the video decoder, if available. It also
    activates the "remember" function on the linked :py:class:`Video` object.

    The player widget emits the following signals, besides the ones
    sent from :py:class:`elementary.layout.Layout`:

    - ``"forward,clicked"`` - the user clicked the forward button.
    - ``"info,clicked"`` - the user clicked the info button.
    - ``"next,clicked"`` - the user clicked the next button.
    - ``"pause,clicked"`` - the user clicked the pause button.
    - ``"play,clicked"`` - the user clicked the play button.
    - ``"prev,clicked"`` - the user clicked the prev button.
    - ``"rewind,clicked"`` - the user clicked the rewind button.
    - ``"stop,clicked"`` - the user clicked the stop button.

    Default content parts of the player widget that you can use for are:

    - "video" - A video of the player

    """

    def __init__(self, evasObject parent):
        self._set_obj(elm_player_add(parent.obj))

    def callback_forward_clicked_add(self, func, *args, **kwargs):
        """the user clicked the forward button."""
        self._callback_add_full("forward,clicked", func, *args, **kwargs)

    def callback_forward_clicked_del(self, func):
        self._callback_del_full("forward,clicked", func)

    def callback_info_clicked_add(self, func, *args, **kwargs):
        """the user clicked the info button."""
        self._callback_add_full("info,clicked", func, *args, **kwargs)

    def callback_info_clicked_del(self, func):
        self._callback_del_full("info,clicked", func)

    def callback_next_clicked_add(self, func, *args, **kwargs):
        """the user clicked the next button."""
        self._callback_add_full("next,clicked", func, *args, **kwargs)

    def callback_next_clicked_del(self, func):
        self._callback_del_full("next,clicked", func)

    def callback_pause_clicked_add(self, func, *args, **kwargs):
        """the user clicked the pause button."""
        self._callback_add_full("pause,clicked", func, *args, **kwargs)

    def callback_pause_clicked_del(self, func):
        self._callback_del_full("pause,clicked", func)

    def callback_play_clicked_add(self, func, *args, **kwargs):
        """the user clicked the play button."""
        self._callback_add_full("play,clicked", func, *args, **kwargs)

    def callback_play_clicked_del(self, func):
        self._callback_del_full("play,clicked", func)

    def callback_prev_clicked_add(self, func, *args, **kwargs):
        """the user clicked the prev button."""
        self._callback_add_full("prev,clicked", func, *args, **kwargs)

    def callback_prev_clicked_del(self, func):
        self._callback_del_full("prev,clicked", func)

    def callback_rewind_clicked_add(self, func, *args, **kwargs):
        """the user clicked the rewind button."""
        self._callback_add_full("rewind,clicked", func, *args, **kwargs)

    def callback_rewind_clicked_del(self, func):
        self._callback_del_full("rewind,clicked", func)

    def callback_stop_clicked_add(self, func, *args, **kwargs):
        """the user clicked the stop button."""
        self._callback_add_full("stop,clicked", func, *args, **kwargs)

    def callback_stop_clicked_del(self, func):
        self._callback_del_full("stop,clicked", func)


_object_mapping_register("elm_player", Player)
