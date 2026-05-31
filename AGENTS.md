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
- Store local durable evidence under `logs/local/` or `~/.AGENTS-temp/localai-lab/repos/localai/`.
- Keep compatibility artifacts under `~/.AGENTS-temp/localai/` via symlink pointers (`long-term-root`, `long-term-localai`).
- Do not store secrets in this repo.
- Prefer ext4-friendly local files and small, reviewable notes.
- Use `CONTEXT.md` as the current truth / restart state.
- Use `HANDOFF.md` only for explicit handoff or session transfer.
- Treat `PLANS.md` as legacy until Amit approves deletion.
- Keep long-range direction in `ROADMAP.md`.

Read order:
1. `AGENTS.md`
2. `CONTEXT.md`
3. `README.md`
4. `ROADMAP.md`
5. `HANDOFF.md` only when resuming a transfer/milestone

Active layout:
- `prompts/` for prompt drafts
- `experiments/` for test runs
- `reports/local/` for local browser-ready summaries
- `reports/cloud/aws/` for cloud/AWS summary placeholders only
- `logs/local/` for local raw output
- `logs/cloud/aws/` for cloud/AWS placeholders only; raw AWS evidence stays outside the repo
- `scripts/local/` for local helper commands
- `scripts/cloud/aws/` for future cloud/AWS helper commands after approval

Cross-repo shared layout (preferred for durable runtime artifacts and dependency evidence):
- `~/.AGENTS-temp/localai-lab/` is the long-term shared workspace.
- `~/.AGENTS-temp/localai-lab/repos/<repo>/` holds repo-scoped evidence.
- `~/.AGENTS-temp/localai-lab/shared/` holds reusable install/dependency/run assets.

Stop rule:
- If the task grows past a small local change, write the plan first and keep the scope bounded.
