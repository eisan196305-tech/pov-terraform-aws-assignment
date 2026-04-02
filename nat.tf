resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.prefix_1}-nat-eip-${var.aws_region}"
    environment = var.environment
  }
}

# NAT Gateway — Public Subnet 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.prefix_1}-nat-gw-${var.aws_region}"
    environment = var.environment
  }

  # IGW
  depends_on = [aws_internet_gateway.main]
}