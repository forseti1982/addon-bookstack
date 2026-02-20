from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class TerminalDataEventIn(BaseModel):
    terminal_id: str = Field(..., examples=["TERM-AT-001"])
    merchant_id: str = Field(..., examples=["MERCH-900"])
    event_type: str = Field(..., examples=["payment"])
    currency: str = Field(default="EUR", min_length=3, max_length=3)
    amount: float = Field(default=0.0)
    status: str = Field(default="ok")
    payload: dict[str, Any] = Field(default_factory=dict)


class TerminalDataBulkIn(BaseModel):
    events: list[TerminalDataEventIn]


class TerminalDataEventOut(BaseModel):
    id: int
    terminal_id: str
    merchant_id: str
    event_type: str
    currency: str
    amount: float
    status: str
    payload: dict[str, Any]
    created_at: datetime

    class Config:
        from_attributes = True


class DashboardSummary(BaseModel):
    total_events: int
    total_payment_amount: float
    by_event_type: dict[str, int]
    by_terminal: dict[str, int]
