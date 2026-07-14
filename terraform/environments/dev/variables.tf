# =============================================================================
# OVHcloud Development Environment - Input Variables
# =============================================================================

variable "service_name" {
  description = "OVHcloud Public Cloud project ID."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.service_name)) > 0
    error_message = "The OVHcloud Public Cloud project ID cannot be empty."
  }
}

variable "region" {
  description = "OVHcloud/OpenStack region where resources will be deployed."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "The deployment region cannot be empty."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "scalable-cloud-infrastructure"

  validation {
    condition = can(regex(
      "^[a-z0-9]+(?:-[a-z0-9]+)*$",
      var.project_name
    ))

    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}


# =============================================================================
# Network Configuration
# =============================================================================

variable "subnet_cidr" {
  description = "CIDR range assigned to the development subnet."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Subnet CIDR must be a valid IPv4 or IPv6 CIDR range."
  }
}

variable "ip_version" {
  description = "IP version used by the subnet."
  type        = number
  default     = 4
}

variable "vlan_id" {
  description = "Optional VLAN ID used by the private network."
  type        = number
  default     = null
  nullable    = true
}

variable "enable_dhcp" {
  description = "Controls whether DHCP is enabled for the subnet."
  type        = bool
  default     = true
}

variable "dns_nameservers" {
  description = "DNS server addresses assigned to the subnet."
  type        = list(string)
  default     = []
}

variable "allocation_pools" {
  description = "Optional IP allocation pools for the subnet."

  type = list(object({
    start = string
    end   = string
  }))

  default = []
}


# =============================================================================
# Security Configuration
# =============================================================================

variable "delete_default_rules" {
  description = "Controls whether OpenStack default security-group rules are removed."
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "Inbound rules for the development security group."

  type = map(object({
    description      = optional(string, "")
    ethertype        = optional(string, "IPv4")
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
    remote_group_id  = optional(string)
  }))

  default = {}
}

variable "egress_rules" {
  description = "Outbound rules for the development security group."

  type = map(object({
    description      = optional(string, "")
    ethertype        = optional(string, "IPv4")
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
    remote_group_id  = optional(string)
  }))

  default = {}
}