
Tutorial 1 - Install
====================

Python-efl is the binding for EFL, an awesome and performance-obcessed
set of libraries. EFL stands for Enlightment Foundation Libraries. It
was started for the `Enlightment <https://www.enlightenment.org/>`__
desktop project and developed into a set of libraries. This tutorial
shows how to install python-efl.

Install Instructions
====================

First create a new folder called efl_dev

.. code:: python

   mkdir efl_dev
   cd efl_dev

Then see `EFL
downloads <https://download.enlightenment.org/rel/libs/efl/>`__ and
`Python-EFL <https://download.enlightenment.org/rel/bindings/python/>`__
downloads.

See the version you want is available on both. Let's choose 1.25.0 for
this tutorial

Download and extract both

.. code:: python

   wget https://download.enlightenment.org/rel/libs/efl/efl-1.25.0.tar.xz
   tar xvf efl-1.25.0.tar.xz
   wget https://download.enlightenment.org/rel/bindings/python/python-efl-1.25.0.tar.xz
   tar xvf python-efl-1.25.0.tar.xz

Install EFL
-----------

Now let us install EFL first. Let's install essentials

.. code:: python

   sudo apt install build-essential check meson ninja-build

and dependencies

.. code:: python

   sudo apt install libssl-dev libsystemd-dev libjpeg-dev libglib2.0-dev libgstreamer1.0-dev liblua5.2-dev libfreetype6-dev libfontconfig1-dev libfribidi-dev libavahi-client-dev libharfbuzz-dev libibus-1.0-dev libx11-dev libxext-dev libxrender-dev libgl1-mesa-dev libopenjp2-7-dev libwebp-dev libgif-dev libtiff5-dev libpoppler-dev libpoppler-cpp-dev libspectre-dev libraw-dev librsvg2-dev libudev-dev libmount-dev libdbus-1-dev libpulse-dev libsndfile1-dev libxcursor-dev libxcomposite-dev libxinerama-dev libxrandr-dev libxtst-dev libxss-dev libgstreamer-plugins-base1.0-dev doxygen libscim-dev libxdamage-dev libwebp-dev libunwind-dev

and what i found missing

.. code:: python

   sudo apt install libluajit-5.1-dev

change dir

.. code:: python

   cd efl-1.25.0

Now let us build the project

.. code:: python

   meson build
   ninja -C build
   sudo ninja -C build install

You also have to make some files visible to pkgconfig. One way of doing
this is to open /etc/profile in a text editor as root (using for example
sudo nano /etc/profile) and add the following line to the end:

.. code:: python

   export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

You may also need to refresh your library path to make sure your apps
can find the EFL libraries:

.. code:: python

   sudo ldconfig

Install Python-EFL
------------------

.. code:: python

   cd ../python-efl-1.25.0

Install python3-dev or corresponding. I was using Python3.9 so i did

.. code:: python

   sudo apt install python3.9-dev

also python dbus

.. code:: python

   sudo apt install python-dbus-dev

Then create and activate virtual environment

.. code:: python

   python3.9 -m venv venv
   . venv/bin/activate

Install cython

.. code:: python

   pip install cython

Now build the package

.. code:: python

   python setup.py build

and install

.. code:: python

   python setup.py install

Conclusion
----------

Now if you run pip freeze you should get something similar

.. code:: python

   Cython==0.29.24
   python-efl==1.25.0

refs:

* https://www.enlightenment.org/docs/distros/ubuntu-start.md

* https://git.enlightenment.org/bindings/python/python-efl.git/tree/INSTALL