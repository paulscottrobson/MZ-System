# *********************************************************************************
# *********************************************************************************
#
#		File:		encode.py
#		Purpose:	Encode and import MZ code
#		Date : 		16th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************
#
#	$81	Blue 	(ignored)
#	$82 Red 	Definition	(Compile a header)
#	$83 Magenta	(ignored)
#	$84 Green	Compile		(Call macro entry if it exists, otherwise compile forth entry/number)
#	$85 Cyan 	(ignored)
# 	$86 Yellow	Execute		(Execute the word in the forth dictionary)
#	$87 White 	Comment 	(Ignored)
#	$A0 		Space character used.
#	$FF 		End of text.
#
#	Input:
#			:x 			definition of x with normal header etc.
#			{word} 		executed word / number
#			other 		compiled word / number
#			converts hexadecimal words to decimal equivalents
# 			// comments
#
import sys,re
from imagelib import *
image = MZImage()
address = 0xC000
paging = 0x400
bootpage = image.bootstrapPage()
print("Loading into bootstrap page ${0:02x}".format(bootpage))
#
#		Erase the page to all $FF
#
for i in range(0xC000,0x10000):
	image.write(bootpage,i,0xFF)
#
#		Work through all source files
#
for f in sys.argv[1:]:
	#
	#		Load
	#
	startAddress = address
	try:
		src = open(f).readlines()
	except:
		print("Can't find "+f)
		sys.exit(0)
	#
	#		Preprocess
	#
	src = [x if x.find("//") < 0 else x[:x.find("//")] for x in src]
	src = [x.replace("\t"," ").strip() for x in src]
	src = " ".join(src)
	#
	#		Do all words
	#
	for word in [x for x in src.split(" ") if x != ""]:
		#
		#		Identify type of word - text -> colour
		#
		wordType = 0x84								# $84 standard compile
		if word[0] == ':':						# $82 standard definition
			wordType = 0x82
			word = word[1:]
		elif word[0] == "{" and word[-1] == "}":	# $86 executable word
			wordType = 0x86
			word = word[1:-1]
		elif word[0] == '$':						# hex constants converted
			if re.match("^\$[0-9A-Fa-f]+$",word) is not None:
				word = str(int(word[1:],16))
		#
		#		Check it fits in a page.
		#
		if int(address/paging) != int((address+len(word)+4	)/paging):
			while address % paging != 0:
				image.write(bootpage,address,0xFF)
				address += 1
		#
		#		Write word out.
		#
		#print("{0:04x} {1} [{2:02x}]".format(address,word,wordType))
		image.write(bootpage,address,wordType)
		address += 1		
		for c in word:
			image.write(bootpage,address,ord(c))
			address += 1		
		image.write(bootpage,address,0xFF)
	print("\t${0:04x} - ${1:04x} {2}".format(startAddress,address,f))
image.save()
