@echo off
del trojan.tar.gz
cd ..
tar -czvf trojan.tar.gz trojan
move trojan.tar.gz trojan\trojan.tar.gz
