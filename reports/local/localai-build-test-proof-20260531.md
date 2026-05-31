# LocalAI Build and Test Proof

Date: 2026-05-31

## Purpose

Record the local-first learning path for building and testing a small local AI
runtime.

## Scope

- Runtime: local Ollama
- Approved model: `qwen2.5:1.5b-instruct`
- Storage: `/mnt/ai` backed by `/dev/sda4`
- Policy: no default external API fallback
- Evidence type: local prompts, gate checks, reports, and small scripts

## Build/Test Assets

- Day-1 gate script: `scripts/local/localai-day1.sh`
- Simple scoring script: `scripts/local/localai-simple-score-check.py`
- Local plan: `plans/local/mvp-dependency-and-goal-run-plan.md`
- Local reports: `reports/local/`
- Local ignored raw logs: `logs/local/`

## Prompt Benchmark Proof

The local proof used fixed prompt gates and prompt comparison reports:

- arithmetic exact-answer gate
- one-sentence local-AI utility response
- privacy-risk plus mitigation response
- JSON response sanitation / validation check

Tracked report artifacts:

- `reports/local/localai-simple-score-20260530.html`
- `reports/local/localai-mvp-capability-20260530-20260530-2051.html`
- `reports/local/localai-mvp-decisions-20260530.html`
- `reports/local/localai-mvp-closeout-20260530.md`

## Result

Day-1 local build/test direction is `Go` for `qwen2.5:1.5b-instruct`, subject
to rerunning `./scripts/local/localai-day1.sh probe` before implementation work.

## Next Step

Implement day-1 app wiring for only `qwen2.5:1.5b-instruct`, using the local
scripts as the precheck gate.
