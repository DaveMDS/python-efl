#
# A simple and stupid Makefile for python-efl.
#
# This is mainly targeted at lazy devlopers (like me) that
# want to type less or do not want to learn the python
# setup syntax.
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


.PHONY: tests
tests:
	$(PY) tests/00_run_all_tests.py


.PHONY: clean
clean:
	$(PY) setup.py clean --all


.PHONY: maintaner-clean
maintaner-clean:
	$(PY) setup.py clean --all clean_generated_files

.PHONY: dist
dist:
	$(PY) setup.py sdist --formats=gztar,bztar


