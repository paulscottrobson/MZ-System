# *********************************************************************************
# *********************************************************************************
#
#		File:		buildbootstrap.py
#		Purpose:	Scan build fake kernel to get code sequences for bootstrap
#		Date : 		16th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************

import sys
#
#		Get information out of label file
#
words = {}
for s in [x.strip().lower() for x in open("generate.bin.vice").readlines()]:
	if s.find("___mzword") > 0:
		parts = s.split(" ")
		address = int(parts[1][2:],16)
		eType = parts[2][10]
		name = "".join([chr(int(x,16)) for x in parts[2][12:].split("_")])
		name = name.split("::")
		#print(name,eType,address)
		if name[0] not in words:
			words[name[0]] = { "name":name[0], "type":name[1], "start":None, "end":None }
		if eType == "s":
			words[name[0]]["start"] = address
		else:
			words[name[0]]["end"] = address
#
#		Read in binary which contains the actual code.
#
binary = [x for x in open("generate.bin","rb").read(-1)]
#
#		Use it to generate bootstrap file
#		
wordNames = [x for x in words.keys()]	
wordNames.sort()
hOut = open("bootstrap.mz","w")
for name in wordNames:
	w = words[name]
	#print(name)
	hOut.write("// ============ {0} ({1}) ============\n\n".format(name,w["type"]))
	# 
	#		Make a list of the code bytes and convert to a sequence of numbers and operators
	#
	codeBytes = binary[w["start"] - 0x8000:w["end"] - 0x8000]
	codeItems = " ".join(["${0:02x} c,".format(x) for x in codeBytes])
	#print("\n",name,codeBytes,codeItems,"\n")
	#
	#		It is a word in code.
	#
	if w["type"] == "word":
		codeExec = [x for x in codeItems.split(" ") if x != ""]
		codeExec = " ".join(["{"+x+"}" for x in codeExec])
		hOut.write("{words}\n")
		hOut.write(":{0} {1} \n\n".format(w["name"],codeExec))
	#
	#		It is a generated word, e.g. a macro
	#
	if w["type"][:9] == "generator":
		hOut.write("{macro}\n")
		hOut.write(":{0} {1} {{$C9}} {{c,}}\n".format(w["name"],codeItems))
		if w["type"] != "generator.noexec":
			hOut.write("{words}\n")
			hOut.write(":{0} {0} {{$C9}} {{c,}}\n".format(w["name"]))
		hOut.write("\n")
hOut.close()
