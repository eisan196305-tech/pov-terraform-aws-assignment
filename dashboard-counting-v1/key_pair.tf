module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name   = "ee-keypair"
  public_key = file("~/.ssh/ee-keypair.pub")

  tags = merge(var.common_tags, { environment = var.environment })
}
