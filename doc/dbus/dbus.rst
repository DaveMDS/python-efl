Ecore DBus Mainloop integration
===============================


How to use the main loop
-----------------------------

Python-EFL provide the necessary main loop integration to let
python-dbus use the Ecore main loop to perform async stuff. The only
function you need to use from the efl is: DBusEcoreMainLoop()

The function returns a NativeMainLoop to attach the Ecore main loop to D-Bus
from within Python. In practice you just need to pass the NativeMainLoop
as the 'mainloop' param when you connect to a bus.

This is how you connect to a dbus bus:

.. code-block:: python

    import dbus
    from efl import ecore
    from efl.dbus_mainloop import DBusEcoreMainLoop

    # connect to the session bus
    bus = dbus.SessionBus(mainloop=DBusEcoreMainLoop())
    # or to the system bus
    bus = dbus.SystemBus(mainloop=DBusEcoreMainLoop())

Once you have your bus connected you can just normally use all the python-dbus
functionality. This is the reason why you will not find any docs about dbus
here (except for some basic examples).

It's therefore highly suggested to read the official python-dbus tutorial and
to use the python-dbus reference, you will find all the links in the bottom
of the page.


Proxy objects
-------------

In the dbus world to interact with an object you need to know:

- the name of the service, ex: `org.enlightenment.FileManager`
- the path to the object you are intrested, ex: `/org/enlightenment/FileManager`
- the interface to interact with, ex: `org.enlightenment.FileManager`

.. code-block:: python

    obj = bus.get_object(named_service, object_path)
    iface = dbus.Interface(obj, iface_name)

then, on the iface object, you can call methods, connect to signals and access
properties.


Calling methods
---------------

There are at least two way to call methods on a remote object, the first
example show how to do it the simple way, while the second show a much more
complex but much powerfull async way. Note: using the sync way can make your
app lag or halt forever if the remote keep too much time to respond.

Both the examples use the ``OpenDirectory(s)`` method of the Enlightenment
file manager to open a new window in the `/tmp` directory.

.. code-block:: python

    # synchronous call

    obj = bus.get_object('org.enlightenment.FileManager',
                         '/org/enlightenment/FileManager')
    iface = dbus.Interface(obj, 'org.enlightenment.FileManager')
    # directly
    iface.OpenDirectory('/tmp')
    # or using a method object
    meth = iface.get_dbus_method('OpenDirectory')
    meth('/tmp')


.. code-block:: python

    # asynchronous call

    def reply_handler(*params):
       print("Method return: " + str(params))

    def error_handler(*params):
        print("Method error")


    obj = bus.get_object('org.enlightenment.FileManager',
                         '/org/enlightenment/FileManager')
    iface = dbus.Interface(obj, 'org.enlightenment.FileManager')
    iface.OpenDirectory('/tmp',
                        reply_handler=reply_handler,
                        error_handler=error_handler)

    ecore.main_loop_begin()


Accessing properties
--------------------

To access properties you need to use the standard **org.freedesktop.DBus.Properties**
interface that all the objects provide. Methods on this iterface are:

- Get(s interface, s propname) → (v value)
- GetAll(s interface) → (a{sv} props)
- Set(s interface, s propname, v value)

The example show how to get the value of the `DaemonVersion` prop of `UDisks`

.. code-block:: python

    
    bus = dbus.SystemBus(mainloop=DBusEcoreMainLoop())
    obj = bus.get_object('org.freedesktop.UDisks',
                         '/org/freedesktop/UDisks')
    props_iface = dbus.Interface(obj, 'org.freedesktop.DBus.Properties')
    value = props_iface.Get('org.freedesktop.UDisks', 'DaemonVersion')




Connecting signals
------------------

.. literalinclude:: ../../examples/dbus/test_signal_simple.py


Introspection
-------------

To get information for a given proxy object you need to use the ``Introspect()``
method on the **org.freedesktop.DBus.Introspectable** interface.
The introspection will return an XML string that describe all the interfaces
available on the object, with all the methods, properties and signals info.

.. code-block:: python

    bus = dbus.SessionBus(mainloop=DBusEcoreMainLoop())
    obj = bus.get_object('org.enlightenment.FileManager',
                         '/org/enlightenment/FileManager')
    iface = dbus.Interface(obj, 'org.freedesktop.DBus.Introspectable')
    xml_string = iface.Introspect()

This other example show how to do recursive introspection on a given service,
starting from the root object path ``/``

.. code-block:: python

    import dbus
    import xml.etree.ElementTree as ElementTree
    from efl import ecore
    from efl.dbus_mainloop import DBusEcoreMainLoop

    def recursive_introspect(bus, named_service, object_path):
        print('Introspecting obj "%s" on service "%s"' % \
              (object_path, named_service))

        # introspect
        obj = bus.get_object(named_service, object_path)
        iface = dbus.Interface(obj, 'org.freedesktop.DBus.Introspectable')
        xml_string = iface.Introspect()

        # parse
        for xml_node in ElementTree.fromstring(xml_string):
            # found an interface
            if xml_node.tag == 'interface':
                print('  Found interface: ' + xml_node.attrib['name'])

                for child in xml_node:
                    if child.tag == 'property':
                        print('    Found property: ' + child.attrib['name'])

                    if child.tag == 'method':
                        print('    Found method: ' + child.attrib['name'])

                    if child.tag == 'signal':
                        print('    Found signal: ' + child.attrib['name'])

            # found another node, introspect it...
            if xml_node.tag == 'node':
                if object_path == '/':
                    object_path = ''
                new_path = '/'.join((object_path, xml_node.attrib['name']))
                recursive_introspect(bus, named_service, new_path)

    bus = dbus.SystemBus(mainloop=DBusEcoreMainLoop())
    recursive_introspect(bus, 'org.freedesktop.UDisks', '/')


References
----------

- `dbus tutorial <http://dbus.freedesktop.org/doc/dbus-tutorial.html>`_
- `python-dbus tutorial <http://dbus.freedesktop.org/doc/dbus-python/doc/tutorial.html>`_
- `python-dbus reference <http://dbus.freedesktop.org/doc/dbus-python/api/index.html>`_
