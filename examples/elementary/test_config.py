#!/usr/bin/env python
# encoding: utf-8

import os

from efl.evas import EVAS_HINT_FILL, EVAS_HINT_EXPAND, EXPAND_BOTH, \
    EXPAND_HORIZ, FILL_BOTH, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow, Window, \
    ELM_WIN_INLINED_IMAGE, ELM_WIN_SOCKET_IMAGE
from efl.elementary.button import Button
from efl.elementary.background import Background
from efl.elementary.label import Label
from efl.elementary.radio import Radio
from efl.elementary.check import Check
from efl.elementary.scroller import Scroller
from efl.elementary.box import Box
from efl.elementary.frame import Frame
from efl.elementary.plug import Plug
from efl.elementary.layout import Layout

from efl.elementary.configuration import Configuration
elm_conf = Configuration()




script_path = os.path.dirname(os.path.abspath(__file__))
img_path = os.path.join(script_path, "images")

class Prof_Data(object):
    rdg = None
    cks = []
    profile = None
    available_profiles = []
    count = None

class App_Data(object):
    win = None
    profiles = []
    curr = Prof_Data()
    new = Prof_Data()

MAX_PROFILES = 20

def LOG(win, m):
    lb = Label(win, text=m, size_hint_weight=(0.0, 0.0),
        size_hint_align=FILL_BOTH)
    lb.show()
    return lb

def profile_update(win):
    lb = win.data["lb"]

    profile = win.profile
    available_profiles = win.available_profiles
    if available_profiles is not None:
        available_profiles = ", ".join(available_profiles)
    lb.text = "Profile: <b>{0}</b><br/>Available profiles: <b>{1}</b>".format(
        profile,
        available_profiles
    )

def bt_profile_set(obj, win):
    ad = win.data["ad"]
    rd = ad.curr.rdg.selected_object
    profile = rd.text
    if profile != "Nothing":
        ad.win.profile = profile
    else:
        ad.win.profile = None
    profile_update(ad.win)

def bt_available_profiles_set(obj, win):
    ad = win.data["ad"]

    a_profs = []

    for o in ad.curr.cks:
        if o.state:
            profile = o.data["profile"]
            if profile:
                a_profs.append(profile)

    ad.curr.available_profiles = a_profs

    ad.win.available_profiles = ad.curr.available_profiles
    profile_update(ad.win)

def bt_win_add(obj, win):
    ad = win.data["ad"]
    rd = ad.new.rdg.selected_object
    profile = rd.text

    if profile != "Nothing":
        ad.new.profile = profile

    for i, o in enumerate(ad.new.cks):
        if o.state:
             profile = o.data["profile"]
             if profile:
                  ad.new.available_profiles.insert(i, profile)

    config_clicked(None, ad.new)

def win_profile_changed_cb(obj, *args, **kwargs):
    profile_update(obj)

def win_del_cb(win, *args, **kwargs):
    ad = win.data["ad"]

    #elm_config_profile_list_free(ad->profiles);
    #ad->profiles = NULL;

    for o in ad.curr.cks:
        del o.data["profile"]

    for o in ad.new.cks:
        del o.data["profile"]

def radio_add(win, bx):
    ad = win.data["ad"]

    i = 0

    bx2 = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), align=(0.0, 0.5),
        horizontal = True)
    bx.pack_end(bx2)
    bx2.show()

    rdg = rd = Radio(win, state_value=i, text="Nothing",
        size_hint_weight=EXPAND_BOTH)
    rd.group_add(rdg)
    bx2.pack_end(rd)
    rd.show()
    i += 1

    for profile in ad.profiles:
        rd = Radio(win, state_value=i, text=profile,
            size_hint_weight=EXPAND_BOTH)
        rd.group_add(rdg)
        bx2.pack_end(rd)
        rd.show()
        i += 1

    return rdg

def check_add(win, bx):
    ad = win.data["ad"]

    bx2 = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), align=(0.0, 0.5),
        horizontal=True)
    bx.pack_end(bx2)
    bx2.show()

    ll = []

    for profile in ad.profiles:
        ck = Check(win, text=profile, size_hint_weight=EXPAND_BOTH)
        ck.data["profile"] = profile
        bx2.pack_end(ck)
        ck.show()

        ll.append(ck)

    return ll

def inlined_add(parent):
    win = Window("inlined", ELM_WIN_INLINED_IMAGE, parent, pos=(10, 100),
        size=(150, 70))

    bg = Background(win, color=(110, 210, 120), size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(bg)
    bg.show()

    bx = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0))
    bx.show()

    lb = LOG(win, "ELM_WIN_INLINED_IMAGE")
    bx.pack_end(lb)

    lb = LOG(win, "Profile: <b>N/A</b>")
    bx.pack_end(lb)
    win.data["lb"] = lb

    win.inlined_image_object.pos = 10, 100
    win.inlined_image_object.size = 150, 70

    win.callback_profile_changed_add(win_profile_changed_cb)
    win.show()

    return win

def socket_add(name):
    win = Window("socket image", ELM_WIN_SOCKET_IMAGE)

    try:
        win.socket_listen(name, 0, False)
    except RuntimeError:
        print("No socket")
        win.delete()
        return None
    else:
        win.autodel = True

        bg = Background(win, color=(80, 110, 205), size_hint_weight=EXPAND_BOTH)
        win.resize_object_add(bg)
        bg.show()

        bx = Box(win, size_hint_weight=EXPAND_HORIZ,
            size_hint_align=(EVAS_HINT_FILL, 0.0))
        bx.show()

        lb = LOG(win, "ELM_WIN_SOCKET_IMAGE")
        bx.pack_end(lb)

        lb = LOG(win, "Profile: <b>N/A</b>")
        bx.pack_end(lb)
        win.data["lb"] = lb

        inlined_add(win)

        win.move(0, 0)
        win.resize(150, 200)

        win.callback_profile_changed_add(win_profile_changed_cb)
        win.show()
        return win

def plug_add(win, bx, name):
    plug = Plug(win, size_hint_weight=EXPAND_BOTH)

    if plug.connect(name, 0, False):
        ly = Layout(win,
            file=(os.path.join(script_path, "test.edj"), "win_config"),
            size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
        ly.show()

        bx.pack_end(ly)
        ly.part_content_set("swallow", plug)
        plug.show()
    else:
        print("No plug")
        plug.delete()
        return None

    return plug

def FRAME(win, bx, t):
    bx2 = Box(win, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=(EVAS_HINT_FILL, 0.0), align=(0.0, 0.5))
    bx2.show()
    fr = Frame(bx, text=t, content=bx2, size_hint_weight=EXPAND_BOTH,
        size_hint_align=FILL_BOTH)
    bx.pack_end(fr)
    fr.show()
    return fr, bx2

def config_clicked(obj, data=None):
    siname = "_TestConfigSocketImage_"

    print("ELM_CONFIG_ICON_THEME_ELEMENTARY = '%s'" % \
          elementary.ELM_CONFIG_ICON_THEME_ELEMENTARY)

    win = StandardWindow("config", "Configuration", autodel=True,
        size=(400,500))
    global ad
    ad = App_Data()
    win.data["ad"] = ad
    ad.win = win
    ad.profiles = elm_conf.profile_list

    bx = Box(win, size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    sc = Scroller(win, content=bx, bounce=(False, True),
        size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(sc)

    fr, bx2 = FRAME(win, bx, "Current window profile")
    # TODO: Add this code
    #ee = ecore_evas_ecore_evas_get(evas_object_evas_get(win));
    #supported = ecore_evas_window_profile_supported_get(ee);
    supported = True
    buf = "Virtual desktop window profile support: <b>{0}</b>".format(
        "Yes" if supported else "No")
    lb = LOG(win, buf)
    bx2.pack_end(lb)

    lb = LOG(win, "Profile: <b>N/A</b><br/>Available profiles:")
    bx2.pack_end(lb)
    win.data["lb"] = lb

    lb = LOG(win, "<br/>Window profile")
    bx2.pack_end(lb)
    ad.curr.rdg = radio_add(win, bx2)

    bt = Button(win, text="Set")
    bt.callback_clicked_add(bt_profile_set, win)
    bx2.pack_end(bt)
    bt.show()

    lb = LOG(win, "Window available profiles")
    bx2.pack_end(lb)
    ad.curr.cks = check_add(win, bx2)

    bt = Button(win, text="Set")
    bt.callback_clicked_add(bt_available_profiles_set, win)
    bx2.pack_end(bt)
    bt.show()

    fr, bx2 = FRAME(win, bx, "Socket")
    if socket_add(siname):
        lb = LOG(win, "Starting socket image.")
        bx2.pack_end(lb)
    else:
        lb = LOG(win,
            "Failed to create socket.<br/>Please check whether another "
            "test configuration window is<br/>already running and providing "
            "socket image.")
        bx2.pack_end(lb)

    fr, bx2 = FRAME(win, bx, "Plug")
    if not plug_add(win, bx2, siname):
        lb = LOG(win, "Failed to connect to server.")
        bx2.pack_end(lb)

    fr, bx2 = FRAME(win, bx, "Create new window with profile")
    lb = LOG(win, "Window profile")
    bx2.pack_end(lb)
    ad.new.rdg = radio_add(win, bx2)

    lb = LOG(win, "Window available profiles")
    bx2.pack_end(lb)
    ad.new.cks = check_add(win, bx2)

    bt = Button(win, text="Create")
    bt.callback_clicked_add(bt_win_add, win)
    bx2.pack_end(bt)
    bt.show()

    win.callback_profile_changed_add(win_profile_changed_cb)
    win.callback_delete_request_add(win_del_cb)
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    if data:
        if data.available_profiles:
            win.available_profiles = data.available_profiles
        if data.profile:
            win.profile = data.profile

        profile_update(win)

    bx.show()
    sc.show()

    win.show()

if __name__ == "__main__":

    config_clicked(None)

    elementary.run()
