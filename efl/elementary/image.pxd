from object cimport Object

cdef class Image(Object):
    cpdef file_set(self, filename, group = *)
    cpdef file_get(self)
