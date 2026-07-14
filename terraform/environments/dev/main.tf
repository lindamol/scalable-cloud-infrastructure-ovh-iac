# =============================================================================
# OVHcloud Development Environment - Root Configuration
#
# This root module connects the development environment values to the
# reusable network and security child modules.
# =============================================================================

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}


# =============================================================================
# Network Module
#
# Creates:
# - One OVHcloud private network
# - One subnet in the selected region
# =============================================================================

module "network" {
  source = "../../modules/network"

  service_name = var.service_name
  region       = var.region

  network_name = "${local.name_prefix}-network"
  subnet_name  = "${local.name_prefix}-subnet"
  subnet_cidr  = var.subnet_cidr

  ip_version       = var.ip_version
  vlan_id          = var.vlan_id
  enable_dhcp      = var.enable_dhcp
  dns_nameservers  = var.dns_nameservers
  allocation_pools = var.allocation_pools
}


# =============================================================================
# Security Module
#
# Creates:
# - One OpenStack security group
# - Zero or more ingress rules
# - Zero or more egress rules
#
# OpenStack credentials are required before this module can be planned
# or applied.
# =============================================================================

module "security" {
  source = "../../modules/security"

  region                     = var.region
  security_group_name        = "${local.name_prefix}-sg"
  security_group_description = "Security group for the ${var.environment} environment."
  delete_default_rules       = var.delete_default_rules

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}