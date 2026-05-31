# PLANS

## Active
- Go for day-1 build with local-only `qwen2.5:1.5b-instruct` after bootstrapped validation.
- Keep one approved model target only on `/mnt/ai` (backed by `/dev/sda4`).
- Keep no-default-API policy: no automatic external fallback.
- Keep the strict 3-prompt validation gate: today passed 3/3.
- Day-1 runbook is implemented in `scripts/localai-day1.sh` (preflight + probe + infer).
- Day-1 capability check was re-run with fresh logs and remains Go on: `/home/dev/git/localai/logs/localai-capability-results-20260530.md`.

## Next
- EC2 approval lane executed: instance created/verified i-0eb1c58004c079f30; evidence in /home/dev/.AGENTS-temp/localai-lab/repos/localai/ec2-proof-20260531/.
- Implement day-1 app wiring for `qwen2.5:1.5b-instruct` only.
- Capture day-1 runtime hygiene: mount verify, service health check, model inventory, and periodic run logs under `/home/dev/.AGENTS-temp/localai-lab`.
- Report web review decision via `http://192.168.0.9/localai/localai-mvp-decisions-20260530.html`.
- Next: run `./scripts/localai-day1.sh probe` as the execution precheck for all future local runs.
- Approved backup note: only manual failover allowed to another local model after re-approval (example candidate `qwen2.5:0.5b-instruct`); no automatic API fallback.
