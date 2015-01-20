#
# A simple and stupid Makefile for python-efl.
#
# This is mainly targeted at lazy devlopers (like me) that
# want to type less or do not want to learn the python
# setup syntax.
#
# NOTE: This file is also used to discriminate when we are building from
# stable tarballs (in this case we disable cython by default) or from git
# sources as the Makefile is not distributed.
#
# Usage:
#
# make <cmd>            to build using the default python interpreter
# make <cmd> PY=pythonX to build using the specified python interpreter
#


PY = python


.PHONY: build
build:
	$(PY) setup.py build


.PHONY: install
install:
	$(PY) setup.py install


.PHONY: doc
doc:
	$(PY) setup.py build build_doc


.PHONY: test
test:
	$(PY) setup.py test


.PHONY: clean
clean:
	$(PY) setup.py clean --all


.PHONY: maintaner-clean
maintaner-clean:
	$(PY) setup.py clean --all clean_generated_files

.PHONY: dist
dist:
	$(PY) setup.py sdist --formats=gztar,bztar


