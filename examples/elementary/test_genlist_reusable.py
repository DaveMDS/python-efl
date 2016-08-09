#!/usr/bin/env python
# encoding: utf-8


from efl.evas import EXPAND_BOTH, EXPAND_HORIZ, FILL_BOTH
from efl import elementary as elm


class MyItemClass(elm.GenlistItemClass):
    def __init__(self):
        elm.GenlistItemClass.__init__(self, item_style='default')

    def text_get(self, obj, part, item_data):
        return 'Item # %i' % item_data

    def content_get(self, obj, part, item_data):
        if part == 'elm.swallow.icon':
            return elm.Icon(obj, standard='user-home')
        if part == 'elm.swallow.end':
            print('Creating NEW content for item #%d' % item_data)
            txt = '<warning>Content for item %i</warning>' % item_data
            return elm.Label(obj, text=txt)
        return None

    def reusable_content_get(self, obj, part, item_data, old_content):
        if part == 'elm.swallow.end' and old_content:
            if obj.data['reusable_enabled'] == True:
                print('REUSING content for item # %i' % item_data)
                return old_content
        return None

itc = MyItemClass()


def check_changed_cb(ck, gl):
    gl.data['reusable_enabled'] = ck.state
    gl.realized_items_update()

def test_genlist_reusable(parent):
    win = elm.StandardWindow('GenlistReusable', 'Genlist Reusable Contents',
                             size=(400, 400), autodel=True)

    # main vertical box
    box = elm.Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    # info frame
    fr = elm.Frame(win, text='Information',  size_hint_expand=EXPAND_HORIZ,
                   size_hint_fill=FILL_BOTH)
    fr.content = elm.Label(fr, text='Numbers on the left should always match the one on the right')
    box.pack_end(fr)
    fr.show()

    # genlist
    gl = elm.Genlist(win, homogeneous=True, mode=elm.ELM_LIST_COMPRESS,
                     size_hint_expand=EXPAND_BOTH, size_hint_fill=FILL_BOTH)
    box.pack_end(gl)
    for i in range(0, 2000):
        gl.item_append(itc, i)
    gl.show()
    gl.data['reusable_enabled'] = True

    # buttons
    ck = elm.Check(win, text='Enable reusable contents', state=True)
    ck.callback_changed_add(check_changed_cb, gl)
    box.pack_end(ck)
    ck.show()

    win.show()


if __name__ == '__main__':
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_reusable(None)
    elm.run()
