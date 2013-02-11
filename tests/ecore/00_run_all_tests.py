#!/usr/bin/env python

import unittest


loader = unittest.TestLoader()
suite = loader.discover('.')
runner = unittest.TextTestRunner(verbosity=2)
result = runner.run(suite)
