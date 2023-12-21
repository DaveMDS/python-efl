Tutorial 5 - Images
===================


Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0

   Needs one image called image.png
   '''

   import efl.elementary as elm
   from efl.elementary.image import Image
   from efl.elementary.label import Label
   from efl.elementary.window import StandardWindow
   from efl.evas import EVAS_HINT_EXPAND

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex1", "Hello Elementary", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())
           our_image = Image(self)
           our_image.size_hint_weight = EXPAND_BOTH
           our_image.file_set("image.png")
           our_image.tooltip_text_set("A picture!")
           our_image.show()
           self.resize_object_add(our_image)


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()

Select image

.. code:: python

   import os
   import efl.elementary as elm
   from efl.elementary.window import StandardWindow
   from efl.elementary.image import Image
   from efl.elementary.box import Box
   from efl.elementary.fileselector_button import FileselectorButton
   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex6", "Selected Image", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())
           self.our_image = our_image = Image(self)
           our_image.size_hint_weight = EXPAND_BOTH
           our_image.size_hint_align = FILL_BOTH
           our_image.file_set("image.png")
           our_image.tooltip_text_set("A picture!")
           our_image.show()

           our_button = FileselectorButton(self)
           our_button.size_hint_weight = EXPAND_HORIZ
           our_button.text = "Select new Image"
           our_button.callback_file_chosen_add(self.file_selected)
           our_button.show()

           our_box = Box(self)
           our_box.size_hint_weight = EXPAND_BOTH
           our_box.pack_end(our_image)
           our_box.pack_end(our_button)
           our_box.show()
           self.resize_object_add(our_box)

       def file_selected(self, fsb, selected_file):
           if selected_file:
               valid_extensions = [".png", ".jpg", ".gif"]
               file_name, file_extension = os.path.splitext(selected_file)
               if file_extension in valid_extensions:
                   self.our_image.file_set(selected_file)


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()
