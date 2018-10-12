setlocal EnableDelayedExpansion

@echo off


set TOPLEVEL=%~dp0
set OLDPATH=%path%
set MSYS2_PATH_TYPE=inherit

call "%VS140COMNTOOLS%../../VC/bin/amd64/vcvars64.bat"
if errorlevel 1 exit /b %errorlevel%

bash --login -c "'%TOPLEVEL%'"/setup_ffmpeg_msvc.sh
if errorlevel 1 exit /b %errorlevel%

set PATH=%OLDPATH%

exit /b 0
