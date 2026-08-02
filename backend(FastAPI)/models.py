from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from datetime import datetime

from database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String, nullable=False)

    email = Column(String, unique=True, index=True, nullable=False)

    password = Column(String, nullable=False)
    sessions = relationship("FocusSession", back_populates="user")

class FocusSession(Base):
    __tablename__ = "focus_sessions"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False
    )

    duration = Column(Integer, nullable=False)

    completed = Column(
        Boolean,
        default=True
    )

    created_at = Column(
        DateTime,
        default=datetime.now
    )

    user = relationship(
        "User",
        back_populates="sessions"
    )