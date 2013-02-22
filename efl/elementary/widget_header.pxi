from cpython cimport Py_INCREF, Py_DECREF
from efl.eo cimport PY_REFCOUNT
from efl.evas cimport Object as evasObject
from efl.eo cimport object_from_instance
from efl.eo cimport _object_mapping_register
from efl.eo cimport _cfruni, _ctouni, _fruni, _touni

import logging
log = logging.getLogger("elementary")
