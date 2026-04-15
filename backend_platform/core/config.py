from pydantic_settings import BaseSettings
from functools import lru_cache

class Settings(BaseSettings):
    # Application
    APP_NAME: str = "SABC Platform"
    APP_VERSION: str = "1.0.0"
    DEBUG: bool = True

    # Base de données
    DB_TYPE: str = "postgres"
    PG_HOST: str = "localhost"
    PG_PORT: str = "5432"
    PG_DATABASE: str = "sabc_packaging"
    PG_USER: str = "postgres"
    PG_PASSWORD: str = ""

    # Sécurité
    SECRET_KEY: str = "change-moi"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 480

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        extra = "ignore"

@lru_cache()
def get_settings() -> Settings:
    return Settings()

settings = get_settings()