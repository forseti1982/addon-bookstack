# SwiPay POS PMS (lokale Testumgebung)

Dieses Projekt liefert ein **lokales POS PMS Testsystem** mit:

- Sicherer Datenannahme vom Terminal (API-Key Header)
- Speicherung in SQL Datenbank (SQLite lokal, leicht auf PostgreSQL umstellbar)
- Dashboard zur Sicht auf aggregierte Daten
- Terminal-Simulator (API + CLI)

## Schnellstart lokal

```bash
cd pos-pms
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Danach öffnen:

- Dashboard: `http://127.0.0.1:8000/`
- API Doku: `http://127.0.0.1:8000/docs`

## Sicherheit für Terminal-Upload

Endpoint `POST /api/v1/terminal-data/bulk` verlangt Header:

- `X-Terminal-Key: swipay-dev-terminal-key`

API-Keys können über ENV gesetzt werden:

```bash
export PMS_TERMINAL_API_KEYS="key1,key2,key3"
```

## EP2-Simulation

### 1) Über Dashboard

Button **"Terminal-Simulation starten (ep2 Sample)"** sendet Beispielereignisse
(Heartbeat, Payment, Reversal, Settlement, Diagnostic) ins PMS.

### 2) Über CLI Simulator

```bash
python scripts/terminal_simulator.py
```

Optional:

```bash
python scripts/terminal_simulator.py --url http://127.0.0.1:8000/api/v1/terminal-data/bulk --api-key swipay-dev-terminal-key
```

## Skalierbarkeit

- SQLAlchemy-basierte Persistenz
- Datenmodell mit JSON Payload für flexible EP2 Felder
- Für Produktion: `PMS_DATABASE_URL` auf PostgreSQL setzen, z.B.

```bash
export PMS_DATABASE_URL="postgresql+psycopg://user:pass@localhost:5432/swipay_pms"
```

## Docker Compose

```bash
cd pos-pms
docker compose up
```

## Tests

```bash
cd pos-pms
pytest
```
