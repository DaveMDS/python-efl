
What is Eo?
--------------

Eo is the generic object system of the whole set of libraries. It is
designed to be the base object system for the EFL.

The :class:`Eo` class is the base for (quite) all the objects in the EFL, in
other words every EFL object inherit from :class:`Eo` and you can use the
methods defined here on every other object.

In practice you will never directly use the :class:`Eo` class, in fact you
cannot create an instance of the class. As a user you will just use a small
number of methods from derived class, like :meth:`Eo.delete()` or
:meth:`Eo.is_deleted()`


API Reference
-------------

.. toctree::
   :titlesonly:

   module-eo.rst
