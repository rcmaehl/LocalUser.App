@echo off

REM <!> This file should be downloaded from within Windows Setup (Shift+F10)
REM <!> If you downloaded this file by going to my.LocalUser.app, you're doing it wrong
REM <!> If you downloaded this file by going to releases on LocalUser.app, you're also doing it wrong

setlocal DisableDelayedExpansion

curl -L -o C:\Windows\Panther\autounattend.xml https://au.localuser.app || exit /b 1

set "name=ACCOUNTNAMEPH"
set "show=DISPLAYNAMEPH"
set "pass=PASSWORDPH"
echo.
echo WARNING: Using the following characters will brick your install: /\[]:;^|=,+*?^<^>"
echo WARNING: Using a username longer than 20 characters will brick your install
echo. 
:SetName
set /P newname=Please Enter Username to Use: || set newname=
if "%newname%"="" (
    echo No Username was specified, defaulting to ADMIN
    set newname=admin
)
:SetDisplay
set /P newshow=Please Enter Display Name to Use: || set newshow=
if "%newshow%"="" (
    echo No DisplayName was specified, defaulting to %newname%
    set newshow=%newname%
)   
:SetPass
set /P newpass=Please Enter Password to Use: || set newpass=
if "%newpass%"="" (
    echo No Password was specified, this is unsafe.
    echo Please Enter "IAmAbsolutelySureIWantABlankPassword" to set a Blank Password
    goto SetPass
)
if "%newpass%"="IAmAbsolutelySureIWantABlankPassword" set newpass=

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

echo.
echo Press Any Key to Reboot and Apply Changes
pause >nul
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\autounattend.xml /reboot
