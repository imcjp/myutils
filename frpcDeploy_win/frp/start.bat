@echo off
cd 0.53.2
:home
frpc.exe -c frpc.toml
goto home