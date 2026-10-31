# Snap Card API (inicio)

Backend inicial de Snap Card con Python, FastAPI, SQLAlchemy, MySQL, contraseñas con Argon2 y tokens JWT.

## 1. Preparar MySQL

Crea una base de datos y un usuario dedicado (cambia la contraseña):

```sql
CREATE DATABASE snapcard_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'snapcard_user'@'localhost' IDENTIFIED BY 'CAMBIA_ESTA_CLAVE';
GRANT ALL PRIVILEGES ON snapcard_db.* TO 'snapcard_user'@'localhost';
FLUSH PRIVILEGES;
```

## 2. Instalar y configurar

En Linux, desde esta carpeta:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
nano .env
```

En `.env`, configura `DATABASE_URL` con la clave que elegiste. Genera un secreto JWT y ponlo en `JWT_SECRET_KEY`:

```bash
python -c 'import secrets; print(secrets.token_urlsafe(48))'
```

No subas `.env` a GitHub.

## 3. Ejecutar

```bash
uvicorn app.main:app --reload
```

- Estado: http://127.0.0.1:8000/health
- Documentación y pruebas: http://127.0.0.1:8000/docs

## Endpoints incluidos

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/logout` (el cliente también debe borrar el token)
- `GET /me` (requiere `Authorization: Bearer <token>`)

## Siguiente fase

Añadir modelos y endpoints para catálogo, precios e historial, y colección de cada usuario. Luego integrar el catálogo Pokémon TCG y Flutter.

**Nota de seguridad:** este es un punto de partida para desarrollo. El logout actual no revoca un JWT emitido; para invalidación inmediata hay que implementar sesiones/revocación en base de datos. Antes de producción también se deben añadir migraciones, pruebas, límites de intentos y HTTPS.
