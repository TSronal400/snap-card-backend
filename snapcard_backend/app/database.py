
import ssl

from pathlib import Path
from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker
from app.config import settings

db_url = settings.database_url

# Usar pg8000 para PostgreSQL
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql+pg8000://", 1)
elif db_url.startswith("postgresql://") and not db_url.startswith("postgresql+"):
    db_url = db_url.replace("postgresql://", "postgresql+pg8000://", 1)

connect_args = {}

# Conexión segura SSL para Supabase
if "supabase" in db_url.lower():
    cert_path = Path(__file__).resolve().parent.parent / "supabase-ca.crt"

    connect_args["ssl_context"] = ssl.create_default_context(cafile=str(cert_path))

if db_url.startswith("sqlite"):
    connect_args["check_same_thread"] = False

engine = create_engine(
    db_url,
    connect_args=connect_args,
    pool_pre_ping=True
)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False
)

class Base(DeclarativeBase):
    pass

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
