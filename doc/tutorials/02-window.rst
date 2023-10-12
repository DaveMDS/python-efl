
Tutorial 2 - Window
===================

Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

Simple window

Be sure to read first:

`How to install Python-efl on Ubuntu or Linux
Mint <https://www.pythonkitchen.com/how-to-install-python-efl-on-ubuntu-or-linux-mint/>`__

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0
   '''
   import efl.elementary as elm
   from efl.elementary.label import Label
   from efl.elementary.window import StandardWindow
   from efl.evas import EVAS_HINT_EXPAND

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex1", "Hello Elementary", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())
           label = Label(self)
           label.size_hint_weight = EXPAND_BOTH
           label.text = "Hello Elementary!"
           label.show()
           self.resize_object_add(label)


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()

Note: elm.shutdown is no longer needed as per the docs which says

.. code:: python

           .. versionchanged:: 1.14

               The Python module calls this function when it is exiting so you
               should no longer have any need to call this manually. Calling it does
               not carry any penalty though.

Updated from Jeff Hoogland's tutos
