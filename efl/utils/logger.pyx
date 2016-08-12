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

from efl.eina cimport Eina_Log_Domain, Eina_Log_Level, \
    eina_log_print_cb_set, eina_log_domain_register, eina_log_level_set, \
    eina_log_level_get, eina_log_domain_level_get, eina_log_domain_level_set, \
    eina_log_print, EINA_LOG_DOM_DBG, EINA_LOG_DOM_INFO, EINA_LOG_DOM_WARN, \
    EINA_LOG_DOM_ERR, EINA_LOG_DOM_CRIT
from cpython cimport PyUnicode_AsUTF8String, PY_VERSION_HEX

import logging
import types

cdef extern from "stdarg.h":
    ctypedef struct va_list:
        pass

cdef extern from "stdio.h":
    int vsprintf(char *, const char *fmt, va_list args)

cdef extern from "Python.h":
    void PyEval_InitThreads()

cdef tuple log_levels = (
    50,
    40,
    30,
    20,
    10
)

cdef dict loggers = dict()

cdef char log_buf[1024]


PyEval_InitThreads()

cdef void py_eina_log_print_cb(const Eina_Log_Domain *d, Eina_Log_Level level,
    const char *file, const char *fnc, int line,
    const char *fmt, void *data, va_list args) with gil:

    cdef:
        unicode msg, name, ufile, ufnc
        object rec, logger

    vsprintf(log_buf, fmt, args)

    msg = log_buf.decode('UTF-8', 'replace')
    name = d.name.decode('UTF-8', 'replace')
    ufile = file.decode('UTF-8', 'replace')
    ufnc = fnc.decode('UTF-8', 'replace')

    rec = logging.LogRecord(
        name, log_levels[level], ufile, line, msg, None, None, ufnc)
    logger = loggers.get(name, loggers["efl"])
    logger.handle(rec)

eina_log_print_cb_set(py_eina_log_print_cb, NULL)

def setLevel(self, lvl):
    cname = self.name
    if isinstance(cname, unicode): cname = PyUnicode_AsUTF8String(cname)
    eina_log_domain_level_set(cname, log_levels.index(lvl))
    logging.Logger.setLevel(self, lvl)

class PyEFLLogger(logging.Logger):

    def __init__(self, name):
        cname = name
        if isinstance(cname, unicode): cname = PyUnicode_AsUTF8String(cname)
        self.eina_log_domain = eina_log_domain_register(cname, NULL)
        loggers[name] = self
        logging.Logger.__init__(self, name)
        if PY_VERSION_HEX < 0x03000000:
            self.setLevel = types.MethodType(setLevel, self, type(self))
        else:
            self.setLevel = types.MethodType(setLevel, self)

cdef object add_logger(object name):
    logging.setLoggerClass(PyEFLLogger)

    log = logging.getLogger(name)
    if not isinstance(log, PyEFLLogger):
        # The logger has been instantiated already so lets add our own
        # initialization for it.
        cname = name
        if isinstance(cname, unicode): cname = PyUnicode_AsUTF8String(cname)
        log.eina_log_domain = eina_log_domain_register(cname, NULL)
        loggers[name] = log
        lvl = log.getEffectiveLevel()
        eina_log_domain_level_set(cname, log_levels.index(lvl))
        if PY_VERSION_HEX < 0x03000000:
            log.setLevel = types.MethodType(setLevel, log, type(log))
        else:
            log.setLevel = types.MethodType(setLevel, log)
    else:
        log.propagate = True
        log.setLevel(logging.WARNING)

    if PY_VERSION_HEX >= 0x02070000:
        log.addHandler(logging.NullHandler())

    logging.setLoggerClass(logging.Logger)

    return log

rootlog = add_logger("efl")
rootlog.propagate = False

cdef public int PY_EFL_LOG_DOMAIN = rootlog.eina_log_domain

def logger_test_dbg():
    EINA_LOG_DOM_DBG(PY_EFL_LOG_DOMAIN, "test message", NULL)
