from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session
from app.database import get_db
from app.dependencies import get_current_user
from app.models import User
from app.schemas import RegisterRequest, LoginRequest, TokenResponse, UserResponse
from app.security import hash_password, verify_password, create_access_token

router = APIRouter(prefix="/auth", tags=["Autenticación"])

@router.post("/register", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def register(data: RegisterRequest, db: Session = Depends(get_db)):
    email = data.email.lower()
    if db.scalar(select(User).where(User.email == email)):
        raise HTTPException(status_code=409, detail="Ya existe una cuenta con ese correo")
    user = User(name=data.name.strip(), email=email, password_hash=hash_password(data.password))
    db.add(user)
    db.commit()
    db.refresh(user)
    return TokenResponse(access_token=create_access_token(user.id), user=user)

@router.post("/login", response_model=TokenResponse)
def login(data: LoginRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == data.email.lower()))
    if user is None or not verify_password(data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Correo o contraseña incorrectos")
    return TokenResponse(access_token=create_access_token(user.id), user=user)

@router.post("/logout")
def logout(_user: User = Depends(get_current_user)):
    # JWT stateless: el cliente debe borrar el token. La expiración limita su validez.
    # Para revocación inmediata se añadirá una lista de revocación o sesiones en BD.
    return {"message": "Sesión cerrada. Elimina el token guardado en la aplicación."}
