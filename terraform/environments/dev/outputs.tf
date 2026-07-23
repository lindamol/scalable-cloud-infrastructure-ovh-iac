# =============================================================================
# OVHcloud Development Environment - Outputs
# =============================================================================


# =============================================================================
# General Project Outputs
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


# =============================================================================
# Managed Kubernetes Outputs
# =============================================================================

output "kubernetes_cluster_id" {
  description = "ID of the OVHcloud Managed Kubernetes cluster."
  value       = module.container_platform.cluster_id
}

output "kubernetes_cluster_name" {
  description = "Name of the OVHcloud Managed Kubernetes cluster."
  value       = module.container_platform.cluster_name
}

output "kubernetes_cluster_region" {
  description = "Region of the OVHcloud Managed Kubernetes cluster."
  value       = module.container_platform.cluster_region
}

output "kubernetes_cluster_status" {
  description = "Current status of the OVHcloud Managed Kubernetes cluster."
  value       = module.container_platform.cluster_status
}

output "kubernetes_cluster_version" {
  description = "Kubernetes version running on the cluster."
  value       = module.container_platform.cluster_version
}

output "kubernetes_private_network_id" {
  description = "Private OpenStack network attached to the Kubernetes cluster."
  value       = module.container_platform.private_network_id
}


# =============================================================================
# Kubernetes Node-Pool Outputs
# =============================================================================

output "kubernetes_node_pool_id" {
  description = "ID of the Kubernetes worker-node pool."
  value       = module.container_platform.node_pool_id
}

output "kubernetes_node_pool_name" {
  description = "Name of the Kubernetes worker-node pool."
  value       = module.container_platform.node_pool_name
}

output "kubernetes_node_pool_status" {
  description = "Current status of the Kubernetes worker-node pool."
  value       = module.container_platform.node_pool_status
}

output "kubernetes_current_nodes" {
  description = "Current number of worker nodes present in the node pool."
  value       = module.container_platform.node_pool_current_nodes
}

output "kubernetes_available_nodes" {
  description = "Number of worker nodes currently ready in the node pool."
  value       = module.container_platform.node_pool_available_nodes
}

output "kubernetes_node_flavor" {
  description = "OVHcloud compute flavor used by the Kubernetes worker nodes."
  value       = var.node_flavor
}

output "kubernetes_node_autoscaling_enabled" {
  description = "Whether worker-node autoscaling is enabled."
  value       = var.node_autoscale
}

output "kubernetes_node_minimum" {
  description = "Minimum number of worker nodes configured."
  value       = var.min_nodes
}

output "kubernetes_node_maximum" {
  description = "Maximum number of worker nodes configured."
  value       = var.max_nodes
}


# =============================================================================
# Kubernetes API Access Outputs
# =============================================================================

output "kubernetes_api_restrictions_enabled" {
  description = "Whether Kubernetes API IP restrictions are configured."
  value       = module.container_platform.api_restrictions_enabled
}


# =============================================================================
# Sensitive Kubernetes Connection Output
#
# This output is marked sensitive because it contains the credentials needed
# to connect kubectl to the Kubernetes cluster.
# =============================================================================

output "kubeconfig" {
  description = "Sensitive kubeconfig used to connect kubectl to the cluster."
  value       = module.container_platform.kubeconfig
  sensitive   = true
}