приостановлено

#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import re
import pymorphy2

morph = pymorphy2.MorphAnalyzer()




# первый параметр - <N> head
#head = int(sys.argv[1])


spl = re.compile('([\\.\\?\\!\\|])')
wordspl = re.compile(u'[^\wабвгдеёжзийклмнопрстуфхцчшщ]',flags=re.IGNORECASE)
phrases = spl.split( sys.stdin.read().decode("utf-8") )
for phrase in phrases:
    words = 


#    terms = extractor(phrase)
#    norm = terms[0].normalized.encode("utf-8") if terms else ""
#    if norm:
#        print(norm+".")
    
    


    