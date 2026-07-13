output "project_name" {
  description = "Name of the cloud infrastructure project."
  value       = var.project_name
}

output "environment" {
  description = "Current deployment environment."
  value       = var.environment
}

output "region" {
  description = "OVHcloud region selected for deployment."
  value       = var.region
}

output "name_prefix" {
  description = "Common naming prefix for resources in this environment."
  value       = local.name_prefix
}