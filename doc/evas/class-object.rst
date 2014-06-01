.. currentmodule:: efl.evas

:class:`efl.evas.Object` Class
==============================

.. _Evas_Keys:

Key Input Functions
===================

Functions which feed key events to the canvas.

As explained in :ref:`evas_main_intro_not_evas`, Evas is **not** aware of input
systems at all. Then, the user, if using it crudely (evas_new()),
will have to feed it with input events, so that it can react
somehow. If, however, the user creates a canvas by means of the
Ecore_Evas wrapper, it will automatically bind the chosen display
engine's input events to the canvas, for you.

This group presents the functions dealing with the feeding of key
events to the canvas. On most of them, one has to reference a given
key by a name (``keyname`` argument). Those are
**platform dependent** symbolic names for the keys. Sometimes
you'll get the right ``keyname`` by simply using an ASCII
value of the key name, but it won't be like that always.

Typical platforms are Linux frame buffer (Ecore_FB) and X server
(Ecore_X) when using Evas with Ecore and Ecore_Evas. Please refer
to your display engine's documentation when using evas through an
Ecore helper wrapper when you need the ``keyname``'s.


.. autoclass:: efl.evas.Object
    :inherited-members:
