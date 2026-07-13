# Root configuration for the OVHcloud development environment.
#
# Infrastructure modules will be connected after Kevares confirms:
# - the OVHcloud Public Cloud project ID
# - the approved OVHcloud region
# - the deployment model
# - whether Managed Kubernetes, self-managed Kubernetes,
#   or another container platform will be used
# - compute flavors, node counts, quotas, and budget

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Future container platform module.
# Keep this commented until Kevares confirms the required platform details.
#
# module "container_platform" {
#   source = "../../modules/container-platform"
#
#   service_name   = var.service_name
#   region         = var.region
#   cluster_name   = "${local.name_prefix}-cluster"
#   node_pool_name = "${local.name_prefix}-pool"
#   flavor_name    = var.flavor_name
#   desired_nodes  = var.desired_nodes
# }
