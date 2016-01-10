.. currentmodule:: efl.elementary

Datetime
########

Widget description
==================

Datetime widget is used to display and input date & time values.

This widget displays date and time as per the **system's locale** settings
(Date includes Day, Month & Year along with the defined separators and Time
includes Hour, Minute & AM/PM fields). Separator for AM/PM field is ignored.

The corresponding Month, AM/PM strings are displayed according to the
system’s language settings.

Datetime format is a combination of LIBC standard characters like "%%d %%b
%%Y %%I : %%M  %%p" which, as a whole represents both Date as well as Time
format.

Elm_datetime supports only the following sub set of libc date format specifiers:

**%%Y** The year as a decimal number including the century (example: 2011).

**%%y** The year as a decimal number without a century (range 00 to 99)

**%%m** The month as a decimal number (range 01 to 12).

**%%b** The abbreviated month name according to the current locale.

**%%B** The full month name according to the current locale.

**%%h** The abbreviated month name according to the current locale(same as %%b).

**%%d** The day of the month as a decimal number (range 01 to 31).

**%%e** The day of the month as a decimal number (range 1 to 31). single
        digits are preceded by a blank.

**%%I** The hour as a decimal number using a 12-hour clock (range 01 to 12).

**%%H** The hour as a decimal number using a 24-hour clock (range 00 to 23).

**%%k** The hour (24-hour clock) as a decimal number (range 0 to 23). single
        digits are preceded by a blank.

**%%l** The hour (12-hour clock) as a decimal number (range 1 to 12); single
        digits are preceded by a blank.

**%%M** The minute as a decimal number (range 00 to 59).

**%%p** Either 'AM' or 'PM' according to the given time value, or the
        corresponding strings for the current locale. Noon is treated as 'PM'
        and midnight as 'AM'

**%%P** Like %p but in lower case: 'am' or 'pm' or a corresponding string for
        the current locale.

**%%c** The preferred date and time representation for the current locale.

**%%x** The preferred date representation for the current locale without the time.

**%%X** The preferred time representation for the current locale without the date.

**%%r** The complete calendar time using the AM/PM format of the current locale.

**%%R** The hour and minute in decimal numbers using the format %H:%M.

**%%T** The time of day in decimal numbers using the format %H:%M:%S.

**%%D** The date using the format %%m/%%d/%%y.

**%%F** The date using the format %%Y-%%m-%%d.


(For more reference on the available **LIBC date format specifiers**,
please visit the link:
http://www.gnu.org/s/hello/manual/libc.html#Formatting-Calendar-Time )

Datetime widget can provide Unicode **separators** in between its fields
except for AM/PM field. A separator can be any **Unicode character**
other than the LIBC standard date format specifiers.

Example: In the format::

    %%b %%d **,** %%y %%H **:** %%M

comma(,) is separator for date field %%d and colon(:) is separator for
hour field %%H.

The default format is a predefined one, based on the system Locale.

Hour format 12hr(1-12) or 24hr(0-23) display can be selected by setting
the corresponding user format.

Datetime supports six fields: Year, Month, Date, Hour, Minute, AM/PM.
Depending on the Datetime module that is loaded, the user can see
different UI to select the individual field values.

The individual fields of Datetime can be arranged in any order according
to the format set by application.

There is a provision to set the visibility of a particular field as TRUE/
FALSE so that **only time/ only date / only required fields** will be
displayed.

Each field is having a default minimum and maximum values just like the
daily calendar information. These min/max values can be modified as per
the application usage.

User can enter the values only in between the range of maximum and
minimum. Apart from these APIs, there is a provision to display only a
limited set of values out of the possible values. APIs to select the
individual field limits are intended for this purpose.

The whole widget is left aligned and its size grows horizontally
depending on the current format and each field's visible/disabled state.

Datetime individual field selection is implemented in a modular style.
Module can be implemented as a Ctxpopup based selection or an ISE based
selection or even a spinner like selection etc.

Datetime Module design
======================

The following functions are expected to be implemented in a Datetime module:

**Field creation**::

     __________                                            __________
    |          |----- obj_hook() ---------------------->>>|          |
    |          |<<<----------------returns Mod_data ------|          |
    | Datetime |_______                                   |          |
    |  widget  |       |Assign module call backs          |  Module  |
    |   base   |<<<____|                                  |          |
    |          |                                          |          |
    |          |----- field_create() ------------------>>>|          |
    |__________|<<<----------------returns field_obj -----|__________|

**Field value setting**::

     __________                                          __________
    |          |                                        |          |
    | Datetime |<<<----------elm_datetime_value_set()---|          |
    |  widget  |                                        |  Module  |
    |   base   |----display_field_value()------------>>>|          |
    |__________|                                        |__________|

**del_hook**::

     __________                                          __________
    |          |                                        |          |
    | Datetime |----obj_unhook()-------------------->>>>|          |
    |  widget  |                                        |  Module  |
    |   base   |         <<<-----frees mod_data---------|          |
    |__________|                                        |__________|

Any module can use the following shared functions that are implemented in
elm_datetime.c:

**field_format_get()** - gives the field format.

**field_limit_get()**  - gives the field minimum, maximum limits.

To enable a module, set the ELM_MODULES environment variable as shown:

**export ELM_MODULES="datetime_input_ctxpopup>datetime/api"**


Emitted signals
===============

- ``changed`` - whenever Datetime field value is changed, this signal is sent.


Enumerations
============

.. _Elm_Datetime_Field_Type:

Datetime fields
---------------

.. data:: ELM_DATETIME_YEAR

    Year

.. data:: ELM_DATETIME_MONTH

    Month

.. data:: ELM_DATETIME_DATE

    Date

.. data:: ELM_DATETIME_HOUR

    Hour

.. data:: ELM_DATETIME_MINUTE

    Minute

.. data:: ELM_DATETIME_AMPM

    Am/Pm


Inheritance diagram
===================

.. inheritance-diagram:: Datetime
    :parts: 2

.. autoclass:: Datetime
