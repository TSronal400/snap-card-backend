from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker
from app.config import settings

db_url = settings.database_url

# 1. Convertir postgres:// o postgresql:// a dialecto SQLAlchemy
if db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql+psycopg2://", 1)
elif db_url.startswith("postgresql://") and not db_url.startswith("postgresql+"):
    db_url = db_url.replace("postgresql://", "postgresql+psycopg2://", 1)

# 2. Supabase requiere conexión segura SSL (sslmode=require)
if "supabase" in db_url.lower() or "postgres" in db_url.lower():
    if "sslmode" not in db_url.lower():
        separator = "&" if "?" in db_url else "?"
        db_url = f"{db_url}{separator}sslmode=require"

connect_args = {}
if db_url.startswith("sqlite"):
    connect_args["check_same_thread"] = False

engine = create_engine(db_url, connect_args=connect_args, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

class Base(DeclarativeBase):
    pass

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
