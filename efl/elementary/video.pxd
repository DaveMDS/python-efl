from efl.evas cimport Eina_Bool, Evas_Object
from libc.string cimport const_char

cdef extern from "Elementary.h":
    Evas_Object             *elm_player_add(Evas_Object *parent)
    Evas_Object             *elm_video_add(Evas_Object *parent)
    Eina_Bool                elm_video_file_set(Evas_Object *video, const_char *filename)
    Evas_Object             *elm_video_emotion_get(Evas_Object *video)
    void                     elm_video_play(Evas_Object *video)
    void                     elm_video_pause(Evas_Object *video)
    void                     elm_video_stop(Evas_Object *video)
    Eina_Bool                elm_video_is_playing_get(Evas_Object *video)
    Eina_Bool                elm_video_is_seekable_get(Evas_Object *video)
    Eina_Bool                elm_video_audio_mute_get(Evas_Object *video)
    void                     elm_video_audio_mute_set(Evas_Object *video, Eina_Bool mute)
    double                   elm_video_audio_level_get(Evas_Object *video)
    void                     elm_video_audio_level_set(Evas_Object *video, double volume)
    double                   elm_video_play_position_get(Evas_Object *video)
    void                     elm_video_play_position_set(Evas_Object *video, double position)
    double                   elm_video_play_length_get(Evas_Object *video)
    void                     elm_video_remember_position_set(Evas_Object *video, Eina_Bool remember)
    Eina_Bool                elm_video_remember_position_get(Evas_Object *video)
    const_char *             elm_video_title_get(Evas_Object *video)
