Set-Location $PSScriptRoot
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Iniciando Servidor FastAPI Snap Card   " -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Servidor activo en: http://localhost:8000" -ForegroundColor Green
Write-Host "Documentacion API en: http://localhost:8000/docs" -ForegroundColor Green
Write-Host ""

& ".\.venv\Scripts\python.exe" -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
