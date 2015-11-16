#!/usr/bin/env python
# encoding: utf-8


from efl import ecore
from efl import ecore_con


def on_complete(canonname, ip):
    print('Lookup completed')
    print('Canonname: %s' % canonname)
    print('Ip: %s' % ip)

    ecore.main_loop_quit()

ecore_con.Lookup('example.com', on_complete)

ecore.main_loop_begin()
