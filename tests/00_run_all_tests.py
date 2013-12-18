#!/usr/bin/env python

import unittest


loader = unittest.TestLoader()
suite = loader.discover('.')
runner = unittest.TextTestRunner(verbosity=1, buffer=True)
result = runner.run(suite)
