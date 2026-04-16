# Terraform AWS Journey

A hands-on learning repository — progressing from a single EC2 instance to CI/CD pipelines with remote state.

## Learning Path

| Lab | Topic | Key Concepts |
|-----|-------|-------------|
| [lab-01](./lab-01/) | First EC2 Instance | init, plan, apply, destroy, providers, state |
| [lab-02](./lab-02/) | EC2 + Security Group | Resource dependencies, SG rules, tfvars |
| lab-03 (coming soon) | Variables & Outputs | variables.tf, outputs.tf, reusability |
| lab-04 (coming soon) | Custom VPC + Subnets | Networking, depends_on, resource references |
| lab-05 (coming soon) | S3 + IAM | Bucket policies, IAM users, state deep dive |
| lab-06 (coming soon) | Reusable Modules | Module blocks, DRY infrastructure |
| lab-07 (coming soon) | Remote State | S3 backend, DynamoDB state locking |
| lab-08 (coming soon) | GitHub Actions CI/CD | plan on PR -> apply on merge |

## Prerequisites

- Terraform installed (>= 1.0)
- AWS CLI configured (aws configure)
- AWS Free Tier account
- Git

## Cost Notice

All labs use AWS Free Tier resources. Always run `terraform destroy` after finishing a lab.