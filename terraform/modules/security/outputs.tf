# =============================================================================
# OVHcloud/OpenStack Security Module - Outputs
#
# These outputs allow root environment modules and dependent infrastructure
# modules to use the security group created by this reusable child module.
#
# Example dependent modules:
#
#   - Compute instances
#   - Kubernetes worker nodes
#   - Load balancers
#   - Container platform resources
#
# Root modules should use these outputs instead of directly referencing
# resources inside this child module.
# =============================================================================


# -----------------------------------------------------------------------------
# Security-group outputs
# -----------------------------------------------------------------------------

output "security_group_id" {
  description = "Unique ID of the OpenStack security group."
  value       = openstack_networking_secgroup_v2.this.id
}

output "security_group_name" {
  description = "Name of the OpenStack security group."
  value       = openstack_networking_secgroup_v2.this.name
}

output "security_group_description" {
  description = "Description assigned to the OpenStack security group."
  value       = openstack_networking_secgroup_v2.this.description
}

output "security_group_region" {
  description = "OVHcloud/OpenStack region where the security group was created."
  value       = openstack_networking_secgroup_v2.this.region
}


# -----------------------------------------------------------------------------
# Security-group rule outputs
#
# The map keys match the rule names supplied by the root environment module.
#
# Example:
#
# ingress_rule_ids = {
#   allow_https = "rule-id"
#   allow_ssh   = "rule-id"
# }
# -----------------------------------------------------------------------------

output "ingress_rule_ids" {
  description = "Map of ingress-rule names to their OpenStack security-group rule IDs."

  value = {
    for rule_name, rule in openstack_networking_secgroup_rule_v2.ingress :
    rule_name => rule.id
  }
}

output "egress_rule_ids" {
  description = "Map of egress-rule names to their OpenStack security-group rule IDs."

  value = {
    for rule_name, rule in openstack_networking_secgroup_rule_v2.egress :
    rule_name => rule.id
  }
}


# -----------------------------------------------------------------------------
# Rule counts
# -----------------------------------------------------------------------------

output "ingress_rule_count" {
  description = "Number of ingress rules created by this module."
  value       = length(openstack_networking_secgroup_rule_v2.ingress)
}

output "egress_rule_count" {
  description = "Number of egress rules created by this module."
  value       = length(openstack_networking_secgroup_rule_v2.egress)
}


# -----------------------------------------------------------------------------
# Combined security-group summary
#
# This output provides the most commonly required security-group information
# in one object.
# -----------------------------------------------------------------------------

output "security_group_summary" {
  description = "Summary of the OpenStack security group and managed rule IDs."

  value = {
    id          = openstack_networking_secgroup_v2.this.id
    name        = openstack_networking_secgroup_v2.this.name
    description = openstack_networking_secgroup_v2.this.description
    region      = openstack_networking_secgroup_v2.this.region

    ingress_rule_ids = {
      for rule_name, rule in openstack_networking_secgroup_rule_v2.ingress :
      rule_name => rule.id
    }

    egress_rule_ids = {
      for rule_name, rule in openstack_networking_secgroup_rule_v2.egress :
      rule_name => rule.id
    }
  }
}