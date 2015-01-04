# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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

from efl.eina cimport Eina_Bool, Eina_List
from efl.evas cimport Evas, Evas_Object
from efl.evas cimport Object as evasObject

cdef extern from "Emotion.h":

    ####################################################################
    # Define
    #
    cpdef enum:
        EMOTION_CHANNEL_AUTO
        EMOTION_CHANNEL_DEFAULT

    ####################################################################
    # Enums
    #
    cpdef enum Emotion_Event:
        EMOTION_EVENT_MENU1
        EMOTION_EVENT_MENU2
        EMOTION_EVENT_MENU3
        EMOTION_EVENT_MENU4
        EMOTION_EVENT_MENU5
        EMOTION_EVENT_MENU6
        EMOTION_EVENT_MENU7
        EMOTION_EVENT_UP
        EMOTION_EVENT_DOWN
        EMOTION_EVENT_LEFT
        EMOTION_EVENT_RIGHT
        EMOTION_EVENT_SELECT
        EMOTION_EVENT_NEXT
        EMOTION_EVENT_PREV
        EMOTION_EVENT_ANGLE_NEXT
        EMOTION_EVENT_ANGLE_PREV
        EMOTION_EVENT_FORCE
        EMOTION_EVENT_0
        EMOTION_EVENT_1
        EMOTION_EVENT_2
        EMOTION_EVENT_3
        EMOTION_EVENT_4
        EMOTION_EVENT_5
        EMOTION_EVENT_6
        EMOTION_EVENT_7
        EMOTION_EVENT_8
        EMOTION_EVENT_9
        EMOTION_EVENT_10
    ctypedef enum Emotion_Event:
        pass

    cpdef enum Emotion_Meta_Info:
        EMOTION_META_INFO_TRACK_TITLE
        EMOTION_META_INFO_TRACK_ARTIST
        EMOTION_META_INFO_TRACK_ALBUM
        EMOTION_META_INFO_TRACK_YEAR
        EMOTION_META_INFO_TRACK_GENRE
        EMOTION_META_INFO_TRACK_COMMENT
        EMOTION_META_INFO_TRACK_DISC_ID
        EMOTION_META_INFO_TRACK_COUNT
    ctypedef enum Emotion_Meta_Info:
        pass

    cpdef enum Emotion_Aspect:
        EMOTION_ASPECT_KEEP_NONE
        EMOTION_ASPECT_KEEP_WIDTH
        EMOTION_ASPECT_KEEP_HEIGHT
        EMOTION_ASPECT_KEEP_BOTH
        EMOTION_ASPECT_CROP
        EMOTION_ASPECT_CUSTOM
    ctypedef enum Emotion_Aspect:
        pass

    cpdef enum Emotion_Suspend:
        EMOTION_WAKEUP
        EMOTION_SLEEP
        EMOTION_DEEP_SLEEP
        EMOTION_HIBERNATE
    ctypedef enum Emotion_Suspend:
        pass

    cpdef enum Emotion_Vis:
        EMOTION_VIS_NONE
        EMOTION_VIS_GOOM
        EMOTION_VIS_LIBVISUAL_BUMPSCOPE
        EMOTION_VIS_LIBVISUAL_CORONA
        EMOTION_VIS_LIBVISUAL_DANCING_PARTICLES
        EMOTION_VIS_LIBVISUAL_GDKPIXBUF
        EMOTION_VIS_LIBVISUAL_G_FORCE
        EMOTION_VIS_LIBVISUAL_GOOM
        EMOTION_VIS_LIBVISUAL_INFINITE
        EMOTION_VIS_LIBVISUAL_JAKDAW
        EMOTION_VIS_LIBVISUAL_JESS
        EMOTION_VIS_LIBVISUAL_LV_ANALYSER
        EMOTION_VIS_LIBVISUAL_LV_FLOWER
        EMOTION_VIS_LIBVISUAL_LV_GLTEST
        EMOTION_VIS_LIBVISUAL_LV_SCOPE
        EMOTION_VIS_LIBVISUAL_MADSPIN
        EMOTION_VIS_LIBVISUAL_NEBULUS
        EMOTION_VIS_LIBVISUAL_OINKSIE
        EMOTION_VIS_LIBVISUAL_PLASMA
        EMOTION_VIS_LAST
    ctypedef enum Emotion_Vis:
        pass

    ####################################################################
    # Structs
    #
    ctypedef struct Emotion_Webcam:
        pass

    ####################################################################
    # Functions
    #
    Eina_Bool emotion_init()
    Eina_Bool emotion_shutdown()

    Evas_Object *emotion_object_add(Evas *e)
    void emotion_object_module_option_set(Evas_Object *obj, char *opt, char *val)
    Eina_Bool emotion_object_init(Evas_Object *obj, char *module_filename)

    void emotion_object_file_set(Evas_Object *obj, char *filename)
    char *emotion_object_file_get(const Evas_Object *obj)

    void emotion_object_play_set(Evas_Object *obj, Eina_Bool play)
    Eina_Bool emotion_object_play_get(const Evas_Object *obj)

    void emotion_object_position_set(Evas_Object *obj, double sec)
    double emotion_object_position_get(const Evas_Object *obj)

    Eina_Bool emotion_object_video_handled_get(const Evas_Object *obj)
    Eina_Bool emotion_object_audio_handled_get(const Evas_Object *obj)
    Eina_Bool emotion_object_seekable_get(const Evas_Object *obj)
    double emotion_object_play_length_get(const Evas_Object *obj)
    void emotion_object_size_get(const Evas_Object *obj, int *iw, int *ih)
    void emotion_object_smooth_scale_set(Evas_Object *obj, Eina_Bool smooth)
    Eina_Bool emotion_object_smooth_scale_get(const Evas_Object *obj)
    double emotion_object_ratio_get(const Evas_Object *obj)
    double emotion_object_buffer_size_get(const Evas_Object *obj)

    void emotion_object_event_simple_send(Evas_Object *obj, Emotion_Event ev)

    void emotion_object_audio_volume_set(Evas_Object *obj, double vol)
    double emotion_object_audio_volume_get(const Evas_Object *obj)
    void emotion_object_audio_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_audio_mute_get(const Evas_Object *obj)
    int emotion_object_audio_channel_count(const Evas_Object *obj)
    char *emotion_object_audio_channel_name_get(const Evas_Object *obj, int channel)
    void emotion_object_audio_channel_set(Evas_Object *obj, int channel)
    int emotion_object_audio_channel_get(const Evas_Object *obj)
    void emotion_object_video_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_video_mute_get(const Evas_Object *obj)
    int emotion_object_video_channel_count(const Evas_Object *obj)
    char *emotion_object_video_channel_name_get(const Evas_Object *obj, int channel)
    void emotion_object_video_channel_set(Evas_Object *obj, int channel)
    int emotion_object_video_channel_get(const Evas_Object *obj)
    void emotion_object_spu_mute_set(Evas_Object *obj, Eina_Bool mute)
    Eina_Bool emotion_object_spu_mute_get(const Evas_Object *obj)
    int emotion_object_spu_channel_count(const Evas_Object *obj)
    char *emotion_object_spu_channel_name_get(const Evas_Object *obj, int channel)
    void emotion_object_spu_channel_set(Evas_Object *obj, int channel)
    int emotion_object_spu_channel_get(const Evas_Object *obj)
    int emotion_object_chapter_count(const Evas_Object *obj)
    void emotion_object_chapter_set(Evas_Object *obj, int chapter)
    int emotion_object_chapter_get(const Evas_Object *obj)
    char *emotion_object_chapter_name_get(const Evas_Object *obj, int chapter)
    void emotion_object_play_speed_set(Evas_Object *obj, double speed)
    double emotion_object_play_speed_get(const Evas_Object *obj)

    void emotion_object_eject(Evas_Object *obj)

    char *emotion_object_title_get(const Evas_Object *obj)
    char *emotion_object_progress_info_get(const Evas_Object *obj)
    double emotion_object_progress_status_get(const Evas_Object *obj)
    char *emotion_object_ref_file_get(const Evas_Object *obj)
    int emotion_object_ref_num_get(const Evas_Object *obj)
    int emotion_object_spu_button_count_get(const Evas_Object *obj)
    int emotion_object_spu_button_get(const Evas_Object *obj)
    char *emotion_object_meta_info_get(const Evas_Object *obj, Emotion_Meta_Info meta)

    void emotion_object_border_set(Evas_Object *obj, int l, int r, int t, int b)
    void emotion_object_border_get(const Evas_Object *obj, int *l, int *r, int *t, int *b)
    void emotion_object_bg_color_set(Evas_Object *obj, int r, int g, int b, int a)
    void emotion_object_bg_color_get(const Evas_Object *obj, int *r, int *g, int *b, int *a)
    void emotion_object_keep_aspect_set(Evas_Object *obj, Emotion_Aspect a)
    Emotion_Aspect emotion_object_keep_aspect_get(const Evas_Object *obj)
    void emotion_object_video_subtitle_file_set(Evas_Object *obj, const char *filepath)
    const char *emotion_object_video_subtitle_file_get(const Evas_Object *obj)
    void  emotion_object_priority_set(Evas_Object *obj, Eina_Bool priority)
    Eina_Bool emotion_object_priority_get(const Evas_Object *obj)
    Emotion_Suspend emotion_object_suspend_get(Evas_Object *obj)
    void emotion_object_suspend_set(Evas_Object *obj, Emotion_Suspend state)
    void emotion_object_last_position_load(Evas_Object *obj)
    void emotion_object_last_position_save(Evas_Object *obj)
    Eina_Bool emotion_object_extension_may_play_get(const char *file)
    Evas_Object *emotion_object_image_get(const Evas_Object *obj)

    const Eina_List *emotion_webcams_get()
    const char *emotion_webcam_name_get(Emotion_Webcam *ew)
    const char *emotion_webcam_device_get(Emotion_Webcam *ew)

    void emotion_object_vis_set(Evas_Object *obj, Emotion_Vis visualization)
    Emotion_Vis emotion_object_vis_get(const Evas_Object *obj)
    Eina_Bool emotion_object_vis_supported(const Evas_Object *obj, Emotion_Vis visualization)


cdef class Emotion(evasObject):
    cdef object _emotion_callbacks
