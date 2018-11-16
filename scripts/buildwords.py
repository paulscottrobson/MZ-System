# *********************************************************************************
# *********************************************************************************
#
#		File:		buildwords.py
#		Purpose:	Build composite assembly file to generate scaffolding code.
#		Date : 		16th November 2018
#		Author:		paul@robsons.org.uk
#
# *********************************************************************************
# *********************************************************************************

import os,re
markerList = ["word","macro","end"]
#
#		Get list of word files.
#
fileList = []
for root,dirs,files in os.walk("source"):
	for f in [x for x in files if x[-6:] == ".words"]:
		fileList.append(root+os.sep+f)
fileList.sort()
#
#		Now process them
#
hOut = open("__words.asm","w")
hOut.write(";\n; Generated.\n;\n")
for f in fileList:
	unclosedWord = None
	for l in [x.rstrip().replace("\t"," ") for x in open(f).readlines()]:
		#print(l)
		#
		#	Look for @<marker> <word>
		#
		if l != "" and l[0] == ";" and l.find("@") >= 0 and l.find("@") < 4:
			m = re.match("^\;\s+\@([\w\.]+)\s*([\w\;\+\-\*\/\.\<\=\>\@\!]*)\s*(.*)$",l)
			assert m is not None,l+" syntax ?"
			marker = m.group(1).lower()
			word = m.group(2).lower()
			protected = m.group(3)
			assert marker in markerList,"Unknown ? "+l
			assert protected == "protected" or protected == "","protect ?"+l
			if protected == "protected":
				marker = marker + "/p"
			#
			#	Starting marker, put label in.
			#
			if marker != "end":
				assert unclosedWord is None,unclosedCleanWord+" not closed ?"
				unclosedWord = word + "::" + marker
				unclosedCleanWord = unclosedWord
				unclosedWord = "_".join(["{0:02x}".format(ord(x)) for x in unclosedWord])
				hOut.write("__mzword_s_"+unclosedWord+":\n")
			#
			#	Ending marker, put label in.
			#
			else:
				assert unclosedWord is not None
				hOut.write("__mzword_e_"+unclosedWord+":\n")
				unclosedWord = None
		hOut.write(l+"\n")
hOut.close()

