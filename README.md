# Python bindings for EFL


## Stable releases
All the stable releases of python-efl can always be found at:
http://download.enlightenment.org/rel/bindings/python/

To install unpack the tarball and run:
```
python setup.py build
sudo python setup.py install
```

NOTE: due to strange cython+gcc behaviour we highly suggest to build python-efl using clang. If you experience issues using gcc (like memory exhausted or strange compile errors) just use clang in this way:

```
cc=clang python setup.py build
```

## Source repository
Development take place on **git**, in the **master** branch, while we backport bugfixes in the release branches.
You will find a branch for each released version, branches are named as **python-efl-X.X**.

### Main repository
https://git.enlightenment.org/bindings/python/python-efl.git/

### Secondary repository
https://github.com/DaveMDS/python-efl

The GitHub repo has been created to simplify the workflow for people that do
not have a git account in the E repo, and thus improving collaboration. 
Feel free to make pull requests on GitHub.


## Documentation

Documentation for the last stable release can be found at [here](https://docs.enlightenment.org/python-efl/current/).
Additionally you can generate the documentation yourself from the source code using the following command:
```
  python setup.py build build_doc
```


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

