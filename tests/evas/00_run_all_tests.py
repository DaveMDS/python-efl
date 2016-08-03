#!/usr/bin/env python

import unittest
import logging

formatter = logging.Formatter("[%(levelname)s] %(name)s (%(filename)s: %(lineno)d) --- %(message)s")
handler = logging.StreamHandler()
handler.setFormatter(formatter)
efllog = logging.getLogger("efl")
efllog.addHandler(handler)
efllog.setLevel(logging.DEBUG)

loader = unittest.TestLoader()
suite = loader.discover('.')
runner = unittest.TextTestRunner(verbosity=2)
result = runner.run(suite)
