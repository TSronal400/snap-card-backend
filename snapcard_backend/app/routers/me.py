from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.dependencies import get_current_user
from app.models import User
from app.schemas import UserResponse, UserUpdateRequest

router = APIRouter(tags=["Usuario"])

@router.get("/me", response_model=UserResponse)
def get_profile(user: User = Depends(get_current_user)):
    return user

@router.put("/me", response_model=UserResponse)
def update_profile(data: UserUpdateRequest, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if data.name is not None:
        user.name = data.name.strip()
    if data.email is not None:
        email = data.email.strip().lower()
        existing = db.query(User).filter(User.email == email, User.id != user.id).first()
        if existing:
            raise HTTPException(status_code=409, detail="El correo ya está en uso por otra cuenta")
        user.email = email

    db.commit()
    db.refresh(user)
    return user
