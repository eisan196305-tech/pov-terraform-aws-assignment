# pov-terraform-aws-assignment

Terraform project that provisions a two-tier microservices demo on AWS — a **Dashboard** front-end in a public subnet and a **Counting** back-end in a private subnet.

---

## Architecture

```
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Public Subnet (10.0.1.0/24)
   └── Dashboard EC2 (t3.micro)  ← port 9002 (UI)
          │  SSH jump host
          ▼
Private Subnet (10.0.2.0/24)
   └── Counting EC2 (t3.micro)   ← port 9001 (API, internal only)
          │
          ▼
        NAT Gateway  (outbound internet only)
```

- Users hit the Dashboard on **port 9002** over the public IP.
- The Dashboard calls the Counting service on **port 9001** using its private IP.
- The Counting instance has no inbound internet access; outbound-only via NAT.
- SSH to the Counting instance is only allowed from the Dashboard instance (jump host).

---

## Prerequisites

| Tool | Version |
|------|---------|
| Terraform | >= 1.0 |
| AWS CLI | configured with credentials |
| SSH key pair | `~/.ssh/ee-keypair` + `~/.ssh/ee-keypair.pub` |

---

## Quick Start

```bash
cd dashboard-counting-v0

# Create SSH key pair if it doesn't exist
ssh-keygen -t ed25519 -f ~/.ssh/ee-keypair

# Initialize providers
terraform init

# Review the plan
terraform plan

# Deploy
terraform apply
```

After `apply` completes, Terraform prints:

```
dashboard_url = "http://<PUBLIC_IP>:9002"
```

Open that URL in your browser to see the dashboard.

---

## Configuration

Edit `terraform.tfvars` to override defaults:

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `ap-northeast-1` | AWS region to deploy into |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidr` | `10.0.1.0/24` | Public subnet CIDR |
| `private_subnet_cidr` | `10.0.2.0/24` | Private subnet CIDR |
| `dashboard_instance_type` | `t3.micro` | EC2 type for Dashboard |
| `counting_instance_type` | `t3.micro` | EC2 type for Counting |
| `ec2_key_pair` | `ee-keypair` | Name of the key pair in AWS |
| `environment` | `dev` | Environment tag |
| `my_ip` | *(required)* | Your IP for SSH ingress (`x.x.x.x/32`) |
| `prefix_1` | `Dashboard` | Resource name prefix for dashboard resources |
| `prefix_2` | `Counting` | Resource name prefix for counting resources |

---

## Outputs

| Output | Description |
|--------|-------------|
| `dashboard_url` | Full URL to the dashboard UI |
| `dashboard_public_ip` | Public IP of the dashboard instance |
| `dashboard_private_ip` | Private IP of the dashboard instance |
| `counting_private_ip` | Private IP of the counting instance |

---

## SSH Access

```bash
# Connect to the Dashboard instance
ssh -i ~/.ssh/ee-keypair ubuntu@<dashboard_public_ip>

# Jump through Dashboard to reach Counting instance
ssh -i ~/.ssh/ee-keypair -J ubuntu@<dashboard_public_ip> ubuntu@<counting_private_ip>
```

---

## Services

Both services are HashiCorp demo binaries (`hashicorp/demo-consul-101`, v0.0.5), managed as systemd units.

| Service | Instance | Port | Notes |
|---------|----------|------|-------|
| `dashboard-service` | public | 9002 | Calls counting service on startup; waits until counting is reachable |
| `counting-service` | private | 9001 | Simple counter API |

Logs: `sudo journalctl -u dashboard-service` / `sudo journalctl -u counting-service`

---

## Teardown

```bash
terraform destroy
```

---

## Directory Layout

```
pov-terraform-aws-assignment/
└── dashboard-counting-v0/       # Active Terraform configuration
    ├── main.tf                  # Provider setup
    ├── variables.tf             # Input variable declarations
    ├── outputs.tf               # Output declarations
    ├── terraform.tfvars         # Variable values
    ├── vpc.tf                   # VPC
    ├── subnets.tf               # Public & private subnets
    ├── igw.tf                   # Internet Gateway
    ├── nat.tf                   # NAT Gateway + Elastic IP
    ├── route_tables.tf          # Route tables & associations
    ├── security_groups.tf       # Security groups & rules
    ├── key_pair.tf              # EC2 key pair
    ├── data.tf                  # AMI data source (Ubuntu 24.04)
    └── scripts/
        ├── dashboard-service.sh # User data for Dashboard EC2
        └── counting-service.sh  # User data for Counting EC2
```
