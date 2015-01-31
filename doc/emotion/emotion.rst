
.. _emotion_main_intro:

What is Emotion?
================

Emotion is a media object library for Evas and Ecore.

Emotion is a library that allows playing audio and video files, using one of
its backends (gstreamer, xine, vlc or generic shm player).

It is integrated into Ecore through its mainloop, and is transparent to the
user of the library how the decoding of audio and video is being done. Once
the objects are created, the user can set callbacks to the specific events
and set options to this object, all in the main loop (no threads are needed).

Emotion is also integrated with Evas. The emotion object returned by
emotion_object_add() is an Evas smart object, so it can be manipulated with
default Evas object functions. Callbacks can be added to the signals emitted
by this object with evas_object_smart_callback_add().

The Emotion library uses Evas smart objects to allow you to manipulate the
created object as any other Evas object, and to connect to its signals,
handling them when needed. It's also possible to swallow Emotion objects
inside Edje themes, and expect it to behave as a normal image or rectangle
when regarding to its dimensions.


How to use the Emotion object
=============================

Emotion provides an Evas smart object that allows to play, control and
display a video or audio file. The API is synchronous but not everything
happens immediately. There are also some signals to report changed states.

Basically, once the object is created and initialized, a file will be set to
it, and then it can be resized, moved, and controlled by other Evas object
functions.

However, the decoding of the music and video occurs not in the Ecore main
loop, but usually in another thread (this depends on the module being used).
The synchronization between this other thread and the main loop not visible
to the end user of the library. The user can just register callbacks to the
available signals to receive information about the changed states, and can
call other functions from the API to request more changes on the current
loaded file.

There will be a delay between an API being called and it being really
executed, since this request will be done in the main thread, and it needs to
be sent to the decoding thread. For this reason, always call functions like
emotion_object_size_get() or emotion_object_length_get() after some signal
being sent, like "playback_started" or "open_done".


Emitted signals
===============

The :py:class:`Emotion` object has a number of signals that can be listened
to using evas' smart callbacks mechanism. The following is a list of
interesting signals:

- ``playback_started`` Emitted when the playback starts
- ``playback_finished`` Emitted when the playback finishes
- ``frame_decode`` Emitted every time a frame is decoded
- ``frame_resize`` Emitted when the frame change its size
- ``open_done`` Emitted when the media file is opened
- ``position_update`` Emitted when emotion_object_position_set is called
- ``audio_level_change`` Emitted when the volume change it's value
- ``decode_stop`` Emitted after the last frame is decoded
- ``length_change`` Emitted if the media change it's size
- ``channels_change`` Emitted when the number of channels change
- ``title_change`` Emitted when the title change (?)
- ``progress_change`` 
- ``ref_change``
- ``button_num_change``
- ``button_change``
- ``position_save,succeed``
- ``position_save,failed``
- ``position_load,succeed``
- ``position_load,failed``


API Reference
=============

.. toctree::
   :titlesonly:

   module-emotion.rst


Inheritance diagram
===================

.. inheritance-diagram:: efl.emotion
    :parts: 2
