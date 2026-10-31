from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.dependencies import get_current_user
from app.models import User, SupportTicket
from app.schemas import SettingsUpdateRequest, UserResponse, SupportRequest, AppInfoResponse

router = APIRouter(tags=["Configuración y Soporte"])

@router.put("/settings", response_model=UserResponse)
def update_settings(data: SettingsUpdateRequest, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if data.notifications_enabled is not None:
        user.notifications_enabled = data.notifications_enabled
    if data.price_alerts_enabled is not None:
        user.price_alerts_enabled = data.price_alerts_enabled
    if data.dark_mode is not None:
        user.dark_mode = data.dark_mode
    if data.theme_color is not None:
        user.theme_color = data.theme_color.strip()

    db.commit()
    db.refresh(user)
    return user

@router.post("/support/ticket", status_code=status.HTTP_201_CREATED)
def submit_support_ticket(data: SupportRequest, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    ticket = SupportTicket(user_email=user.email, message=data.message.strip())
    db.add(ticket)
    db.commit()
    return {"message": "Ticket de soporte enviado correctamente. Te contactaremos pronto."}

@router.get("/app/about", response_model=AppInfoResponse)
def get_app_info():
    return AppInfoResponse(
        app_name="SNAP CARD",
        version="1.0.0+1",
        description="Aplicación móvil profesional para descubrir, escanear, valorar y coleccionar cartas TCG con Inteligencia Artificial.",
        developer="Equipo Snap Card & Ronal",
    )
