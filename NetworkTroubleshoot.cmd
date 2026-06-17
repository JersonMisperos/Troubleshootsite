@echo off
title Network Troubleshoot Toolkit
color 0A
:MENU
cls
echo.
echo ========================================
echo    NETWORK TROUBLESHOOT TOOLKIT
echo ========================================
echo.
echo 1. Show IP Configuration
echo 2. Flush DNS Cache
echo 3. Release IP Address
echo 4. Renew IP Address
echo 5. Reset Winsock
echo 6. Reset TCP/IP Stack
echo 7. Ping Google
echo 8. Network Statistics
echo 9. Open Network Connections
echo 10. Open Wi-Fi Settings
echo 11. Full Network Repair
echo 12. Exit
echo.
echo ========================================
echo.
set /p choice=Select option:


if "%choice%"=="1" goto IPCONFIG
if "%choice%"=="2" goto FLUSHDNS
if "%choice%"=="3" goto RELEASE
if "%choice%"=="4" goto RENEW
if "%choice%"=="5" goto WINSOCK
if "%choice%"=="6" goto TCPIP
if "%choice%"=="7" goto PING
if "%choice%"=="8" goto NETSTAT
if "%choice%"=="9" goto NETCONN
if "%choice%"=="10" goto WIFI
if "%choice%"=="11" goto FULLREPAIR
if "%choice%"=="12" goto EXIT


echo Invalid option! Please try again.
pause
goto MENU


:IPCONFIG
cls
ipconfig /all
echo.
echo Press any key to return to menu...
pause > nul
goto MENU


:FLUSHDNS
cls
echo Flushing DNS Cache...
ipconfig /flushdns
echo.
echo DNS Cache flushed successfully!
pause
goto MENU


:RELEASE
cls
echo Releasing IP Address...
ipconfig /release
echo.
echo IP Address released!
pause
goto MENU


:RENEW
cls
echo Renewing IP Address...
ipconfig /renew
echo.
echo IP Address renewed!
pause
goto MENU


:WINSOCK
cls
echo Resetting Winsock...
netsh winsock reset
echo.
echo Winsock reset complete! Please restart your computer.
pause
goto MENU


:TCPIP
cls
echo Resetting TCP/IP Stack...
netsh int ip reset
echo.
echo TCP/IP Stack reset complete! Please restart your computer.
pause
goto MENU


:PING
cls
echo Pinging Google (8.8.8.8)...
ping -n 4 8.8.8.8
echo.
pause
goto MENU


:NETSTAT
cls
echo Network Statistics:
netstat -ano
echo.
pause
goto MENU


:NETCONN
cls
echo Opening Network Connections...
ncpa.cpl
goto MENU


:WIFI
cls
echo Opening Wi-Fi Settings...
start ms-settings:network-wifi
goto MENU


:FULLREPAIR
cls
echo Starting Full Network Repair...
echo.
echo Step 1: Flushing DNS Cache...
ipconfig /flushdns
echo.
echo Step 2: Releasing IP Address...
ipconfig /release
echo.
echo Step 3: Renewing IP Address...
ipconfig /renew
echo.
echo Step 4: Resetting Winsock...
netsh winsock reset
echo.
echo Step 5: Resetting TCP/IP Stack...
netsh int ip reset
echo.
echo ========================================
echo Full Network Repair Complete!
echo Please restart your computer for changes to take effect.
echo ========================================
pause
goto MENU


:EXIT
cls
echo Goodbye!
timeout /t 1 > nul
exit
