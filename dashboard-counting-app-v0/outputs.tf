output "bastion_public_ip"  { value = aws_instance.bastion.public_ip }
output "frontend_public_ip" { value = aws_instance.frontend.public_ip }
output "api_private_ip"     { value = aws_instance.api.private_ip }
output "nat_eip"            { value = aws_eip.nat.public_ip }