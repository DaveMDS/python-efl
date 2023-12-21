Tutorial 3 - Weight Hints 
=========================

Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

Callback demo

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0
   '''

   import efl.elementary as elm
   from efl.elementary.box import Box
   from efl.elementary.button import Button
   from efl.elementary.label import Label
   from efl.elementary.window import StandardWindow
   from efl.evas import EVAS_HINT_EXPAND

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex1", "Good Bye Elementary", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())
           our_label = Label(self)
           our_label.size_hint_weight = EXPAND_BOTH
           our_label.text = "Hello Elementary!"
           our_label.show()

           our_button = Button(self)
           our_button.size_hint_weight = EXPAND_BOTH
           our_button.text = "Good Bye Elementary!"
           our_button.callback_clicked_add(self.button_pressed)
           our_button.show()

           our_box = Box(self)
           our_box.size_hint_weight = EXPAND_BOTH
           our_box.pack_end(our_label)
           our_box.pack_end(our_button)
           our_box.show()

           self.resize_object_add(our_box)

       def button_pressed(self, btn):
           elm.exit()


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()
       elm.shutdown()

