@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

echo [+] updating the local time...
echo            # starting time service
sc start "W32Time" > NUL
timeout 10 /nobreak > NUL 
echo            # updating time
w32tm /resync
timeout 1 /nobreak > NUL 
echo.
echo.
echo [+] disabling internet explorer proxy
netsh winhttp reset proxy
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
echo.
echo.
echo disabling intel network debugging driver
rename C:\Windows\System32\drivers\iqvw64e.sys C:\Windows\System32\drivers\iqvw64e_.sys > NUL 2>&1
echo.
echo.
echo [+] disabling HyperV
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios /v HypervisorEnforcedCodeIntegrity /t REG_DWORD /d 0 /f
bcdedit /set hypervisorlaunchtype off
echo N | DISM /Online /Disable-Feature /FeatureName:Microsoft-Hyper-V

start winver.exe
pause