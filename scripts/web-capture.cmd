@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0web-capture.ps1" %*
