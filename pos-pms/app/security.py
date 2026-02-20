from fastapi import Header, HTTPException, status

from .config import settings


VALID_KEYS = {value.strip() for value in settings.terminal_api_keys.split(",") if value.strip()}


def verify_terminal_key(x_terminal_key: str = Header(default="")) -> str:
    if x_terminal_key not in VALID_KEYS:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid terminal API key",
        )
    return x_terminal_key
