# =============================================================================
# OVHcloud/OpenStack Security Module - Main Resources
#
# This reusable child module creates:
#
#   1. One OpenStack Neutron security group
#   2. Zero or more ingress security-group rules
#   3. Zero or more egress security-group rules
#
# Environment-specific values are supplied by the root environment module:
#
# terraform/environments/dev/
# terraform/environments/test/
# terraform/environments/prod/
#
# Credentials, project IDs, regions, ports, and client-specific CIDR ranges
# must not be hardcoded inside this reusable module.
# =============================================================================


# -----------------------------------------------------------------------------
# OpenStack security group
#
# OpenStack Neutron creates the security group separately from its rules.
#
# During the initial POC, delete_default_rules should normally remain false.
# This preserves the default OpenStack outbound rules until all required
# egress access has been identified and explicitly configured.
# -----------------------------------------------------------------------------

resource "openstack_networking_secgroup_v2" "this" {
  region               = var.region
  name                 = var.security_group_name
  description          = var.security_group_description
  delete_default_rules = var.delete_default_rules
}


# -----------------------------------------------------------------------------
# Ingress security-group rules
#
# One rule is created for every entry supplied through var.ingress_rules.
#
# Example map keys supplied by the root module:
#
#   allow_https
#   allow_health_check
#   allow_internal_api
#
# The map key is used by Terraform to track each rule consistently.
# -----------------------------------------------------------------------------

resource "openstack_networking_secgroup_rule_v2" "ingress" {
  for_each = var.ingress_rules

  region            = var.region
  direction         = "ingress"
  description       = each.value.description
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  remote_group_id   = each.value.remote_group_id
  security_group_id = openstack_networking_secgroup_v2.this.id
}


# -----------------------------------------------------------------------------
# Egress security-group rules
#
# One rule is created for every entry supplied through var.egress_rules.
#
# When delete_default_rules is false, OpenStack's default outbound rules are
# retained. Therefore, the initial POC can leave egress_rules as an empty map
# unless an additional specific outbound rule is required.
# -----------------------------------------------------------------------------

resource "openstack_networking_secgroup_rule_v2" "egress" {
  for_each = var.egress_rules

  region            = var.region
  direction         = "egress"
  description       = each.value.description
  ethertype         = each.value.ethertype
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min
  port_range_max    = each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  remote_group_id   = each.value.remote_group_id
  security_group_id = openstack_networking_secgroup_v2.this.id
}