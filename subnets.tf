# Public Subnet — Dashboard EC2
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.dashboard-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-northeast-1a"  # ap-northeast-1a
  map_public_ip_on_launch = true           # Public IP auto-assign

  tags = {
    Name        = "${var.prefix_1}-public-subnet-${var.aws_region}"
    environment = var.environment
  }
}

# Private Subnet — Counting EC2
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.dashboard-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-northeast-1a" 

  tags = {
    Name        = "${var.prefix_2}-private-subnet-${var.aws_region}"
    environment = var.environment
  }
}