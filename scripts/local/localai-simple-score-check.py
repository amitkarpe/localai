#!/usr/bin/env python3
"""Run 3 fixed prompts against local model and output score."""

import json
import os
import re
import urllib.request
import urllib.error
from datetime import datetime
from pathlib import Path
from subprocess import run, PIPE, CalledProcessError


MODEL_NAME = os.environ.get("MODEL_NAME", os.environ.get("LOCALAI_MODEL_NAME", "qwen2.5:1.5b-instruct"))
OLLAMA_HOST = os.environ.get("OLLAMA_HOST", "127.0.0.1:11434")
OLLAMA_API = f"http://{OLLAMA_HOST}/api/generate"

REPO = Path(__file__).resolve().parents[2]
LOGS = REPO / "logs" / "local"
LOGS.mkdir(parents=True, exist_ok=True)
REPORT_FILE = LOGS / "localai-simple-score-results.md"
COUNT_FILE = LOGS / "localai-simple-score-pass-count.txt"

PROMPTS = [
    {
        "id": 1,
        "prompt": "What is 12 * 13? Answer with only a number.",
        "type": "exact",
        "expected": "156",
    },
    {
        "id": 2,
        "prompt": "Reply with exactly this token and nothing else: READY-FOR-LOCAL",
        "type": "exact",
        "expected": "READY-FOR-LOCAL",
    },
    {
        "id": 3,
        "prompt": "Return only valid JSON: {\"task\":\"healthcheck\",\"status\":\"ok\",\"model\":\"qwen2.5\"}.",
        "type": "json",
        "expected": {"task": "healthcheck", "status": "ok"},
    },
]


def strip_code_fences(text: str) -> str:
    return "\n".join([ln for ln in text.splitlines() if not re.match(r"^\s*```", ln)]).strip()


def preflight() -> bool:
    try:
        run(
            [str(REPO / "scripts/local/localai-day1.sh"), "preflight"],
            cwd=str(REPO),
            check=True,
            text=True,
            capture_output=True,
        )
        return True
    except CalledProcessError as exc:
        print("preflight failed")
        print(exc.stdout or "")
        return False


def ask(prompt: str) -> str:
    payload = json.dumps({"model": MODEL_NAME, "prompt": prompt, "stream": False}).encode("utf-8")
    req = urllib.request.Request(
        OLLAMA_API,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=90) as resp:
        data = json.loads(resp.read().decode("utf-8", errors="replace"))
    return data.get("response", "")


def eval_case(case, response):
    if case["type"] == "exact":
        ok = response.strip() == case["expected"]
        return ok, response.strip()

    body = strip_code_fences(response.strip())
    try:
        parsed = json.loads(body)
    except Exception as exc:
        return False, f"JSON parse failed: {exc}"

    expected = case["expected"]
    for k, v in expected.items():
        if str(parsed.get(k, "")) != str(v):
            return False, f"json mismatch {k}: {parsed.get(k)!r}"
    return True, json.dumps(parsed)


def main():
    if not preflight():
        return 1

    total = 0
    rows = []
    for case in PROMPTS:
        try:
            response = ask(case["prompt"])
        except (urllib.error.URLError, TimeoutError) as exc:
            ok, detail = False, f"request error: {exc}"
        else:
            ok, detail = eval_case(case, response)

        if ok:
            total += 1
            status = "PASS"
        else:
            status = "FAIL"

        rows.append(f"## Prompt {case['id']}\nInput: {case['prompt']}\nResult: {status}\nDetail: {detail}\n")

    text = [
        "# LocalAI simple score check",
        f"Date: {datetime.now().astimezone().isoformat(timespec='seconds')}",
        f"Model: {MODEL_NAME}",
        f"Endpoint: {OLLAMA_API}",
        "",
    ] + rows + [f"Pass count: {total}/3", ""]

    REPORT_FILE.write_text("\n".join(text))
    COUNT_FILE.write_text(f"{total}/3")

    print(f"PASS={total}/3")
    print(f"REPORT_FILE={REPORT_FILE}")
    print(f"COUNT_FILE={COUNT_FILE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
