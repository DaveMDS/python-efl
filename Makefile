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


PY = python3


.PHONY: build
build:
	$(PY) setup.py build


.PHONY: install
install:
# .PHONY: uninstall
# uninstall:
# 	$(PY) setup.py uninstall
# 	$(PY) -m pip uninstall python-efl --break-system-packages


.PHONY: doc
doc:
	cd doc; $(PY) -m sphinx . ../build/docs/; cd ..


.PHONY: test
test:
	$(PY) setup.py test


.PHONY: clean
clean:
	$(PY) setup.py clean --all


.PHONY: maintainer-clean
maintainer-clean:
	$(PY) setup.py clean --all clean_generated_files
	rm -rf build/
	rm -rf dist/
	rm -rf python_efl.egg-info/
	rm -f installed_files-*.txt


.PHONY: dist
dist:
	$(PY) setup.py sdist --formats=gztar,xztar
	$(PY) setup.py bdist_wheel
	@cd dist/; for f in `ls *.tar.*` ; do \
	echo Generating sha256 for: $$f ; \
	sha256sum $$f > $$f.sha256; \
	done
