Tutorial 8 - Lists
==================

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
   from efl.elementary.list import List

   from elmextensions import StandardPopup
   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL

   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
   list_items = ["Apples",
               "Bananas",
               "Cookies",
               "Fruit Loops",
               "Milk",
               "Apple Juice",
               "BBQ Sauce",
               "Nesquik",
               "Trail Mix",
               "Chips",
               "Crackers",
               "Cheese",
               "Peanutbutter",
               "Jelly",
               "Ham",
               "Turkey",
               "Potatos",
               "Stuffing",
               "Tomato Sauce",
               "Pineapple",
               "Hot Dog Chili Sauce",
               "Stewed Tomatoes",
               "Creamed Corn",
               "Cream of Mushroom Soup",
               "Peaches",
               "Chilies and Tomatoes",
               "Cream of Chicken Soup",    
               "Cherry Pie Filling",   
               "Canned Beans (various)",
               "Cream of Tomato Soup", 
               "Apple Pie Filling",
               "Canned Peas",
               "Green Beans"
               ]


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex9", "List", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())

           our_list = List(self)
           our_list.size_hint_weight = EXPAND_BOTH
           our_list.callback_activated_add(self.list_item_selected)

           list_items.sort()

           for it in list_items:
               our_list.item_append(it)

           our_list.go()
           our_list.show()

           self.resize_object_add(our_list)

       def list_item_selected(self, our_list, our_item):
           our_popup = StandardPopup(self, "You selected %s"%our_item.text, "ok")
           our_popup.show()

   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()

Searcheable list

.. code:: python

   import efl.elementary as elm
   from efl.elementary.window import StandardWindow

   from elmextensions import SearchableList
   from elmextensions import StandardPopup
   from efl.evas import EVAS_HINT_EXPAND, EVAS_HINT_FILL


   EXPAND_BOTH = EVAS_HINT_EXPAND, EVAS_HINT_EXPAND
   EXPAND_HORIZ = EVAS_HINT_EXPAND, 0.0
   FILL_BOTH = EVAS_HINT_FILL, EVAS_HINT_FILL
   list_items = ["Apples",
               "Bananas",
               "Cookies",
               "Fruit Loops",
               "Milk",
               "Apple Juice",
               "BBQ Sauce",
               "Nesquik",
               "Trail Mix",
               "Chips",
               "Crackers",
               "Cheese",
               "Peanutbutter",
               "Jelly",
               "Ham",
               "Turkey",
               "Potatos",
               "Stuffing",
               "Tomato Sauce",
               "Pineapple",
               "Hot Dog Chili Sauce",
               "Stewed Tomatoes",
               "Creamed Corn",
               "Cream of Mushroom Soup",
               "Peaches",
               "Chilies and Tomatoes",
               "Cream of Chicken Soup",    
               "Cherry Pie Filling",   
               "Canned Beans (various)",
               "Cream of Tomato Soup", 
               "Apple Pie Filling",
               "Canned Peas",
               "Green Beans"
               ]


   class MainWindow(StandardWindow):
       def __init__(self):
           StandardWindow.__init__(self, "ex10", "Searchable List", size=(300, 200))
           self.callback_delete_request_add(lambda o: elm.exit())

           search_list = SearchableList(self)
           search_list.size_hint_weight = EXPAND_BOTH
           search_list.lst.callback_activated_add(self.list_item_selected)

           list_items.sort()

           for it in list_items:
               search_list.item_append(it)

           search_list.show()

           self.resize_object_add(search_list)

       def list_item_selected(self, ourList, our_item):
           our_popup = StandardPopup(self, "You selected %s"%our_item.text, "ok")
           our_popup.show()

   if __name__ == "__main__":
       elm.init()
       gui = MainWindow()
       gui.show()
       elm.run()
