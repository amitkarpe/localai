# Cloud AI Coding Model Benchmark

Date: 2026-05-31

## Run

- Instance: `i-0d02137145786faab`
- Name: `localai-cloud-coder-g4dn-20260531`
- Instance type: `g4dn.xlarge`
- AMI: `ami-0e415afa8e100f3f1`
- Model: `qwen2.5-coder:7b-instruct`
- Runtime: Ollama `0.24.0`
- GPU: NVIDIA Tesla T4, 16 GiB
- Access: SSM Run Command only
- Ingress: zero security-group inbound rules
- Final state: stopped

## Score

| Prompt | Result | Seconds |
|---|---:|---:|
| Bash bugfix | PASS | 75.46 |
| Python parser | PASS | 4.31 |
| Terraform security-group review | PASS | 13.01 |
| SSM vs SSH design choice | PASS | 3.51 |
| JSON-only automation | FAIL | 1.29 |

Overall: 4/5 prompt checks passed.

## Key Findings

- The GPU path worked: `ollama ps` reported the model running with `100% GPU`.
- The coding model gave useful explanations for Bash and Terraform review tasks.
- The Python parser answer was plausible but not production-ready without review.
- The model did not reliably obey JSON-only output. It wrapped JSON in Markdown
  fences even after a stricter retry.
- Automation using this model should sanitize code fences or use a stronger
  structured-output wrapper.

## Operational Notes

- First SSM attempt installed Ollama but failed to start `ollama serve` because
  the SSM command environment had no `HOME`.
- Retry fixed this by setting `HOME=/root`.
- The instance was stopped after the benchmark.

## Evidence

Raw evidence is kept outside the repo:

- `/home/dev/.AGENTS-temp/localai-lab/repos/localai/cloud-coding-test-20260531/`
