# Lab 01 — Your First EC2 Instance

## What This Lab Does

Launches a single EC2 instance (Amazon Linux 2023, t2.micro) on AWS using Terraform.
No VPC customization, no security groups, no key pair — just the absolute minimum to understand how Terraform works.

---

## What You Learn

- What `terraform init` actually does (downloads the AWS provider plugin)
- The difference between `terraform plan` and `terraform apply`
- What the `terraform.tfstate` file is and why it matters
- How Terraform tracks resources it created
- The `provider`, `resource`, `variable`, and `output` blocks
- How to cleanly destroy infrastructure with `terraform destroy`

---

## Files in This Lab

```
lab-01-first-ec2/
├── main.tf         # Provider + EC2 resource definition
├── variables.tf    # Input variables (region, ami, instance_type)
├── outputs.tf      # Values printed after apply (instance_id, public_ip)
└── README.md       # This file
```

---

## Pre-requisites

1. Terraform installed: https://developer.hashicorp.com/terraform/install
2. AWS CLI installed and configured:
   ```bash
   aws configure
   # Enter: Access Key ID, Secret Access Key, Region (us-east-1), Output (json)
   ```
3. Verify AWS credentials work:
   ```bash
   aws sts get-caller-identity
   ```

---

## Step-by-Step Commands

### Step 1 — Initialize Terraform

```bash
cd lab-01-first-ec2
terraform init
```

What happens:
- Terraform reads `main.tf` and sees you need the `aws` provider
- Downloads the AWS provider plugin into `.terraform/` directory
- Creates `.terraform.lock.hcl` (locks provider version)

You will see: `Terraform has been successfully initialized!`

---

### Step 2 — Preview What Will Be Created

```bash
terraform plan
```

What happens:
- Terraform compares your code against current state (nothing exists yet)
- Shows exactly what it WILL create — no real changes happen
- `+` means resource will be created
- You should see `Plan: 1 to add, 0 to change, 0 to destroy`

Read the plan carefully. This is your safety net before applying.

---

### Step 3 — Create the Infrastructure

```bash
terraform apply
```

What happens:
- Terraform shows the plan again and asks for confirmation
- Type `yes` and press Enter
- AWS creates the EC2 instance
- Terraform saves the result in `terraform.tfstate`
- Outputs are printed (instance_id, public_ip, etc.)

Check your AWS Console → EC2 → Instances to see it running.

---

### Step 4 — Inspect the State File

```bash
cat terraform.tfstate
```

This JSON file is how Terraform remembers what it created.
It maps your code to real AWS resource IDs.

Key things to notice:
- `instance_id` (e.g. `i-0a1b2c3d4e5f67890`)
- `ami`, `instance_type`, `tags`
- The `public_ip` assigned by AWS

> Never manually edit this file. Never commit it to Git (it can contain sensitive data).

---

### Step 5 — Check Outputs

```bash
terraform output
```

Prints the values defined in `outputs.tf`.
You can also get a specific output:
```bash
terraform output instance_id
terraform output instance_public_ip
```

---

### Step 6 — Make a Change (Optional Experiment)

Open `main.tf` and add a new tag:
```hcl
tags = {
  Name        = "lab-01-first-server"
  Environment = "learning"
  Lab         = "01"
  ManagedBy   = "Terraform"
  UpdatedBy   = "Me"       # <-- add this
}
```

Then run:
```bash
terraform plan    # See the ~ (in-place update) symbol
terraform apply   # Apply the tag change
```

This shows how Terraform handles updates — it doesn't recreate, it patches in-place.

---

### Step 7 — Destroy Everything

```bash
terraform destroy
```

Type `yes` to confirm.
Terraform will terminate the EC2 instance.

Always destroy after finishing a lab to avoid AWS charges.

---

## Key Concepts Learned

| Concept | Explanation |
|---------|-------------|
| `terraform init` | Downloads providers, prepares working directory |
| `terraform plan` | Dry-run — shows what will change, nothing is created |
| `terraform apply` | Executes the plan and creates real infrastructure |
| `terraform destroy` | Deletes all resources managed by this Terraform config |
| `terraform.tfstate` | JSON file tracking all created resources and their IDs |
| Provider | Plugin that knows how to talk to AWS API |
| Resource | A unit of infrastructure (EC2, SG, VPC, etc.) |
| Variable | Reusable input value defined in `variables.tf` |
| Output | Value printed after apply, like a return value |

---

## Common Errors & Fixes

**Error: `InvalidAMIID.NotFound`**
The AMI ID in `variables.tf` is region-specific. If you're not in `us-east-1`, find the correct AMI:
```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*" \
  --query "sort_by(Images, &CreationDate)[-1].ImageId" \
  --output text
```

**Error: `AuthFailure` or `NoCredentialProviders`**
Your AWS credentials aren't configured. Run `aws configure` again.

**Error: `UnauthorizedOperation`**
Your IAM user doesn't have EC2 permissions. Attach `AmazonEC2FullAccess` policy in AWS Console.

---

## Next Lab

➡️ [Lab 02 — EC2 + Security Group](../lab-02-ec2-security-group/)

In Lab 02 we add a Security Group to control inbound/outbound traffic, introduce `terraform.tfvars`, and learn about resource dependencies.
