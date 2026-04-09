output "dashboard_public_ip" {
  value       = module.dashboard_instance.public_ip
  description = "Public IP to access the dashboard by using port 9002"
}

output "dashboard_private_ip" {
  value       = module.dashboard_instance.private_ip
  description = "Dashboard Server Private IP"
}

output "counting_private_ip" {
  value       = module.counting_instance.private_ip
  description = "Counting Server Private IP (access from dashboard)"
}

output "private_key" {
  value = module.key_pair.key_pair_name
}

output "dashboard_url" {
  description = "Dashboard URL (front end)"
  value       = "http://${module.dashboard_instance.public_ip}:9002"
}
