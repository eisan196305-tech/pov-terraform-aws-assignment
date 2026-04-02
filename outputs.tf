output "dashboard_public_ip" {
  value       = aws_instance.dashboard-instance.public_ip
  description = "Public IP to access the dashboard by using port 9002"
}

output "dashboard_private_ip" {
  value       = aws_instance.dashboard-instance.private_ip
  description = "Dashboard Server Private IP"
}

output "counting_private_ip" {
  value       = aws_instance.counting-instance.private_ip
  description = "Counting Server Private IP (access from dashboard)"
}

output "private_key" {
  value = aws_key_pair.dashboard-vpc.public_key
}

output "dashboard_url" {
  description = "Dashboard URL (front end)"
  value       = "http://${aws_instance.dashboard-instance.public_ip}:9002"
}