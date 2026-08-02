from sqlalchemy.orm import Session

import models
import schemas

from auth import hash_password, verify_password


def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()


def create_user(db: Session, user: schemas.UserCreate):
    new_user = models.User(
        name=user.name,
        email=user.email,
        password=hash_password(user.password)
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


def login_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)

    if not user:
        return None

    if not verify_password(password, user.password):
        return None

    return user
def get_user_profile(db: Session, email: str):
    return get_user_by_email(db, email)

def create_focus_session(
    db: Session,
    user_id: int,
    session: schemas.FocusSessionCreate
):
    new_session = models.FocusSession(
        user_id=user_id,
        duration=session.duration,
        completed=session.completed
    )

    db.add(new_session)
    db.commit()
    db.refresh(new_session)

    return new_session

def get_user_sessions(
    db: Session,
    user_id: int
):
    return (
        db.query(models.FocusSession)
        .filter(models.FocusSession.user_id == user_id)
        .order_by(models.FocusSession.created_at.desc())
        .all()
    )