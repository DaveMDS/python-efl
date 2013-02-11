#!/usr/bin/env python

import optparse
import commands

from efl import evas
from efl import edje
from efl import emotion
from efl import elementary


def pkgconfig_variable(pkg, var):
    cmdline = "pkg-config --variable=%s %s" % (var, pkg)
    status, output = commands.getstatusoutput(cmdline)
    if status != 0:
        raise ValueError("could not find pkg-config module: %s" % pkg)
    return output


prefix_dir = pkgconfig_variable("emotion", "prefix")
data_dir = prefix_dir + "/share/emotion/data"
theme_file = data_dir + "/theme.edj"


class MovieWindow(edje.Edje):
    def __init__(self, canvas, media_module, media_file):
        # emotion video
        # self.vid = emotion.Emotion(canvas, module_filename=media_module)
        # self.vid.file = media_file
        # self.vid.smooth_scale = True
        # self.vid.play = True

        # edje scene object
        edje.Edje.__init__(self, canvas, size=(320, 240),
                           file=theme_file, group="video_controller")
        self.part_drag_value_set("video_speed", 0.0, 1.0)
        self.part_text_set("video_speed_txt", "1.0")
        # self.part_swallow("video_swallow", self.vid)
        self.data["moving"] = False
        self.data["resizing"] = False

        # connect edje + emotion signals
        # self._setup_signals_video()
        # self._setup_signals_frame()

    def _setup_signals_video(self):
        # connect emotion events
        # self.vid.on_frame_decode_add(self.vid_frame_decode_cb)
        # self.vid.on_length_change_add(self.vid_length_change_cb)
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
        self.signal_callback_add("drag", "video_speed",
                                  self.frame_signal_alpha_cb)

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
        lm = length / 60 - (lh * 60)
        ls = length - (lm * 60)
        ph = pos / 3600
        pm = pos / 60 - (ph * 60)
        ps = pos - (pm * 60)
        pf = pos * 100 - (ps * 100) - (pm * 60 * 100) - (ph * 60 * 60 * 100)
        buf = "%i:%02i:%02i.%02i / %i:%02i:%02i" % (ph, pm, ps, pf, lh, lm, ls)
        self.part_text_set("video_progress_txt", buf)
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
        frame.color = (spd, spd, spd, spd)
        frame.part_text_set("video_speed_txt", "%0.0f" % spd)

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
        vid.position = 0.0
        vid.play = True

    def vid_channels_change_cb(self, vid):
        print "Channels: %d audio, %d video, %d spu" % \
              (self.vid.audio_channel_count(),
               self.vid.video_channel_count(),
               self.vid.spu_channel_count())

    def vid_title_change_cb(self, vid):
        print "title:", vid.title

    def vid_progress_change_cb(self, vid):
        print "progress:", vid.progress_info, vid.progress_status

    def vid_ref_change_cb(self, vid):
        print "ref_change:", vid.ref_file, vid.ref_num

    def vid_button_num_change_cb(self, vid):
        print "spu button num:", vid.spu_button_count

    def vid_button_change_cb(self, vid):
        print "spu button:", vid.spu_button

"""
class AppKeyboardEvents(object):
    def broadcast_event(win, event):
        for mw in win.data["movie_windows"]:
            mw.vid.event_simple_send(event)

    def lower_volume(win):
        for mw in win.data["movie_windows"]:
            v = mw.vid.audio_volume
            print "lower:", v
            mw.vid.audio_volume = max(0.0, v - 0.1)

    def raise_volume(win):
        for mw in win.data["movie_windows"]:
            v = mw.vid.audio_volume
            print "raise:", v
            mw.vid.audio_volume = min(1.0, v + 0.1)

    def mute_audio(win):
        for mw in win.data["movie_windows"]:
            mw.vid.audio_mute = not mw.vid.audio_mute

    def mute_video(win):
        for mw in win.data["movie_windows"]:
            mw.vid.video_mute = not mw.vid.video_mute

    def media_info(win):
        for mw in win.data["movie_windows"]:
            print "Info for:", mw.vid
            print "\taudio channels:", mw.vid.audio_channel_count()
            print "\tvideo channels:", mw.vid.video_channel_count()
            print "\tspu channels:", mw.vid.spu_channel_count()
            print "\tseekable:", mw.vid.seekable

    def fullscreen_change(win):
        win.fullscreen = not win.fullscreen
        print "fullscreen is now", win.fullscreen

    # def avoid_damage_change(win):
        # win.avoid_damage = not win.avoid_damage
        # print "avoid_damage is now", win.avoid_damage

    def shaped_change(win):
        win.shaped = not win.shaped
        print "shaped is now", win.shaped

    def bordless_change(win):
        win.borderless = not win.borderless
        print "borderless is now", win.borderless

    def main_delete_request(win):
        print "quit main loop"
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
        "bracketleft": (lower_volume,),
        "bracketright": (raise_volume,),
        "v": (mute_video,),
        "a": (mute_audio,),
        "i": (media_info,),
        "f": (fullscreen_change,),
        # "d": (avoid_damage_change,),
        "s": (shaped_change,),
        "b": (bordless_change,),
        "q": (main_delete_request,),
        }
    def __call__(self, win, info):
        try:
            params = self.key_dispatcher[info.keyname]
            f = params[0]
            args = params[1:]
            f(win, *args)
        except KeyError, e:
            pass
        except Exception, e:
            print "%s ignored exception: %s" % (self.__class__.__name__, e)
"""

"""
def create_scene(ee, canvas):
    bg = edje.Edje(canvas, file=theme_file, group="background")
    bg.size = canvas.size
    bg.layer = -999
    bg.focus = True
    bg.show()
    bg.on_key_down_add(AppKeyboardEvents(), ee)
    ee.data["bg"] = bg





def create_videos(ee, canvas, media_module, args):
    objects = []
    for fname in args:
        mw = MovieWindow(canvas, media_module=media_module, media_file=fname)
        mw.show()
        mw.play = True
        objects.append(mw)
    ee.data["movie_windows"] = objects


def destroy_videos(ee):
    for obj in ee.data["movie_windows"]:
        obj.delete()
    del ee.data["movie_windows"]
"""


def parse_geometry(option, opt, value, parser):
    try:
        w, h = value.split("x")
        w = int(w)
        h = int(h)
    except Exception, e:
        raise optparse.OptionValueError("Invalid format for %s" % option)
    parser.values.geometry = (w, h)


def cmdline_parse():
    usage = "usage: %prog [options] file1 ... fileN"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-g", "--geometry", type="string", metavar="WxH",
                      action="callback", callback=parse_geometry,
                      default=(800, 600),
                      help="use given window geometry")
    parser.add_option("-e", "--engine", type="choice",
                      choices=("xine", "gstreamer", "generic"), default="gstreamer",
                      help=("which multimedia engine to use (xine, gst, generic), "
                            "default=%default"))
    options, args = parser.parse_args()
    if not args:
        parser.error("missing filename")
    return options, args


if __name__ == "__main__"or True:
    options, args = cmdline_parse()

    elementary.init()

    # elementary window
    win = elementary.Window("test-emotion", elementary.ELM_WIN_BASIC)
    win.title_set("python-emotion test application")
    win.callback_delete_request_add(lambda o: elementary.exit())
    # win.on_key_down_add(AppKeyboardEvents())

    
    # edje main scene object
    scene = edje.Edje(win.evas, file=theme_file, group="background")
    win.resize_object_add(scene)
    # win.data["scene"] = scene
    scene.show()

    # one edje frame for each file passed
    i = 0
    objects = []
    for fname in args:
        mw = MovieWindow(win.evas, media_module=options.engine, media_file=fname)
        mw.pos = (i, i)
        mw.show()
        objects.append(mw)
        i += 40
    win.data["movie_windows"] = objects

    r = evas.Rectangle(win.evas, size=(100,100))
    r.show()

    r.delete()
    
    # vid = emotion.Emotion(win.evas, module_filename=options.engine)
    # vid.file = args[0]
    # vid.size=(200,200)
    # vid.smooth_scale = True
    # vid.play = True
    # vid.show()

    # show the win and enter elm main loop
    win.resize(*options.geometry)
    win.show()
    elementary.run()

    # Cleanup objects or you'll get "NAUGHTY PROGRAMMER!!!" on shutdown ;-)
    
    # vid.delete()
    # r.delete()
    # for obj in win.data["movie_windows"]:
        # obj.delete()

    # scene.delete()
    # del win.data["movie_windows"]
    # win.delete()
    # del scene
    

    elementary.shutdown()
    # emotion.shutdown()
    # evas.shutdown()
