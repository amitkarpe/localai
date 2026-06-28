#!/usr/bin/env python3
"""Local-only regression checks for JSON response sanitizing.

This does not call a model, API, network, or AWS. It protects the automation
path from the known failure mode where a model returns valid JSON wrapped in
Markdown fences.
"""

import json
import re
import sys


def strip_code_fences(text: str) -> str:
    return "\n".join(
        line for line in text.splitlines() if not re.match(r"^\s*```", line)
    ).strip()


CASES = [
    (
        "plain-json",
        '{"task":"healthcheck","status":"ok"}',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "fenced-json",
        '```json\n{"task":"healthcheck","status":"ok"}\n```',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "fenced-no-language",
        '```\n{"task":"healthcheck","status":"ok"}\n```',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "leading-trailing-text-fails",
        'Here is JSON:\n{"task":"healthcheck","status":"ok"}',
        None,
    ),
]


def main() -> int:
    failed = 0
    for name, raw, expected in CASES:
        cleaned = strip_code_fences(raw)
        try:
            parsed = json.loads(cleaned)
        except json.JSONDecodeError:
            parsed = None

        ok = parsed == expected
        status = "PASS" if ok else "FAIL"
        print(f"{name}: {status}")
        if not ok:
            failed += 1

    if failed:
        print(f"result=fail failed={failed}")
        return 1

    print("result=pass")
    return 0


if __name__ == "__main__":
    sys.exit(main())
