.. module:: efl

:py:mod:`efl` Package
=====================

.. versionadded:: 1.8

Logging
-------

PyEFL provides `logging <http://docs.python.org/2/library/logging.html>`_
to loggers which are usually named after their equivalent module,
f.e. *efl.eo*. There is a root logger called *efl* which also receives
any messages coming from the underlying C libraries.

These loggers have a NullHandler by default and are set to log messages
with level logging.WARNING and higher. The child loggers propagate
messages to *efl*, which doesn't propagate to the root Python logger,
so you need to add handlers to it to get output from it::

    import logging
    elog = logging.getLogger("efl")
    elog.addHandler(logging.StreamHandler())

You should also set its level::

    elog.setLevel(logging.INFO)

And you may control the child loggers individually::

    elm_log = logging.getLogger("efl.elementary")
    elm_log.propagate = False
    elm_log.addHandler(logging.StreamHandler())
    elm_log.setLevel(logging.ERROR)

.. versionadded:: 1.8
    Loggers

Class properties
----------------

All class properties have their respective _get/_set methods defined.

These are useful when there are properties with the same name in the
inheritance tree, or when you're using a lambda.

The properties can be applied to the instance by using keyword arguments that
are not already used by the constructor, for example like this::

    Button(win, text="I win")

.. versionadded:: 1.8
    Using keyword arguments to set properties
