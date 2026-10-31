import os
from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    app_name: str = "Snap Card API"
    database_url: str = "sqlite:///./snapcard.db"
    jwt_secret_key: str = Field(
        default="snapcard_secret_key_dev_mode_38df72983ba019a28bc",
        validation_alias="JWT_SECRET_KEY",
    )
    secret_key: str = Field(
        default="",
        validation_alias="SECRET_KEY",
    )
    jwt_expire_minutes: int = 60
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    def model_post_init(self, __context):
        if self.secret_key:
            self.jwt_secret_key = self.secret_key

        # En Vercel Serverless, el sistema de archivos es de solo lectura excepto /tmp
        if os.getenv("VERCEL") or os.getenv("AWS_LAMBDA_FUNCTION_NAME"):
            if self.database_url == "sqlite:///./snapcard.db" or self.database_url.startswith("sqlite:///./"):
                self.database_url = "sqlite:////tmp/snapcard.db"

settings = Settings()
