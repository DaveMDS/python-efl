
.. _ethumb_main_intro:


What is Ethumb?
===============

Ethumb will use Evas to generate thumbnail images of given files. The API
allows great customization of the generated files and also helps compling to
FreeDesktop.Org Thumbnail Specification.

(http://specifications.freedesktop.org/thumbnail-spec/thumbnail-spec-latest.html)

However, thumbnailing can be an expensive process that will impact your
application experience, blocking animations and user interaction during the
generation. Another problem is that one should try to cache the thumbnails in
a place that other applications can benefit from the file.

:class:`~efl.ethumb_client.EthumbClient` exists to solve this. It will
communicate with a server using standard D-Bus protocol. The server will use
:class:`~efl.ethumb.Ethumb` itself to generate the thumbnail images and cache
them using FreeDesktop.Org standard. It is recommended that most applications
use :class:`~efl.ethumb_client.EthumbClient` instead of
:class:`~efl.ethumb.Ethumb` directly.

Another difference is that one :class:`~efl.ethumb.Ethumb` instance
can only generate a single thumbnail at a given time, so you must implement
some sort of queue mechanism if you need more than one. Instead
:class:`~efl.ethumb_client.EthumbClient` is a able to receive more than one
request at the same time.

Recommended reading:

    :class:`~efl.ethumb.Ethumb` to generate thumbnails in the local process.

    :class:`~efl.ethumb_client.EthumbClient` to generate thumbnails using a
    server (recommended).


API Reference
=============

.. toctree::
   :titlesonly:

   module-ethumb.rst
   module-ethumb_client.rst


Inheritance diagram
===================

.. inheritance-diagram:: efl.ethumb
    :parts: 2

