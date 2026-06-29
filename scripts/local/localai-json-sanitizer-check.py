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
    lines = text.splitlines()
    fence_start = -1
    fence_end = -1
    for i, line in enumerate(lines):
        if re.match(r"^\s*```", line):
            if fence_start == -1:
                fence_start = i
            else:
                fence_end = i
                break
    if fence_start != -1 and fence_end != -1:
        return "\n".join(lines[fence_start + 1 : fence_end]).strip()
    return text.strip()


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
        "fenced-with-surrounding-text",
        'Sure, here is the result:\n```json\n{"task":"healthcheck","status":"ok"}\n```\nHope that helps!',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "fenced-leading-text-only",
        'The answer is:\n```\n{"task":"healthcheck","status":"ok"}\n```',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "leading-text-no-fence-fails",
        'Here is JSON:\n{"task":"healthcheck","status":"ok"}',
        None,
    ),
    (
        "whitespace-before-fence",
        '  ```json\n{"task":"healthcheck","status":"ok"}\n  ```',
        {"task": "healthcheck", "status": "ok"},
    ),
    (
        "empty-fence-yields-none",
        '```json\n\n```',
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
