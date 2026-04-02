resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.dashboard-vpc.id

  tags = {
    Name        = "${var.prefix_1}-igw-${var.aws_region}"
    environment = var.environment
  }
}