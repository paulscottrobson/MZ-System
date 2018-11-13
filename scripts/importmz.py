# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		importmz.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		10th November 2018
#		Purpose :	MZ Import to Bootstrap
#
# ***************************************************************************************
# ***************************************************************************************

from imagelib import *
import sys
#
#		Open file and get information.
#
image = MZImage()
page = image.bootstrapPage()
address = 0xC000
paging = image.bootstrapPaging()
defWords = image.getDefiningWords()
#
#		Zero the bootstrap page
#
for i in range(0,0x4000):
	image.write(page,i+0xC000,0)
#
#		Work through all the files.
#
for f in sys.argv[1:]:
	print("Importing "+f)
	startAddress = address
	#
	#		Load file and preprocess
	#
	src = [x.replace("\t"," ").strip() for x in open(f).readlines()]
	src = [x if x.find("//") < 0 else x[:x.find("//")].strip() for x in src]
	src = [x for x in " ".join(src).split(" ") if x != ""]
	#
	#		For each word
	#
	for word in src:
		#
		#		Make space if needed
		#
		required = len(word)+3
		if word in defWords:
			required += 32
		if int(address/paging) != int((address+required)/paging):
			#print("-------------")
			while address % paging != 0:
				image.write(page,address,0)
				address += 1
		#
		#		Output the word
		#
		#print("{0:04x} {1} {2}".format(address,word,required))
		for c in " "+word:
			image.write(page,address,ord(c))
			address += 1
		image.write(page,address,0)
	print("\tFrom ${0:04x} to ${1:04x}".format(startAddress,address-1))
#
#		Write out target image.
#
image.save()

