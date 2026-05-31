# Cloud AI EC2 and SSM Proof

Date: 2026-05-31

## Purpose

Record the cloud-side learning proof for running a temporary EC2 validation
lane and controlling it through AWS Systems Manager instead of SSH.

## Scope

- AWS profile: `amit`
- Region: `ap-southeast-1`
- Proof type: low-cost CPU EC2 first
- GPU: not started
- Control path: SSM only
- Public exposure target: zero inbound rules

## Results

### Private-only EC2 proof

- Instance: `i-0eb1c58004c079f30`
- Name: `localai-cpu-proof-20260531`
- State at closeout: stopped
- Public IP: none
- Result: No-Go for SSM because the instance had no public IP and no SSM VPC
  endpoints.

Evidence packet:

- `/home/dev/.AGENTS-temp/localai-lab/repos/localai/ec2-proof-20260531/ssm-readiness-result.md`

### Public SSM-only replacement proof

- Instance: `i-0ac9e1e9750a330cc`
- Name: `localai-cpu-proof-public-ssm-20260531`
- State at closeout: stopped
- Public IP: none after stop
- Security group: `sg-08c18dc79595d6cb7`
- Ingress: zero rules
- Egress: HTTPS/443 only
- Result: Pass. SSM reached Online and a harmless proof command succeeded.

Evidence packet:

- `/home/dev/.AGENTS-temp/localai-lab/repos/localai/ec2-public-ssm-proof-20260531/result.md`

## Learning Proof

- Private subnet without public internet needs SSM VPC endpoints for SSM-only
  control.
- Public subnet plus zero-ingress security group can support short-lived SSM
  proof, but it still carries public IPv4 exposure/cost and should remain a
  temporary personal-lab path.
- For longer reusable cloud AI testing, prefer an explicit private SSM endpoint
  design or another approved private control path.

## Tracked Cloud Assets

- `plans/cloud/aws/aws-ec2-proof-plan-20260531.md`
- `plans/cloud/aws/aws-ec2-proof-execution-checklist.md`
- `docs/cloud/aws/README.md`
- `reports/cloud/aws/ec2-ssm-proof-20260531.md`

## Next Step

Do not start more AWS work until the exact next cloud run is approved. The next
cloud design choice is private SSM endpoints versus another short-lived public
SSM-only proof.
