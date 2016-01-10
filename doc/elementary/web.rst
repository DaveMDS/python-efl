.. currentmodule:: efl.elementary

Web
###


Widget description
==================

A web widget is used for displaying web pages (HTML/CSS/JS)
using WebKit-EFL. You must have compiled Elementary with
ewebkit support.


Emitted signals
===============

- ``download,request``: A file download has been requested. Event info is
  a WebDownload instance
- ``editorclient,contents,changed``: Editor client's contents changed
- ``editorclient,selection,changed``: Editor client's selection changed
- ``frame,created``: A new frame was created. Event info is an
  Evas_Object which can be handled with WebKit's ewk_frame API
- ``icon,received``: An icon was received by the main frame
- ``inputmethod,changed``: Input method changed. Event info is an
  Eina_Bool indicating whether it's enabled or not
- ``js,windowobject,clear``: JS window object has been cleared
- ``link,hover,in``: Mouse cursor is hovering over a link. Event info
  is a tuple, where the first string contains the URL the link
  points to, and the second one the title of the link
- ``link,hover,out``: Mouse cursor left the link
- ``load,document,finished``: Loading of a document finished. Event info
  is the frame that finished loading
- ``load,error``: Load failed. Event info is a WebFrameLoadError instance
- ``load,finished``: Load finished. Event info is None on success, on
  error it's a WebFrameLoadError instance
- ``load,newwindow,show``: A new window was created and is ready to be
  shown
- ``load,progress``: Overall load progress. Event info is
  a double containing a value between 0.0 and 1.0
- ``load,provisional``: Started provisional load
- ``load,started``: Loading of a document started
- ``menubar,visible,get``: Queries if the menubar is visible. Event info
  is a bool where the callback should set True if
  the menubar is visible, or False in case it's not
- ``menubar,visible,set``: Informs menubar visibility. Event info is
  a bool indicating the visibility
- ``popup,created``: A dropdown widget was activated, requesting its
  popup menu to be created. Event info is a WebMenu instance
- ``popup,willdelete``: The web object is ready to destroy the popup
  object created. Event info is a WebMenu instance
- ``ready``: Page is fully loaded
- ``scrollbars,visible,get``: Queries visibility of scrollbars. Event
  info is a bool where the visibility state should be set
- ``scrollbars,visible,set``: Informs scrollbars visibility. Event info
  is an Eina_Bool with the visibility state set
- ``statusbar,text,set``: Text of the statusbar changed. Event info is
  a string with the new text
- ``statusbar,visible,get``: Queries visibility of the status bar.
  Event info is a bool where the visibility state should be
  set.
- ``statusbar,visible,set``: Informs statusbar visibility. Event info is
  an Eina_Bool with the visibility value
- ``title,changed``: Title of the main frame changed. Event info is a
  string with the new title
- ``toolbars,visible,get``: Queries visibility of toolbars. Event info
  is a bool where the visibility state should be set
- ``toolbars,visible,set``: Informs the visibility of toolbars. Event
  info is an Eina_Bool with the visibility state
- ``tooltip,text,set``: Show and set text of a tooltip. Event info is
  a string with the text to show
- ``uri,changed``: URI of the main frame changed. Event info is a string (deprecated. use ``url,changed`` instead)
- ``url,changed``: URL of the main frame changed. Event info is a string
  with the new URI
- ``view,resized``: The web object internal's view changed sized
- ``windows,close,request``: A JavaScript request to close the current
  window was requested
- ``zoom,animated,end``: Animated zoom finished


Enumerations
============

.. _Elm_Web_Window_Feature:

Web window features
-------------------

.. data:: ELM_WEB_WINDOW_FEATURE_TOOLBAR

    Toolbar

.. data:: ELM_WEB_WINDOW_FEATURE_STATUSBAR

    Status bar

.. data:: ELM_WEB_WINDOW_FEATURE_SCROLLBARS

    Scrollbars

.. data:: ELM_WEB_WINDOW_FEATURE_MENUBAR

    Menu bar

.. data:: ELM_WEB_WINDOW_FEATURE_LOCATIONBAR

    Location bar

.. data:: ELM_WEB_WINDOW_FEATURE_FULLSCREEN

    Fullscreen


.. _Elm_Web_Zoom_Mode:

Web zoom modes
--------------

.. data:: ELM_WEB_ZOOM_MODE_MANUAL

    Zoom controlled normally by :py:attr:`~Web.zoom`

.. data:: ELM_WEB_ZOOM_MODE_AUTO_FIT

    Zoom until content fits in web object.

.. data:: ELM_WEB_ZOOM_MODE_AUTO_FILL

    Zoom until content fills web object.


Inheritance diagram
===================

.. inheritance-diagram:: Web
    :parts: 2


.. autoclass:: Web
