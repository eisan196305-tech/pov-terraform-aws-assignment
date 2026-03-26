resource "aws_vpc" "dashboard-vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "dashboard-vpc"
    }

#   tags = merge(
#     { Name = "${var.friendly_name_prefix}-${var.vpc_name}" },
#     var.common_tags
#   )

}