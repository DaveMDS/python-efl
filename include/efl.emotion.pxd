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

from efl cimport Eina_Bool
from efl.evas cimport Evas, Evas_Object
from efl.evas cimport Object as evasObject


cdef extern from "Emotion.h":

    ctypedef enum Emotion_Event:
        pass

    ctypedef enum Emotion_Meta_Info:
        pass

    ctypedef enum Emotion_Aspect:
        pass

    ctypedef enum Emotion_Suspend:
        pass

    Eina_Bool emotion_init()
    Eina_Bool emotion_shutdown()
    
    Evas_Object *emotion_object_add(Evas *e)
    void emotion_object_module_option_set(Evas_Object *obj, char *opt, char *val)
    Eina_Bool emotion_object_init(Evas_Object *obj, char *module_filename)

    void emotion_object_file_set(Evas_Object *obj, char *filename)
    char *emotion_object_file_get(Evas_Object *obj)

    void emotion_object_play_set(Evas_Object *obj, Eina_Bool play)
    Eina_Bool emotion_object_play_get(Evas_Object *obj)

    void emotion_object_position_set(Evas_Object *obj, double sec)
    double emotion_object_position_get(Evas_Object *obj)

    Eina_Bool emotion_object_video_handled_get(Evas_Object *obj)
    Eina_Bool emotion_object_audio_handled_get(Evas_Object *obj)
    Eina_Bool emotion_object_seekable_get(Evas_Object *obj)
    double emotion_object_play_length_get(Evas_Object *obj)
    void emotion_object_size_get(Evas_Object *obj, int *iw, int *ih)
    void emotion_object_smooth_scale_set(Evas_Object *obj, Eina_Bool smooth)
    Eina_Bool emotion_object_smooth_scale_get(Evas_Object *obj)
    double emotion_object_ratio_get(Evas_Object *obj)
    double emotion_object_buffer_size_get(Evas_Object *obj)

    void emotion_object_event_simple_send(Evas_Object *obj, Emotion_Event ev)

    void emotion_object_audio_volume_set(Evas_Object *obj, double vol)
    double emotion_object_audio_volume_get(Evas_Object *obj)
    void emotion_object_audio_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_audio_mute_get(Evas_Object *obj)
    int emotion_object_audio_channel_count(Evas_Object *obj)
    char *emotion_object_audio_channel_name_get(Evas_Object *obj, int channel)
    void emotion_object_audio_channel_set(Evas_Object *obj, int channel)
    int emotion_object_audio_channel_get(Evas_Object *obj)
    void emotion_object_video_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_video_mute_get(Evas_Object *obj)
    int emotion_object_video_channel_count(Evas_Object *obj)
    char *emotion_object_video_channel_name_get(Evas_Object *obj, int channel)
    void emotion_object_video_channel_set(Evas_Object *obj, int channel)
    int emotion_object_video_channel_get(Evas_Object *obj)
    void emotion_object_spu_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_spu_mute_get(Evas_Object *obj)
    int emotion_object_spu_channel_count(Evas_Object *obj)
    char *emotion_object_spu_channel_name_get(Evas_Object *obj, int channel)
    void emotion_object_spu_channel_set(Evas_Object *obj, int channel)
    int emotion_object_spu_channel_get(Evas_Object *obj)
    int emotion_object_chapter_count(Evas_Object *obj)
    void emotion_object_chapter_set(Evas_Object *obj, int chapter)
    int emotion_object_chapter_get(Evas_Object *obj)
    char *emotion_object_chapter_name_get(Evas_Object *obj, int chapter)
    void emotion_object_play_speed_set(Evas_Object *obj, double speed)
    double emotion_object_play_speed_get(Evas_Object *obj)

    void emotion_object_eject(Evas_Object *obj)

    char *emotion_object_title_get(Evas_Object *obj)
    char *emotion_object_progress_info_get(Evas_Object *obj)
    double emotion_object_progress_status_get(Evas_Object *obj)
    char *emotion_object_ref_file_get(Evas_Object *obj)
    int emotion_object_ref_num_get(Evas_Object *obj)
    int emotion_object_spu_button_count_get(Evas_Object *obj)
    int emotion_object_spu_button_get(Evas_Object *obj)
    char *emotion_object_meta_info_get(Evas_Object *obj, Emotion_Meta_Info meta)


cdef class Emotion(evasObject):
    cdef object _emotion_callbacks
