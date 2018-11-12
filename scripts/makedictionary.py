# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makedictionary.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		8th November 2018
#		Purpose :	Create initial dictionary from kernel.lst
#
# ***************************************************************************************
# ***************************************************************************************

import re
from imagelib import *

image = MZImage()
#
#		Read in all the __mzdefine(*) labels
#
labels = {}
for l in [x.lower().strip() for x in open("boot.img.vice").readlines() if x.find("__MZDEFINE") > 0]:
	m = re.match("^al\s*c\:\s*([0-9a-f]+) ___mzdefine_([0-9a-fnd_]+)$",l)
	assert m is not None,l+" syntax"
	assert m.group(2) not in labels,l+" duplicate"
	labels[m.group(2)] = int(m.group(1),16)
#
#		Sort them by address
#
keys = [x for x in labels.keys()]
keys.sort()

#
#		For each key (that's not a macro end)
#
for l in keys:
	if l[-4:] != "_end":
		#
		#		Analyse it
		#
		word = "".join([chr(int(x,16)) for x in l.split("_")])
		#print(word,labels[l])
		#
		#		Add to the physical dictionary in the image
		#
		image.addDictionary(word,image.currentCodePage(),labels[l])
#
#		Write the image out.
#
image.save()

