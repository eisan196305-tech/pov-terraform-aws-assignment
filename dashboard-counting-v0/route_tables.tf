# ── Public Route Table ─────────────────────────────────────────
# To reach from Internet to Dashboard EC2
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dashboard-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id # igw.tf ထဲက resource
  }

  tags = {
    Name        = "${var.prefix_1}-public-rt-${var.aws_region}"
    environment = var.environment
  }
}

# Connect Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ── Private Route Table ────────────────────────────────────────
# Counting EC2 outbound (package install etc) from NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dashboard-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id # nat.tf resource
  }

  tags = {
    Name        = "${var.prefix_2}-private-rt-${var.aws_region}"
    environment = var.environment
  }
}

# Connect Private Subnet 
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}