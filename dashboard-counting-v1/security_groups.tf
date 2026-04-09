# Security Group for the Public Dashboard
module "dashboard_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${var.prefix_1}-dashboard-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9002
      to_port     = 9002
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.common_tags, { environment = var.environment })
}

# Security Group for the Private Counting Instance
module "counting_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${var.prefix_2}-counting-sg"
  vpc_id = module.vpc.vpc_id

  # Allow dashboard SG → counting port 9001
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 9001
      to_port                  = 9001
      protocol                 = "tcp"
      source_security_group_id = module.dashboard_sg.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = module.dashboard_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules = ["all-all"]

  tags = merge(var.common_tags, { environment = var.environment })
}
