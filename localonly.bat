@echo off
setlocal EnableDelayedExpansion

REM <!> This file should be downloaded from within Windows Setup (Shift+F10)
REM <!> If you downloaded this file by going to my.LocalUser.app, you're doing it wrong
REM <!> If you downloaded this file by going to releases on LocalUser.app, you're also doing it wrong

curl -L -o C:\Temp\autounattend.xml https://au.localuser.app || exit /b 1

set "name=ACCOUNTNAMEPH"
set "show=DISPLAYNAMEPH"
set "pass=PASSWORDPH"
set "host=HOSTNAMEPH"
set "comment1=<!--START"
set "comment2=END-->"
set "blank="
echo.
echo WARNING: Using the following in your Username WILL brick your install: /\[]:;^|=,+*?^<^>"
echo WARNING: Using a Username longer than 20 characters WILL brick your install
echo WARNING: Using a Space in your Username MAY cause application issues
echo.

:SetName
set /P newname=Please Enter Username to Use: || set newname=
if "%newname%"=="" (
    echo No Username was specified, defaulting to ADMIN
    echo.
    set newname=admin
)

:SetDisplay
set /P newshow=Please Enter Display Name to Use: || set newshow=
if "%newshow%"=="" (
    echo No DisplayName was specified, defaulting to %newname%
    echo.
    set newshow=%newname%
)   

:SetPass
set /P newpass=Please Enter Password to Use: || set newpass=
if "%newpass%"=="" (
    echo No Password was specified, this is unsafe.
    echo Please Enter "IAmAbsolutelySureIWantABlankPassword" to set a Blank Password
    echo.
    goto SetPass
)
if "%newpass%"=="IAmAbsolutelySureIWantABlankPassword" set newpass=

:SetHost
echo.
echo WARNING: Using the following in your Hostanme WILL brick your install: ,~:!@#$%^^^&'.(){}_
echo WARNING: Using a Hostname longer than 15 characters WILL LIKELY brick your install
echo WARNING: Using a Space in your Hostname WILL brick your install
echo.
set /P newhost=Please Enter Hostname to Use (Blank = Default): || set newhost=

:ApplyUsername
echo Setting Username...
for /F "delims=" %%a in (C:\Temp\test.xml) DO (
    set line=%%a 
    >> C:\Temp\test1.xml echo(!line:%name%=%newname%!
)

:ApplyDisplayName
echo Setting Display Name...
for /F "delims=" %%a in (C:\Temp\test1.xml) DO (
    set line=%%a
    >> C:\Temp\test2.xml echo(!line:%show%=%newshow%!
)

:ApplyPassword
echo Setting Password...
for /F "delims=" %%a in (C:\Temp\test2.xml) DO (
    set line=%%a
    >> C:\Temp\test3.xml echo(!line:%pass%=%newpass%!
)

:ApplyHostname
if "%newhost%"=="" ( 
    move /Y C:\Temp\test3.xml C:\Temp\autounattend.xml >nul
) else (
    echo Setting Hostname...
    for /F "delims=" %%a in (C:\temp\test3.xml) DO (
        set "line=%%a"
        set "line=!line:%comment1%=!"
        echo(!line!>>C:\temp\test4.xml 
    )
    for /F "delims=" %%a in (C:\temp\test4.xml) DO (
        set "line=%%a"
        set "line=!line:%comment2%=!"
        echo(!line!>>C:\temp\test5.xml 
    )
    for /F "delims=" %%a in (C:\temp\test5.xml) DO (
        set line=%%a
        >> C:\temp\test6.xml echo(!line:%host%=%newhost%!
    )
    move /Y C:\Temp\test6.xml C:\Temp\autounattend.xml >nul
    del /Q C:\Temp\test5.xml
    del /Q C:\Temp\test4.xml
    del /Q C:\Temp\test3.xml
)

:FileCleanup
del /Q C:\Temp\test2.xml
del /Q C:\Temp\test1.xml

:Finish
echo.
echo Press Any Key to Reboot and Apply Changes. Do not Reboot Manually.
pause >nul
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\autounattend.xml /reboot
