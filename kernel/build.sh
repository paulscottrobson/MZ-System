pushd ../bootloader
sh build.sh
popd
#
#	Tidy up
#
rm __words.asm boot.img ../files/boot.img
#
#	Assemble the kernel file.
#
python ../scripts/buildwords.py
zasm -buw kernel.asm -l kernel.lst -o boot.img
#
#	Create the core dictionary.
#
if [ -e boot.img ]
then
	python ../scripts/makedictionary.py
	cp boot.img ../files/boot.img
fi