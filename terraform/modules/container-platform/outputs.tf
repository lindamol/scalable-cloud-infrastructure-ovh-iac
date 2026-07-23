output "cluster_id" {
  description = "ID of the OVHcloud Managed Kubernetes cluster."
  value       = ovh_cloud_project_kube.this.id
}

output "cluster_name" {
  description = "Name of the Managed Kubernetes cluster."
  value       = ovh_cloud_project_kube.this.name
}

output "cluster_region" {
  description = "Region of the Managed Kubernetes cluster."
  value       = ovh_cloud_project_kube.this.region
}

output "cluster_status" {
  description = "Current status of the Managed Kubernetes cluster."
  value       = ovh_cloud_project_kube.this.status
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster."
  value       = ovh_cloud_project_kube.this.version
}

output "private_network_id" {
  description = "Private network attached to the Kubernetes cluster."
  value       = ovh_cloud_project_kube.this.private_network_id
}

output "node_pool_id" {
  description = "ID of the Kubernetes node pool."
  value       = ovh_cloud_project_kube_nodepool.this.id
}

output "node_pool_name" {
  description = "Name of the Kubernetes node pool."
  value       = ovh_cloud_project_kube_nodepool.this.name
}

output "node_pool_status" {
  description = "Current status of the Kubernetes node pool."
  value       = ovh_cloud_project_kube_nodepool.this.status
}

output "node_pool_current_nodes" {
  description = "Current number of nodes in the node pool."
  value       = ovh_cloud_project_kube_nodepool.this.current_nodes
}

output "node_pool_available_nodes" {
  description = "Number of ready nodes in the node pool."
  value       = ovh_cloud_project_kube_nodepool.this.available_nodes
}

output "api_restrictions_enabled" {
  description = "Whether Kubernetes API IP restrictions are configured."
  value       = length(var.api_allowed_cidrs) > 0
}

output "kubeconfig" {
  description = "Sensitive kubeconfig used to connect kubectl to the cluster."
  value       = ovh_cloud_project_kube.this.kubeconfig
  sensitive   = true
}