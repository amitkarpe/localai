# AGENTS.md — localai

Purpose: controller workspace for local AI setup, experiments, notes, and review.

Session rule:
- Read `~/.codex/AGENTS.md` first as the global baseline, then apply this
  file as the local workspace override.
- For any new `localai` worker session, ensure this `AGENTS.md` is present and
  loaded before session-level actions.

Rules:
- Keep it short and simple.
- Separate durable docs from logs and scratch files.
- Store durable evidence under `logs/` or `~/.AGENTS-temp/localai-lab/repos/localai/`.
- Keep compatibility artifacts under `~/.AGENTS-temp/localai/` via symlink pointers (`long-term-root`, `long-term-localai`).
- Do not store secrets in this repo.
- Prefer ext4-friendly local files and small, reviewable notes.
- Keep current plan in `PLANS.md`; keep long-range direction in `ROADMAP.md`.

Read order:
1. `AGENTS.md`
2. `README.md`
3. `ROADMAP.md`
4. `PLANS.md`

Active layout:
- `prompts/` for prompt drafts
- `experiments/` for test runs
- `reports/` for browser-ready summaries
- `logs/` for raw output
- `scripts/` for helper commands

Cross-repo shared layout (preferred for durable runtime artifacts and dependency evidence):
- `~/.AGENTS-temp/localai-lab/` is the long-term shared workspace.
- `~/.AGENTS-temp/localai-lab/repos/<repo>/` holds repo-scoped evidence.
- `~/.AGENTS-temp/localai-lab/shared/` holds reusable install/dependency/run assets.

Stop rule:
- If the task grows past a small local change, write the plan first and keep the scope bounded.
