from pydantic import BaseModel, EmailStr
from datetime import datetime

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    id: int
    name: str
    email: EmailStr

    class Config:
        from_attributes = True

class FocusSessionCreate(BaseModel):
    duration: int
    completed: bool = True


class FocusSessionResponse(BaseModel):
    id: int
    user_id: int
    duration: int
    completed: bool
    created_at: datetime

    class Config:
        from_attributes = True