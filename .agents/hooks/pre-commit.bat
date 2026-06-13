@echo off
:: pre-commit.bat -- Wrapper Windows para pre-commit.ps1 (P-146 Loop 34)
:: Instalar: copiar para .git/hooks/pre-commit (sem extensao nao funciona no Windows)
:: O git no Windows chama este .bat que delega ao .ps1
powershell.exe -NonInteractive -ExecutionPolicy Bypass -File "%~dp0pre-commit.ps1"
exit /b %ERRORLEVEL%
