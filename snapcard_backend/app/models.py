from datetime import datetime, timezone
from sqlalchemy import DateTime, String, Float, Text, Boolean, Integer
from sqlalchemy.orm import Mapped, mapped_column
from app.database import Base

class User(Base):
    __tablename__ = "users"
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(100))
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    notifications_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    price_alerts_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    dark_mode: Mapped[bool] = mapped_column(Boolean, default=True)
    theme_color: Mapped[str] = mapped_column(String(20), default="orange")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

class Card(Base):
    __tablename__ = "cards"
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(100), index=True)
    category: Mapped[str] = mapped_column(String(50), index=True)  # ej: Legendaria, Épica, Rara, Especial, Común
    price: Mapped[float] = mapped_column(Float, default=0.0)
    element_type: Mapped[str] = mapped_column(String(50), default="fuego")  # ej: fuego, agua, planta, electrico, psiquico
    description: Mapped[str] = mapped_column(Text, default="")
    image_url: Mapped[str] = mapped_column(String(255), default="")
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

class UserCollection(Base):
    __tablename__ = "user_collections"
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, index=True)
    card_id: Mapped[int] = mapped_column(Integer, index=True)
    acquired_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

class SupportTicket(Base):
    __tablename__ = "support_tickets"
    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    user_email: Mapped[str] = mapped_column(String(255))
    message: Mapped[str] = mapped_column(Text)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
