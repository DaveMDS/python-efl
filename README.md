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
http://download.enlightenment.org/rel/bindings/python/

To install download and unpack a tarball and run:
```
python setup.py build
python setup.py install --user
or
sudo python setup.py install (for sistem-wide installation)
```

NOTE: due to strange cython+gcc behaviour we highly suggest to build python-efl using clang. If you experience issues using gcc (like memory exhausted or strange compile errors) just use clang in this way:

```
cc=clang python setup.py build
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
Additionally you can generate the documentation yourself from the source code using the following command:
```
  python setup.py build build_doc
```
The HTML generated documentation will be available in the folder: `build/sphinx/html/`

## Some of the projects using Python-EFL (in random order)

| **Project** | **Website** |
| -- | -- |
| **EpyMC** - Media Center | https://github.com/DaveMDS/epymc |
| **Espionage** - D-Bus inspector | https://phab.enlightenment.org/w/projects/espionage/ |
| **Epour** - BitTorrent Client | https://phab.enlightenment.org/w/projects/epour/ |
| **Econnman** - Connman GUI | https://phab.enlightenment.org/w/projects/econnman/ |
| **Eluminance** - Fast photo browser | https://github.com/DaveMDS/eluminance |
| **Egitu** - Git User Interface | https://github.com/DaveMDS/egitu |
| **Edone** - GettingThingsDone  | https://github.com/DaveMDS/edone |
| **Lekha** - PDF viewer | https://github.com/kaihu/lekha |
| **Epack** - Archive extractor | https://github.com/wfx/epack |

... and many more that cannot fit in this short list. If have some code and want it in this list just let us know.

