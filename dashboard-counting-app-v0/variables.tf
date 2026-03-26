#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
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
    type = string
    description = "Name of VPC"
    default = "vpc"
}


variable "aws_region" {
    default = "ap-northeast-1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    default = "10.0.2.0/24"
}

variable "az" {
    default = "ap-northeast-1a" 
}

variable "my_ip" {
    description = "my_ip"
    type = string
}

variable "key_name" {
    description = "EC2 key pair name"
    type = string
}