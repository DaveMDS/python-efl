.. currentmodule:: efl.elementary

Table
#####

.. image:: /images/table-preview.png


Widget description
==================

A container widget to arrange other widgets in a table where items can
span multiple columns or rows - even overlap (and then be raised or
lowered accordingly to adjust stacking if they do overlap).

The row and column count is not fixed. The table widget adjusts itself
when subobjects are added to it dynamically.

The most common way to use a table is::

    table = Table(win)
    table.show()
    table.padding = (space_between_columns, space_between_rows)
    table.pack(table_content_object, x_coord, y_coord, colspan, rowspan)
    table.pack(table_content_object, x_coord, y_coord, colspan, rowspan)
    table.pack(table_content_object, x_coord, y_coord, colspan, rowspan)


Inheritance diagram
===================

.. inheritance-diagram:: Table
    :parts: 2


.. autoclass:: Table
.. autofunction:: table_pack_set
.. autofunction:: table_pack_get
