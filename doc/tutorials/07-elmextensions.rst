Tutorial 7 - Elm Extensions
===========================


Python-EFL is a wrapper around the Enlightenment GUI kit. This series of
tutorials is an update from the original author.

To follow this tutorial, download/clone `this
repo <https://github.com/BodhiDev/python3-elm-extensions>`__ and pip
install it

.. code:: python

   '''
   Abdur-Ramaan Janhangeer
   Updated from Jeff Hoogland's tutos
   for Python3.9 and Python-elf 1.25.0
   '''

   AUTHORS = """
   <br>
   <align=center>
   <hilight>Jeff Hoogland (Jef91)</hilight><br>
   <link><a href=http://www.jeffhoogland.com>Contact</a></link><br><br>
   </align>
   """

   LICENSE = """
   <align=center>
   <hilight>
   GNU GENERAL PUBLIC LICENSE<br>
   Version 3, 29 June 2007<br><br>
   </hilight>
   This program is free software: you can redistribute it and/or modify 
   it under the terms of the GNU General Public License as published by 
   the Free Software Foundation, either version 3 of the License, or 
   (at your option) any later version.<br><br>
   This program is distributed in the hope that it will be useful, 
   but WITHOUT ANY WARRANTY; without even the implied warranty of 
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
   GNU General Public License for more details.<br><br>
   You should have received a copy of the GNU General Public License 
   along with this program. If not, see<br>
   <link><a href=http://www.gnu.org/licenses>http://www.gnu.org/licenses/</a></link>
   </align>
   """

   INFO = """
   <align=center>
   <hilight>Elementary Python Extensions</hilight> are awesome!<br> 
   <br>
   <br>
   </align>
   """
   import efl.elementary as elm
   from efl.elementary.window import StandardWindow
   from efl.elementary.box import Box

   from elmextensions import StandardButton
   from elmextensions import StandardPopup
   from elmextensions import AboutWindow


   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL
   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL

   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex8", "ElmEx - Button and Popup", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())

           our_button = StandardButton(self, "Show Popup", cb_onclick=self.button_pressed)
           our_button.size_hint_weight = EXPAND_HORIZ
           our_button.size_hint_align = FILL_BOTH
           our_button.show()


           main_box = Box(self)
           main_box.size_hint_weight = EXPAND_BOTH
           main_box.size_hint_align = FILL_BOTH
           main_box.pack_end(our_button)
           main_box.show()

           self.resize_object_add(main_box)

       def button_pressed(self, btn):
           ourPopup = StandardPopup(self, "Press OK to close this message.", "ok")
           ourPopup.show()


   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()
