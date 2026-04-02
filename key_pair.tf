resource "aws_key_pair" "dashboard-vpc" {
  key_name   = "ee-keypair"
  public_key = file("~/.ssh/ee-keypair.pub")
}