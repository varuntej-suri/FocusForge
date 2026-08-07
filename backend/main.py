from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from security import create_access_token
import models
import schemas
import crud
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from security import verify_access_token

from database import engine, SessionLocal

# Create all database tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="FocusForge API")

security = HTTPBearer(auto_error=True)

# Database Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Home API
@app.get("/")
def home():
    return {
        "message": "Welcome to FocusForge API 🚀"
    }


# Register API
@app.post("/register", response_model=schemas.UserResponse)
def register(
    user: schemas.UserCreate,
    db: Session = Depends(get_db)
):
    existing_user = crud.get_user_by_email(db, user.email)

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )

    return crud.create_user(db, user)
@app.post("/login")
def login(
    user: schemas.UserLogin,
    db: Session = Depends(get_db)
):
    logged_in_user = crud.login_user(
        db,
        user.email,
        user.password
    )

    if not logged_in_user:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    access_token = create_access_token(
    data={
        "sub": logged_in_user.email
    }
)

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": logged_in_user.id,
            "name": logged_in_user.name,
            "email": logged_in_user.email
        }
    }
@app.get("/profile")
def profile(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):

    payload = verify_access_token(credentials.credentials)

    email = payload.get("sub")

    user = crud.get_user_profile(db, email)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return {
        "id": user.id,
        "name": user.name,
        "email": user.email
    }

@app.post(
    "/sessions",
    response_model=schemas.FocusSessionResponse
)
def create_session(
    session: schemas.FocusSessionCreate,
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)

):
    

    payload = verify_access_token(credentials.credentials)

    email = payload.get("sub")

    user = crud.get_user_profile(db, email)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return crud.create_focus_session(
        db,
        user.id,
        session
    )

@app.get(
    "/sessions",
    response_model=list[schemas.FocusSessionResponse]
)
def get_sessions(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):

    payload = verify_access_token(credentials.credentials)

    email = payload.get("sub")

    user = crud.get_user_profile(db, email)

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    return crud.get_user_sessions(
        db,
        user.id
    )

@app.get("/debug-token")
def debug_token(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    return {
        "scheme": credentials.scheme,
        "token": credentials.credentials
    }