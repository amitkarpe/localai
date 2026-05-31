# CONTEXT.md

Updated: 2026-05-31 14:59 SGT

## Current truth

- `localai` is the worker/execution repo for personal local AI experiments.
- `boss` is the controller repo for this lane.
- Office/GCC context is out of scope unless Amit explicitly says otherwise.
- Personal AWS profile is `amit`; never run `aws sso login`.
- Current context model:
  - `AGENTS.md` = stable rules
  - `CONTEXT.md` = current truth / restart state
  - `HANDOFF.md` = explicit transfer snapshot only when requested
  - `PLANS.md` = legacy until Amit approves deletion

## Current status

- Repo split commit:
  - `e0b31e4 Reorganize localai repo structure`
- Current cleanup focus:
  - keep restart truth in `CONTEXT.md`
  - keep stable repo rules in `AGENTS.md`
  - leave transient worker goals out of commits unless they become stable truth
- Evidence root:
  - `/home/dev/.AGENTS-temp/localai-lab/repos/localai/`
- Done marker:
  - `/home/dev/.AGENTS-temp/localai-lab/inbox/localai.done`

## Read first

1. `AGENTS.md`
2. `CONTEXT.md`
3. `GOAL.md` when executing the active worker goal
4. `README.md`
5. `ROADMAP.md`

## No-go

- Do not mutate AWS unless Amit approves the exact run.
- Do not use office AWS profiles.
- Do not store secrets or raw AWS evidence in this repo.
- Do not delete `PLANS.md` until Amit approves cleanup.
