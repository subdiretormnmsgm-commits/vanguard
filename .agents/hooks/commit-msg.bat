@echo off
:: commit-msg.bat -- Wrapper Windows para commit-msg.ps1 (R-02 Loop 34)
powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "%~dp0commit-msg.ps1" "%1"
exit /b %ERRORLEVEL%
