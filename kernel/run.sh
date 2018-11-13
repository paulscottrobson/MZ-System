@echo off
sh build.sh
cp ../files/bootloader.sna .
python ../scripts/importmz.py core.mz
wine ../bin/CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna 