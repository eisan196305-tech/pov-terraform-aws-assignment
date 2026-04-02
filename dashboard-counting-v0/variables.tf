#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "prefix_1" {
  description = "Prefix for dashboard"
  type        = string
}

variable "prefix_2" {
  description = "Prefix for counting"
  type        = string
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

#------------------------------------------------------------------------------
# Networking
#------------------------------------------------------------------------------
variable "create_vpc" {
  type        = bool
  description = "Boolean to create a VPC."
  default     = false
}

variable "vpc_name" {
  type        = string
  description = "Name of VPC"
  default     = "vpc"
}


variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR BLOCK"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Public Subnet CIDR"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Private Subnet CIDR"
}

variable "my_ip" {
  description = "my_ip"
  type        = string
}

variable "ec2_key_pair" {
  type        = string
  description = "EC2 key pair name"
  default     = null
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "dashboard_instance_type" {
  description = "EC2 instance type for dashboard"
  type        = string
  default     = "t3.micro"
}

variable "counting_instance_type" {
  description = "EC2 instance type for counting"
  type        = string
  default     = "t3.micro"
}
