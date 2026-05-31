# LocalAI EC2 Proof Plan (2026-05-31)

## Scope
Private GitHub proof for LocalAI learning workflow using only AWS profile `amit`.

## Constraints / Hard boundaries
- Do not launch EC2 instances without separate explicit approval.
- No office/GCC/GovTech/IHiS/Synapxe accounts or profiles.
- No GPU always-on workloads.

## Account and tooling
- AWS CLI profile: `amit`
- Validate identity before any AWS action:
  - `aws --profile amit sts get-caller-identity`
- Use private profile only for all checks and commands.

## Build approach
1. Start with low-cost CPU proof.
2. Validate bootstrap and one coding-helper workflow.
3. Only if CPU proof is successful, propose a short bounded GPU proof.

## Instance sizing plan
### CPU proof (mandatory first)
- Prefer `c6i.large` (or `c6i.xlarge` if needed).
- Keep instance off when idle.

### GPU proof (optional, only after CPU pass)
- `g4dn.xlarge` for short bounded evaluation only.
- Stop immediately after test window.

## Storage and path policy
- Local model cache path: `/mnt/ai`.
- Use small GP3 EBS volume for proof workspace.
- Avoid oversized volumes and unnecessary snapshot churn.

## Cost controls (required)
- Apply TTL tag on all resources to force cleanup.
- Add auto-stop or scheduled stop for runtime cap.
- Configure budget alarm and stop threshold.
- Use minimum viable instance run window (hours, not always-on).
- Prefer no public exposure unless needed by test.

## Proof steps
1. Bootstrap environment from repo materials.
2. Run basic validation script + model smoke test.
3. Execute one coding-helper task end-to-end.
4. Capture logs/results under repo evidence path.
5. Stop instance and verify cleanup.

## Success criteria
- Instance bootstrap completes.
- Smoke test executes successfully.
- One coding-helper task completes.
- Evidence/logs recorded with timestamps.
- Cost-control measures active; no lingering compute after test.

## Cleanup and closeout
- Ensure instance is stopped.
- Remove temporary attachments and ephemeral storage if any.
- Commit plan and findings in GitHub repository.
