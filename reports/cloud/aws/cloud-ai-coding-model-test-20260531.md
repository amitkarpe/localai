# Cloud AI Coding Model Test

Date: 2026-05-31
Issue: https://github.com/amitkarpe/localai/issues/3

## Goal

Run a short EC2-based cloud AI coding-model test and preserve the learning proof
in GitHub.

## Current Status

Status: pending launch approval

`main` has been pushed. This PR records the proposed run shape and will be
updated with results after the EC2 test is explicitly launched and completed.

## Proposed Run

- AWS profile: `amit`
- Region: `ap-southeast-1`
- Instance proposal: `g5.xlarge`
- Model proposal: `qwen2.5-coder:7b-instruct`
- Runtime: Ollama
- Access: SSM only
- Ingress: zero security-group inbound rules
- SSH key: none
- TTL: same-day short test

## Why This Shape

- The previous EC2 proof showed SSM works with a zero-ingress public SSM-only
  path for short personal testing.
- A GPU instance is more appropriate than CPU for a coding-focused model test.
- `qwen2.5-coder:7b-instruct` is small enough for a first cloud coding-model
  test and is available through Ollama.

## Benchmark Prompts To Record

1. Bash bugfix: identify the issue and provide the minimal patch.
2. Python parser: write a tiny parser plus one test case.
3. Terraform review: identify security-group risk in a short snippet.
4. Design choice: compare two implementation approaches and choose one.
5. JSON automation: return only valid JSON for a fixed schema.

## Evidence To Attach After Run

- EC2 instance ID, AMI, type, region, TTL, and final state
- SSM Online proof and command output
- model pull/load proof
- prompt output transcript
- pass/fail score table
- cost/time notes
- cleanup or stop proof

## Launch Gate

Do not launch paid EC2 from this PR until the exact instance type, model, max
runtime, TTL, and cleanup rule are approved.

## References

- Ollama model page: https://ollama.com/library/qwen2.5-coder:7b-instruct
- AWS G5 instance page: https://aws.amazon.com/ec2/instance-types/g5/
