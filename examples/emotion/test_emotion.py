#!/usr/bin/env python

import os
import optparse

from efl import evas
from efl import edje
from efl import emotion
from efl.emotion import Emotion
from efl import elementary
from efl.elementary.window import Window, ELM_WIN_BASIC


script_path = os.path.dirname(os.path.abspath(__file__))
theme_file = os.path.join(script_path, "theme.edj")


class MyDecoratedEmotion(Emotion):
    def __init__(self, canvas, module_name):
        Emotion.__init__(self, canvas, module_name=module_name)

    @emotion.on_event("frame_resize")
    def cb_frame_decoded(self):
        print("Decorated callback successfully called")


class MovieWindow(edje.Edje):
    def __init__(self, canvas, media_module, media_file):
        # emotion video
        self.vid = MyDecoratedEmotion(canvas, module_name=media_module)
        self.vid.file = media_file
        self.vid.smooth_scale = True
        self.vid.play = True
        self.vid.audio_volume = 0.5

        if options.position:
            self.vid.last_position_load()

        # edje scene object
        if options.reflex:
            group = "video_controller/reflex"
        else:
            group = "video_controller"
        edje.Edje.__init__(self, canvas, size=(320, 240),
                           file=theme_file, group=group)
        self.part_drag_value_set("video_alpha", 0.0, 1.0)
        self.part_text_set("video_alpha_txt", "alpha 255")
        self.part_drag_value_set("video_volume", 0.0, 0.5)
        self.part_text_set("video_volume_txt", "vol 0.50")

        self.part_swallow("video_swallow", self.vid)
        self.data["moving"] = False
        self.data["resizing"] = False

        # connect edje + emotion signals
        self._setup_signals_video()
        self._setup_signals_frame()

    def _setup_signals_video(self):
        # connect emotion events
        self.vid.on_frame_decode_add(self.vid_frame_decode_cb)
        self.vid.on_length_change_add(self.vid_length_change_cb)
        self.vid.on_frame_resize_add(self.vid_frame_resize_cb)
        self.vid.on_decode_stop_add(self.vid_decode_stop_cb)
        self.vid.on_channels_change_add(self.vid_channels_change_cb)
        self.vid.on_title_change_add(self.vid_title_change_cb)
        self.vid.on_progress_change_add(self.vid_progress_change_cb)
        self.vid.on_ref_change_add(self.vid_ref_change_cb)
        self.vid.on_button_num_change_add(self.vid_button_num_change_cb)
        self.vid.on_button_change_add(self.vid_button_change_cb)

    def _setup_signals_frame(self):
        # connect frame edje events
        self.signal_callback_add("video_control", "play",
                                  self.frame_signal_play_cb)
        self.signal_callback_add("video_control", "pause",
                                  self.frame_signal_pause_cb)
        self.signal_callback_add("video_control", "stop",
                                  self.frame_signal_stop_cb)
        self.signal_callback_add("drag", "video_progress",
                                  self.frame_signal_jump_cb)
        self.signal_callback_add("drag", "video_alpha",
                                  self.frame_signal_alpha_cb)
        self.signal_callback_add("drag", "video_volume",
                                  self.frame_signal_volume_cb)

        self.signal_callback_add("frame_move", "start",
                                  self.frame_signal_move_start_cb)
        self.signal_callback_add("frame_move", "stop",
                                  self.frame_signal_move_stop_cb)
        self.signal_callback_add("frame_resize", "start",
                                  self.frame_signal_resize_start_cb)
        self.signal_callback_add("frame_resize", "stop",
                                  self.frame_signal_resize_stop_cb)
        self.signal_callback_add("mouse,move", "*",
                                  self.frame_signal_move_cb)

    def delete(self):
        self.vid.delete()
        edje.Edje.delete(self)

    def vid_frame_time_update(self, vid):
        pos = vid.position
        length = vid.play_length
        lh = length / 3600
        lm = (length % 3600) / 60
        ls = length % 60
        ph = pos / 3600
        pm = (pos % 3600) / 60
        ps = pos % 60
        pf = (pos % 1) * 100
        buf = "%i:%02i:%02i.%02i / %i:%02i:%02i" % (ph, pm, ps, pf, lh, lm, ls)
        self.part_text_set("video_progress_txt", buf)
        if length > 0:
            self.part_drag_value_set("video_progress", pos / length, 0.0)

    # frame callbacks
    def frame_signal_play_cb(self, frame, emission, source):
        self.vid.play = True
        self.signal_emit("video_state", "play")

    def frame_signal_pause_cb(self, frame, emission, source):
        self.vid.play = False
        self.signal_emit("video_state", "pause")

    def frame_signal_stop_cb(self, frame, emission, source):
        self.vid.play = False
        self.vid.position = 0.0
        self.signal_emit("video_state", "stop")

    def frame_signal_jump_cb(self, frame, emission, source):
        x, y = frame.part_drag_value_get(source)
        length = self.vid.play_length
        self.vid.position = x * length

    def frame_signal_alpha_cb(self, frame, emission, source):
        x, y = frame.part_drag_value_get(source)
        spd = int(255 * y)
        self.vid.color = (spd, spd, spd, spd)
        frame.part_text_set("video_alpha_txt", "alpha %0.0f" % spd)

    def frame_signal_volume_cb(self, frame, emission, source):
        x, vol = frame.part_drag_value_get(source)
        self.vid.audio_volume = vol
        frame.part_text_set("video_volume_txt", "vol %.2f" % vol)

    def frame_signal_move_start_cb(self, frame, emission, source):
        self.data["moving"] = True
        self.data["move_pos"] = frame.evas.pointer_canvas_xy
        self.raise_()

    def frame_signal_move_stop_cb(self, frame, emission, source):
        self.data["moving"] = False

    def frame_signal_move_cb(self, frame, emission, source):
        if self.data["moving"]:
            lx, ly = self.data["move_pos"]
            x, y = self.evas.pointer_canvas_xy
            self.move_relative(x - lx, y - ly)
            self.data["move_pos"] = (x, y)
        elif self.data["resizing"]:
            lx, ly = self.data["resize_pos"]
            x, y = self.evas.pointer_canvas_xy
            w, h = self.size
            self.size = (w + x - lx, h + y - ly)
            self.data["resize_pos"] = (x, y)

    def frame_signal_resize_start_cb(self, frame, emission, source):
        self.data["resizing"] = True
        self.data["resize_pos"] = frame.evas.pointer_canvas_xy
        frame.raise_()

    def frame_signal_resize_stop_cb(self, frame, emission, source):
        self.data["resizing"] = False

    # emotion callbacks
    def vid_frame_decode_cb(self, vid):
        self.vid_frame_time_update(vid)

    def vid_length_change_cb(self, vid):
        self.vid_frame_time_update(vid)

    def vid_frame_resize_cb(self, vid):
        if vid.size == (0, 0):
            self.size = vid.image_size
        else:
            w, h = self.size
            ratio = vid.ratio
            if ratio > 0.0:
                w = h * ratio + 0.5
            self.size = (w, h)

    def vid_decode_stop_cb(self, vid):
        if options.loop:
            vid.position = 0.0
            vid.play = True

    def vid_channels_change_cb(self, vid):
        print("Channels: %d audio, %d video, %d spu" % \
              (self.vid.audio_channel_count(),
               self.vid.video_channel_count(),
               self.vid.spu_channel_count()))

    def vid_title_change_cb(self, vid):
        print("title: %s" % vid.title)

    def vid_progress_change_cb(self, vid):
        print("progress: %f %f" % (vid.progress_info, vid.progress_status))

    def vid_ref_change_cb(self, vid):
        print("ref_change: %s %s" % vid.ref_file, vid.ref_num)

    def vid_button_num_change_cb(self, vid):
        print("spu button num: %d" % vid.spu_button_count)

    def vid_button_change_cb(self, vid):
        print("spu button: %s" % vid.spu_button)


class AppKeyboardEvents(object):
    def broadcast_event(win, event):
        for mw in win.data["movie_windows"]:
            mw.vid.event_simple_send(event)

    def lower_volume(win):
        for mw in win.data["movie_windows"]:
            v = mw.vid.audio_volume
            print("lower: %f" % v)
            mw.vid.audio_volume = max(0.0, v - 0.1)

    def raise_volume(win):
        for mw in win.data["movie_windows"]:
            v = mw.vid.audio_volume
            print("raise: %f" % v)
            mw.vid.audio_volume = min(1.0, v + 0.1)

    def mute_audio(win):
        for mw in win.data["movie_windows"]:
            mw.vid.audio_mute = not mw.vid.audio_mute

    def mute_video(win):
        for mw in win.data["movie_windows"]:
            mw.vid.video_mute = not mw.vid.video_mute

    def media_info(win):
        for mw in win.data["movie_windows"]:
            print("Info for: %s" % mw.vid)
            print("\taudio channels: %d" % mw.vid.audio_channel_count())
            print("\tvideo channels: %d" % mw.vid.video_channel_count())
            print("\tspu channels: %d" % mw.vid.spu_channel_count())
            print("\tseekable: %s" % mw.vid.seekable)

    def toggle_pause(win):
        for mw in win.data["movie_windows"]:
            mw.vid.play = not mw.vid.play
            print("play is now %s" % mw.vid.play)

    def fullscreen_change(win):
        win.fullscreen = not win.fullscreen
        print("fullscreen is now %s" % win.fullscreen)

    # def avoid_damage_change(win):
        # win.avoid_damage = not win.avoid_damage
        # print "avoid_damage is now", win.avoid_damage

    def shaped_change(win):
        win.shaped = not win.shaped
        print("shaped is now %s" % win.shaped)

    def bordless_change(win):
        win.borderless = not win.borderless
        print("borderless is now %s" % win.borderless)

    def main_delete_request(win):
        print("quit main loop")
        elementary.exit()

    key_dispatcher = {
        "Escape": (main_delete_request,),
        "Up": (broadcast_event, emotion.EMOTION_EVENT_UP),
        "Down": (broadcast_event, emotion.EMOTION_EVENT_DOWN),
        "Left": (broadcast_event, emotion.EMOTION_EVENT_LEFT),
        "Right": (broadcast_event, emotion.EMOTION_EVENT_RIGHT),
        "Return": (broadcast_event, emotion.EMOTION_EVENT_SELECT),
        "m": (broadcast_event, emotion.EMOTION_EVENT_MENU1),
        "Prior": (broadcast_event, emotion.EMOTION_EVENT_PREV),
        "Next": (broadcast_event, emotion.EMOTION_EVENT_NEXT),
        "0": (broadcast_event, emotion.EMOTION_EVENT_0),
        "1": (broadcast_event, emotion.EMOTION_EVENT_1),
        "2": (broadcast_event, emotion.EMOTION_EVENT_2),
        "3": (broadcast_event, emotion.EMOTION_EVENT_3),
        "4": (broadcast_event, emotion.EMOTION_EVENT_4),
        "5": (broadcast_event, emotion.EMOTION_EVENT_5),
        "6": (broadcast_event, emotion.EMOTION_EVENT_6),
        "7": (broadcast_event, emotion.EMOTION_EVENT_7),
        "8": (broadcast_event, emotion.EMOTION_EVENT_8),
        "9": (broadcast_event, emotion.EMOTION_EVENT_9),
        "-": (broadcast_event, emotion.EMOTION_EVENT_10),
        "minus": (lower_volume,),
        "plus": (raise_volume,),
        "v": (mute_video,),
        "a": (mute_audio,),
        "i": (media_info,),
        "f": (fullscreen_change,),
        # "d": (avoid_damage_change,),
        "s": (shaped_change,),
        "b": (bordless_change,),
        "q": (main_delete_request,),
        "p": (toggle_pause,),
        }
    def __call__(self, win, info):
        try:
            params = self.key_dispatcher[info.keyname]
            f = params[0]
            args = params[1:]
            f(win, *args)
        except KeyError as e:
            pass
        except Exception as e:
            print("%s ignored exception: %s" % (self.__class__.__name__, e))



def parse_geometry(option, opt, value, parser):
    try:
        w, h = value.split("x")
        w = int(w)
        h = int(h)
    except Exception as e:
        raise optparse.OptionValueError("Invalid format for %s" % option)
    parser.values.geometry = (w, h)


def cmdline_parse():
    usage = "usage: %prog [options] file1 ... fileN"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-g", "--geometry", type="string", metavar="WxH",
                      action="callback", callback=parse_geometry,
                      default=(800, 600),
                      help="use given window geometry")
    engines = ("gstreamer1", "vlc", "gstreamer", "xine")
    parser.add_option("-e", "--engine", type="choice",
                      choices=engines, default=engines[0],
                      help=("multimedia engine to use {} "
                            "default=%default").format(engines) )
    parser.add_option("-w", "--webcams", action="store_true",
                      default=False,
                      help=("show all the available v4l streams") )
    parser.add_option("-r", "--reflex", action="store_true",
                      default=False,
                      help=("show video reflex effect") )
    parser.add_option("-l", "--loop", action="store_true",
                      default=False,
                      help=("restart the video when end reached") )
    parser.add_option("-p", "--position", action="store_true",
                      default=False,
                      help=("start the video from last know position") )
    options, args = parser.parse_args()
    if not args and not options.webcams:
        parser.error("missing filename or the -w option")
    return options, args


if __name__ == "__main__":
    options, args = cmdline_parse()

    # elementary window
    win = Window("test-emotion", ELM_WIN_BASIC)
    win.title_set("python-emotion test application")
    win.callback_delete_request_add(lambda o: elementary.exit())
    win.on_key_down_add(AppKeyboardEvents())

    # edje main scene object
    scene = edje.Edje(win.evas, file=theme_file, group="background")
    win.resize_object_add(scene)
    scene.show()

    win.data["movie_windows"] = objects = []

    # one edje frame for each file passed
    for fname in args:
        print("Playing url: '%s'" % (fname))
        mw = MovieWindow(win.evas, media_module=options.engine, media_file=fname)
        objects.append(mw)

    # one edje frame for each webcams found
    if options.webcams:
        for webcam in emotion.webcams_get():
            print("Found webcam: '%s'  url: '%s'" % (webcam))
            name, url = webcam
            mw = MovieWindow(win.evas, media_module=options.engine, media_file=url)
            objects.append(mw)

    # show each frame
    i = 0
    for mw in objects:
        mw.pos = (i, i)
        mw.show()
        i += 40

    # show the win and enter elm main loop
    win.resize(*options.geometry)
    win.show()
    elementary.run()

    # Cleanup objects or you'll get "NAUGHTY PROGRAMMER!!!" on shutdown ;-)
    for obj in win.data["movie_windows"]:
        obj.delete()

    scene.delete()
    del win.data["movie_windows"]
    win.delete()
    del scene
