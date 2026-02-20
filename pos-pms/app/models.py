from sqlalchemy import Column, DateTime, Float, Integer, JSON, String
from sqlalchemy.sql import func

from .database import Base


class TerminalEvent(Base):
    __tablename__ = "terminal_events"

    id = Column(Integer, primary_key=True, index=True)
    terminal_id = Column(String(64), index=True, nullable=False)
    merchant_id = Column(String(64), index=True, nullable=False)
    event_type = Column(String(64), index=True, nullable=False)
    currency = Column(String(3), default="EUR", nullable=False)
    amount = Column(Float, default=0.0, nullable=False)
    status = Column(String(32), default="ok", nullable=False)
    payload = Column(JSON, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
