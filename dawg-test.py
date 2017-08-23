#!/usr/bin/env python2.7

 выкинуть

import dawg_python
f = "/usr/local/lib/python2.7/dist-packages/pymorphy2_dicts_ru/data/words.dawg"
d = dawg_python.DAWG().load(f)
for l in d:
    print(l)