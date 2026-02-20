from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "SwiPay POS PMS"
    database_url: str = "sqlite:///./pos_pms.db"
    terminal_api_keys: str = "swipay-dev-terminal-key"

    model_config = SettingsConfigDict(env_prefix="PMS_", env_file=".env", extra="ignore")


settings = Settings()
