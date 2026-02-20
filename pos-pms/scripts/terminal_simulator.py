#!/usr/bin/env python3
import argparse

import httpx


DEFAULT_PAYLOAD = {
    "events": [
        {
            "terminal_id": "TERM-AT-CLI-01",
            "merchant_id": "MERCH-900",
            "event_type": "payment",
            "currency": "EUR",
            "amount": 11.20,
            "status": "ok",
            "payload": {"ep2_message_type": "financial_request", "card_scheme": "MASTERCARD"},
        },
        {
            "terminal_id": "TERM-AT-CLI-01",
            "merchant_id": "MERCH-900",
            "event_type": "diagnostic",
            "currency": "EUR",
            "amount": 0,
            "status": "ok",
            "payload": {"ep2_message_type": "status", "battery": "good", "network": "online"},
        },
    ]
}


def main() -> None:
    parser = argparse.ArgumentParser(description="Send terminal sample events to PMS")
    parser.add_argument("--url", default="http://127.0.0.1:8000/api/v1/terminal-data/bulk")
    parser.add_argument("--api-key", default="swipay-dev-terminal-key")
    args = parser.parse_args()

    response = httpx.post(args.url, headers={"X-Terminal-Key": args.api_key}, json=DEFAULT_PAYLOAD, timeout=30)
    response.raise_for_status()
    print("Events uploaded:", len(response.json()))


if __name__ == "__main__":
    main()
