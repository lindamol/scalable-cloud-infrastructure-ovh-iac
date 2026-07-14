# =============================================================================
# OVHcloud Development Environment - Outputs
# =============================================================================

output "project_name" {
  description = "Name of the cloud infrastructure project."
  value       = var.project_name
}

output "environment" {
  description = "Current deployment environment."
  value       = var.environment
}

output "region" {
  description = "OVHcloud/OpenStack deployment region."
  value       = var.region
}

output "name_prefix" {
  description = "Common naming prefix for development resources."
  value       = local.name_prefix
}


# =============================================================================
# Network Outputs
# =============================================================================

output "network_id" {
  description = "ID of the OVHcloud private network."
  value       = module.network.network_id
}

output "network_openstack_id" {
  description = "Region-specific OpenStack network ID."
  value       = module.network.network_openstack_id
}

output "subnet_id" {
  description = "ID of the OVHcloud private subnet."
  value       = module.network.subnet_id
}

output "subnet_cidr" {
  description = "CIDR assigned to the private subnet."
  value       = module.network.subnet_cidr
}


# =============================================================================
# Security Outputs
# =============================================================================

output "security_group_id" {
  description = "ID of the OpenStack security group."
  value       = module.security.security_group_id
}

output "security_group_name" {
  description = "Name of the OpenStack security group."
  value       = module.security.security_group_name
}

output "ingress_rule_count" {
  description = "Number of ingress rules created."
  value       = module.security.ingress_rule_count
}

output "egress_rule_count" {
  description = "Number of egress rules created."
  value       = module.security.egress_rule_count
}