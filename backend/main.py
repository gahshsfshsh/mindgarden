"""
ZenFlow API v2.1 - Premium Meditation & Yoga Backend
FastAPI + Vercel Postgres + Stripe + ЮКасса
"""

from fastapi import FastAPI, HTTPException, Depends, status, Query, Request, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.responses import JSONResponse
from pydantic import BaseModel, EmailStr
from typing import List, Optional
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
import os
import json
from dotenv import load_dotenv

# Database
from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime, Text, ForeignKey, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship

# Payments
from payments import YuKassaPayment, StripePayment, SubscriptionManager

load_dotenv()

# ==================== DATABASE CONFIG ====================

DATABASE_URL = os.getenv("POSTGRES_URL", os.getenv("DATABASE_URL", "sqlite:///./zenflow.db"))

if DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

if "sqlite" in DATABASE_URL:
    engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
else:
    engine = create_engine(DATABASE_URL, pool_pre_ping=True, pool_size=5)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


# ==================== DATABASE MODELS ====================

class UserDB(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    name = Column(String(255), nullable=False)
    hashed_password = Column(String(255), nullable=False)
    avatar_url = Column(String(500), nullable=True)
    is_premium = Column(Boolean, default=False)
    subscription_type = Column(String(50), default="free")
    subscription_end = Column(DateTime, nullable=True)
    stripe_customer_id = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    last_login = Column(DateTime, nullable=True)
    
    progress = relationship("ProgressDB", back_populates="user", uselist=False)
    sessions = relationship("SessionDB", back_populates="user")
    moods = relationship("MoodDB", back_populates="user")


class ContentDB(Base):
    __tablename__ = "content"
    
    id = Column(Integer, primary_key=True, index=True)
    type = Column(String(50), nullable=False, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    duration = Column(String(50))
    category = Column(String(100), index=True)
    level = Column(String(50))
    is_premium = Column(Boolean, default=False, index=True)
    audio_url = Column(String(500))
    video_url = Column(String(500))
    thumbnail_url = Column(String(500))
    instructor = Column(String(255))
    benefits = Column(Text)
    tags = Column(Text)
    play_count = Column(Integer, default=0)
    rating = Column(Float, default=5.0)
    created_at = Column(DateTime, default=datetime.utcnow)


class ProgressDB(Base):
    __tablename__ = "progress"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, unique=True)
    total_minutes = Column(Integer, default=0)
    total_sessions = Column(Integer, default=0)
    current_streak = Column(Integer, default=0)
    longest_streak = Column(Integer, default=0)
    last_session_date = Column(String(10))
    weekly_goal = Column(Integer, default=7)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    user = relationship("UserDB", back_populates="progress")


class SessionDB(Base):
    __tablename__ = "sessions"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    content_id = Column(Integer, nullable=False)
    content_type = Column(String(50))
    duration_minutes = Column(Integer, nullable=False)
    completed_at = Column(DateTime, default=datetime.utcnow)
    rating = Column(Integer, nullable=True)
    
    user = relationship("UserDB", back_populates="sessions")


class MoodDB(Base):
    __tablename__ = "moods"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    mood_value = Column(Integer, nullable=False)  # 1-5
    factors = Column(Text)  # JSON array
    note = Column(Text, nullable=True)
    recorded_at = Column(DateTime, default=datetime.utcnow)
    
    user = relationship("UserDB", back_populates="moods")


class AchievementDB(Base):
    __tablename__ = "achievements"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    achievement_id = Column(String(100), nullable=False)
    unlocked_at = Column(DateTime, default=datetime.utcnow)


class PaymentDB(Base):
    __tablename__ = "payments"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    provider = Column(String(50))  # stripe, yukassa
    payment_id = Column(String(255))
    amount = Column(Float)
    currency = Column(String(10))
    status = Column(String(50))
    plan = Column(String(50))
    created_at = Column(DateTime, default=datetime.utcnow)


# Create tables
Base.metadata.create_all(bind=engine)


# ==================== PYDANTIC SCHEMAS ====================

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: str

class UserResponse(BaseModel):
    id: int
    email: str
    name: str
    avatar_url: Optional[str]
    is_premium: bool
    subscription_type: str
    subscription_end: Optional[datetime]
    created_at: datetime
    
    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

class ContentResponse(BaseModel):
    id: int
    type: str
    title: str
    description: Optional[str]
    duration: Optional[str]
    category: Optional[str]
    level: Optional[str]
    is_premium: bool
    audio_url: Optional[str]
    video_url: Optional[str]
    thumbnail_url: Optional[str]
    instructor: Optional[str]
    play_count: int = 0
    rating: float = 5.0
    
    class Config:
        from_attributes = True

class ProgressResponse(BaseModel):
    total_minutes: int
    total_sessions: int
    current_streak: int
    longest_streak: int
    weekly_goal: int = 7

class SessionCreate(BaseModel):
    content_id: int
    duration_minutes: int
    rating: Optional[int] = None

class MoodCreate(BaseModel):
    mood_value: int  # 1-5
    factors: List[str] = []
    note: Optional[str] = None

class MoodResponse(BaseModel):
    id: int
    mood_value: int
    factors: List[str]
    note: Optional[str]
    recorded_at: datetime
    
    class Config:
        from_attributes = True

class PaymentCreate(BaseModel):
    plan: str  # premium, lifetime
    provider: str = "yukassa"  # yukassa, stripe
    return_url: Optional[str] = None


# ==================== APP CONFIG ====================

app = FastAPI(
    title="ZenFlow API",
    description="Premium Meditation & Yoga API with Stripe & ЮКасса payments",
    version="2.1.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:8080",
        "https://zenflow.vercel.app",
        "https://*.vercel.app",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ==================== SECURITY ====================

SECRET_KEY = os.getenv("JWT_SECRET", "zenflow-super-secret-key-change-in-production-2024")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_DAYS = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=ACCESS_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


async def get_current_user(
    token: str = Depends(oauth2_scheme), 
    db: Session = Depends(get_db)
) -> UserDB:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = db.query(UserDB).filter(UserDB.email == email).first()
    if user is None:
        raise credentials_exception
    
    # Check subscription status
    if user.subscription_end and datetime.utcnow() > user.subscription_end:
        user.is_premium = False
        user.subscription_type = "free"
        db.commit()
    
    return user


async def get_optional_user(
    request: Request,
    db: Session = Depends(get_db)
) -> Optional[UserDB]:
    """Get user if authenticated, None otherwise"""
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return None
    try:
        token = auth_header.split(" ")[1]
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        if email:
            return db.query(UserDB).filter(UserDB.email == email).first()
    except:
        pass
    return None


# ==================== ROUTES ====================

@app.get("/")
async def root():
    return {
        "name": "ZenFlow API",
        "version": "2.1.0",
        "status": "🚀 Running",
        "docs": "/docs",
        "features": ["Auth", "Content", "Progress", "Payments", "AI Recommendations"]
    }


@app.get("/health")
async def health():
    return {"status": "healthy", "timestamp": datetime.utcnow().isoformat()}


# ==================== AUTH ====================

@app.post("/api/auth/register", response_model=Token, tags=["Auth"])
async def register(user: UserCreate, db: Session = Depends(get_db)):
    """Регистрация нового пользователя"""
    if db.query(UserDB).filter(UserDB.email == user.email).first():
        raise HTTPException(status_code=400, detail="Email уже зарегистрирован")
    
    new_user = UserDB(
        email=user.email,
        name=user.name,
        hashed_password=get_password_hash(user.password),
        avatar_url=f"https://ui-avatars.com/api/?name={user.name}&background=a855f7&color=fff&size=200"
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    # Create progress record
    progress = ProgressDB(user_id=new_user.id)
    db.add(progress)
    db.commit()
    
    access_token = create_access_token(data={"sub": new_user.email})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": new_user
    }


@app.post("/api/auth/login", response_model=Token, tags=["Auth"])
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    """Вход пользователя"""
    user = db.query(UserDB).filter(UserDB.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Неверный email или пароль"
        )
    
    user.last_login = datetime.utcnow()
    db.commit()
    
    access_token = create_access_token(data={"sub": user.email})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user
    }


@app.get("/api/auth/me", response_model=UserResponse, tags=["Auth"])
async def get_me(current_user: UserDB = Depends(get_current_user)):
    """Текущий пользователь"""
    return current_user


# ==================== CONTENT ====================

@app.get("/api/content", response_model=List[ContentResponse], tags=["Content"])
async def get_content(
    type: Optional[str] = Query(None),
    category: Optional[str] = Query(None),
    level: Optional[str] = Query(None),
    is_premium: Optional[bool] = Query(None),
    search: Optional[str] = Query(None),
    sort: Optional[str] = Query("newest"),  # newest, popular, rating
    limit: int = Query(50, le=200),
    offset: int = Query(0),
    db: Session = Depends(get_db),
    user: Optional[UserDB] = Depends(get_optional_user)
):
    """Получить контент с фильтрами"""
    query = db.query(ContentDB)
    
    if type:
        query = query.filter(ContentDB.type == type)
    if category:
        query = query.filter(ContentDB.category == category)
    if level:
        query = query.filter(ContentDB.level == level)
    if is_premium is not None:
        query = query.filter(ContentDB.is_premium == is_premium)
    if search:
        query = query.filter(ContentDB.title.ilike(f"%{search}%"))
    
    # Sorting
    if sort == "popular":
        query = query.order_by(ContentDB.play_count.desc())
    elif sort == "rating":
        query = query.order_by(ContentDB.rating.desc())
    else:
        query = query.order_by(ContentDB.created_at.desc())
    
    return query.offset(offset).limit(limit).all()


@app.get("/api/content/{content_id}", response_model=ContentResponse, tags=["Content"])
async def get_content_by_id(
    content_id: int,
    db: Session = Depends(get_db)
):
    """Получить контент по ID"""
    content = db.query(ContentDB).filter(ContentDB.id == content_id).first()
    if not content:
        raise HTTPException(status_code=404, detail="Контент не найден")
    return content


@app.post("/api/content/{content_id}/play", tags=["Content"])
async def record_play(
    content_id: int,
    db: Session = Depends(get_db)
):
    """Записать воспроизведение (увеличить счётчик)"""
    content = db.query(ContentDB).filter(ContentDB.id == content_id).first()
    if content:
        content.play_count += 1
        db.commit()
    return {"success": True}


@app.get("/api/content/categories/{type}", tags=["Content"])
async def get_categories(type: str, db: Session = Depends(get_db)):
    """Категории по типу контента"""
    categories = db.query(ContentDB.category).filter(
        ContentDB.type == type,
        ContentDB.category.isnot(None)
    ).distinct().all()
    return [c[0] for c in categories if c[0]]


# ==================== PROGRESS ====================

@app.get("/api/progress", response_model=ProgressResponse, tags=["Progress"])
async def get_progress(
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Прогресс пользователя"""
    progress = db.query(ProgressDB).filter(ProgressDB.user_id == current_user.id).first()
    if not progress:
        progress = ProgressDB(user_id=current_user.id)
        db.add(progress)
        db.commit()
        db.refresh(progress)
    return progress


@app.post("/api/progress/session", tags=["Progress"])
async def complete_session(
    session: SessionCreate,
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Записать сессию"""
    # Get content info
    content = db.query(ContentDB).filter(ContentDB.id == session.content_id).first()
    
    # Create session
    new_session = SessionDB(
        user_id=current_user.id,
        content_id=session.content_id,
        content_type=content.type if content else None,
        duration_minutes=session.duration_minutes,
        rating=session.rating
    )
    db.add(new_session)
    
    # Update progress
    progress = db.query(ProgressDB).filter(ProgressDB.user_id == current_user.id).first()
    if not progress:
        progress = ProgressDB(user_id=current_user.id)
        db.add(progress)
    
    today = datetime.utcnow().strftime("%Y-%m-%d")
    yesterday = (datetime.utcnow() - timedelta(days=1)).strftime("%Y-%m-%d")
    
    # Update streak
    if progress.last_session_date == yesterday:
        progress.current_streak += 1
    elif progress.last_session_date != today:
        progress.current_streak = 1
    
    progress.total_minutes += session.duration_minutes
    progress.total_sessions += 1
    progress.longest_streak = max(progress.longest_streak, progress.current_streak)
    progress.last_session_date = today
    
    # Check achievements
    await check_achievements(current_user.id, progress, db)
    
    db.commit()
    
    return {
        "success": True,
        "streak": progress.current_streak,
        "total_minutes": progress.total_minutes,
        "total_sessions": progress.total_sessions
    }


async def check_achievements(user_id: int, progress: ProgressDB, db: Session):
    """Check and award achievements"""
    achievements_to_check = [
        ("first-session", progress.total_sessions >= 1),
        ("week-streak", progress.current_streak >= 7),
        ("ten-sessions", progress.total_sessions >= 10),
        ("hour-practice", progress.total_minutes >= 60),
        ("month-streak", progress.current_streak >= 30),
        ("fifty-sessions", progress.total_sessions >= 50),
        ("century", progress.total_sessions >= 100),
        ("five-hours", progress.total_minutes >= 300),
    ]
    
    for achievement_id, condition in achievements_to_check:
        if condition:
            existing = db.query(AchievementDB).filter(
                AchievementDB.user_id == user_id,
                AchievementDB.achievement_id == achievement_id
            ).first()
            if not existing:
                db.add(AchievementDB(user_id=user_id, achievement_id=achievement_id))


@app.get("/api/progress/achievements", tags=["Progress"])
async def get_achievements(
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Достижения пользователя"""
    progress = db.query(ProgressDB).filter(ProgressDB.user_id == current_user.id).first()
    unlocked = db.query(AchievementDB).filter(AchievementDB.user_id == current_user.id).all()
    unlocked_ids = {a.achievement_id: a.unlocked_at for a in unlocked}
    
    achievements = [
        {"id": "first-session", "title": "Первый шаг", "description": "Завершите первую практику", "icon": "🎯", "max": 1},
        {"id": "week-streak", "title": "Неделя силы", "description": "7 дней подряд", "icon": "🔥", "max": 7},
        {"id": "ten-sessions", "title": "Упорный практик", "description": "10 практик", "icon": "⭐", "max": 10},
        {"id": "hour-practice", "title": "Час осознанности", "description": "60 минут практики", "icon": "⏰", "max": 60},
        {"id": "month-streak", "title": "Мастер привычки", "description": "30 дней подряд", "icon": "🏆", "max": 30},
        {"id": "fifty-sessions", "title": "Полсотни", "description": "50 практик", "icon": "💎", "max": 50},
        {"id": "century", "title": "Сотня", "description": "100 практик", "icon": "💯", "max": 100},
        {"id": "five-hours", "title": "5 часов дзена", "description": "300 минут практики", "icon": "🧘", "max": 300},
    ]
    
    if progress:
        for a in achievements:
            if a["id"] in ["first-session", "ten-sessions", "fifty-sessions", "century"]:
                a["progress"] = min(progress.total_sessions, a["max"])
            elif a["id"] in ["week-streak", "month-streak"]:
                a["progress"] = min(progress.current_streak, a["max"])
            elif a["id"] in ["hour-practice", "five-hours"]:
                a["progress"] = min(progress.total_minutes, a["max"])
            a["unlocked_at"] = unlocked_ids.get(a["id"])
    
    return achievements


@app.get("/api/progress/history", tags=["Progress"])
async def get_session_history(
    days: int = Query(30, le=365),
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """История сессий за период"""
    since = datetime.utcnow() - timedelta(days=days)
    sessions = db.query(SessionDB).filter(
        SessionDB.user_id == current_user.id,
        SessionDB.completed_at >= since
    ).order_by(SessionDB.completed_at.desc()).all()
    
    return [
        {
            "id": s.id,
            "content_id": s.content_id,
            "content_type": s.content_type,
            "duration_minutes": s.duration_minutes,
            "completed_at": s.completed_at.isoformat(),
            "rating": s.rating
        }
        for s in sessions
    ]


# ==================== MOOD TRACKER ====================

@app.post("/api/mood", response_model=MoodResponse, tags=["Mood"])
async def record_mood(
    mood: MoodCreate,
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Записать настроение"""
    new_mood = MoodDB(
        user_id=current_user.id,
        mood_value=mood.mood_value,
        factors=json.dumps(mood.factors),
        note=mood.note
    )
    db.add(new_mood)
    db.commit()
    db.refresh(new_mood)
    
    return MoodResponse(
        id=new_mood.id,
        mood_value=new_mood.mood_value,
        factors=mood.factors,
        note=new_mood.note,
        recorded_at=new_mood.recorded_at
    )


@app.get("/api/mood/history", tags=["Mood"])
async def get_mood_history(
    days: int = Query(30, le=365),
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """История настроения"""
    since = datetime.utcnow() - timedelta(days=days)
    moods = db.query(MoodDB).filter(
        MoodDB.user_id == current_user.id,
        MoodDB.recorded_at >= since
    ).order_by(MoodDB.recorded_at.desc()).all()
    
    return [
        {
            "id": m.id,
            "mood_value": m.mood_value,
            "factors": json.loads(m.factors) if m.factors else [],
            "note": m.note,
            "recorded_at": m.recorded_at.isoformat()
        }
        for m in moods
    ]


# ==================== PAYMENTS ====================

@app.post("/api/payments/create", tags=["Payments"])
async def create_payment(
    payment: PaymentCreate,
    current_user: UserDB = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Создать платёж (Stripe или ЮКасса)"""
    
    if payment.provider == "yukassa":
        result = await YuKassaPayment.create_subscription(
            user_id=current_user.id,
            plan=payment.plan,
            return_url=payment.return_url
        )
        
        # Save payment record
        db.add(PaymentDB(
            user_id=current_user.id,
            provider="yukassa",
            payment_id=result["payment_id"],
            amount=490 if payment.plan == "premium" else 4990,
            currency="RUB",
            status="pending",
            plan=payment.plan
        ))
        db.commit()
        
        return result
    
    elif payment.provider == "stripe":
        result = await StripePayment.create_checkout_session(
            user_email=current_user.email,
            user_id=current_user.id,
            plan=payment.plan,
            success_url=payment.return_url
        )
        return result
    
    raise HTTPException(status_code=400, detail="Invalid payment provider")


@app.post("/api/payments/webhook/yukassa", tags=["Payments"])
async def yukassa_webhook(request: Request, db: Session = Depends(get_db)):
    """Webhook ЮКассы"""
    body = await request.json()
    
    event_type = body.get("event")
    payment_data = body.get("object", {})
    payment_id = payment_data.get("id")
    
    if event_type == "payment.succeeded":
        metadata = payment_data.get("metadata", {})
        user_id = metadata.get("user_id")
        plan = metadata.get("plan")
        
        if user_id and plan:
            user = db.query(UserDB).filter(UserDB.id == int(user_id)).first()
            if user:
                user.is_premium = True
                user.subscription_type = plan
                user.subscription_end = SubscriptionManager.calculate_subscription_end(plan)
                
                # Update payment status
                payment = db.query(PaymentDB).filter(PaymentDB.payment_id == payment_id).first()
                if payment:
                    payment.status = "succeeded"
                
                db.commit()
    
    return {"status": "ok"}


@app.post("/api/payments/webhook/stripe", tags=["Payments"])
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    """Webhook Stripe"""
    import stripe
    stripe.api_key = os.getenv("STRIPE_SECRET_KEY")
    webhook_secret = os.getenv("STRIPE_WEBHOOK_SECRET")
    
    payload = await request.body()
    sig_header = request.headers.get("stripe-signature")
    
    try:
        event = stripe.Webhook.construct_event(payload, sig_header, webhook_secret)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    
    if event["type"] == "checkout.session.completed":
        session = event["data"]["object"]
        metadata = session.get("metadata", {})
        user_id = metadata.get("user_id")
        plan = metadata.get("plan")
        
        if user_id and plan:
            user = db.query(UserDB).filter(UserDB.id == int(user_id)).first()
            if user:
                user.is_premium = True
                user.subscription_type = plan
                user.subscription_end = SubscriptionManager.calculate_subscription_end(plan)
                user.stripe_customer_id = session.get("customer")
                db.commit()
    
    return {"status": "ok"}


# ==================== AI RECOMMENDATIONS ====================

@app.get("/api/recommendations", response_model=List[ContentResponse], tags=["AI"])
async def get_recommendations(
    limit: int = Query(10, le=20),
    current_user: Optional[UserDB] = Depends(get_optional_user),
    db: Session = Depends(get_db)
):
    """AI-рекомендации на основе времени и истории"""
    hour = datetime.utcnow().hour
    
    # Time-based category selection
    if 5 <= hour < 10:
        preferred_categories = ["Утро", "Утренняя йога", "Энергия"]
        content_type = "meditation"
    elif 10 <= hour < 14:
        preferred_categories = ["Концентрация", "Фокус", "Продуктивность"]
        content_type = "meditation"
    elif 14 <= hour < 18:
        preferred_categories = ["Хатха йога", "Силовая йога", "Виньяса"]
        content_type = "yoga"
    elif 18 <= hour < 21:
        preferred_categories = ["Вечерняя йога", "Релаксация", "Инь йога"]
        content_type = "yoga"
    else:
        preferred_categories = ["Медитация сна", "Природа", "Амбиент"]
        content_type = "sleep"
    
    # Get content
    query = db.query(ContentDB).filter(ContentDB.type == content_type)
    
    # Filter by categories
    query = query.filter(ContentDB.category.in_(preferred_categories))
    
    # If user is not premium, only free content
    if not current_user or not current_user.is_premium:
        query = query.filter(ContentDB.is_premium == False)
    
    results = query.order_by(ContentDB.rating.desc()).limit(limit).all()
    
    # If not enough results, get popular content
    if len(results) < limit:
        additional = db.query(ContentDB).filter(
            ContentDB.type == content_type,
            ContentDB.id.notin_([r.id for r in results])
        )
        if not current_user or not current_user.is_premium:
            additional = additional.filter(ContentDB.is_premium == False)
        additional = additional.order_by(ContentDB.play_count.desc()).limit(limit - len(results)).all()
        results.extend(additional)
    
    return results


# ==================== STARTUP ====================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
