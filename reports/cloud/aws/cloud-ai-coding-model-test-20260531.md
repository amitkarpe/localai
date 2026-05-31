# Cloud AI Coding Model Test

Date: 2026-05-31
Issue: https://github.com/amitkarpe/localai/issues/3

## Goal

Run a short EC2-based cloud AI coding-model test and preserve the learning proof
in GitHub.

## Current Status

Status: completed and stopped

`main` has been pushed. This PR records the proposed run shape and will be
updated with results after the EC2 test is explicitly launched and completed.

Update after approval request:

- Approved shape was `g5.xlarge`, `qwen2.5-coder:7b-instruct`, max 2 hours,
  TTL `01-06-26`, stop after test.
- AWS EC2 API in `ap-southeast-1` returned `InvalidInstanceType` for
  `g5.xlarge`.
- Available nearby GPU options found in this account/region:
  - `g4dn.xlarge`: 4 vCPU, 16 GiB RAM, NVIDIA T4 16 GiB
  - `g4dn.2xlarge`: 8 vCPU, 32 GiB RAM, NVIDIA T4 16 GiB
- No EC2 instance was launched because the exact approved instance type is not
  available.

Final run after substitute approval:

- Approved substitute: `g4dn.xlarge`, `qwen2.5-coder:7b-instruct`, max 2
  hours, TTL `01-06-26`, stop after test.
- Instance: `i-0d02137145786faab`
- Name: `localai-cloud-coder-g4dn-20260531`
- AMI: `ami-0e415afa8e100f3f1` - Deep Learning Base OSS Nvidia Driver GPU AMI
  Ubuntu 22.04, 20260529
- Instance type: `g4dn.xlarge`
- GPU: NVIDIA Tesla T4, 16 GiB
- Public IPv4 during run: `18.141.234.160`
- Final state: stopped
- Final public IP: none
- Security group: `sg-08c18dc79595d6cb7`, zero ingress, HTTPS egress only
- SSM command IDs:
  - setup/benchmark first attempt: `8a32e763-72d1-47b9-9c25-e7cf2c39e108`
  - setup/benchmark retry: `fd99b0d6-6218-4742-b07f-8e7e05d21f2a`
  - artifact collection: `08b1fccb-2acc-4afa-b1ad-6ec7228ef4aa`

First attempt note:

- Ollama installed, but SSM had no `HOME` environment value and `ollama serve`
  failed with `$HOME is not defined`.
- Retry set `HOME=/root` and completed the model pull and benchmark.

## Proposed Run

- AWS profile: `amit`
- Region: `ap-southeast-1`
- Instance proposal: `g5.xlarge` originally; executed substitute `g4dn.xlarge`
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

## Benchmark Result

Model: `qwen2.5-coder:7b-instruct`

| Prompt | Result | Seconds | Notes |
|---|---:|---:|---|
| Bash bugfix | PASS | 75.46 | Found command-substitution/word-splitting bug and gave quoted glob loop fix. |
| Python parser | PASS | 4.31 | Returned concise parser and assert, but used a questionable walrus pattern. |
| Terraform SG review | PASS | 13.01 | Correctly flagged `0.0.0.0/0` SSH risk and suggested restricted CIDR. |
| SSM vs SSH design choice | PASS | 3.51 | Compared both paths, but did not clearly choose one despite prompt wording. |
| JSON-only automation | FAIL | 1.29 | Returned JSON inside Markdown fences, so strict JSON parsing failed. |

Strict JSON retry also failed because the model again wrapped JSON in Markdown
fences. This is useful evidence: automation should either sanitize fences or use
a stronger structured-output wrapper for this model.

GPU proof:

- `nvidia-smi` showed the Ollama process using about 4.8 GiB of GPU memory.
- `ollama ps` reported `qwen2.5-coder:7b-instruct` running with `100% GPU`.

## Evidence To Attach After Run

- EC2 instance ID, AMI, type, region, TTL, and final state
- SSM Online proof and command output
- model pull/load proof
- prompt output transcript
- pass/fail score table
- cost/time notes
- cleanup or stop proof

Evidence saved outside the repo:

- `/home/dev/.AGENTS-temp/localai-lab/repos/localai/cloud-coding-test-20260531/`

## Launch Gate

Launch completed and the instance was stopped after the test.

## References

- Ollama model page: https://ollama.com/library/qwen2.5-coder:7b-instruct
- AWS G5 instance page: https://aws.amazon.com/ec2/instance-types/g5/
