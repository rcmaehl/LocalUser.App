@echo off
setlocal DisableDelayedExpansion

REM curl -L -o C:\Windows\Panther\autounattend.xml https://raw.githubusercontent.com/rcmaehl/LocalUser.app/refs/heads/main/autounattend.xml || exit /b 1

set "name=ACCOUNTNAMEPH"
set "show=DISPLAYNAMEPH"
set "pass=PASSWORDPH"
echo WARNING: Using the following characters will brick your install: /\[]:;^|=,+*?^<^>"
echo WARNING: Using a username longer than 20 characters will brick your install
echo.
set /P newname=Please Enter Username to Use: || set newname=admin
set /P newshow=Please Enter Display Name to Use: || set newshow=admin
set /P newpass=Please Enter Password to Use: || set newpass=password
for /F "delims=" %%a in (C:\Windows\Panther\autounattend.xml) DO (
   set line=%%a
   setlocal EnableDelayedExpansion
   >> C:\Windows\Panther\stage1.xml echo(!line:%name%=%newname%!
   endlocal
)
for /F "delims=" %%a in (C:\Windows\Panther\stage1.xml) DO (
   set line=%%a
   setlocal EnableDelayedExpansion
   >> C:\Windows\Panther\stage2.xml echo(!line:%show%=%newshow%!
   endlocal
)
for /F "delims=" %%a in (C:\Windows\Panther\stage2.xml) DO (
   set line=%%a
   setlocal EnableDelayedExpansion
   >> C:\Windows\Panther\stage3.xml echo(!line:%pass%=%newpass%!
   endlocal
)
move /Y C:\Windows\Panther\stage3.xml C:\Windows\Panther\autounattend.xml >nul
del /Q C:\Windows\Panther\stage1.xml
del /Q C:\Windows\Panther\stage2.xml
