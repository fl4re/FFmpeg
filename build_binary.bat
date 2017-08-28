setlocal EnableDelayedExpansion

@echo off


set TOPLEVEL=%~dp0
set OLDPATH=%path%
set MSYS2_PATH_TYPE=inherit

call "%VS140COMNTOOLS%../../VC/bin/amd64/vcvars64.bat"
if !errorlevel! neq 0 exit /b !errorlevel!
REM first revert the patch if it was already applied previously and redirect stderr to NULL to minimize bogus error output
git apply -R --whitespace=fix %TOPLEVEL%/ffmpeg_msvc2015.patch 2> NUL
git apply --whitespace=fix %TOPLEVEL%/ffmpeg_msvc2015.patch
if !errorlevel! neq 0 exit /b !errorlevel!


start "minttyffmpeg" /B /WAIT %MSYS64%\usr\bin\mintty.exe -o daemonize=false -i /msys2.ico /usr/bin/bash --login -c "'%TOPLEVEL%'"/setup_ffmpeg_msvc.sh
if !errorlevel! neq 0 exit /b !errorlevel!

set PATH=%OLDPATH%

git apply -R --whitespace=fix %TOPLEVEL%/ffmpeg_msvc2015.patch
if !errorlevel! neq 0 exit /b !errorlevel!

if exist "%TOPLEVEL%"setup_ffmpeg_msvc.log (
type "%TOPLEVEL%"setup_ffmpeg_msvc.log
del /F /Q "%TOPLEVEL%"setup_ffmpeg_msvc.log
exit /b 1
)
