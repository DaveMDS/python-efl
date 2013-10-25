# Copyright (C) 2007-2013 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

from libc.string cimport const_char
from efl.eina cimport Eina_Log_Domain, const_Eina_Log_Domain, Eina_Log_Level, \
    eina_log_print_cb_set, eina_log_domain_register, eina_log_level_set, \
    eina_log_level_get, eina_log_domain_level_get, eina_log_domain_level_set, \
    eina_log_print
from cpython cimport PyUnicode_AsUTF8String

cdef extern from "stdarg.h":
    ctypedef struct va_list:
        pass

cdef extern from "Python.h":
    object PyUnicode_FromFormatV(char *format, va_list vargs)

cdef tuple log_levels = (
    50,
    40,
    30,
    20,
    10
)

cdef dict loggers = dict()

cdef void py_eina_log_print_cb(const_Eina_Log_Domain *d,
                              Eina_Log_Level level,
                              const_char *file, const_char *fnc, int line,
                              const_char *fmt, void *data, va_list args) with gil:
    cdef unicode msg = PyUnicode_FromFormatV(fmt, args)
    cdef unicode name = d.name.decode("utf-8")
    rec = logging.LogRecord(name, log_levels[level], file, line, msg, None, None, fnc)
    logger = loggers.get(name, loggers["efl"])
    logger.handle(rec)

import logging

eina_log_print_cb_set(py_eina_log_print_cb, NULL)

class PyEFLLogger(logging.Logger):
    def __init__(self, name):
        cname = name
        if isinstance(cname, unicode): cname = PyUnicode_AsUTF8String(cname)
        self.eina_log_domain = eina_log_domain_register(cname, NULL)
        loggers[name] = self
        logging.Logger.__init__(self, name)

    def setLevel(self, lvl):
        cname = self.name
        if isinstance(cname, unicode): cname = PyUnicode_AsUTF8String(cname)
        eina_log_domain_level_set(cname, log_levels.index(lvl))
        logging.Logger.setLevel(self, lvl)

logging.setLoggerClass(PyEFLLogger)

rootlog = logging.getLogger("efl")
rootlog.propagate = False
rootlog.setLevel(logging.WARNING)
rootlog.addHandler(logging.NullHandler())

logging.setLoggerClass(logging.Logger)

cdef public int PY_EFL_LOG_DOMAIN = rootlog.eina_log_domain

cdef int add_logger(object name):
    logging.setLoggerClass(PyEFLLogger)

    log = logging.getLogger(name)
    log.propagate = True
    log.setLevel(logging.WARNING)
    log.addHandler(logging.NullHandler())

    logging.setLoggerClass(logging.Logger)

    return log.eina_log_domain
