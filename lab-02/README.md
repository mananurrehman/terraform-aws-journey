# Lab 02 — EC2 + Security Group

## What This Lab Does

Builds on Lab 01 by adding a **Security Group** to control inbound and outbound traffic.
The EC2 instance gets SSH (port 22) and HTTP (port 80) access, and a `user_data` bootstrap
script installs Apache web server automatically on first boot.

---

## What You Learn

- How to define an `aws_security_group` resource
- Ingress (inbound) and egress (outbound) rules
- Resource references and implicit dependencies (SG -> EC2)
- How `terraform.tfvars` works and why we separate variable values from definitions
- What `user_data` is (EC2 bootstrap script)
- `terraform refresh` — syncing state with real AWS
- How Terraform decides the order to create resources

---

## Files in This Lab

```
lab-02-ec2-security-group/
├── main.tf                    # Security Group + EC2 resources
├── variables.tf               # Variable definitions
├── outputs.tf                 # instance_id, public_ip, ssh_command, web_url
├── terraform.tfvars.example   # Template — copy to terraform.tfvars and fill in
└── README.md                  # This file
```

---

## Pre-requisites

1. Completed Lab 01 (you understand init/plan/apply/destroy)
2. AWS CLI configured
3. An EC2 Key Pair created in your AWS account

### Creating a Key Pair (if you don't have one)

```bash
# Option A: AWS Console
# EC2 -> Key Pairs -> Create key pair -> RSA -> .pem -> Create
# Move the downloaded file: mv ~/Downloads/my-key.pem ~/.ssh/
# Fix permissions: chmod 400 ~/.ssh/my-key.pem

# Option B: AWS CLI
aws ec2 create-key-pair \
  --key-name my-terraform-key \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/my-terraform-key.pem

chmod 400 ~/.ssh/my-terraform-key.pem
```

---

## Step-by-Step Commands

### Step 1 — Set Up Your tfvars File

```bash
cd lab-02-ec2-security-group
cp terraform.tfvars.example terraform.tfvars
```

Open `terraform.tfvars` and set your `key_name` to the name of your key pair.

---

### Step 2 — Initialize Terraform

```bash
terraform init
```

Same as Lab 01 — downloads the AWS provider.

---

### Step 3 — Plan

```bash
terraform plan
```

You should see `Plan: 2 to add` — one Security Group + one EC2 instance.

Look for the implicit dependency in the plan output:
Terraform knows to create `aws_security_group.web_sg` BEFORE `aws_instance.web_server`
because `web_server` references `web_sg.id`.

---

### Step 4 — Apply

```bash
terraform apply
```

Type `yes` to confirm. After ~30 seconds you will see outputs printed:
- `instance_public_ip`
- `ssh_command`
- `web_url`

---

### Step 5 — Test the Web Server

Open the `web_url` output in your browser (wait ~60 seconds for `user_data` to finish):

```
http://<your-public-ip>
```

You should see: **"Lab 02 - Terraform EC2 + Security Group"**

---

### Step 6 — SSH Into the Instance

Use the `ssh_command` output directly:

```bash
terraform output ssh_command
# Copy and run the command shown
```

Or manually:
```bash
ssh -i ~/.ssh/your-key.pem ec2-user@<public_ip>
```

---

### Step 7 — Understand terraform refresh

While SSH'd into the instance, stop the EC2 from the AWS Console (simulate an external change).

Then run:
```bash
terraform refresh
terraform output
```

`terraform refresh` queries AWS and updates the local state file to reflect the REAL current
state of your resources — without making any changes to infrastructure.
This is useful when someone changes infrastructure outside of Terraform.

After this, run:
```bash
terraform plan
```

Terraform will show a diff because the desired state (running) doesn't match actual state (stopped).

---

### Step 8 — Experiment: Update the Security Group

Try removing the HTTP ingress rule from `main.tf` and run `terraform plan`.
You'll see `~ update in-place` for the Security Group — Terraform modifies it without recreating EC2.

Then add it back and apply again.

---

### Step 9 — Destroy Everything

```bash
terraform destroy
```

Type `yes`. Terraform destroys EC2 first, then the Security Group
(reverse dependency order — it knows it can't delete the SG while EC2 is still attached to it).

---

## Understanding Implicit Dependencies

This is one of the most important concepts in Terraform:

```hcl
# In aws_instance block:
vpc_security_group_ids = [aws_security_group.web_sg.id]
#                         ^--- This reference tells Terraform:
#                              "web_sg must exist before web_server"
```

Terraform builds a dependency graph automatically. You don't have to tell it the order.
In Lab 04 you will also learn `depends_on` for explicit dependencies when there's no direct reference.

---

## Key Concepts Learned

| Concept | Explanation |
|---------|-------------|
| `aws_security_group` | Virtual firewall resource controlling traffic |
| `ingress` block | Defines allowed INBOUND traffic rules |
| `egress` block | Defines allowed OUTBOUND traffic rules |
| `cidr_blocks` | IP ranges in CIDR notation (0.0.0.0/0 = all IPs) |
| `vpc_security_group_ids` | Attaches a SG to an EC2 instance |
| Implicit dependency | Terraform infers creation order from resource references |
| `user_data` | Shell script that runs on EC2 first boot |
| `terraform.tfvars` | File where you set variable values (excluded from Git) |
| `terraform refresh` | Syncs local state file with real AWS resource state |

---

## Common Errors & Fixes

**Web page not loading after apply**
Wait 60-90 seconds. `user_data` takes time to install Apache. Also verify port 80 ingress rule exists in the SG.

**SSH connection refused / timeout**
- Verify port 22 is in the SG ingress rules: `terraform state show aws_security_group.web_sg`
- Make sure your `.pem` file has correct permissions: `chmod 400 ~/.ssh/your-key.pem`
- Use the right username: Amazon Linux uses `ec2-user`, Ubuntu uses `ubuntu`

**Error: key pair not found**
The `key_name` in `terraform.tfvars` must exactly match the key pair name in your AWS account.
Check: `aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName"`

---

## Next Lab

➡️ [Lab 03 — Variables & Outputs](../lab-03-variables-outputs/) *(coming soon)*

In Lab 03 we go deeper into `variables.tf`, validation rules, local values, and more output tricks.
