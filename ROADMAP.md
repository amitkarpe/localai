# ROADMAP

## Phase 1
- Define the local AI setup boundary
- Decide what runs locally vs via API
- Keep one clear place for notes and experiments
- Define an explicit MVP with one approved local model and one approval gate.
- Split repo structure so local computer/runtime work and cloud/AWS proof work
  are clearly separated.

## Phase 2
- Add small prompt/evidence workflow
- Add repeatable model comparison notes
- Add cleanup rules for logs and caches
- Keep model benchmark evidence small and reproducible.
- Move cloud proof plans, scripts, and result pointers under `plans/cloud/aws/`
  and related `*/cloud/aws/` paths; keep raw AWS evidence outside the repo
  under `.AGENTS-temp`.

## Phase 3
- Add local dashboard/report flow
- Add long-run watcher/reminder notes
- Keep it KISS and easy to restart
- Add lightweight repo navigation docs after the `local/` vs `cloud/aws/`
  split is stable.
