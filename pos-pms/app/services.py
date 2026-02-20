from collections import Counter

from sqlalchemy import func
from sqlalchemy.orm import Session

from .models import TerminalEvent
from .schemas import DashboardSummary, TerminalDataEventIn


def store_events(db: Session, events: list[TerminalDataEventIn]) -> list[TerminalEvent]:
    rows = [
        TerminalEvent(
            terminal_id=event.terminal_id,
            merchant_id=event.merchant_id,
            event_type=event.event_type,
            currency=event.currency,
            amount=event.amount,
            status=event.status,
            payload=event.payload,
        )
        for event in events
    ]
    db.add_all(rows)
    db.commit()
    for row in rows:
        db.refresh(row)
    return rows


def build_summary(db: Session) -> DashboardSummary:
    rows = db.query(TerminalEvent).all()
    total_events = len(rows)
    by_event_type = Counter(row.event_type for row in rows)
    by_terminal = Counter(row.terminal_id for row in rows)
    total_payment_amount = (
        db.query(func.coalesce(func.sum(TerminalEvent.amount), 0.0))
        .filter(TerminalEvent.event_type == "payment")
        .scalar()
    )
    return DashboardSummary(
        total_events=total_events,
        total_payment_amount=float(total_payment_amount or 0.0),
        by_event_type=dict(by_event_type),
        by_terminal=dict(by_terminal),
    )


def sample_ep2_events(terminal_id: str = "TERM-AT-001", merchant_id: str = "MERCH-900") -> list[TerminalDataEventIn]:
    return [
        TerminalDataEventIn(
            terminal_id=terminal_id,
            merchant_id=merchant_id,
            event_type="heartbeat",
            status="ok",
            payload={"firmware": "8.2.0", "network": "online"},
        ),
        TerminalDataEventIn(
            terminal_id=terminal_id,
            merchant_id=merchant_id,
            event_type="payment",
            amount=49.90,
            payload={"ep2_message_type": "financial_request", "card_scheme": "VISA", "approval_code": "AP1234"},
        ),
        TerminalDataEventIn(
            terminal_id=terminal_id,
            merchant_id=merchant_id,
            event_type="reversal",
            amount=49.90,
            status="reversed",
            payload={"ep2_message_type": "reversal", "reference": "TXN-2026-0001"},
        ),
        TerminalDataEventIn(
            terminal_id=terminal_id,
            merchant_id=merchant_id,
            event_type="settlement",
            amount=1299.20,
            payload={"ep2_message_type": "batch_close", "batch_id": "BATCH-42"},
        ),
        TerminalDataEventIn(
            terminal_id=terminal_id,
            merchant_id=merchant_id,
            event_type="diagnostic",
            payload={"ep2_message_type": "status", "printer": "ok", "pinpad": "ok"},
        ),
    ]
