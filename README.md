# localai

Local workspace for AI setup, model experiments, controller notes, and review artifacts.

Current design:
- keep controller truth in `AGENTS.md`, `ROADMAP.md`, and `PLANS.md`
- keep local raw outputs in `logs/local/`
- keep local readable summaries in `reports/local/`
- keep cloud/AWS plans and placeholders under `*/cloud/aws/`
- keep prompts in `prompts/`
- keep durable evidence in `~/.AGENTS-temp/localai-lab/repos/localai/` for long-term reuse across repos.

This repo is meant to stay small and practical.

## Day-1 local app wiring (local-only)

Run local model checks and inference from repo scripts:

- `./scripts/local/localai-day1.sh preflight`
- `./scripts/local/localai-day1.sh probe`
- `./scripts/local/localai-day1.sh run "Your prompt"`
- `./scripts/local/localai-day1.sh run-json '{"task":"healthcheck"}'` (sanitized JSON response helper)

Rules:

- Primary model: `qwen2.5:1.5b-instruct`
- Storage root: `/mnt/ai` on `/dev/sda4`
- Models only: `qwen2.5:1.5b-instruct`
- No default API fallback

Environment:

- `OLLAMA_HOST` default `127.0.0.1:11434`
- `LOCALAI_MODEL_NAME` default `qwen2.5:1.5b-instruct`
- `OLLAMA_MODELS` defaults to `/mnt/ai/ollama-models`

Recommended day-1 command:

```bash
./scripts/local/localai-day1.sh probe
```

This must pass `3/3` before day-1 build proceeds.
