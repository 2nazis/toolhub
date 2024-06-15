@echo off
%~d0
CD %~dp0\files
color 03


echo Kevlar Software Fix File
echo.    


net session >nul 2>&1
if %errorLevel% == 0 (
    goto :continue
) else (
    goto :admin
)

:admin
echo.
echo.
echo.
echo.
powershell -Command "Start-Process '%0' -Verb RunAs"
exit

:continue
echo.
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Config" /v VulnerableDriverBlocklistEnable /t REG_DWORD /d 0x000000

bcdedit /set hypervisorlaunchtype off
color 03
echo.
echo.
echo [+] Installing Microsoft Redistrutables 
echo.

start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q

start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb

start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart

start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart

start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart

start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_x64.exe /passive /norestart


start /wait ndp48-x86-x64-allos-enu.exe /passive /norestart
start /wait DXSETUP.exe /silent
color 03
echo [+] Disable Windows Defender and Close
start /wait DefenderControl.exe
echo.
color 0A
echo [+] Please Restart Your Computer Now                    
pause>nul
exit