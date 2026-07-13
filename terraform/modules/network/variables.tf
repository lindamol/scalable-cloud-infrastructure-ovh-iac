# =============================================================================
# OVHcloud Network Module - Input Variables
#
# This module contains the reusable network inputs for the project.
# Environment-specific values must be passed from:
#
# terraform/environments/dev/
#
# Do not hardcode credentials, project IDs, regions, or network ranges here.
# =============================================================================

variable "service_name" {
  description = "OVHcloud Public Cloud project ID."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.service_name)) > 0
    error_message = "The OVHcloud Public Cloud project ID cannot be empty."
  }

  # TODO:
  # Kevares must provide the real OVHcloud Public Cloud project ID.
  # The value will be added to the real terraform.tfvars file or passed
  # securely through the CI/CD pipeline.
}

variable "region" {
  description = "OVHcloud region where the network will be created."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "The OVHcloud region cannot be empty."
  }

  # TODO:
  # Replace the placeholder region after Kevares confirms:
  # - Approved OVHcloud region
  # - Available services in that region
  # - Resource quotas
  # - Data residency requirements
}

variable "network_name" {
  description = "Name of the private network."
  type        = string
  nullable    = false

  validation {
    condition = can(regex(
      "^[a-z0-9]+(?:-[a-z0-9]+)*$",
      var.network_name
    ))

    error_message = "Network name must contain only lowercase letters, numbers, and hyphens."
  }

  # Example:
  # scalable-cloud-infrastructure-dev-network
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
  nullable    = false

  validation {
    condition = can(regex(
      "^[a-z0-9]+(?:-[a-z0-9]+)*$",
      var.subnet_name
    ))

    error_message = "Subnet name must contain only lowercase letters, numbers, and hyphens."
  }

  # TODO:
  # Confirm whether Kevares expects:
  # - One subnet for the initial POC
  # - Separate public and private subnets
  # - Separate application, database, and management subnets
  # - Separate subnets for dev, test, and prod
}

variable "subnet_cidr" {
  description = "CIDR range assigned to the subnet."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Subnet CIDR must be a valid IPv4 or IPv6 CIDR range."
  }

  # TODO:
  # Confirm the approved network CIDR with Kevares before deployment.
  #
  # Example only:
  # 10.10.1.0/24
  #
  # The CIDR must not overlap with:
  # - Other OVHcloud networks
  # - Company networks
  # - VPN-connected networks
  # - Future dev, test, or prod environments
}

variable "ip_version" {
  description = "IP version used by the subnet."
  type        = number
  default     = 4
  nullable    = false

  validation {
    condition     = contains([4, 6], var.ip_version)
    error_message = "IP version must be either 4 or 6."
  }

  # TODO:
  # IPv4 is used by default.
  # Enable IPv6 only if Kevares confirms it is required and supported
  # by the selected OVHcloud services.
}

variable "vlan_id" {
  description = "Optional VLAN ID used by the private network."
  type        = number
  default     = null
  nullable    = true

  validation {
    condition = (
      var.vlan_id == null ||
      (var.vlan_id >= 1 && var.vlan_id <= 4094)
    )

    error_message = "VLAN ID must be null or a number between 1 and 4094."
  }

  # TODO:
  # Set this value only after Kevares confirms:
  # - That the selected network implementation requires a VLAN ID
  # - That the VLAN ID is available
  # - That it does not conflict with another environment or network
}

variable "enable_dhcp" {
  description = "Controls whether DHCP is enabled for the subnet."
  type        = bool
  default     = true
  nullable    = false

  # TODO:
  # Keep DHCP enabled for the initial POC unless Kevares requires
  # static IP management or another addressing strategy.
}

variable "dns_nameservers" {
  description = "DNS server IP addresses assigned to the subnet."
  type        = list(string)
  default     = []
  nullable    = false

  # TODO:
  # Confirm whether the project should use:
  # - OVHcloud-provided DNS
  # - Public DNS servers
  # - Kevares internal DNS servers
  #
  # Keep this empty until the DNS requirement is confirmed.
}

variable "allocation_pools" {
  description = "Optional IP allocation ranges for the subnet."

  type = list(object({
    start = string
    end   = string
  }))

  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for pool in var.allocation_pools :
      length(trimspace(pool.start)) > 0 &&
      length(trimspace(pool.end)) > 0
    ])

    error_message = "Each allocation pool must contain a start and end IP address."
  }

  # TODO:
  # Add allocation pools only after the subnet CIDR and IP-addressing
  # strategy are approved.
  #
  # Example:
  #
  # allocation_pools = [
  #   {
  #     start = "10.10.1.20"
  #     end   = "10.10.1.200"
  #   }
  # ]
  #
  # Reserve addresses for gateways, load balancers, management systems,
  # and other infrastructure where required.
}