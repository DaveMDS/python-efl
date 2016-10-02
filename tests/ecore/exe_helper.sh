#!/usr/bin/env python

import time
import sys

delay = float(sys.argv[1])

for i in range(1000):
    print(i)
    sys.stdout.flush()
    time.sleep(delay)

exit(0)

