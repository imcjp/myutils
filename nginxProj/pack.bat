@echo off
del nginxProj.tar.gz
cd ..
tar -czvf nginxProj.tar.gz nginxProj
move nginxProj.tar.gz nginxProj\nginxProj.tar.gz
