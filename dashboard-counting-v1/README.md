# Dashboard Counting — v1 (Terraform Public Modules)

HashiCorp [demo-consul-101](https://github.com/hashicorp/demo-consul-101) 
Dashboard and Counting services are deployed on AWS with Terraform configuration

difference of v0 , instead of raw `resource` blocks by using **public modules**  Terraform Registry 

---

## Architecture

```
                        Internet
                           │
                    ┌──────▼──────┐
                    │     IGW     │
                    └──────┬──────┘
                           │
              ┌────────────▼────────────┐
              │        VPC (10.0.0.0/16) │
              │                          │
              │  ┌───────────────────┐   │
              │  │  Public Subnet    │   │
              │  │  (10.0.1.0/24)    │   │
              │  │                   │   │
              │  │  ┌─────────────┐  │   │
              │  │  │  Dashboard  │  │   │
              │  │  │  EC2 :9002  │◄─┼───┼── Browser
              │  │  └──────┬──────┘  │   │
              │  │         │ :9001   │   │
              │  └─────────┼─────────┘   │
              │            │             │
              │  ┌─────────▼─────────┐   │
              │  │  Private Subnet   │   │
              │  │  (10.0.2.0/24)    │   │
              │  │                   │   │
              │  │  ┌─────────────┐  │   │
              │  │  │  Counting   │  │   │
              │  │  │  EC2 :9001  │  │   │
              │  │  └─────────────┘  │   │
              │  │        │          │   │
              │  │   NAT Gateway     │   │
              │  └───────────────────┘   │
              └──────────────────────────┘
```

| Component | Detail |
|---|---|
| Dashboard EC2 | Public subnet, port 9002, public IP 포함 |
| Counting EC2 | Private subnet, port 9001, Dashboard 에서만 접근 |
| NAT Gateway | Private subnet → internet outbound |

---

## Public Modules ที่ใช้

| Module | Version | ทำหน้าที่ |
|---|---|---|
| [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) | `~> 5.0` | VPC, Subnets, IGW, NAT Gateway, Route Tables |
| [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws) | `~> 5.0` | Dashboard SG, Counting SG |
| [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws) | `~> 6.0` | Dashboard EC2, Counting EC2 |
| [terraform-aws-modules/key-pair/aws](https://registry.terraform.io/modules/terraform-aws-modules/key-pair/aws) | `~> 2.0` | SSH Key Pair |

---

## File Structure

```
dashboard-counting-v1/
├── main.tf               # Provider (AWS) configuration
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output values
├── terraform.tfvars      # Variable values
├── data.tf               # Ubuntu 24.04 AMI data source
├── vpc.tf                # VPC module (networking)
├── security_groups.tf    # Security group modules
├── instance.tf           # EC2 instance modules
├── key_pair.tf           # Key pair module
└── scripts/
    ├── dashboard-service.sh   # Dashboard EC2 user_data
    └── counting-service.sh    # Counting EC2 user_data
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured (`aws configure`)
- SSH key pair: `~/.ssh/ee-keypair.pub`

create SSH key pair 

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ee-keypair
```

---

## Usage

### 1. Variables

change ip `terraform.tfvars` `my_ip` 

```hcl
prefix_1     = "Dashboard"
prefix_2     = "Counting"
aws_region   = "ap-northeast-1"
my_ip        = "YOUR_IP/32"    # <-- change ip
ec2_key_pair = "ee-keypair"
environment  = "dev"
```

### 2. Initialize

```bash
terraform init
```

### 3. Plan

```bash
terraform plan
```

### 4. Apply

```bash
terraform apply --auto-approve
```

### 5. open Dashboard 

After Terraform apply the output URL is included:

```
dashboard_url = "http://<public_ip>:9002"
```

### 6. Destroy

```bash
terraform destroy
```

---

## Input Variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `prefix_1` | `string` | — | Dashboard resource prefix |
| `prefix_2` | `string` | — | Counting resource prefix |
| `aws_region` | `string` | `ap-northeast-1` | AWS region |
| `vpc_cidr` | `string` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidr` | `string` | `10.0.1.0/24` | Public subnet CIDR |
| `private_subnet_cidr` | `string` | `10.0.2.0/24` | Private subnet CIDR |
| `my_ip` | `string` | — | Your IP for SSH access |
| `ec2_key_pair` | `string` | `null` | EC2 key pair name |
| `environment` | `string` | — | Environment name (e.g. dev) |
| `dashboard_instance_type` | `string` | `t3.micro` | Dashboard EC2 instance type |
| `counting_instance_type` | `string` | `t3.micro` | Counting EC2 instance type |

---

## Outputs

| Output | Description |
|---|---|
| `dashboard_url` | Dashboard UI URL (http://IP:9002) |
| `dashboard_public_ip` | Dashboard EC2 public IP |
| `dashboard_private_ip` | Dashboard EC2 private IP |
| `counting_private_ip` | Counting EC2 private IP |
| `private_key` | Key pair name |

---

## SSH Access

**Dashboard instance (public):**

```bash
ssh -i ~/.ssh/ee-keypair ubuntu@<dashboard_public_ip>
```

**Counting instance (private) — jump Dashboard**

```bash
ssh -i ~/.ssh/ee-keypair -J ubuntu@<dashboard_public_ip> ubuntu@<counting_private_ip>
```

