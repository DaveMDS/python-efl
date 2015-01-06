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


Distutils helpers for your setup.py
-----------------------------------

.. versionadded:: 1.13

For your convenience **python-efl** provide some usefull `distutils
<https://docs.python.org/2/distutils/>`_ Commands to be used in your
**setup.py** script.

Provided commands are:
 * ``build_edc`` To build (using edje_cc) and install your application themes.
 * ``build_i18n`` To integrate the gettext framework.
 * ``build_fdo`` To install .desktop and icons as per FreeDesktop specifications.
 * ``uninstall`` To uninstall your app.
 * ``build_extra`` Adds the provided commands to the build target.

The usage is quite simple, just import and add them in your setup() cmdclass.

.. code-block:: python

    from distutils.core import setup
    from efl.utils.setup import build_edc, build_i18n, build_fdo
    from efl.utils.setup import build_extra, uninstall

    setup(
        ...
        cmdclass = {
            'build': build_extra,
            'build_edc': build_edc,
            'build_i18n': build_i18n,
            'build_fdo': build_fdo,
            'uninstall': uninstall,
        },
        command_options={
            'install': {'record': ('setup.py', 'installed_files.txt')}
        },
    )


The **install** option is required if you want to use the **uninstall** command.

The **build_extra** command is only used to automatically add all the other
commands to the default build command, you probably always want it, unless
you are providing your own yet.

Once you have added a command you can look at the help for more informations,
for example::

    python setup.py build_i18n --help

or more in general::

    python setup.py --help-commands

