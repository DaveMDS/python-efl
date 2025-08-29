# Python bindings for the EFL

EFL, or the *Enlightenment Foundation Libraries*, is a collection of libraries for handling many common tasks such as data structures, communication, rendering, widgets and more. Read more on the [efl web site](https://www.enlightenment.org/about-efl).

Python-EFL are the python bindings for the whole EFL stack (evas, ecore, edje, emotion, ethumb and elementary). You can use Python-EFL to build a portable GUI application in minutes.

The documentation for Python-EFL is available [here](https://docs.enlightenment.org/python-efl/current/).


## Install from pypi

The last stable release is always available on pypi, and pip is the raccomanded way to install Python-EFL:
```
pip install python-efl
```
The only requirement is to have the EFL already installed on your machine, see [here](https://www.enlightenment.org/docs/distros/start) for install instructions for various linux distro or for building EFL from sources.

NOTE: Currently only sources packages are available on pip, this means that the installation will be quite long as it need to compile all the modules, and that you need a C compiler for installation to work (we highly suggest to use clang as your C compiler). For the next release we have plans to also upload binary packages on pypi, so the installation will be blazing fast and will have zero dependencies!


## Install from released tarballs

All the stable releases of python-efl can always be found at:
https://download.enlightenment.org/rel/bindings/python/

To install download and unpack a tarball and run:
```
python -m build
python -m pip install dist/python-efl-X.Y.Z.whl

or
sudo python -m pip install dist/python-efl-X.Y.Z.whl (for sistem-wide installation)
```

NOTE: due to cython+gcc behaviour we highly suggest to build python-efl using clang, it's twice faster and eat less ram. If you experience issues using gcc (like memory exhausted or strange compile errors) just use clang in this way:

```
CC=clang python -m build
```


## Source repository

If you would like to contribute to Python-EFL and make changes to the Python-EFL code you need to build from **git**. Development take place in the **master** branch, while we backport bugfixes in the release branches. You will find a branch for each released version, branches are named as **python-efl-X.X**.

To build from git you also need to have [Cython](https://cython.org/) installed.

### Main repository
https://git.enlightenment.org/bindings/python/python-efl.git/

### GitHub repository
https://github.com/DaveMDS/python-efl

The GitHub repo has been created to simplify the workflow for people that do
not have a git account in the E repo, and thus improving collaboration. 
Feel free to make pull requests on GitHub.


## Documentation
Documentation for the last stable release can be found [here](https://docs.enlightenment.org/python-efl/current/).

To build the docs for the bindings you need to have Sphinx installed, for
(optional) graphs you need Graphviz, for (optional) Youtube demonstration
videos you need the YouTube module from sphinx contrib repository.
packages: python-sphinx, graphviz, python-pygraphviz, libgv-python

To build the docs run:
```
python -m sphinx doc/ build/docs/
```

The HTML generated documentation will be available in the folder: `build/docs/`

Note: you must have python-efl installed for building the docs, or you will end up with empty documentation.


## Tests and Examples
The tests/ folder contains all the unit tests available, you can run individual
tests or use the 00_run_all_tests.py in each folder or even in the tests/ base
dir to run all the tests at once.

The scripts in examples/ folder must be run by the user as they require
user interaction.


## Some of the projects using Python-EFL (in random order)

| **Project**                         | **Website**                                          |
|-------------------------------------|------------------------------------------------------|
| **EpyMC** - Media Center            | https://github.com/DaveMDS/epymc                     |
| **Espionage** - D-Bus inspector     | https://phab.enlightenment.org/w/projects/espionage/ |
| **Epour** - BitTorrent Client       | https://phab.enlightenment.org/w/projects/epour/     |
| **Eluminance** - Fast photo browser | https://github.com/DaveMDS/eluminance                |
| **Egitu** - Git User Interface      | https://github.com/DaveMDS/egitu                     |
| **Edone** - GettingThingsDone       | https://github.com/DaveMDS/edone                     |
| **Epack** - Archive extractor       | https://github.com/wfx/epack                         |

... and many more that cannot fit in this short list. If have some code and want it in this list just let us know.


## A brief history of Python-EFL

Python-EFL was begun in 2007 by work of Gustavo Sverzut Barbieri and others while working for Nokia on the software project Canola Media Player. The language bindings were initially developed for the individual components of EFL, until merged together in 2013.

He was later joined by Ulisses Furquim Freire da Silva, who together formed the company ProFUSION embedded systems where the developement continued and a new software project called Editje was created, which uses the Python bindings for most of its functionality.

Python-EFL gained many more developers, also at this time an independent application project called EpyMC was created by Davide Andreoli.

In the beginning of the year 2011 the developement was practically halted. In 2012 Davide Andreoli picked up the developement and Kai Huuhko (@kuuko) joined him shortly after. Work at this time was focused on finishing the Python bindings for Elementary, the toolkit library.

In 2013 the individual components were merged together and a new documentation system was implemented, enabling easier access for the end-user developers.

Currently (as in 2025) the bindings are still actively maintained and improved by Davide Andreoli, in his effort to bring to python a powerfull and attractive UI toolkit.
