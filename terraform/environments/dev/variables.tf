# =============================================================================
# OVHcloud Development Environment - Input Variables
# =============================================================================


# =============================================================================
# General Project Configuration
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

  validation {
    condition     = contains([4, 6], var.ip_version)
    error_message = "IP version must be either 4 or 6."
  }
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


# =============================================================================
# Managed Kubernetes Configuration
# =============================================================================

variable "cluster_plan" {
  description = "OVHcloud Managed Kubernetes service plan."
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "standard"], var.cluster_plan)
    error_message = "cluster_plan must be either free or standard using lowercase letters."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version used by the OVHcloud Managed Kubernetes cluster. Null allows OVHcloud to select an available version."
  type        = string
  default     = null
  nullable    = true
}

variable "node_pool_name" {
  description = "Name of the Kubernetes worker-node pool."
  type        = string
  default     = "dev-pool"

  validation {
    condition = can(regex(
      "^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$",
      var.node_pool_name
    ))

    error_message = "Node-pool name must contain only letters, numbers, and hyphens."
  }
}

variable "node_flavor" {
  description = "OVHcloud instance flavor used by Kubernetes worker nodes."
  type        = string
  default     = "b3-8"

  validation {
    condition     = length(trimspace(var.node_flavor)) > 0
    error_message = "Node flavor cannot be empty."
  }
}

variable "desired_nodes" {
  description = "Initial desired number of worker nodes."
  type        = number
  default     = 1

  validation {
    condition = (
      var.desired_nodes >= 0 &&
      floor(var.desired_nodes) == var.desired_nodes
    )

    error_message = "Desired nodes must be a non-negative whole number."
  }
}

variable "min_nodes" {
  description = "Minimum number of worker nodes in the node pool."
  type        = number
  default     = 1

  validation {
    condition = (
      var.min_nodes >= 0 &&
      floor(var.min_nodes) == var.min_nodes
    )

    error_message = "Minimum nodes must be a non-negative whole number."
  }
}

variable "max_nodes" {
  description = "Maximum number of worker nodes in the node pool."
  type        = number
  default     = 1

  validation {
    condition = (
      var.max_nodes >= 0 &&
      floor(var.max_nodes) == var.max_nodes
    )

    error_message = "Maximum nodes must be a non-negative whole number."
  }
}

variable "node_autoscale" {
  description = "Controls whether OVHcloud worker-node autoscaling is enabled."
  type        = bool
  default     = false
}

variable "monthly_billed" {
  description = "Controls whether worker nodes use monthly billing. False uses hourly billing."
  type        = bool
  default     = false
}

variable "api_allowed_cidrs" {
  description = "Public CIDR ranges authorized to access the Kubernetes API. Team public IP addresses should normally use /32."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.api_allowed_cidrs :
      can(cidrhost(cidr, 0))
    ])

    error_message = "Each Kubernetes API access value must be a valid CIDR, such as 203.0.113.10/32."
  }
}