# =============================================================================
# OVHcloud Network Module
#
# Creates:
# - One OVHcloud Public Cloud private network
# - One subnet in the selected region
#
# This module creates resources only after it is called from an environment
# such as terraform/environments/dev/main.tf.
# =============================================================================

resource "ovh_cloud_project_network_private" "this" {
  service_name = var.service_name
  name         = var.network_name
  regions      = [var.region]
  vlan_id      = var.vlan_id
}

resource "ovh_cloud_project_network_private_subnet_v2" "this" {
  service_name = var.service_name

  # The private network has a region-specific OpenStack network ID.
  network_id = one(
    ovh_cloud_project_network_private.this.regions_attributes[*].openstackid
  )

  name   = var.subnet_name
  region = var.region
  cidr   = var.subnet_cidr
  dhcp   = var.enable_dhcp

  # An empty list allows OVHcloud to use its default DNS configuration.
  dns_nameservers = (
    length(var.dns_nameservers) > 0
    ? var.dns_nameservers
    : null
  )

  use_default_public_dns_resolver = length(var.dns_nameservers) == 0

  dynamic "allocation_pools" {
    for_each = var.allocation_pools

    content {
      start = allocation_pools.value.start
      end   = allocation_pools.value.end
    }
  }

  lifecycle {
    precondition {
      condition     = var.ip_version == 4
      error_message = "This network module currently supports IPv4 subnets only."
    }
  }
}