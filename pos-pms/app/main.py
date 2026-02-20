from pathlib import Path

from fastapi import Depends, FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session

from .config import settings
from .database import Base, engine, get_db
from .schemas import DashboardSummary, TerminalDataBulkIn, TerminalDataEventOut
from .security import verify_terminal_key
from .services import build_summary, sample_ep2_events, store_events

Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.app_name, version="0.1.0")
static_dir = Path(__file__).resolve().parent / "static"
app.mount("/static", StaticFiles(directory=static_dir), name="static")


@app.get("/")
def dashboard_index() -> FileResponse:
    return FileResponse(static_dir / "index.html")


@app.post("/api/v1/terminal-data/bulk", response_model=list[TerminalDataEventOut])
def ingest_terminal_events(
    request: TerminalDataBulkIn,
    db: Session = Depends(get_db),
    _api_key: str = Depends(verify_terminal_key),
):
    return store_events(db, request.events)


@app.get("/api/v1/dashboard/summary", response_model=DashboardSummary)
def dashboard_summary(db: Session = Depends(get_db)):
    return build_summary(db)


@app.post("/api/v1/simulator/push-sample", response_model=list[TerminalDataEventOut])
def push_sample_events(
    terminal_id: str = "TERM-AT-001",
    merchant_id: str = "MERCH-900",
    db: Session = Depends(get_db),
):
    events = sample_ep2_events(terminal_id=terminal_id, merchant_id=merchant_id)
    return store_events(db, events)
