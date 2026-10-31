import sys
import os

# Agregar snapcard_backend al path de importación de Python para Vercel
backend_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "snapcard_backend"))
if backend_path not in sys.path:
    sys.path.insert(0, backend_path)

from app.main import app
