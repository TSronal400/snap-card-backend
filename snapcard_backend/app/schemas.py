from pydantic import BaseModel, ConfigDict, EmailStr, Field
from typing import Optional

class RegisterRequest(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)

class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)

class UserResponse(BaseModel):
    id: int
    name: str
    email: EmailStr
    notifications_enabled: Optional[bool] = True
    price_alerts_enabled: Optional[bool] = True
    dark_mode: Optional[bool] = True
    theme_color: Optional[str] = "orange"
    model_config = ConfigDict(from_attributes=True)

class UserUpdateRequest(BaseModel):
    name: Optional[str] = Field(None, min_length=2, max_length=100)
    email: Optional[EmailStr] = None

class SettingsUpdateRequest(BaseModel):
    notifications_enabled: Optional[bool] = None
    price_alerts_enabled: Optional[bool] = None
    dark_mode: Optional[bool] = None
    theme_color: Optional[str] = None

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse

class CardResponse(BaseModel):
    id: int
    name: str
    category: str
    price: float
    element_type: str
    description: Optional[str] = ""
    image_url: Optional[str] = ""
    model_config = ConfigDict(from_attributes=True)

class CardCreateRequest(BaseModel):
    name: str
    category: str
    price: float
    element_type: str = "fuego"
    description: Optional[str] = ""
    image_url: Optional[str] = ""

class SupportRequest(BaseModel):
    message: str = Field(min_length=5, max_length=1000)

class AppInfoResponse(BaseModel):
    app_name: str
    version: str
    description: str
    developer: str
