@echo off
rem One-click: compile winutil.ps1 and launch the GUI
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-run.ps1"
if errorlevel 1 pause
