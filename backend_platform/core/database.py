from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .config import settings

def get_database_url() -> str:
    return (
        f"postgresql://{settings.PG_USER}:{settings.PG_PASSWORD}"
        f"@{settings.PG_HOST}:{settings.PG_PORT}/{settings.PG_DATABASE}"
    )

DATABASE_URL = get_database_url()

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_tables():
    Base.metadata.create_all(bind=engine)