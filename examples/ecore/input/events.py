#!/usr/bin/env python
# encoding: utf-8


from efl import evas
from efl import ecore
from efl import ecore_input
from efl import elementary as elm



def _event_cb1(event, one, two, asd):
   print(event)
   print(one, two, asd) # test args and kargs
   print()
   return ecore.ECORE_CALLBACK_PASS_ON  # or ECORE_CALLBACK_DONE to stop propagation

def _event_cb2(event):
   print(event)
   print()
   return ecore.ECORE_CALLBACK_PASS_ON


move_handler = None

def move_connect_cb(btn):
    global move_handler

    if move_handler is None:
        move_handler = ecore_input.on_mouse_move_add(_event_cb2)

def move_delete_cb(btn):
    global move_handler

    if move_handler is not None:
        move_handler.delete()
        move_handler = None


if __name__ == "__main__":

    win = elm.StandardWindow("ecore_input_test", "Ecore Input Test",
                             size=(200,200))
    win.callback_delete_request_add(lambda w: elm.exit())
    win.focus_highlight_enabled = True
    win.focus_highlight_animate = True

    tb = elm.Table(win, padding=(10,10), size_hint_expand=evas.EXPAND_BOTH,
                   size_hint_fill=evas.FILL_BOTH)
    win.resize_object_add(tb)
    tb.show()

    lb = elm.Label(tb, text="<b><info>Watch for events in console.</info></b>")
    tb.pack(lb, 0, 0, 2, 1)
    lb.show()
    
    bt = elm.Button(tb, text="Connect MouseMove")
    bt.callback_clicked_add(move_connect_cb)
    tb.pack(bt, 0, 1, 1, 1)
    bt.show()
    bt.focus = True
    
    bt = elm.Button(tb, text="Delete MouseMove")
    bt.callback_clicked_add(move_delete_cb)
    tb.pack(bt, 1, 1, 1, 1)
    bt.show()

    en = elm.Entry(tb, text="Test event propagation",
                   editable=True, scrollable=True, single_line=True,
                   size_hint_expand=evas.EXPAND_HORIZ,
                   size_hint_fill=evas.FILL_BOTH)
    tb.pack(en, 0, 2, 2, 1)
    en.show()

    # NOTE FOR BRAVE HACKERS:
    # You can setup the event callbacks BEFORE win creation to have the ability
    # to stop (ECORE_CALLBACK_DONE) or continue (ECORE_CALLBACK_PASS_ON) the
    # event propagation down to elementary widgets.
    ecore_input.on_key_down_add(_event_cb1, 1, 2, 'DOWN')
    ecore_input.on_key_up_add(_event_cb2)
    ecore_input.on_mouse_button_down_add(_event_cb2)
    ecore_input.on_mouse_button_up_add(_event_cb2)
    ecore_input.on_mouse_in_add(_event_cb2) # this event do not work here
    ecore_input.on_mouse_out_add(_event_cb2) # this event do not work here
    ecore_input.on_mouse_wheel_add(_event_cb2)

    win.show()
    elm.run()
