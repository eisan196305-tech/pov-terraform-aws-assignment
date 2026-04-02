# # ── Bastion EC2 (Public) ─────────────────────────────────
# resource "aws_instance" "counting-instance" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.counting_instance_type
#   subnet_id              = aws_subnet.public.id
#   vpc_security_group_ids = [aws_security_group.bastion.id]
#   key_name               = var.ec2_key_pair

#   tags = { Name = "counting-instance-ec2" }
# }

# ── Dashboard EC2 (Public) ────────────────────────────────
resource "aws_instance" "dashboard-instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.dashboard_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.dashboard_SG.id]
  key_name               = var.ec2_key_pair

  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    counting_private_ip = aws_instance.counting-instance.private_ip
  })

  tags = { Name = "dashboard-instance" }
}

# ── Counting EC2 (Private) ────────────────────────────────────
resource "aws_instance" "counting-instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.counting_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.counting_SG.id]
  key_name               = var.ec2_key_pair

  user_data = templatefile("${path.module}/scripts/counting-service.sh", {})

  tags = { Name = "counting-instance" }
}