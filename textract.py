#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import re


# первый параметр - <N> head
#head = int(sys.argv[1])
# используется установленный от рута rutermextract

from rutermextract import TermExtractor
extractor = TermExtractor()

spl = re.compile('([\\.\\?\\!\\|])')
phrases = spl.split( sys.stdin.read().decode("utf-8") )
for phrase in phrases:
    terms = extractor(phrase)
    norm = terms[0].normalized.encode("utf-8") if terms else ""
    if norm:
        print(norm+".")
    
    


    