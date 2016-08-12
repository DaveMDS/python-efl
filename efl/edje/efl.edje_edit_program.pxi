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


cdef class Program(object):
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
        def __set__(self, newname):
            self.rename(newname)

    def rename(self, newname not None):
        cdef Eina_Bool ret
        if isinstance(newname, unicode): newname = newname.encode("UTF-8")
        ret = edje_edit_program_name_set(self.edje.obj, self.name,
                    <const char *>newname if newname is not None else NULL)
        if ret == 0:
            return False
        eina_stringshare_replace(&self.name, <const char *>newname)
        return True

    def edje_get(self):
        return self.edje

    def run(self):
        return bool(edje_edit_program_run(self.edje.obj, self.name))

    # TODO: add (or better convert) all this to properties
    #       like is done in Part()
    def source_get(self):
        cdef const char *s
        s = edje_edit_program_source_get(self.edje.obj, self.name)
        ret = _ctouni(s)
        edje_edit_string_free(s)
        return ret

    def source_set(self, source):
        if isinstance(source, unicode): source = source.encode("UTF-8")
        return bool(edje_edit_program_source_set(self.edje.obj, self.name,
                    <const char *>source if source is not None else NULL))

    def signal_get(self):
        cdef const char *s
        s = edje_edit_program_signal_get(self.edje.obj, self.name)
        ret = _ctouni(s)
        edje_edit_string_free(s)
        return ret

    def signal_set(self, signal):
        if isinstance(signal, unicode): signal = signal.encode("UTF-8")
        return bool(edje_edit_program_signal_set(self.edje.obj, self.name,
                    <const char *>signal if signal is not None else NULL))

    def in_from_get(self):
        return edje_edit_program_in_from_get(self.edje.obj, self.name)

    def in_from_set(self, double f):
        return bool(edje_edit_program_in_from_set(self.edje.obj, self.name, f))

    def in_range_get(self):
        return edje_edit_program_in_range_get(self.edje.obj, self.name)

    def in_range_set(self, double r):
        return bool(edje_edit_program_in_range_set(self.edje.obj, self.name, r))

    def action_get(self):
        return edje_edit_program_action_get(self.edje.obj, self.name)

    def action_set(self, action):
        if isinstance(action, unicode): action = action.encode("UTF-8")
        return bool(edje_edit_program_action_set(self.edje.obj, self.name,
                                                 action))

    def targets_get(self):
        cdef Eina_List *lst
        lst = edje_edit_program_targets_get(self.edje.obj, self.name)
        ret = eina_list_strings_to_python_list(lst)
        edje_edit_string_list_free(lst)
        return ret

    def target_add(self, target):
        if isinstance(target, unicode): target = target.encode("UTF-8")
        return bool(edje_edit_program_target_add(self.edje.obj, self.name,
                    <const char *>target if target is not None else NULL))

    def target_del(self, target):
        if isinstance(target, unicode): target = target.encode("UTF-8")
        return bool(edje_edit_program_target_del(self.edje.obj, self.name,
                    <const char *>target if target is not None else NULL))

    def targets_clear(self):
        return bool(edje_edit_program_targets_clear(self.edje.obj, self.name))

    def afters_get(self):
        cdef Eina_List *lst
        lst = edje_edit_program_afters_get(self.edje.obj, self.name)
        ret = eina_list_strings_to_python_list(lst)
        edje_edit_string_list_free(lst)
        return ret

    def after_add(self, after):
        if isinstance(after, unicode): after = after.encode("UTF-8")
        return bool(edje_edit_program_after_add(self.edje.obj, self.name,
                    <const char *>after if after is not None else NULL))

    def after_del(self, after):
        if isinstance(after, unicode): after = after.encode("UTF-8")
        return bool(edje_edit_program_after_del(self.edje.obj, self.name,
                    <const char *>after if after is not None else NULL))

    def afters_clear(self):
        return bool(edje_edit_program_afters_clear(self.edje.obj, self.name))

    def state_get(self):
        cdef const char *s
        s = edje_edit_program_state_get(self.edje.obj, self.name)
        ret = _ctouni(s)
        edje_edit_string_free(s)
        return ret

    def state_set(self, state):
        if isinstance(state, unicode): state = state.encode("UTF-8")
        return bool(edje_edit_program_state_set(self.edje.obj, self.name,
                    <const char *>state if state is not None else NULL))

    def value_get(self):
        return edje_edit_program_value_get(self.edje.obj, self.name)

    def value_set(self, double v):
        return bool(edje_edit_program_value_set(self.edje.obj, self.name, v))

    def state2_get(self):
        cdef const char *s
        s = edje_edit_program_state2_get(self.edje.obj, self.name)
        ret = _ctouni(s)
        edje_edit_string_free(s)
        return ret

    def state2_set(self, state):
        if isinstance(state, unicode): state = state.encode("UTF-8")
        return bool(edje_edit_program_state2_set(self.edje.obj, self.name,
                    <const char *>state if state is not None else NULL))

    def value2_get(self):
        return edje_edit_program_value2_get(self.edje.obj, self.name)

    def value2_set(self, double v):
        return bool(edje_edit_program_value2_set(self.edje.obj, self.name, v))

    def transition_get(self):
        return edje_edit_program_transition_get(self.edje.obj, self.name)

    def transition_set(self, t):
        return bool(edje_edit_program_transition_set(self.edje.obj, self.name, t))

    def transition_time_get(self):
        return edje_edit_program_transition_time_get(self.edje.obj, self.name)

    def transition_time_set(self, double t):
        return bool(edje_edit_program_transition_time_set(self.edje.obj, self.name, t))

    property api:
        def __get__(self):
            cdef:
                const char *name
                const char *desc
            name = edje_edit_program_api_name_get(self.edje.obj, self.name)
            desc = edje_edit_program_api_description_get(self.edje.obj, self.name)
            n, d = _ctouni(name), _ctouni(desc)
            edje_edit_string_free(name)
            edje_edit_string_free(desc)
            return (n, d)

        def __set__(self, value):
            cdef object name, desc
            name, desc = value
            if isinstance(name, unicode): name = name.encode("UTF-8")
            if isinstance(desc, unicode): desc = desc.encode("UTF-8")
            edje_edit_program_api_name_set(self.edje.obj, self.name,
                    <const char *>name if name is not None else NULL)
            edje_edit_program_api_description_set(self.edje.obj, self.name,
                    <const char *>desc if desc is not None else NULL)

    property script:
        def __get__(self):
            cdef char *code
            code = edje_edit_script_program_get(self.edje.obj, self.name)
            ret = _touni(code)
            free(code)
            return ret

        def __set__(self, code):
            if isinstance(code, unicode): code = code.encode("UTF-8")
            edje_edit_script_program_set(self.edje.obj, self.name,
                    <const char *>code if code is not None else NULL)

        def __del__(self):
            edje_edit_script_program_set(self.edje.obj, self.name, NULL)

