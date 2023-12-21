Tutorial 6 - Naviframe
======================

Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0
   '''

   import efl.elementary as elm 
   from efl.elementary.window import StandardWindow 
   from efl.elementary.image import Image 
   from efl.elementary.label import Label 
   from efl.elementary.button import Button 
   from efl.elementary.box import Box 
   from efl.elementary.naviframe import Naviframe  
   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL 

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND 
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0 
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL   

   class MainWindow(StandardWindow):    
       def __init__(self):        
           StandardWindow.__init__(self, "ex7", "Naviframe", size=(300, 200))        
           self.callback_delete_request_add(lambda o: elm.exit())          
           static_image = static_image = Image(self)        
           static_image.size_hint_weight = EXPAND_BOTH        
           static_image.file_set("image.png")        
           static_image.tooltip_text_set("A picture!")        
           static_image.show() 

           our_label = our_label = Label(self)        
           our_label.size_hint_weight = EXPAND_BOTH        
           our_label.text = "Hey look some text!"        
           our_label.show()           

           self.nf = Naviframe(self)        
           self.nf.size_hint_weight = EXPAND_BOTH        
           self.nf.size_hint_align = FILL_BOTH        
           self.nf.show()

           button_one = Button(self)        
           button_one.size_hint_weight = EXPAND_BOTH        
           button_one.text = "Show image"        
           button_one.callback_clicked_add(self.button_pressed, static_image)        
           button_one.show()

           button_two = Button(self)        
           button_two.size_hint_weight = EXPAND_BOTH        
           button_two.text = "Show label"        
           button_two.callback_clicked_add(self.button_pressed, our_label)        
           button_two.show() 

           button_box = Box(self)        
           button_box.size_hint_weight = EXPAND_HORIZ        
           button_box.horizontal_set(True)        
           button_box.pack_end(button_one)        
           button_box.pack_end(button_two)        
           button_box.show()

           main_box = Box(self)        
           main_box.size_hint_weight = EXPAND_BOTH        
           main_box.pack_end(self.nf)        
           main_box.pack_end(button_box)        
           main_box.show()    

           self.nf.item_simple_push(static_image)                
           self.resize_object_add(main_box)            
       def button_pressed(self, btn, our_object):        
           self.nf.item_simple_push(our_object)   

   if __name__ == "__main__":    
       elm.init()    
       gui = MainWindow()    
       gui.show()    
       elm.run()
