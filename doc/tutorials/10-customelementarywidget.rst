Tutorial 10 - Custom Elementary Widget
======================================

Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0

   https://www.toolbox.com/tech/operating-systems/blogs/py-efl-tutorial-9-custom-elementary-widgets-020116/
   '''

   import efl.elementary as elm
   from efl.elementary.window import StandardWindow
   from efl.elementary.frame import Frame
   from efl.elementary.image import Image


   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

   class PictureFrame(Frame):
       def __init__(self, parent_widget, ourText=None, image=None, *args, **kwargs):
           Frame.__init__(self, parent_widget, *args, **kwargs)

           self.text = ourText

           self.our_image = Image(self)
           self.our_image.size_hint_weight = EXPAND_BOTH

           if image:
               self.our_image.file_set(image)

           self.content_set(self.our_image)

       def file_set(self, image):
           self.our_image.file_set(image)

   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex12", "Custom Widget", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())

           our_picture_frame = PictureFrame(self)
           our_picture_frame.size_hint_weight = EXPAND_BOTH
           our_picture_frame.text = "A Custom Picture Frame"
           our_picture_frame.file_set("image.png")
           our_picture_frame.show()

           self.resize_object_add(our_picture_frame)

   if __name__ == "__main__":
       elm.init()
       GUI = MainWindow()
       GUI.show()
       elm.run()
       elm.shutdown()
