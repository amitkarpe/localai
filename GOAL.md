# LocalAI Worker Goal

Goal:
- Finalize and lock LocalAI MVP to single-model qwen2.5:1.5b-instruct, run interaction-only comparison against previous options, and return an explicit Go/No-Go + exact next implementation step.

Repo truth:
- /home/dev/git/localai/PLANS.md
- /home/dev/git/localai/ROADMAP.md

Do first:
- create/update evidence note under ~/.AGENTS-temp/localai/mvp-model-decision-20260530/
- keep scope to local-only viability and fit-on-resources only

Rules:
- keep scope bounded to one objective (single approved model path)
- do not add dependency-heavy installs
- storage assumption remains sda4 mounted at /mnt/ai
- no default API fallback; only re-approve if local path fails hard

Success:
- decision output is single-line: Go for day-1 with qwen2.5:1.5b-instruct or No-Go with reason
- one exact next implementation action is recorded

Stop if:
- local runtime cannot start or cannot meet the fixed validation gate
- resource/security risk exceeds day-1 safe envelope

Evidence:
- ~/.AGENTS-temp/localai/mvp-model-decision-20260530/

Stop rule:
- if context rises near 80–85%, finish this bounded confirmation and stop.
