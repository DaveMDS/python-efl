cdef class Pending(object):

    cdef EDBus_Pending *pending

    def data_set(self, key, data):
        edbus_pending_data_set(self.pending, const char *key, const void *data) EINA_ARG_NONNULL(1, 2, 3)

    def data_get(self, key):
        void *edbus_pending_data_get(self.pending, const char *key) EINA_ARG_NONNULL(1, 2)

    def data_del(self, key):
        void *edbus_pending_data_del(self.pending, const char *key) EINA_ARG_NONNULL(1, 2)

    def cancel(self):
        edbus_pending_cancel(self.pending)

    property destination:
        def __get__(self):
            const char *edbus_pending_destination_get(self.pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property path:
        def __get__(self):
            const char *edbus_pending_path_get(self.pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property interface:
        def __get__(self):
            const char *edbus_pending_interface_get(self.pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    property method:
        def __get__(self):
            const char *edbus_pending_method_get(self.pending) EINA_ARG_NONNULL(1) EINA_WARN_UNUSED_RESULT

    def free_cb_add(self, cb, cb_data):
        """

        Add a callback function to be called when pending will be freed.

        """
        edbus_pending_free_cb_add(self.pending, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)

    def free_cb_del(self, cb, cb_data):
        """

        Remove callback registered in edbus_pending_free_cb_add().

        """
        edbus_pending_free_cb_del(self.pending, EDBus_Free_Cb cb, const void *data) EINA_ARG_NONNULL(1, 2)
