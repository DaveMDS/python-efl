Tutorial 4 - Align Hints
========================

Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0
   '''

   import efl.elementary as elm
   from efl.elementary.box import Box
   from efl.elementary.button import Button
   from efl.elementary.window import StandardWindow
   from efl.evas import EVAS_HINT_EXPAND
   from efl.evas import EVAS_HINT_FILL

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex3", "Weight Example", size=(300, 400))
           self.callback_delete_request_add(lambda o: elm.exit())

           our_button = Button(self)
           our_button.size_hint_weight = (0, 0)
           our_button.size_hint_align = FILL_BOTH
           our_button.text = "Button 1"
           our_button.show()

           our_button2 = Button(self)
           our_button2.size_hint_weight = EXPAND_BOTH
           our_button2.size_hint_align = FILL_BOTH
           our_button2.text = "Button 2"
           our_button2.show()

           our_button3 = Button(self)
           our_button3.size_hint_weight = (0, 0.5)
           our_button3.size_hint_align = FILL_BOTH
           our_button3.text = "Button 3"
           our_button3.show()

           our_box = Box(self)
           our_box.size_hint_weight = EXPAND_BOTH
           our_box.pack_end(our_button)
           our_box.pack_end(our_button2)
           our_box.pack_end(our_button3)
           our_box.show()

           self.resize_object_add(our_box)


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()

2nd version

.. code:: python

   import efl.elementary as elm
   from efl.elementary.box import Box
   from efl.elementary.button import Button
   from efl.elementary.window import StandardWindow
   from efl.evas import EVAS_HINT_EXPAND
   from efl.evas import EVAS_HINT_FILL

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex4", "Align Example", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())

           our_button = Button(self)
           our_button.size_hint_weight = EXPAND_BOTH
           our_button.size_hint_align = (0, 0)
           # our_button.size_hint_align = (EVAS_HINT_FILL, 0)
           our_button.text = "Button 1"

           our_button.show()
           our_button2 = Button(self)
           our_button2.size_hint_weight = EXPAND_BOTH
           our_button2.size_hint_align = FILL_BOTH
           our_button2.text = "Button 2"
           our_button2.show()

           our_button3 = Button(self)
           our_button3.size_hint_weight = EXPAND_BOTH
           our_button3.size_hint_align = (1, 1)
           our_button3.text = "Button 3"
           our_button3.show()

           our_box = Box(self)
           our_box.size_hint_weight = EXPAND_BOTH
           our_box.pack_end(our_button)
           our_box.pack_end(our_button2)
           our_box.pack_end(our_button3)
           our_box.show()

           self.resize_object_add(our_box)


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()


