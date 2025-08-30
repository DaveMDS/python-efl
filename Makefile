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
CC = clang


.PHONY: build
build:
	CC=$(CC) $(PY) -m build


.PHONY: dist
dist:
	CC=$(CC) $(PY) -m build --sdist
	@cd dist/; for f in `ls *.tar.*` ; do \
	echo Generating sha256 for: $$f ; \
	sha256sum $$f > $$f.sha256; \
	done


.PHONY: install
install:
	CC=$(CC) $(PY) -m pip install . --verbose


.PHONY: uninstall
uninstall:
	$(PY) -m pip uninstall python-efl


.PHONY: doc
doc:
	$(PY) -m sphinx doc/ build/docs/


.PHONY: test
test:
	$(PY) -m unittest discover tests/ --verbose


.PHONY: clean
clean:
	find -type f -name "*.c" ! -name "e_dbus.c" -exec rm -r {} \;
	find -type d -name "__pycache__" -exec rm -r {} \;
	rm -rf build/
	rm -rf dist/
	rm -rf src/python_efl.egg-info/
