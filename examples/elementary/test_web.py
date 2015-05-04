#!/usr/bin/env python
# encoding: utf-8

from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL, \
    EXPAND_BOTH, FILL_BOTH, EXPAND_HORIZ, FILL_HORIZ
from efl import elementary
from efl.elementary.window import StandardWindow
from efl.elementary.box import Box
from efl.elementary.button import Button
from efl.elementary.entry import Entry
from efl.elementary.web import Web


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

    web = Web(
        win, url="http://enlightenment.org/",
        size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH,
        size_hint_min=(100, 100)
        )
    vbx.pack_end(web)
    web.show()

    # Debug:
    def dbg(*args):
        print("DEBUG: %s %s" % (
            args[-1], " ".join(repr(x) for x in args[1:-1])
            ))

    #web.callback_download_request_add(dbg, "download request")
    web.callback_editorclient_contents_changed_add(
        dbg, "editor client contents changed")
    web.callback_editorclient_selection_changed_add(
        dbg, "editor client selection changed")
    #web.callback_frame_created_add(dbg, frame created)
    web.callback_icon_received_add(dbg, "icon received")
    web.callback_inputmethod_changed_add(dbg, "input method changed")
    web.callback_js_windowobject_clear_add(dbg, "js window object clear")
    web.callback_link_hover_in_add(dbg, "link hover in")
    web.callback_link_hover_out_add(dbg, "link hover out")

    #web.callback_load_document_finished_add(dbg, "load document finished")
    web.callback_load_error_add(dbg, "load error")
    web.callback_load_finished_add(dbg, "load finished")
    web.callback_load_newwindow_show_add(dbg, "load new window show")
    web.callback_load_progress_add(dbg, "load progress")
    web.callback_load_provisional_add(dbg, "load provisional")
    web.callback_load_started_add(dbg, "load started")

    #web.callback_menubar_visible_get_add(dbg, "menubar visible get")
    web.callback_menubar_visible_set_add(dbg, "menubar visible set")

    #web.callback_popup_created_add(dbg, "popup created")
    #web.callback_popup_willdelete_add(dbg, "popup will delete")

    web.callback_ready_add(dbg, "ready")

    #web.callback_scrollbars_visible_get_add(dbg, "scrollbars visible get")
    web.callback_scrollbars_visible_set_add(dbg, "scrollbars visible set")

    web.callback_statusbar_text_set_add(dbg, "statusbar text set")
    #web.callback_statusbar_visible_get_add(dbg, "statusbar visible get")
    web.callback_statusbar_visible_set_add(dbg, "statusbar visible set")

    web.callback_title_changed_add(dbg, "title changed")

    #web.callback_toolbars_visible_get_add(dbg, "toolbars visible get")
    web.callback_toolbars_visible_set_add(dbg, "toolbars visible set")

    web.callback_tooltip_text_set_add(dbg, "tooltip text set")
    web.callback_uri_changed_add(dbg, "uri changed")
    web.callback_view_resized_add(dbg, "view resized")
    web.callback_windows_close_request_add(dbg, "windows close request")
    web.callback_zoom_animated_end_add(dbg, "zoom animated end")

    web.callback_focused_add(dbg, "focused")
    web.callback_unfocused_add(dbg, "unfocused")

    # JS debug to console:
    def console_msg(obj, msg, line, src):
        print(("CONSOLE: %s:%d %r" % (src, line, msg)))
    web.console_message_hook_set(console_msg)

    # navigation bar:
    hbx = Box(
        win, horizontal=True, size_hint_weight=EXPAND_HORIZ,
        size_hint_align=FILL_HORIZ
        )
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

    en = Entry(
        win, scrollable=True, editable=True, single_line=True,
        size_hint_weight=EXPAND_HORIZ, size_hint_align=FILL_BOTH
        )
    hbx.pack_end(en)
    en.show()

    # Sync navigation entry and current URI
    def do_change_url(en):
        web.url = en.entry

    def did_change_url(web, url, en):
        en.entry = url

    en.callback_activated_add(do_change_url)
    web.callback_url_changed_add(did_change_url, en)

    # Sync title
    def did_change_title(web, title, win):
        win.title_set("Web - %s" % title)
    web.callback_title_changed_add(did_change_title, win)

    win.show()


if __name__ == "__main__":
    if not elementary.need_web():
        raise SystemExit("EFL-webkit not available!")

    elementary.policy_set(elementary.ELM_POLICY_QUIT,
                          elementary.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)

    web_clicked(None)

    elementary.run()
