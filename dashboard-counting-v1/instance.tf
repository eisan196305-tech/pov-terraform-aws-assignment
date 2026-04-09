# ── Counting EC2 (Private) — must be created first for its private_ip ──
module "counting_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name          = "counting-instance"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.counting_instance_type
  subnet_id     = module.vpc.private_subnets[0]

  vpc_security_group_ids = [module.counting_sg.security_group_id]
  key_name               = module.key_pair.key_pair_name

  user_data = templatefile("${path.module}/scripts/counting-service.sh", {})

  tags = merge(var.common_tags, { environment = var.environment })
}

# ── Dashboard EC2 (Public) ──
module "dashboard_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name          = "dashboard-instance"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.dashboard_instance_type
  subnet_id     = module.vpc.public_subnets[0]

  associate_public_ip_address = true

  vpc_security_group_ids = [module.dashboard_sg.security_group_id]
  key_name               = module.key_pair.key_pair_name

  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    counting_private_ip = module.counting_instance.private_ip
  })

  tags = merge(var.common_tags, { environment = var.environment })
}
