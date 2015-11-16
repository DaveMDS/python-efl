#!/usr/bin/env python
# encoding: utf-8


from efl import ecore
from efl import ecore_con

def on_data(event):
    print("data: " + str(event.data))
    # do something here with the received data

def on_progress(event):
    # print(event)
    print("received %d on a total of %d bytes" % (
           event.down_now, event.down_total))

def on_complete(event):
    # print(event)
    print("http result: %d" % event.status)
    print("Total received bytes: %d" % event.url.received_bytes)

    u.delete() # don't forget to delete !!
    ecore.main_loop_quit()

u = ecore_con.Url('http://www.example.com', verbose=False)
u.on_data_event_add(on_data)
u.on_progress_event_add(on_progress)
u.on_complete_event_add(on_complete)
u.get()

ecore.main_loop_begin()
