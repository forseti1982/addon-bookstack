from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_simulator_and_summary_flow():
    simulate_response = client.post("/api/v1/simulator/push-sample")
    assert simulate_response.status_code == 200
    assert len(simulate_response.json()) == 5

    summary_response = client.get("/api/v1/dashboard/summary")
    assert summary_response.status_code == 200
    body = summary_response.json()
    assert body["total_events"] >= 5
    assert "payment" in body["by_event_type"]


def test_protected_ingestion_requires_api_key():
    response = client.post(
        "/api/v1/terminal-data/bulk",
        json={
            "events": [
                {
                    "terminal_id": "TERM-AT-TEST-01",
                    "merchant_id": "MERCH-900",
                    "event_type": "payment",
                    "amount": 12,
                    "status": "ok",
                    "payload": {},
                }
            ]
        },
    )
    assert response.status_code == 401
