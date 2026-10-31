import sys
import os
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select

# Asegurar que sys.path contenga la carpeta raíz del backend para evitar ModuleNotFoundError en Vercel
backend_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app.config import settings
from app.database import Base, engine, SessionLocal
from app import models  # registra los modelos antes de crear tablas
from app.routers import auth, me, cards, ai, settings as settings_router, collection

INITIAL_CARDS = [
    {
        "name": "Charizard Fuego Divino",
        "category": "Legendaria",
        "price": 350.00,
        "element_type": "fuego",
        "description": "Una carta legendaria extremadamente rara envuelta en llamas divinas.",
    },
    {
        "name": "Guardián del Mar",
        "category": "Épica",
        "price": 85.50,
        "element_type": "agua",
        "description": "Protector místico de los océanos profundos.",
    },
    {
        "name": "Bosque Antiguo",
        "category": "Rara",
        "price": 25.00,
        "element_type": "planta",
        "description": "Posee la sabiduría de miles de años de vegetación sagrada.",
    },
    {
        "name": "Tormenta Eléctrica",
        "category": "Épica",
        "price": 110.00,
        "element_type": "electrico",
        "description": "Canaliza relámpagos de alta tensión con poder devastador.",
    },
    {
        "name": "Sombra Nocturna",
        "category": "Rara",
        "price": 45.00,
        "element_type": "psiquico",
        "description": "Emerge del reino de las sombras al caer la noche.",
    },
    {
        "name": "Cristal Mágico",
        "category": "Especial",
        "price": 190.00,
        "element_type": "psiquico",
        "description": "Brilla con un aura mística que multiplica el poder místico.",
    },
    {
        "name": "Pikachu Trueno Dorado",
        "category": "Especial",
        "price": 220.00,
        "element_type": "electrico",
        "description": "Edición especial con aura dorada de alto impacto.",
    },
    {
        "name": "Mewtwo Psíquico Supremo",
        "category": "Legendaria",
        "price": 420.00,
        "element_type": "psiquico",
        "description": "Creado mediante ingeniería genética con fuerza mental ilimitada.",
    },
    {
        "name": "Blastoise Cañón de Agua",
        "category": "Épica",
        "price": 130.00,
        "element_type": "agua",
        "description": "Dispara chorros de agua a alta presión capaces de perforar acero.",
    },
    {
        "name": "Venusaur Flor Ancestral",
        "category": "Épica",
        "price": 95.00,
        "element_type": "planta",
        "description": "Absorbe la luz solar para lanzar ataques solares fulminantes.",
    },
    {
        "name": "Gengar Fantasma Voraz",
        "category": "Rara",
        "price": 75.00,
        "element_type": "psiquico",
        "description": "Acecha en las sombras absorbiendo el calor del ambiente.",
    },
    {
        "name": "Gyarados Furia Marina",
        "category": "Épica",
        "price": 115.00,
        "element_type": "agua",
        "description": "Emerge de las tormentas provocando olas gigantescas.",
    },
]

def seed_cards():
    db = SessionLocal()
    try:
        count = db.scalar(select(models.Card).limit(1))
        if count is None:
            for item in INITIAL_CARDS:
                db.add(models.Card(**item))
            db.commit()
            print("Cartas iniciales creadas exitosamente en la base de datos.")
    except Exception as e:
        print(f"Error sembrando cartas: {e}")
    finally:
        db.close()

@asynccontextmanager
async def lifespan(app: FastAPI):
    try:
        Base.metadata.create_all(bind=engine)
        seed_cards()
    except Exception as e:
        print(f"Error creando tablas en BD: {e}")
    yield

app = FastAPI(title=settings.app_name, version="0.1.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(me.router)
app.include_router(cards.router)
app.include_router(ai.router)
app.include_router(settings_router.router)
app.include_router(collection.router)

@app.get("/", tags=["Sistema"])
def root():
    return {"status": "ok", "service": settings.app_name, "docs": "/docs"}

@app.get("/health", tags=["Sistema"])
def health():
    return {"status": "ok", "service": "snap-card-api"}
