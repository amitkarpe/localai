# LocalAI EC2 Proof Execution Checklist

## Run log
- Region: ap-southeast-1
- Profile: amit
- Shape: c6i.large
- AMI: ami-0543dbdaf4e114be7 (Amazon Linux 2023)
- Name: localai-cpu-proof-20260531
- VPC: vpc-d15c94b4
- Subnet: subnet-4b69dd2e (private)
- Security Group: sg-c2ee6aa7
- IAM role: AmazonSSMRoleForInstancesQuickSetup
- Root disk: 30 GiB gp3, delete on termination
- Public IP: disabled for launch
- TTL tag: 01-06-26

## Steps performed
1. AWS preflight identity + profile verification
2. Launch c6i.large instance
3. Capture state + network + SSM registration status
4. Record commit/evidence
