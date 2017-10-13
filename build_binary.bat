setlocal EnableDelayedExpansion

@echo off


set TOPLEVEL=%~dp0
set OLDPATH=%path%
set MSYS2_PATH_TYPE=inherit

call "%VS140COMNTOOLS%../../VC/bin/amd64/vcvars64.bat"
if errorlevel 1 exit /b %errorlevel%


start "minttyffmpeg" /B /WAIT %MSYS64%\usr\bin\mintty.exe -l setup_ffmpeg_msvc.log -o daemonize=false -i /msys2.ico /usr/bin/bash --login -c "'%TOPLEVEL%'"/setup_ffmpeg_msvc.sh
if errorlevel 1 exit /b %errorlevel%

set PATH=%OLDPATH%


if exist "%TOPLEVEL%"setup_ffmpeg_msvc.log (
type "%TOPLEVEL%"setup_ffmpeg_msvc.log
del /F /Q "%TOPLEVEL%"setup_ffmpeg_msvc.log
exit /b 1
)

exit /b 0
