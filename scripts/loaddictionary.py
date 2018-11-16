# *********************************************************************************
# *********************************************************************************
#
#		File:		loaddictionary.py
#		Purpose:	Load kernel dictionary words
#		Date : 		16th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************

from imagelib import *
import re
#
#		Read label file
#
labels = {}
for l in [x.strip().lower() for x in open("boot.img.vice").readlines() if x.strip() != ""]:
	m = re.match("^al\s+c\:([0-9a-f]+)\s+_(.*)$",l)
	assert m is not None,l+" .vice syntax"
	labels[m.group(2).strip()] = int(m.group(1),16)
#
#		Read and process words to be inserted
#
image = MZImage()
words = [x.lower().replace("\t"," ").strip() for x in open("words.txt").readlines() if x.strip() != ""]
words = [x for x in words if (x+"  ")[:2] != "//"]
for w in words:
	w = [x for x in w.split(" ") if x != ""]
	assert w[1] in labels,w[1]+" missing ?"
	#print(w[0],labels[w[1]])
	image.addDictionary(w[0],0x24,labels[w[1]],False)
image.save()