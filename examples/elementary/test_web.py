#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
from efl import ecore
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.background import Background
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.web import Web

EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
FILL_HORIZ = EVAS_HINT_FILL, 0.5

def web_clicked(obj):
    if not elementary.need_web():
        print("EFL-webkit not available!")
        return

    win = StandardWindow("web", "Web", autodel=True, size=(800, 600))
    if obj is None:
        win.callback_delete_request_add(lambda o: elementary.exit())

    vbx = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(vbx)
    vbx.show()

    web = Web(win, url="http://enlightenment.org/",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        size_hint_min=(100, 100))
    vbx.pack_end(web)
    web.show()

    # Debug:
    def dbg(*args):
        print(("DEBUG: %s" % args[-1], " ".join(repr(x) for x in args[1:-1])))
    web.callback_link_hover_in_add(dbg, "link in")
    web.callback_link_hover_out_add(dbg, "link out")

    web.callback_uri_changed_add(dbg, "uri")
    web.callback_title_changed_add(dbg, "title")
    web.callback_load_finished_add(dbg, "load finished")
    web.callback_load_finished_add(dbg, "load error")
    web.callback_load_progress_add(dbg, "load progress")
    web.callback_load_provisional_add(dbg, "load provisional")
    web.callback_load_started_add(dbg, "load started")

    # JS debug to console:
    def console_msg(obj, msg, line, src):
        print(("CONSOLE: %s:%d %r" % (src, line, msg)))
    web.console_message_hook_set(console_msg)

    # navigation bar:
    hbx = Box(win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ)
    vbx.pack_start(hbx)
    hbx.show()

    bt = Button(win, text="Back")
    bt.callback_clicked_add(lambda x: web.back())
    hbx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Forward")
    bt.callback_clicked_add(lambda x: web.forward())
    hbx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Reload")
    bt.callback_clicked_add(lambda x: web.reload())
    hbx.pack_end(bt)
    bt.show()

    bt = Button(win, text="Stop")
    bt.callback_clicked_add(lambda x: web.stop())
    hbx.pack_end(bt)
    bt.show()

    en = Entry(win, scrollable=True, editable=True, single_line=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH)
    hbx.pack_end(en)
    en.show()

    # Sync navigation entry and current URI
    def do_change_uri(en):
        web.uri = en.entry

    def did_change_uri(web, uri, en):
        en.entry = uri

    en.callback_activated_add(do_change_uri)
    web.callback_uri_changed_add(did_change_uri, en)

    # Sync title
    def did_change_title(web, title, win):
        win.title_set("Web - %s" % title)
    web.callback_title_changed_add(did_change_title, win)

    win.show()


if __name__ == "__main__":
    elementary.init()
    if not elementary.need_web():
        elementary.shutdown()
        raise SystemExit("EFL-webkit not available!")

    elementary.policy_set(elementary.ELM_POLICY_QUIT,
                          elementary.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)

    web_clicked(None)

    elementary.run()
    elementary.shutdown()
