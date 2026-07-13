# =============================================================================
# OVHcloud Network Module - Outputs
# =============================================================================

output "network_id" {
  description = "OVHcloud private network ID."
  value       = ovh_cloud_project_network_private.this.id
}

output "network_name" {
  description = "Name of the OVHcloud private network."
  value       = ovh_cloud_project_network_private.this.name
}

output "network_openstack_id" {
  description = "Region-specific OpenStack ID of the private network."
  value = one(
    ovh_cloud_project_network_private.this.regions_attributes[*].openstackid
  )
}

output "subnet_id" {
  description = "ID of the private network subnet."
  value       = ovh_cloud_project_network_private_subnet_v2.this.id
}

output "subnet_name" {
  description = "Name of the private network subnet."
  value       = ovh_cloud_project_network_private_subnet_v2.this.name
}

output "subnet_cidr" {
  description = "CIDR range assigned to the subnet."
  value       = ovh_cloud_project_network_private_subnet_v2.this.cidr
}

output "region" {
  description = "OVHcloud region where the network and subnet are created."
  value       = ovh_cloud_project_network_private_subnet_v2.this.region
}

output "gateway_ip" {
  description = "Gateway IP address assigned to the subnet."
  value       = ovh_cloud_project_network_private_subnet_v2.this.gateway_ip
}

output "dhcp_enabled" {
  description = "Indicates whether DHCP is enabled for the subnet."
  value       = ovh_cloud_project_network_private_subnet_v2.this.dhcp
}

output "vlan_id" {
  description = "VLAN ID associated with the private network."
  value       = ovh_cloud_project_network_private.this.vlan_id
}