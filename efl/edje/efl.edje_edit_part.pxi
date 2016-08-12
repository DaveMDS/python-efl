# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.


cdef class Part(object):
    cdef EdjeEdit edje
    cdef const char *name

    def __init__(self, EdjeEdit e not None, name not None):
        if isinstance(name, unicode): name = name.encode("UTF-8")
        self.edje = e
        self.name = eina_stringshare_add(name)

    def __dealloc__(self):
        eina_stringshare_del(self.name)

    property name:
        def __get__(self):
            return _ctouni(self.name)
        def __set__(self, name):
            self.rename(name)

    def rename(self, newname not None):
        cdef Eina_Bool ret
        if isinstance(newname, unicode): newname = newname.encode("UTF-8")
        ret = edje_edit_part_name_set(self.edje.obj, self.name,
                    <const char *>newname if newname is not None else NULL)
        if ret == 0:
            return False
        eina_stringshare_replace(&self.name, <const char *>newname)
        return True

    def above_get(self):
        cdef:
            const char *part
            object ret
        part = edje_edit_part_above_get(self.edje.obj, self.name)
        ret = _ctouni(part)
        edje_edit_string_free(part)
        return ret

    def below_get(self):
        cdef:
            const char *part
            object ret
        part = edje_edit_part_below_get(self.edje.obj, self.name)
        ret = _ctouni(part)
        edje_edit_string_free(part)
        return ret

    def restack_below(self):
        return bool(edje_edit_part_restack_below(self.edje.obj, self.name))

    def restack_above(self):
        return bool(edje_edit_part_restack_above(self.edje.obj, self.name))

    property type:
        def __get__(self):
            return edje_edit_part_type_get(self.edje.obj, self.name)


    property states:
        def __get__(self):
            cdef Eina_List *lst
            lst = edje_edit_part_states_list_get(self.edje.obj, self.name)
            ret = eina_list_strings_to_python_list(lst)
            edje_edit_string_list_free(lst)
            return ret

    def state_get(self, sname, double value=0.0):
        if self.state_exist(sname, value):
            return State(self, sname, value)

    def state_add(self, sname, double value=0.0):
        if isinstance(sname, unicode): sname = sname.encode("UTF-8")
        return bool(edje_edit_state_add(self.edje.obj, self.name,
                    <const char *>sname if sname is not None else NULL,
                    value))

    def state_del(self, sname, double value=0.0):
        if isinstance(sname, unicode): sname = sname.encode("UTF-8")
        return bool(edje_edit_state_del(self.edje.obj, self.name,
                    <const char *>sname if sname is not None else NULL,
                    value))

    def state_exist(self, sname, double value=0.0):
        if isinstance(sname, unicode): sname = sname.encode("UTF-8")
        return bool(edje_edit_state_exist(self.edje.obj, self.name,
                    <const char *>sname if sname is not None else NULL,
                    value))

    def state_copy(self, sfrom, double vfrom, sto, double vto):
        if isinstance(sfrom, unicode): sfrom = sfrom.encode("UTF-8")
        if isinstance(sto, unicode): sto = sto.encode("UTF-8")
        return bool(edje_edit_state_copy(self.edje.obj, self.name,
                    <const char *>sfrom if sfrom is not None else NULL, vfrom,
                    <const char *>sto if sto is not None else NULL, vto))

    def state_selected_get(self):
        cdef const char *sel
        cdef double val
        sel = edje_edit_part_selected_state_get(self.edje.obj, self.name, &val)
        if sel == NULL: return None
        r = _ctouni(sel)
        v = val
        edje_edit_string_free(sel)
        return (r, v)

    def state_selected_set(self, state, double value=0.0):
        if isinstance(state, unicode): state = state.encode("UTF-8")
        edje_edit_part_selected_state_set(self.edje.obj, self.name,
                <const char *>state if state is not None else NULL,
                value)

    property clip_to:
        def __get__(self):
            cdef const char *clipper
            clipper = edje_edit_part_clip_to_get(self.edje.obj, self.name)
            ret = _ctouni(clipper)
            edje_edit_string_free(clipper)
            return ret

        def __set__(self, clipper):
            if isinstance(clipper, unicode): clipper = clipper.encode("UTF-8")
            edje_edit_part_clip_to_set(self.edje.obj, self.name,
                    <const char *>clipper if clipper is not None else NULL)

        def __del__(self):
            edje_edit_part_clip_to_set(self.edje.obj, self.name, NULL)

    property source:
        def __get__(self):
            cdef const char *source
            source = edje_edit_part_source_get(self.edje.obj, self.name)
            ret = _ctouni(source)
            edje_edit_string_free(source)
            return ret

        def __set__(self, source):
            if isinstance(source, unicode): source = source.encode("UTF-8")
            edje_edit_part_source_set(self.edje.obj, self.name,
                        <const char *>source if source is not None else NULL)

        def __del__(self):
            edje_edit_part_source_set(self.edje.obj, self.name, NULL)

    property mouse_events:
        def __get__(self):
            return bool(edje_edit_part_mouse_events_get(self.edje.obj, self.name))

        def __set__(self, me):
            edje_edit_part_mouse_events_set(self.edje.obj, self.name,
                                            1 if me else 0)

    property repeat_events:
        def __get__(self):
            return bool(edje_edit_part_repeat_events_get(self.edje.obj, self.name))

        def __set__(self, re):
            edje_edit_part_repeat_events_set(self.edje.obj, self.name,
                                             1 if re else 0)

    property effect:
        def __get__(self):
            return edje_edit_part_effect_get(self.edje.obj, self.name)

        def __set__(self, effect):
            edje_edit_part_effect_set(self.edje.obj, self.name, effect)

    property ignore_flags:
        def __get__(self):
            return edje_edit_part_ignore_flags_get(self.edje.obj, self.name)

        def __set__(self, flags):
            edje_edit_part_ignore_flags_set(self.edje.obj, self.name, flags)

    property scale:
        def __get__(self):
            return bool(edje_edit_part_scale_get(self.edje.obj, self.name))

        def __set__(self, scale):
            edje_edit_part_scale_set(self.edje.obj, self.name,
                                     1 if scale else 0)

    property drag:
        def __get__(self):
            cdef int x, y
            x = edje_edit_part_drag_x_get(self.edje.obj, self.name)
            y = edje_edit_part_drag_y_get(self.edje.obj, self.name)
            return (x, y)

        def __set__(self, val):
            x, y = val
            edje_edit_part_drag_x_set(self.edje.obj, self.name, x)
            edje_edit_part_drag_y_set(self.edje.obj, self.name, y)

    property drag_step:
        def __get__(self):
            cdef int x, y
            x = edje_edit_part_drag_step_x_get(self.edje.obj, self.name)
            y = edje_edit_part_drag_step_y_get(self.edje.obj, self.name)
            return (x, y)

        def __set__(self, val):
            x, y = val
            edje_edit_part_drag_step_x_set(self.edje.obj, self.name, x)
            edje_edit_part_drag_step_y_set(self.edje.obj, self.name, y)

    property drag_count:
        def __get__(self):
            cdef int x, y
            x = edje_edit_part_drag_count_x_get(self.edje.obj, self.name)
            y = edje_edit_part_drag_count_y_get(self.edje.obj, self.name)
            return (x, y)

        def __set__(self, val):
            x, y = val
            edje_edit_part_drag_count_x_set(self.edje.obj, self.name, x)
            edje_edit_part_drag_count_y_set(self.edje.obj, self.name, y)

    property drag_confine:
        def __get__(self):
            cdef const char *confine
            confine = edje_edit_part_drag_confine_get(self.edje.obj, self.name)
            ret = _ctouni(confine)
            edje_edit_string_free(confine)
            return ret

        def __set__(self, confine):
            if isinstance(confine, unicode): confine = confine.encode("UTF-8")
            edje_edit_part_drag_confine_set(self.edje.obj, self.name,
                        <const char *>confine if confine is not None else NULL)

    property drag_event:
        def __get__(self):
            cdef const char *event
            event = edje_edit_part_drag_event_get(self.edje.obj, self.name)
            ret = _ctouni(event)
            edje_edit_string_free(event)
            return ret

        def __set__(self, event):
            if isinstance(event, unicode): event = event.encode("UTF-8")
            edje_edit_part_drag_event_set(self.edje.obj, self.name,
                            <const char *>event if event is not None else NULL)

    property api:
        def __get__(self):
            cdef:
                const char *name
                const char *desc
            name = edje_edit_part_api_name_get(self.edje.obj, self.name)
            desc = edje_edit_part_api_description_get(self.edje.obj, self.name)
            n, d = _ctouni(name), _ctouni(desc)
            edje_edit_string_free(name)
            edje_edit_string_free(desc)
            return (n, d)

        def __set__(self, value):
            cdef object name, desc
            name, desc = value
            if isinstance(name, unicode): name = name.encode("UTF-8")
            if isinstance(desc, unicode): desc = desc.encode("UTF-8")
            edje_edit_part_api_name_set(self.edje.obj, self.name,
                            <const char *>name if name is not None else NULL)
            edje_edit_part_api_description_set(self.edje.obj, self.name,
                            <const char *>desc if desc is not None else NULL)
