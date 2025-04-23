@echo off
cd /d %~dp0
love src 2>&1 | more
pause