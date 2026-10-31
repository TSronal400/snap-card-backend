@echo off
title Snap Card API Backend
cd /d "%~dp0"
echo =========================================
echo    Iniciando Servidor FastAPI Snap Card
echo =========================================
echo.
echo Servidor activo en: http://localhost:8000
echo Documentacion API en: http://localhost:8000/docs
echo.
.venv\Scripts\python.exe -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
pause
