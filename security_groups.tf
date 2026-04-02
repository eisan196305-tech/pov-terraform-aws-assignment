# Security Group for the Public Dashboard
resource "aws_security_group" "dashboard_SG" {
  vpc_id = aws_vpc.dashboard-vpc.id

  # Allow SSH from your local machine
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = [var.my_ip]
    cidr_blocks = ["0.0.0.0/0"] // access from worldwide ssh
  }

  # Allow browser access to the Dashboard UI
  ingress {
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic (to download updates/reach counting)
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
}

# Security Group for the Private Counting Instance
resource "aws_security_group" "counting_SG" {
  vpc_id = aws_vpc.dashboard-vpc.id

  # Allow all outbound traffic (to reach NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RULE 1: Allow the Dashboard App to connect to the Counting Service
resource "aws_security_group_rule" "allow_dash_to_count" {
  type      = "ingress"
  from_port = 9001
  to_port   = 9001
  protocol  = "tcp"

  security_group_id        = aws_security_group.counting_SG.id
  source_security_group_id = aws_security_group.dashboard_SG.id
}

# RULE 2: Allow SSH "Jump" from Dashboard to Counting Instance
resource "aws_security_group_rule" "allow_ssh_from_dash_to_count" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.counting_SG.id
  source_security_group_id = aws_security_group.dashboard_SG.id
}


