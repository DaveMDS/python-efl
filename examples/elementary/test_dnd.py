#!/usr/bin/env python
# encoding: utf-8

from efl import evas
from efl import elementary
from efl.elementary.box import Box
from efl.elementary.window import StandardWindow
from efl.elementary.icon import Icon
from efl.elementary.genlist import Genlist, GenlistItemClass, \
    ELM_SEL_FORMAT_TARGETS, ELM_GENLIST_ITEM_NONE

img = (
    "panel_01.jpg",
    "plant_01.jpg",
    "rock_01.jpg",
    "rock_02.jpg",
    "sky_01.jpg",
    "sky_02.jpg",
    "sky_03.jpg",
    "sky_04.jpg",
    "wood_01.jpg",
    )

# class anim_icon_st:
#     int start_x
#     int start_y
#     Evas_Object *o

# class drag_anim_st:
#     Evas_Object *icwin
#     Evas *e
#     Evas_Coord mdx     # Mouse-down x
#     Evas_Coord mdy     # Mouse-down y
#     Eina_List *icons   # List of icons to animate (anim_icon_st)
#     Ecore_Timer *tm
#     Ecore_Animator *ea
#     Evas_Object *gl

DRAG_TIMEOUT = 0.3
ANIM_TIME = 0.5

def item_ptr_cmp(d1, d2):
    return (d1 - d2)

#static Elm_Genlist_Item_Class *itc1
#static Elm_Gengrid_Item_Class *gic


class DndItemClass(GenlistItemClass):
    def text_get(self, obj, part, data, *args):
        return data

    def content_get(self, obj, part, data, *args):
        if not part == "elm.swallow.icon":
            icon = Icon(obj)
            icon.file = data
            icon.size_hint_aspect = evas.EVAS_ASPECT_CONTROL_VERTICAL, 1, 1
            icon.show()
            return icon
        return None

def win_del(obj, data):
    #print("<%s> <%d> will del <%p>\n", __func__, __LINE__, data)
    data.drop_item_container_del()
    data.drag_item_container_del()

    # FIXME Needed?: if (gic) elm_gengrid_item_class_free(gic)
    #gic = NULL
    # FIXME Needed?: if (itc1) elm_genlist_item_class_free(itc1)
    #itc1 = NULL

    elementary.exit()

def gl_item_getcb(gl, x, y):
    # This function returns pointer to item under (x,y) coords
    #print("<%s> <%d> obj=<%p>\n", __func__, __LINE__, gl)
    gli, yposret = gl.at_xy_item_get(x, y)
    if gli is not None:
        print("over <%s>, gli=<%s> yposret %i\n" % (gli.part_text_get("elm.text"), gli, yposret))
    else:
        print("over none, yposret %i\n", yposret)
    return gli, None, yposret

# def grid_item_getcb(obj, x, y, int *xposret, int *yposret):
#     # This function returns pointer to item under (x,y) coords
#     #print("<%s> <%d> obj=<%p>\n", __func__, __LINE__, obj)
#     item = gl.at_xy_item_get(x, y, xposret, yposret)
#     if item is not None:
#         print("over <%s>, item=<%p> xposret %i yposret %i\n",
#             elm_object_item_part_text_get(item, "elm.text"), item, *xposret, *yposret)
#     else:
#         print("over none, xposret %i yposret %i\n", *xposret, *yposret)
#     return item

def gl_dropcb(data, obj, it,
    ev, # Elm_Selection_Data *
    xposret, yposret):
    # This function is called when data is dropped on the genlist
    #print("<%s> <%d> str=<%s>\n", __func__, __LINE__, (char *) ev->data)
    if ev.data is None:
        return False

    p = ev.data
    p = strchr(p, '#')
    while p is not None:
        p += 1
        p2 = strchr(p, '#')
        if p2 is not None:
            p2 = '\0'
            print("Item %s\n", p)
            if yposret == -1:
                obj.item_insert_before(itc1, p, before=it,
                        flags=ELM_GENLIST_ITEM_NONE)
            elif yposret == 0 or yposret == 1:
                if not it:
                    it = obj.last_item

                if it:
                    it = obj.item_insert_after(itc1, p, None, it,
                    ELM_GENLIST_ITEM_NONE)
                else:
                    it = obj.item_append(itc1, p, None,
                    ELM_GENLIST_ITEM_NONE)
            else:
                return False

            p = p2

        else:
            p = None

    return True

# def grid_dropcb(data, obj, it, Elm_Selection_Data *ev, int xposret, int yposret):
#     # This function is called when data is dropped on the genlist
#     #print("<%s> <%d> str=<%s>\n", __func__, __LINE__, (char *) ev->data)
#     if not ev.data:
#         return False

#     p = ev->data
#     p = strchr(p, '#')
#     while(p)
#       {
#           p++
#           char *p2 = strchr(p, '#')
#           if (p2)
#              {
#                  *p2 = '\0'
#                  print("Item %s\n", p)
#                  if (!it) it = elm_gengrid_last_item_get(obj)
#                  if (it) it = elm_gengrid_item_insert_after(obj, gic, strdup(p), it, NULL, NULL)
#                  else it = elm_gengrid_item_append(obj, gic, strdup(p), NULL, NULL)
#                  p = p2
#              }
#           else p = NULL
#       }

#     return True

# static void _gl_obj_mouse_move( void *data, Evas *e, Evas_Object *obj, void *event_info)
# static void _gl_obj_mouse_up( void *data, Evas *e, Evas_Object *obj, void *event_info)

# def anim_st_free(drag_anim_st *anim_st):
#     # Stops and free mem of ongoing animation
#     #print("<%s> <%d>\n", __func__, __LINE__)
#     if anim_st is not None:
#         evas_object_event_callback_del_full
#               (anim_st->gl, EVAS_CALLBACK_MOUSE_MOVE, _gl_obj_mouse_move, anim_st)
#         evas_object_event_callback_del_full
#               (anim_st->gl, EVAS_CALLBACK_MOUSE_UP, _gl_obj_mouse_up, anim_st)
#         if anim_st.tm is not None:
#             ecore_timer_del(anim_st->tm)
#             anim_st->tm = NULL

#         if anim_st.ea is not None:
#             ecore_animator_del(anim_st->ea)
#             anim_st->ea = NULL

#         anim_icon_st *st

#         EINA_LIST_FREE(anim_st->icons, st)
#              {
#                  evas_object_hide(st->o)
#                  evas_object_del(st->o)
#                  free(st)
#              }

#         free(anim_st)

# def drag_anim_play(void *data, double pos):
#     # Impl of the animation of icons, called on frame time
#     drag_anim_st *anim_st = data
#     #print("<%s> <%d>\n", __func__, __LINE__)
#     anim_icon_st *st

#     if anim_st is not None:
#         if pos > 0.99:
#             anim_st.ea = None  # Avoid deleting on mouse up

#             for st in anim_st.icons:
#                 st.o.hide()   # Hide animated icons
#             anim_st_free(anim_st)
#             return ECORE_CALLBACK_CANCEL

#         for st in anim_st.icons:
#             w, h = st.o.size
#             xm, ym = anim_st.e.pointer_canvas_xy
#             x = st.start_x + (pos * (xm - (st.start_x + (w/2))))
#             y = st.start_y + (pos * (ym - (st.start_y + (h/2))))
#             st.o.move(x, y)

#         return ECORE_CALLBACK_RENEW

#     return ECORE_CALLBACK_CANCEL

# def gl_anim_start(void *data):
#     # Start icons animation before actually drag-starts
#     drag_anim_st *anim_st = data
#     #print("<%s> <%d>\n", __func__, __LINE__)
#     int yposret = 0

#     Eina_List *l
#     Eina_List *items = eina_list_clone(elm_genlist_selected_items_get(anim_st->gl))
#     Elm_Object_Item *gli = elm_genlist_at_xy_item_get(anim_st->gl,
#             anim_st->mdx, anim_st->mdy, &yposret)
#     if gli is not None:
#         # Add the item mouse is over to the list if NOT seleced
#           void *p = eina_list_search_unsorted(items, _item_ptr_cmp, gli)
#           if (!p)
#              items = eina_list_append(items, gli)

#     for gli in items:
#         # Now add icons to animation window
#         o = gli.part_content_get("elm.swallow.icon")

#         if o is not None:
#             st = []
#             f, g = o.file
#             ic = Icon(anim_st.gl)
#             ic.file = f, g
#             st.start_x, st.start_y, w, h = o.geometry
#             ic.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
#             ic.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND

#             ic.move(st.start_x, st.start_y)
#             ic.resize(w, h)
#             ic.show()

#             st.o = ic
#             anim_st.icons.append(st)

#     eina_list_free(items)

#     anim_st.tm = None
#     anim_st.ea = ecore_animator_timeline_add(DRAG_TIMEOUT,
#             _drag_anim_play, anim_st)

#     return ECORE_CALLBACK_CANCEL

# def gl_obj_mouse_up(e, obj, event_info, data):
#     # Cancel any drag waiting to start on timeout
#     drag_anim_st *anim_st = data
#     anim_st_free(anim_st)

# def gl_obj_mouse_move(e, obj, event_info, data):
#     # Cancel any drag waiting to start on timeout
#     if (((Evas_Event_Mouse_Move *)event_info)->event_flags & EVAS_EVENT_FLAG_ON_HOLD):
#         drag_anim_st *anim_st = data
#         anim_st_free(anim_st)

# def gl_obj_mouse_down(e, obj, event_info, data):
#     # Launch a timer to start drag animation
#     Evas_Event_Mouse_Down *ev = event_info
#     drag_anim_st *anim_st = calloc(1, sizeof(*anim_st))
#     anim_st->e = e
#     anim_st->mdx = ev->canvas.x
#     anim_st->mdy = ev->canvas.y
#     anim_st->gl = data
#     anim_st->tm = ecore_timer_add(DRAG_TIMEOUT, _gl_anim_start, anim_st)
#     evas_object_event_callback_add(data, EVAS_CALLBACK_MOUSE_UP,
#             _gl_obj_mouse_up, anim_st)
#     evas_object_event_callback_add(data, EVAS_CALLBACK_MOUSE_MOVE,
#             _gl_obj_mouse_move, anim_st)
# # END   - Handling drag start animation

def gl_dragdone(obj, doaccept, data):
    #print("<%s> <%d> data=<%p> doaccept=<%d>\n", __func__, __LINE__, data, doaccept)

    if doaccept:
        # Remove items dragged out (accepted by target)
        for it in data:
            it.delete()

def gl_createicon(data, win, xoff, yoff):
    #print("<%s> <%d>\n", __func__, __LINE__)
    it = data
    o = it.part_content_get("elm.swallow.icon")

    if o is not None:
        w = h = 30

        f, g = o.file

        xm, ym = o.evas.pointer_canvas_xy

        if xoff is not None:
            xoff = xm - (w/2)
        if yoff is not None:
            yoff = ym - (h/2)

        icon = Icon(win)
        icon.file = f, g
        icon.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
        icon.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND

        if xoff is not None and yoff is not None:
            icon.move(xoff, yoff)
        icon.resize(w, h)

    return icon

def gl_icons_get(data):
    # Start icons animation before actually drag-starts
    #print("<%s> <%d>\n", __func__, __LINE__)
    gl = data

    yposret = 0

    icons = []

    xm, ym = gl.evas.pointer_canvas_xy
    items = gl.selected_items
    gli = gl.at_xy_item_get(xm, ym, yposret)

    if gli is not None:
        # Add the item mouse is over to the list if NOT seleced
        p = eina_list_search_unsorted(items, _item_ptr_cmp, gli)
        if p is not None:
            items = eina_list_append(items, gli)

    for gli in items:
        # Now add icons to animation window
        o = gli.part_content_get("elm.swallow.icon")

        if o is not None:
            f, g = o.file
            ic = Icon(gl)
            ic.file = f, g
            x, y, w, h = o.geometry
            ic.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
            ic.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND

            ic.move(x, y)
            ic.resize(w, h)
            ic.show()

            icons.append(ic)

    eina_list_free(items)
    return icons

def gl_get_drag_data(gl, it, items):
    # Construct a string of dragged info, user frees returned string
    drag_data = None
    #print("<%s> <%d>\n", __func__, __LINE__)

    items = gl.selected_items
    if it is not None:
        # Add the item mouse is over to the list if NOT seleced
        p = eina_list_search_unsorted(items, _item_ptr_cmp, it)
        if p is None:
            items = eina_list_append(items, it)

    if items:
        # Now we can actually compose string to send and start dragging
        drag_data = "file://"

        for it in items:
            t = it.part_text_get("elm.text")
            if t is not None:
                drag_data += "#"
                drag_data += t

        drag_data += "#"

        #print("<%s> <%d> Sending <%s>\n", __func__, __LINE__, drag_data)

    return drag_data

# def grid_get_drag_data(gg, it, Eina_List **items):
#     # Construct a string of dragged info, user frees returned string
#     const char *drag_data = NULL
#     #print("<%s> <%d>\n", __func__, __LINE__)

#     *items = eina_list_clone(elm_gengrid_selected_items_get(obj))
#     if (it)
#       {  # Add the item mouse is over to the list if NOT seleced
#           void *p = eina_list_search_unsorted(*items, _item_ptr_cmp, it)
#           if (!p)
#              *items = eina_list_append(*items, it)
#       }

#     if (*items)
#       {  # Now we can actually compose string to send and start dragging
#           Eina_List *l
#           const char *t
#           unsigned int len = 0

#           EINA_LIST_FOREACH(*items, l, it)
#              {
#                  t = elm_object_item_part_text_get(it, "elm.text")
#                  if (t)
#                     len += strlen(t)
#              }

#           drag_data = malloc(len + eina_list_count(*items) * 2 + 8)
#           strcpy((char *) drag_data, "file://")

#           EINA_LIST_FOREACH(*items, l, it)
#              {
#                  t = elm_object_item_part_text_get(it, "elm.text")
#                  if (t)
#                     {
#                         strcat((char *) drag_data, "#")
#                         strcat((char *) drag_data, t)
#                     }
#              }
#           strcat((char *) drag_data, "#")

#           print("<%s> <%d> Sending <%s>\n", __func__, __LINE__, drag_data)
#       }

#     return drag_data

def gl_dnd_default_anim_data_getcb(gl, it,
        info # Elm_Drag_User_Info *
    ):
    # This called before starting to drag, mouse-down was on it
    info.format = ELM_SEL_FORMAT_TARGETS
    info.createicon = _gl_createicon
    info.createdata = it
    info.icons = _gl_icons_get(obj)
    info.dragdone = _gl_dragdone

    # Now, collect data to send for drop from ALL selected items
    # Save list pointer to remove items after drop and free list on done
    info.data = _gl_get_drag_data(obj, it, info.donecbdata)
    #print("%s - data = %s\n", __FUNCTION__, info->data)
    info.acceptdata = info.donecbdata

    if info.data is not None:
        return True
    else:
        return False

# def gl_data_getcb(gl,  it,
#         Elm_Drag_User_Info *info):
#     # This called before starting to drag, mouse-down was on it
#     info->format = ELM_SEL_FORMAT_TARGETS
#     info->createicon = _gl_createicon
#     info->createdata = it
#     info->dragdone = _gl_dragdone

#     # Now, collect data to send for drop from ALL selected items
#     # Save list pointer to remove items after drop and free list on done
#     info->data = _gl_get_drag_data(obj, it, (Eina_List **) &info->donecbdata)
#     info->acceptdata = info->donecbdata

#     if (info->data)
#       return True
#     else
#       return False

# def grid_icons_get(void *data):
#     # Start icons animation before actually drag-starts
#     #print("<%s> <%d>\n", __func__, __LINE__)

#     Eina_List *l

#     Eina_List *icons = NULL

#     Evas_Coord xm, ym
#     evas_pointer_canvas_xy_get(evas_object_evas_get(data), &xm, &ym)
#     Eina_List *items = eina_list_clone(elm_gengrid_selected_items_get(data))
#     Elm_Object_Item *gli = elm_gengrid_at_xy_item_get(data,
#             xm, ym, NULL, NULL)
#     if gli is not None:
#         # Add the item mouse is over to the list if NOT seleced
#         void *p = eina_list_search_unsorted(items, _item_ptr_cmp, gli)
#         if p is None:
#             items = eina_list_append(items, gli)

#     for gli in items:
#         # Now add icons to animation window
#         o = gli.part_content_get("elm.swallow.icon")

#         if o is not None:
#             int x, y, w, h
#             const char *f, *g
#             elm_image_file_get(o, &f, &g)
#             Evas_Object *ic = elm_icon_add(data)
#             elm_image_file_set(ic, f, g)
#             evas_object_geometry_get(o, &x, &y, &w, &h)
#             ic.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
#             ic.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND

#             ic.move(x, y)
#             ic.resize(w, h)
#             ic.show()

#             icons =  eina_list_append(icons, ic)

#     eina_list_free(items)
#     return icons

# def grid_data_getcb(gl, it,
#         Elm_Drag_User_Info *info):
#     # This called before starting to drag, mouse-down was on it
#     info->format = ELM_SEL_FORMAT_TARGETS
#     info->createicon = _gl_createicon
#     info->createdata = it
#     info->icons = _grid_icons_get(obj)
#     info->dragdone = _gl_dragdone

#     # Now, collect data to send for drop from ALL selected items
#     # Save list pointer to remove items after drop and free list on done
#     info->data = _grid_get_drag_data(obj, it, (Eina_List **) &info->donecbdata)
#     print("%s - data = %s\n", __FUNCTION__, info->data)
#     info->acceptdata = info->donecbdata

#     if (info->data)
#       return True
#     else
#       return False

def dnd_genlist_default_anim_clicked(*args):
    win = StandardWindow("dnd-genlist-default-anim", "DnD-Genlist-Default-Anim")
    win.autodel = True

    bxx = Box(win)
    bxx.horizontal = True
    bxx.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
    win.resize_object_add(bxx)
    bxx.show()

    for j in range(2):
        gl = Genlist(win)

        # START Drag and Drop handling
        win.callback_delete_request_add(win_del, gl)
        gl.multi_select = True # We allow multi drag
        gl.drop_item_container_add(ELM_SEL_FORMAT_TARGETS,
              gl_item_getcb, dropcb=gl_dropcb)

        gl.drag_item_container_add(ANIM_TIME, DRAG_TIMEOUT,
              gl_item_getcb, gl_dnd_default_anim_data_getcb)

        # FIXME: This causes genlist to resize the horiz axis very slowly :(
        # Reenable this and resize the window horizontally, then try to resize it back
        #elm_genlist_mode_set(gl, ELM_LIST_LIMIT)
        gl.size_hint_weight = evas.EVAS_HINT_EXPAND, evas.EVAS_HINT_EXPAND
        gl.size_hint_align = evas.EVAS_HINT_FILL, evas.EVAS_HINT_FILL
        bxx.pack_end(gl)
        gl.show()

        itc1 = DndItemClass()

        for i in range (20):
            gl.item_append(itc1, "images/{0}".format(img[i % 9]), flags=ELM_GENLIST_ITEM_NONE)

    win.resize(680, 800)
    win.show()

# def test_dnd_genlist_user_anim(obj, event_info, data):
#     win = StandardWindow("dnd-genlist-user-anim", "DnD-Genlist-User-Anim")
#     win.autodel = True

#     bxx = Box(win)
#     bxx.horizontal = True
#     bxx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
#     win.resize_object_add(bxx)
#     bxx.show()

#     itc1 = elm_genlist_item_class_new()
#     itc1->item_style     = "default"
#     itc1->func.text_get = gl_text_get
#     itc1->func.content_get  = gl_content_get
#     itc1->func.del       = NULL

#     for (j = 0 j < 2 j++):
#         gl = Genlist(win)

#         # START Drag and Drop handling
#         win.callback_delete_request_add(win_del, gl)
#         elm_genlist_multi_select_set(gl, True) # We allow multi drag
#         elm_drop_item_container_add(gl,
#               ELM_SEL_FORMAT_TARGETS,
#               _gl_item_getcb,
#               NULL, NULL,
#               NULL, NULL,
#               NULL, NULL,
#               _gl_dropcb, NULL)

#         elm_drag_item_container_add(gl, ANIM_TIME, DRAG_TIMEOUT,
#               _gl_item_getcb, _gl_data_getcb)

#         # We add mouse-down, up callbacks to start/stop drag animation
#         evas_object_event_callback_add(gl, EVAS_CALLBACK_MOUSE_DOWN,
#               _gl_obj_mouse_down, gl)
#         # END Drag and Drop handling

#         # FIXME: This causes genlist to resize the horiz axis very slowly :(
#         # Reenable this and resize the window horizontally, then try to resize it back
#         #elm_genlist_mode_set(gl, ELM_LIST_LIMIT)
#         gl.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
#         gl.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
#         elm_box_pack_end(bxx, gl)
#         gl.show()

#         for (i = 0 i < 20 i++)
#             snprintf(buf, sizeof(buf), "%s/images/%s", elm_app_data_dir_get(), img[(i % 9)])
#             const char *path = eina_stringshare_add(buf)
#             elm_genlist_item_append(gl, itc1, path, NULL, ELM_GENLIST_ITEM_NONE, NULL, NULL)

#     evas_object_resize(win, 680, 800)
#     win.show()

# def test_dnd_genlist_gengrid(void *data __UNUSED__, Evas_Object *obj __UNUSED__, void *event_info __UNUSED__):
#     win = StandardWindow("dnd-genlist-gengrid", "DnD-Genlist-Gengrid")
#     win.autodel = True

#     bxx = elm_box_add(win)
#     elm_box_horizontal_set(bxx, True)
#     bxx.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
#     elm_win_resize_object_add(win, bxx)
#     bxx.show()

#       {
#           itc1 = elm_genlist_item_class_new()
#           itc1->item_style     = "default"
#           itc1->func.text_get = gl_text_get
#           itc1->func.content_get  = gl_content_get
#           itc1->func.del       = NULL

#           Evas_Object *gl = elm_genlist_add(win)
#           evas_object_smart_callback_add(win, "delete,request", _win_del, gl)

#           # START Drag and Drop handling
#           elm_genlist_multi_select_set(gl, True) # We allow multi drag
#           elm_drop_item_container_add(gl, ELM_SEL_FORMAT_TARGETS, _gl_item_getcb, NULL, NULL,
#                   NULL, NULL, NULL, NULL, _gl_dropcb, NULL)

#           elm_drag_item_container_add(gl, ANIM_TIME, DRAG_TIMEOUT,
#                   _gl_item_getcb, _gl_dnd_default_anim_data_getcb)
#           # END Drag and Drop handling

#           # FIXME: This causes genlist to resize the horiz axis very slowly :(
#           # Reenable this and resize the window horizontally, then try to resize it back
#           #elm_genlist_mode_set(gl, ELM_LIST_LIMIT)
#           gl.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
#           gl.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL
#           elm_box_pack_end(bxx, gl)
#           gl.show()

#           for (i = 0 i < 20 i++)
#              {
#                  snprintf(buf, sizeof(buf), "%s/images/%s", elm_app_data_dir_get(), img[(i % 9)])
#                  const char *path = eina_stringshare_add(buf)
#                  elm_genlist_item_append(gl, itc1, path, NULL, ELM_GENLIST_ITEM_NONE, NULL, NULL)
#              }
#       }

#       {
#           Evas_Object *grid = elm_gengrid_add(win)
#           evas_object_smart_callback_add(win, "delete,request", _win_del, grid)
#           elm_gengrid_item_size_set(grid,
#                   elm_config_scale_get() * 150,
#                   elm_config_scale_get() * 150)
#           elm_gengrid_horizontal_set(grid, False)
#           elm_gengrid_reorder_mode_set(grid, False)
#           elm_gengrid_multi_select_set(grid, True) # We allow multi drag
#           grid.size_hint_weight = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
#           grid.size_hint_align = EVAS_HINT_FILL, EVAS_HINT_FILL

#           gic = elm_gengrid_item_class_new()
#           gic->item_style = "default"
#           gic->func.text_get = gl_text_get
#           gic->func.content_get = gl_content_get

#           elm_drop_item_container_add(grid, ELM_SEL_FORMAT_TARGETS, _grid_item_getcb, NULL, NULL,
#                   NULL, NULL, NULL, NULL, _grid_dropcb, NULL)

#           elm_drag_item_container_add(grid, ANIM_TIME, DRAG_TIMEOUT,
#                   _grid_item_getcb, _grid_data_getcb)
#           for (i = 0 i < 20 i++)
#              {
#                  snprintf(buf, sizeof(buf), "%s/images/%s", elm_app_data_dir_get(), img[(i % 9)])
#                  const char *path = eina_stringshare_add(buf)
#                  elm_gengrid_item_append(grid, gic, path, NULL, NULL)
#              }
#           elm_box_pack_end(bxx, grid)
#           grid.show()
#       }

#     evas_object_resize(win, 680, 800)
#     win.show()


if __name__ == "__main__":
    elementary.init()

    dnd_genlist_default_anim_clicked(None)

    elementary.run()
    elementary.shutdown()
