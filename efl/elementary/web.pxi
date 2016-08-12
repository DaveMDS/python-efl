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
#

include "web_cdef.pxi"

cdef object _cb_bool_conv(void *addr):
    if addr == NULL:
        return None
    cdef Eina_Bool *ret = <Eina_Bool *>addr
    return <bint>ret[0]


cdef object _web_double_conv(void *addr):
    if addr == NULL:
        return None
    cdef double *ret = <double *>addr
    return ret[0]


cdef object _web_load_frame_error_conv(void *addr):
    cdef Elm_Web_Frame_Load_Error *err
    if addr == NULL:
        return None
    err = <Elm_Web_Frame_Load_Error *>addr
    return {"code": err.code, "is_cancellation": bool(err.is_cancellation),
           "domain": _ctouni(err.domain) if err.domain else None,
           "description": _ctouni(err.description) if err.description else None,
           "failing_url": _ctouni(err.failing_url) if err.failing_url else None,
           "frame": object_from_instance(err.frame) if err.frame else None}


cdef object _web_link_hover_in_conv(void *addr):
    cdef char **info
    if addr == NULL:
        url = title = None
    else:
        info = <char **>addr
        url = None if info[0] == NULL else info[0]
        title = None if info[1] == NULL else info[1]
    return (url, title)


cdef void _web_console_message_hook(void *data, Evas_Object *obj, const char *message, unsigned int line_number, const char *source_id) with gil:
    cdef Web self = <Web>data

    try:
        self._console_message_hook(self, _ctouni(message), line_number, _ctouni(source_id))
    except Exception:
        traceback.print_exc()

cdef class WebWindowFeatures(object):

    cdef Elm_Web_Window_Features *wf

    def property_get(self, Elm_Web_Window_Feature_Flag flag):
        """

        Get boolean properties from Elm_Web_Window_Features
        (such as statusbar, menubar, etc) that are on a window.

        :param flag: The web window feature flag whose value is required.

        :return: True if the flag is set, False otherwise

        """
        return bool(elm_web_window_features_property_get(self.wf, flag))

    property region:
        """

        TODO : Add documentation.

        :type: Tuple of ints (x, y, w, h)

        """
        def __get__(self):
            cdef Evas_Coord x, y, w, h
            elm_web_window_features_region_get(self.wf, &x, &y, &w, &h)
            return x, y, w, h

    def ref(self):
        """

        .. versionadded:: 1.8

        """
        elm_web_window_features_ref(self.wf)

    def unref(self):
        """

        .. versionadded:: 1.8

        """
        elm_web_window_features_unref(self.wf)


cdef class Web(Object):
    """

    This class actually implements the widget.

    """

    cdef object _console_message_hook

    def __init__(self,evasObject parent, *args, **kwargs):
        """Web(...)

        :param parent: The parent object
        :type parent: :py:class:`efl.evas.Object`
        :param \**kwargs: All the remaining keyword arguments are interpreted
                          as properties of the instance

        """
        self._set_obj(elm_web_add(parent.obj))
        self._set_properties_from_keyword_args(kwargs)

    property zoom_mode:
        """The zoom mode to use

        The modes can be any of those defined in ::Elm_Web_Zoom_Mode, except
        ::ELM_WEB_ZOOM_MODE_LAST. The default is ::ELM_WEB_ZOOM_MODE_MANUAL.

        ::ELM_WEB_ZOOM_MODE_MANUAL means the zoom level will be controlled
        with the elm_web_zoom_set() function.
        ::ELM_WEB_ZOOM_MODE_AUTO_FIT will calculate the needed zoom level to
        make sure the entirety of the web object's contents are shown.
        ::ELM_WEB_ZOOM_MODE_AUTO_FILL will calculate the needed zoom level to
        fit the contents in the web object's size, without leaving any space
        unused.

        :type: :ref:`Elm_Web_Zoom_Mode`

        """
        def __set__(self, Elm_Web_Zoom_Mode mode):
            elm_web_zoom_mode_set(self.obj, mode)

        def __get__(self):
            return elm_web_zoom_mode_get(self.obj)

    def zoom_mode_set(self, Elm_Web_Zoom_Mode mode):
        elm_web_zoom_mode_set(self.obj, mode)

    def zoom_mode_get(self):
        return elm_web_zoom_mode_get(self.obj)


    # TODO:
    # property webkit_view:
    #     """

    #     Get internal ewk_view object from web object.

    #     Elementary may not provide some low level features of EWebKit,
    #     instead of cluttering the API with proxy methods we opted to
    #     return the internal reference. Be careful using it as it may
    #     interfere with elm_web behavior.

    #     :return: The internal ewk_view object or **None** if it does not
    #             exist. (Failure to create or Elementary compiled without
    #             ewebkit)

    #     :see: elm_web_add()

    #     """
    #     def __get__(self):
    #         return object_from_instance(elm_web_webkit_view_get(self.obj))

    def webkit_view_get(self):
        cdef Evas_Object *obj = elm_web_webkit_view_get(self.obj)
        return object_from_instance(obj)

    # TODO:
    # def window_create_hook_set(self, func, func_data=None):
    #     """

    #     Sets the function to call when a new window is requested

    #     This hook will be called when a request to create a new window is
    #     issued from the web page loaded.
    #     There is no default implementation for this feature, so leaving this
    #     unset or passing **None** in @p func will prevent new windows from
    #     opening.

    #     :param func: The hook function to be called when a window is requested
    #     :param data: User data

    #     """
    #     elm_web_window_create_hook_set(self.obj,
    #         Elm_Web_Window_Open func,
    #         void *data)

    # def dialog_alert_hook_set(self, func, func_data=None):
    #     """

    #     Sets the function to call when an alert dialog

    #     This hook will be called when a JavaScript alert dialog is requested.
    #     If no function is set or **None** is passed in @p func, the default
    #     implementation will take place.

    #     :param func: The callback function to be used
    #     :param data: User data

    #     :see: elm_web_inwin_mode_set()

    #     """
    #     elm_web_dialog_alert_hook_set(self.obj,
    #         Elm_Web_Dialog_Alert func,
    #         void *data)

    # def dialog_confirm_hook_set(self, func, func_data=None):
    #     """

    #     Sets the function to call when an confirm dialog

    #     This hook will be called when a JavaScript confirm dialog is requested.
    #     If no function is set or **None** is passed in @p func, the default
    #     implementation will take place.

    #     :param func: The callback function to be used
    #     :param data: User data

    #     :see: elm_web_inwin_mode_set()

    #     """
    #     elm_web_dialog_confirm_hook_set(self.obj,
    #         Elm_Web_Dialog_Confirm func,
    #         void *data)

    # def dialog_prompt_hook_set(self, func, func_data=None):
    #     """

    #     Sets the function to call when an prompt dialog

    #     This hook will be called when a JavaScript prompt dialog is requested.
    #     If no function is set or **None** is passed in @p func, the default
    #     implementation will take place.

    #     :param func: The callback function to be used
    #     :param data: User data

    #     :see: elm_web_inwin_mode_set()

    #     """
    #     elm_web_dialog_prompt_hook_set(self.obj,
    #         Elm_Web_Dialog_Prompt func,
    #         void *data)

    # def dialog_file_selector_hook_set(self, func, func_data=None):
    #     """

    #     Sets the function to call when an file selector dialog

    #     This hook will be called when a JavaScript file selector dialog is
    #     requested.
    #     If no function is set or **None** is passed in @p func, the default
    #     implementation will take place.

    #     :param func: The callback function to be used
    #     :param data: User data

    #     :see: elm_web_inwin_mode_set()

    #     """
    #     elm_web_dialog_file_selector_hook_set(self.obj,
    #         Elm_Web_Dialog_File_Selector func,
    #         void *data)

    def console_message_hook_set(self, func, func_data=None):
        """

        Sets the function to call when a console message is emitted from JS

        This hook will be called when a console message is emitted from
        JavaScript. There is no default implementation for this feature.

        :param func: The callback function to be used
        :param data: User data

        """
        self._console_message_hook = func
        if func:
            elm_web_console_message_hook_set(self.obj,
                _web_console_message_hook,
                <void *>self)
        else:
            elm_web_console_message_hook_set(self.obj, NULL, NULL)

    property useragent:
        """

        useragent of a elm_web object

        :type: string

        """
        def __set__(self, user_agent):
            if isinstance(user_agent, unicode):
                user_agent = PyUnicode_AsUTF8String(user_agent)
            elm_web_useragent_set(self.obj, user_agent)

        def __get__(self):
            return _ctouni(elm_web_useragent_get(self.obj))

    def useragent_set(self, user_agent):
        if isinstance(user_agent, unicode):
            user_agent = PyUnicode_AsUTF8String(user_agent)
        elm_web_useragent_set(self.obj, user_agent)

    def useragent_get(self):
        return _ctouni(elm_web_useragent_get(self.obj))

    # TODO: Not implemented in ewebkit2 backend (yet?)
    # property tab_propagate:
    #     """Whether to use tab propagation

    #     If tab propagation is enabled, whenever the user presses the Tab key,
    #     Elementary will handle it and switch focus to the next widget.
    #     The default value is disabled, where WebKit will handle the Tab key to
    #     cycle focus though its internal objects, jumping to the next widget
    #     only when that cycle ends.

    #     :type: bool

    #     """
    #     def __get__(self):
    #         return bool(elm_web_tab_propagate_get(self.obj))

    #     def __set__(self, bint propagate):
    #         elm_web_tab_propagate_set(self.obj, propagate)

    property url:
        """

        The URL for the web object

        It must be a full URL, with resource included, in the form
        http://www.enlightenment.org or file:///tmp/something.html

        The returned string must not be freed and is guaranteed to be
        stringshared.

        :type: string

        :raise RuntimeError: if url could not be set

        .. versionadded:: 1.8

        """
        def __set__(self, url):
            if isinstance(url, unicode): url = PyUnicode_AsUTF8String(url)
            if not elm_web_url_set(self.obj, url):
                raise RuntimeWarning("Cannot set url")

        def __get__(self):
            return _ctouni(elm_web_url_get(self.obj))

    def url_set(self, url):
        if isinstance(url, unicode): url = PyUnicode_AsUTF8String(url)
        if not elm_web_url_set(self.obj, url):
            raise RuntimeWarning("Cannot set url")

    def url_get(self):
        return _ctouni(elm_web_url_get(self.obj))

    property uri:
        """

        .. deprecated:: 1.8
            Use property "url" instead.

        """
        def __get__(self):
            return self.uri_get()

        def __set__(self, value):
            self.uri_set(value)

    @DEPRECATED("1.8", "Use property url instead.")
    def uri_set(self, uri):
        return bool(elm_web_url_set(self.obj, uri))

    @DEPRECATED("1.8", "Use property url instead.")
    def uri_get(self):
        return _ctouni(elm_web_url_get(self.obj))

    property title:
        """

        Get the current title

        The returned string must not be freed and is guaranteed to be
        stringshared.

        :type: string

        """
        def __get__(self):
            return _ctouni(elm_web_title_get(self.obj))

    property bg_color:
        """

        The background color to be used by the web object

        This is the color that will be used by default when the loaded page
        does not set it's own. Color values are pre-multiplied.

        :param r: Red component
        :param g: Green component
        :param b: Blue component
        :param a: Alpha component

        """
        def __set__(self, value):
            cdef int r, g, b, a
            r, g, b, a = value
            elm_web_bg_color_set(self.obj, r, g, b, a)

        def __get__(self):
            cdef int r, g, b, a
            elm_web_bg_color_get(self.obj, &r, &g, &b, &a)
            return r, g, b, a

    property selection:
        """

        Get a copy of the currently selected text

        The string returned must be freed by the user when it's done with it.

        :return: A newly allocated string, or **None** if nothing is selected or an
            error occurred

        """
        def __get__(self):
            return _ctouni(elm_web_selection_get(self.obj))

    def popup_selected_set(self, int index):
        """

        Tells the web object which index in the currently open popup was selected

        When the user handles the popup creation from the "popup,created" signal,
        it needs to tell the web object which item was selected by calling this
        function with the index corresponding to the item.

        :param index: The index selected

        :see: elm_web_popup_destroy()

        """
        elm_web_popup_selected_set(self.obj, index)

    def popup_destroy(self):
        """

        Dismisses an open dropdown popup

        When the popup from a dropdown widget is to be dismissed, either after
        selecting an option or to cancel it, this function must be called, which
        will later emit an "popup,willdelete" signal to notify the user that
        any memory and objects related to this popup can be freed.

        :return: **True** if the menu was successfully destroyed, or **False**
            if there was no menu to destroy

        """
        return bool(elm_web_popup_destroy(self.obj))

    def text_search(self, string, bint case_sensitive, bint forward, bint wrap):
        """

        Searches the given string in a document.

        :param string: String to search
        :param case_sensitive: If search should be case sensitive or not
        :param forward: If search is from cursor and on or backwards
        :param wrap: If search should wrap at the end

        :return: **True** if the given string was found, **False** if not
            or failure

        """
        if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
        return bool(elm_web_text_search(self.obj,
            string, case_sensitive, forward, wrap))

    def text_matches_mark(self, string, bint case_sensitive, bint highlight,
        unsigned int limit):
        """

        Marks matches of the given string in a document.

        :param string: String to match
        :param case_sensitive: If match should be case sensitive or not
        :param highlight: If matches should be highlighted
        :param limit: Maximum amount of matches, or zero to unlimited

        :return: number of matched @a string

        """
        if isinstance(string, unicode): string = PyUnicode_AsUTF8String(string)
        return elm_web_text_matches_mark(self.obj, string, case_sensitive, highlight, limit)

    def text_matches_unmark_all(self):
        """

        Clears all marked matches in the document

        :return: **True** on success, **False** otherwise

        """
        if not elm_web_text_matches_unmark_all(self.obj):
            raise RuntimeWarning("Cannot clear marked matches")

    property text_matches_highlight:
        """

        Whether to highlight the matched marks

        If enabled, marks set with elm_web_text_matches_mark() will be
        highlighted.

        :type: bool

        """
        def __set__(self, bint highlight):
            if not elm_web_text_matches_highlight_set(self.obj, highlight):
                raise RuntimeWarning("Cannot set matched marks highlighting")

        def __get__(self):
            return bool(elm_web_text_matches_highlight_get(self.obj))

    property load_progress:
        """

        Get the overall loading progress of the page

        Returns the estimated loading progress of the page, with a value
        between 0.0 and 1.0. This is an estimated progress accounting for all
        the frames included in the page.

        :return: A value between 0.0 and 1.0 indicating the progress, or -1.0
            on failure

        """
        def __get__(self):
            return elm_web_load_progress_get(self.obj)

    def stop(self):
        """

        Stops loading the current page

        Cancels the loading of the current page in the web object. This will
        cause a "load,error" signal to be emitted, with the is_cancellation
        flag set to **True**.

        :return: **True** if the cancel was successful, **False** otherwise

        """
        if not elm_web_stop(self.obj):
            raise RuntimeWarning("Cannot stop")

    def reload(self):
        """

        Requests a reload of the current document in the object

        :return: **True** on success, **False** otherwise

        """
        if not elm_web_reload(self.obj):
            raise RuntimeWarning("Cannot reload")

    def reload_full(self):
        """

        Requests a reload of the current document, avoiding any existing caches

        :return: **True** on success, **False** otherwise

        """
        if not elm_web_reload_full(self.obj):
            raise RuntimeWarning("Cannot reload without caches")

    def back(self):
        """

        Goes back one step in the browsing history

        This is equivalent to calling elm_web_object_navigate(obj, -1);

        :return: **True** on success, **False** otherwise

        :see: elm_web_history_enabled_set()
        :see: elm_web_back_possible()
        :see: elm_web_forward()
        :see: elm_web_navigate()

        """
        if not elm_web_back(self.obj):
            raise RuntimeWarning("Cannot go back")

    def forward(self):
        """

        Goes forward one step in the browsing history

        This is equivalent to calling elm_web_object_navigate(obj, 1);

        :return: **True** on success, **False** otherwise

        :see: elm_web_history_enabled_set()
        :see: elm_web_forward_possible_get()
        :see: elm_web_back()
        :see: elm_web_navigate()

        """
        if not elm_web_forward(self.obj):
            raise RuntimeWarning("Cannot go forward")

    def navigate(self, int steps):
        """

        Jumps the given number of steps in the browsing history

        The @p steps value can be a negative integer to back in history, or a
        positive to move forward.

        :param steps: The number of steps to jump

        :return: **True** on success, **False** on error or if not enough
            history exists to jump the given number of steps

        :see: elm_web_history_enabled_set()
        :see: elm_web_back()
        :see: elm_web_forward()

        """
        return bool(elm_web_navigate(self.obj, steps))

    property back_possible:
        """

        Queries whether it's possible to go back in history

        :return: **True** if it's possible to back in history, **False**
            otherwise

        """
        def __get__(self):
            return bool(elm_web_back_possible_get(self.obj))

    property forward_possible:
        """

        Queries whether it's possible to go forward in history

        :return: **True** if it's possible to forward in history, **False**
            otherwise

        """
        def __get__(self):
            return bool(elm_web_forward_possible_get(self.obj))

    def navigate_possible_get(self, int steps):
        """

        Queries whether it's possible to jump the given number of steps

        The @p steps value can be a negative integer to back in history, or a
        positive to move forward.
        :param steps: The number of steps to check for

        :return: **True** if enough history exists to perform the given jump,
            **False** otherwise

        """
        return bool(elm_web_navigate_possible_get(self.obj, steps))

    property history_enabled:
        """

        Whether browsing history is enabled for the given object

        :type: bool

        """
        def __get__(self):
            return bool(elm_web_history_enabled_get(self.obj))

        def __set__(self, bint enabled):
            elm_web_history_enabled_set(self.obj, enabled)

    def history_enabled_get(self):
        return bool(elm_web_history_enabled_get(self.obj))

    def history_enabled_set(self, bint enabled):
        elm_web_history_enabled_set(self.obj, enabled)

    property zoom:
        """

        Sets the zoom level of the web object

        Zoom level matches the Webkit API, so 1.0 means normal zoom, with higher
        values meaning zoom in and lower meaning zoom out. This function will
        only affect the zoom level if the mode set with elm_web_zoom_mode_set()
        is ::ELM_WEB_ZOOM_MODE_MANUAL.

        Note that this is the zoom level set on the web object and not that
        of the underlying Webkit one. In the ::ELM_WEB_ZOOM_MODE_MANUAL mode,
        the two zoom levels should match, but for the other two modes the
        Webkit zoom is calculated internally to match the chosen mode without
        changing the zoom level set for the web object.

        :type: float

        """
        def __set__(self, double zoom):
            elm_web_zoom_set(self.obj, zoom)

        def __get__(self):
            return elm_web_zoom_get(self.obj)

    def zoom_set(self, double zoom):
        elm_web_zoom_set(self.obj, zoom)

    def zoom_get(self):
        return elm_web_zoom_get(self.obj)

    def region_show(self, int x, int y, int w, int h):
        """

        Shows the given region in the web object

        :param x: The x coordinate of the region to show
        :param y: The y coordinate of the region to show
        :param w: The width of the region to show
        :param h: The height of the region to show

        """
        elm_web_region_show(self.obj, x, y, w, h)

    def region_bring_in(self, int x, int y, int w, int h):
        """

        Brings in the region to the visible area

        Like elm_web_region_show(), but it animates the scrolling of the object
        to show the area

        :param x: The x coordinate of the region to show
        :param y: The y coordinate of the region to show
        :param w: The width of the region to show
        :param h: The height of the region to show

        """
        elm_web_region_bring_in(self.obj, x, y, w, h)

    property inwin_mode:
        """

        Whether the default dialogs use an Inwin instead of a normal window

        If set, then the default implementation for the JavaScript dialogs and
        file selector will be opened in an Inwin. Otherwise they will use a
        normal separated window.

        :type: bool

        """
        def __set__(self, bint value):
            elm_web_inwin_mode_set(self.obj, value)

        def __get__(self):
            return bool(elm_web_inwin_mode_get(self.obj))


    # TODO:
    # def callback_download_request_add(self, func, *args, **kwargs):
    #     """A file download has been requested. Event info is a pointer to a
    #     Elm_Web_Download."""
    #     self._callback_add_full("download,request", _web_download_conv, func,
    #         *args, **kwargs)

    # def callback_download_request_del(self, func):
    #     self._callback_del_full("download,request", _web_download_conv, func)

    def callback_editorclient_contents_changed_add(self, func, *args, **kwargs):
        """Editor client's contents changed."""
        self._callback_add("editorclient,contents,changed", func, args, kwargs)

    def callback_editorclient_contents_changed_del(self, func):
        self._callback_del("editorclient,contents,changed", func)

    def callback_editorclient_selection_changed_add(self, func, *args, **kwargs):
        """Editor client's selection changed."""
        self._callback_add("editorclient,selection,changed", func, args, kwargs)

    def callback_editorclient_selection_changed_del(self, func):
        self._callback_del("editorclient,selection,changed", func)

    # TODO:
    # def callback_frame_created_add(self, func, *args, **kwargs):
    #     """A new frame was created. Event info is an
    #     Evas_Object which can be handled with WebKit's ewk_frame API."""
    #     self._callback_add("frame,created", func, args, kwargs)

    # def callback_frame_created_del(self, func):
    #     self._callback_del("frame,created", func)

    def callback_icon_received_add(self, func, *args, **kwargs):
        """An icon was received by the main frame."""
        self._callback_add("icon,received", func, args, kwargs)

    def callback_icon_received_del(self, func):
        self._callback_del("icon,received", func)

    def callback_inputmethod_changed_add(self, func, *args, **kwargs):
        """Input method changed. Event info is an Eina_Bool indicating whether
        it's enabled or not."""
        self._callback_add_full("inputmethod,changed", _cb_bool_conv, func,
            args, kwargs)

    def callback_inputmethod_changed_del(self, func):
        self._callback_del_full("inputmethod,changed", _cb_bool_conv, func)

    def callback_js_windowobject_clear_add(self, func, *args, **kwargs):
        """JS window object has been cleared."""
        self._callback_add("js,windowobject,clear", func, args, kwargs)

    def callback_js_windowobject_clear_del(self, func):
        self._callback_del("js,windowobject,clear", func)

    def callback_link_hover_in_add(self, func, *args, **kwargs):
        """Mouse cursor is hovering over a link. Event info
        is a tuple, where the first string contains the URL the link
        points to, and the second one the title of the link."""
        self._callback_add_full("link,hover,in", _web_link_hover_in_conv, func,
            args, kwargs)

    def callback_link_hover_in_del(self, func):
        self._callback_del_full("link,hover,in", _web_link_hover_in_conv, func)

    def callback_link_hover_out_add(self, func, *args, **kwargs):
        """Mouse cursor left the link."""
        self._callback_add("link,hover,out", func, args, kwargs)

    def callback_link_hover_out_del(self, func):
        self._callback_del("link,hover,out", func)

    # TODO:
    # def callback_load_document_finished_add(self, func, *args, **kwargs):
    #     """Loading of a document finished. Event info
    #     is the frame that finished loading."""
    #     self._callback_add("load,document,finished", func, args, kwargs)

    # def callback_load_document_finished_del(self, func):
    #     self._callback_del("load,document,finished", func)

    def callback_load_error_add(self, func, *args, **kwargs):
        """Load failed. Event info is a WebFrameLoadError instance."""
        self._callback_add_full("load,error", _web_load_frame_error_conv, func,
            args, kwargs)

    def callback_load_error_del(self, func):
        self._callback_del_full("load,error", _web_load_frame_error_conv, func)

    def callback_load_finished_add(self, func, *args, **kwargs):
        """Load finished. Event info is None on success, on error it's
        a pointer to Elm_Web_Frame_Load_Error."""
        self._callback_add_full("load,finished", _web_load_frame_error_conv, func, args, kwargs)

    def callback_load_finished_del(self, func):
        self._callback_del_full("load,finished", _web_load_frame_error_conv, func)

    def callback_load_newwindow_show_add(self, func, *args, **kwargs):
        """A new window was created and is ready to be shown."""
        self._callback_add("load,newwindow,show", func, args, kwargs)

    def callback_load_newwindow_show_del(self, func):
        self._callback_del("load,newwindow,show", func)

    def callback_load_progress_add(self, func, *args, **kwargs):
        """Overall load progress. Event info is a double containing
        a value between 0.0 and 1.0."""
        self._callback_add_full("load,progress", _web_double_conv, func,
            args, kwargs)

    def callback_load_progress_del(self, func):
        self._callback_del_full("load,progress", _web_double_conv, func)

    def callback_load_provisional_add(self, func, *args, **kwargs):
        """Started provisional load."""
        self._callback_add("load,provisional", func, args, kwargs)

    def callback_load_provisional_del(self, func):
        self._callback_del("load,provisional", func)

    def callback_load_started_add(self, func, *args, **kwargs):
        """Loading of a document started."""
        self._callback_add("load,started", func, args, kwargs)

    def callback_load_started_del(self, func):
        self._callback_del("load,started", func)

    # def callback_menubar_visible_get_add(self, func, *args, **kwargs):
    #     """Queries if the menubar is visible. Event info
    #     is a bool where the callback should set True if
    #     the menubar is visible, or False in case it's not."""
    #     # FIXME: the cb for this should use the return value, not the bool passed.
    #     self._callback_add_full("menubar,visible,get", _cb_bool_conv, func,
    #         *args, **kwargs)

    # def callback_menubar_visible_get_del(self, func):
    #     self._callback_del_full("menubar,visible,get", _cb_bool_conv, func)

    def callback_menubar_visible_set_add(self, func, *args, **kwargs):
        """Informs menubar visibility. Event info is
        a bool indicating the visibility."""
        self._callback_add_full("menubar,visible,set", _cb_bool_conv, func,
            args, kwargs)

    def callback_menubar_visible_set_del(self, func):
        self._callback_del_full("menubar,visible,set", _cb_bool_conv, func)

    # TODO:
    # def callback_popup_created_add(self, func, *args, **kwargs):
    #     """A dropdown widget was activated, requesting its
    #     popup menu to be created. Event info is a pointer to Elm_Web_Menu."""
    #     self._callback_add("popup,created", func, args, kwargs)

    # def callback_popup_created_del(self, func):
    #     self._callback_del("popup,created", func)

    # def callback_popup_willdelete_add(self, func, *args, **kwargs):
    #     """The web object is ready to destroy the popup
    #     object created. Event info is a pointer to Elm_Web_Menu."""
    #     self._callback_add("popup,willdelete", func, args, kwargs)

    # def callback_popup_willdelete_del(self, func):
    #     self._callback_del("popup,willdelete", func)

    def callback_ready_add(self, func, *args, **kwargs):
        """Page is fully loaded."""
        self._callback_add("ready", func, args, kwargs)

    def callback_ready_del(self, func):
        self._callback_del("ready", func)

    # def callback_scrollbars_visible_get_add(self, func, *args, **kwargs):
    #     """Queries visibility of scrollbars. Event info is a bool where the
    #     visibility state should be set."""
    #     self._callback_add_full("scrollbars,visible,get", _cb_bool_conv, func,
    #         *args, **kwargs)

    # def callback_scrollbars_visible_get_del(self, func):
    #     self._callback_del_full("scrollbars,visible,get", _cb_bool_conv, func)

    def callback_scrollbars_visible_set_add(self, func, *args, **kwargs):
        """Informs scrollbars visibility. Event info
        is a bool with the visibility state set."""
        self._callback_add_full("scrollbars,visible,set", _cb_bool_conv, func,
            args, kwargs)

    def callback_scrollbars_visible_set_del(self, func):
        self._callback_del_full("scrollbars,visible,set", _cb_bool_conv, func)

    def callback_statusbar_text_set_add(self, func, *args, **kwargs):
        """Text of the statusbar changed. Event info is
        a string with the new text."""
        self._callback_add_full("statusbar,text,set", _cb_string_conv, func,
            args, kwargs)

    def callback_statusbar_text_set_del(self, func):
        self._callback_del_full("statusbar,text,set", _cb_string_conv, func)

    # def callback_statusbar_visible_get_add(self, func, *args, **kwargs):
    #     """Queries visibility of the status bar.
    #     Event info is a bool where the visibility state should
    #     be set."""
    #     self._callback_add_full("statusbar,visible,get", _cb_bool_conv, func,
    #         *args, **kwargs)

    # def callback_statusbar_visible_get_del(self, func):
    #     self._callback_del_full("statusbar,visible,get", _cb_bool_conv, func)

    def callback_statusbar_visible_set_add(self, func, *args, **kwargs):
        """Informs statusbar visibility. Event info is
        a bool with the visibility value."""
        self._callback_add_full("statusbar,visible,set", _cb_bool_conv, func,
            args, kwargs)

    def callback_statusbar_visible_set_del(self, func):
        self._callback_del_full("statusbar,visible,set", _cb_bool_conv, func)

    def callback_title_changed_add(self, func, *args, **kwargs):
        """Title of the main frame changed. Event info is a
        string with the new title."""
        self._callback_add_full("title,changed", _cb_string_conv, func, args, kwargs)

    def callback_title_changed_del(self, func):
        self._callback_del_full("title,changed", _cb_string_conv, func)

    # def callback_toolbars_visible_get_add(self, func, *args, **kwargs):
    #     """Queries visibility of toolbars. Event info
    #     is a bool where the visibility state should be set."""
    #     self._callback_add_full("toolbars,visible,get", _cb_bool_conv, func,
    #         *args, **kwargs)

    # def callback_toolbars_visible_get_del(self, func):
    #     self._callback_del_full("toolbars,visible,get", _cb_bool_conv, func)

    def callback_toolbars_visible_set_add(self, func, *args, **kwargs):
        """Informs the visibility of toolbars. Event
        info is a bool with the visibility state."""
        self._callback_add_full("toolbars,visible,set", _cb_bool_conv, func,
            args, kwargs)

    def callback_toolbars_visible_set_del(self, func):
        self._callback_del_full("toolbars,visible,set", _cb_bool_conv, func)

    def callback_tooltip_text_set_add(self, func, *args, **kwargs):
        """Show and set text of a tooltip. Event info is
        a string with the text to show."""
        self._callback_add_full("tooltip,text,set", _cb_string_conv, func,
            args, kwargs)

    def callback_tooltip_text_set_del(self, func):
        self._callback_del_full("tooltip,text,set", _cb_string_conv, func)

    def callback_uri_changed_add(self, func, *args, **kwargs):
        """URI of the main frame changed. Event info is a string.
        (deprecated. use "url,changed" instead)"""
        self._callback_add_full("uri,changed", _cb_string_conv, func,
            args, kwargs)

    def callback_uri_changed_del(self, func):
        self._callback_del_full("uri,changed", _cb_string_conv, func)

    def callback_url_changed_add(self, func, *args, **kwargs):
        """URL of the main frame changed. Event info is a string
        with the new URI."""
        self._callback_add_full("url,changed", _cb_string_conv, func,
            args, kwargs)

    def callback_url_changed_del(self, func):
        self._callback_del_full("url,changed", _cb_string_conv, func)

    def callback_view_resized_add(self, func, *args, **kwargs):
        """The web object internal's view changed sized."""
        self._callback_add("view,resized", func, args, kwargs)

    def callback_view_resized_del(self, func):
        self._callback_del("view,resized", func)

    def callback_windows_close_request_add(self, func, *args, **kwargs):
        """A JavaScript request to close the current
        window was requested."""
        self._callback_add("windows,close,request", func, args, kwargs)

    def callback_windows_close_request_del(self, func):
        self._callback_del("windows,close,request", func)

    def callback_zoom_animated_end_add(self, func, *args, **kwargs):
        """Animated zoom finished."""
        self._callback_add("zoom,animated,end", func, args, kwargs)

    def callback_zoom_animated_end_del(self, func):
        self._callback_del("zoom,animated,end", func)



_object_mapping_register("Elm_Web", Web)
