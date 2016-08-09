#!/usr/bin/env python
# encoding: utf-8


from efl.evas import Rectangle, EXPAND_BOTH, FILL_BOTH, EVAS_CALLBACK_MOUSE_DOWN

from efl import elementary as elm
from efl.elementary import StandardWindow, Box, Label, Button, Radio, Icon, \
    Genlist, GenlistItemClass, ELM_LIST_COMPRESS


# item class "classic" implementation method
def itc1_text_get(obj, part, item_data):
    return "Item # %i" % item_data

def itc1_content_get(obj, part, item_data):
    if part == 'elm.swallow.icon':
        return  Icon(obj, standard='user-home')
    elif part == 'elm.swallow.end':
        return  Icon(obj, standard='user-trash')

itc1 = GenlistItemClass(item_style="default",
                        text_get_func=itc1_text_get,
                        content_get_func=itc1_content_get)


# item class "subclass" implementation method
class MyItemClass(GenlistItemClass):
    def __init__(self):
        GenlistItemClass.__init__(self, item_style="default")

    def text_get(self, obj, part, item_data):
        return "Item # %i (itc2)" % item_data

    def content_get(self, obj, part, item_data):
        if part == 'elm.swallow.icon':
            return  Icon(obj, standard='user-trash')
        elif part == 'elm.swallow.end':
            return  Icon(obj, standard='user-home')

itc2 = MyItemClass()


# list items callbacks
def item_selected_cb(item, gl, item_data):
    print("\n---GenlistItem selected---")
    print(item)
    print(gl)
    print(("item_data: %s" % item_data))


# list callbacks
def list_selected_cb(gl, gli, *args, **kwargs):
    print("\n---Genlist selected---")
    print(gl)
    print(gli)
    print(args)
    print(kwargs)

def list_clicked_double_cb(gl, gli):
    print("\n---Genlist double clcked---")
    print(gl)
    print(gli)

def list_longpressed_cb(gl, gli):
    print("\n---Genlist longpressed---")
    print(gl)
    print(gli)


# over rect callbacks
def rect_mouse_down_cb(evas, evt, gl):
    print("\n---OverRect click---")
    item, pos = gl.at_xy_item_get(evt.position.canvas.x, evt.position.canvas.y)
    if item:
        print("Over item: %s" % item)
        print("At pos: %d" % pos)
    else:
        print("Over none")

# tooltip creation function
def tooltip_content_cb(gl, item, obj):
    txt = "Tooltip <b>from callback</b> for item # %d" % item.data
    return Label(gl, text=txt)


def test_genlist_1(parent):
    win = StandardWindow("Genlist", "Genlist test 1",
                         size=(480, 800), autodel=True)

    # main vertical box
    box = Box(win, size_hint_weight=EXPAND_BOTH)
    win.resize_object_add(box)
    box.show()

    # Genlist
    gl = Genlist(win, homogeneous=True, mode=ELM_LIST_COMPRESS,
                 size_hint_weight=EXPAND_BOTH, size_hint_align=FILL_BOTH)
    gl.callback_selected_add(list_selected_cb, "arg1", "arg2",
                             kwarg1="kwarg1", kwarg2="kwarg2")
    gl.callback_clicked_double_add(list_clicked_double_cb)
    gl.callback_longpressed_add(list_longpressed_cb)
    box.pack_end(gl)
    gl.show()

    # over evas rectangle (transparent, used to catch mouse events)
    over = Rectangle(win.evas, color=(0,0,0,0), repeat_events=True,
                     size_hint_expand=EXPAND_BOTH)
    over.event_callback_add(EVAS_CALLBACK_MOUSE_DOWN, rect_mouse_down_cb, gl)
    win.resize_object_add(over)
    over.show()

    # populate the genlist
    for i in range(0, 2000):
        
        if i % 2:
            item = gl.item_append(itc1, i, func=item_selected_cb)
            item.tooltip_text_set("Static Tooltip for item # %d" % i)
        else:
            item = gl.item_append(itc2, i, func=item_selected_cb)
            item.tooltip_content_cb_set(tooltip_content_cb)

        if i == 50:     it_50 = item
        elif i == 1500: it_1500 = item

    # scroll_to methods
    hbox = Box(win, horizontal=True)
    box.pack_end(hbox)
    hbox.show()

    rdg = rd = Radio(win, text='SCROLL_IN',
                     state_value=elm.ELM_GENLIST_ITEM_SCROLLTO_IN)
    hbox.pack_end(rd)
    rd.show()

    rd = Radio(win, text='SCROLL_TOP',
               state_value=elm.ELM_GENLIST_ITEM_SCROLLTO_TOP)
    rd.group_add(rdg)
    hbox.pack_end(rd)
    rd.show()

    rd = Radio(win, text='SCROLL_MIDDLE',
               state_value=elm.ELM_GENLIST_ITEM_SCROLLTO_MIDDLE)
    rd.group_add(rdg)
    hbox.pack_end(rd)
    rd.show()

    rd = Radio(win, text='SCROLL_BOTTOM',
               state_value=elm.ELM_GENLIST_ITEM_SCROLLTO_BOTTOM)
    rd.group_add(rdg)
    hbox.pack_end(rd)
    rd.show()

    rdg.value = elm.ELM_GENLIST_ITEM_SCROLLTO_IN

    # item 50/1500 buttons
    hbox = Box(win, horizontal=True)
    box.pack_end(hbox)
    hbox.show()

    bt = Button(win, text="Show 50")
    bt.callback_clicked_add(lambda bt: it_50.show(rdg.value))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="BringIn 50")
    bt.callback_clicked_add(lambda bt: it_50.bring_in(rdg.value))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="Show 1500")
    bt.callback_clicked_add(lambda bt: it_1500.show(rdg.value))
    hbox.pack_end(bt)
    bt.show()

    bt = Button(win, text="BringIn 1500")
    bt.callback_clicked_add(lambda bt: it_1500.bring_in(rdg.value))
    hbox.pack_end(bt)
    bt.show()

    # item content unset
    def content_unset_clicked(bt, gl):
        item = gl.selected_item
        if item is None:
            print("You must select an item first!")
        else:
            contents = item.all_contents_unset()
            print(contents)
            for obj in contents:
                obj.pos = (200, 0)
                obj.show()
            # Now all the unsetted objects are orphan in the canvas,
            # the user should do something with them
        
    bt = Button(win, text="Item content unset")
    bt.callback_clicked_add(content_unset_clicked, gl)
    hbox.pack_end(bt)
    bt.show()

    # show the window
    win.show()


if __name__ == "__main__":
    elm.policy_set(elm.ELM_POLICY_QUIT, elm.ELM_POLICY_QUIT_LAST_WINDOW_CLOSED)
    test_genlist_1(None)
    elm.run()
