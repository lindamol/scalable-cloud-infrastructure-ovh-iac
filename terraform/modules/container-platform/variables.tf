# =============================================================================
# OVHcloud Container Platform Module - Input Variables
# =============================================================================


# =============================================================================
# General Cluster Configuration
# =============================================================================

variable "service_name" {
  description = "OVHcloud Public Cloud project ID."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.service_name)) > 0
    error_message = "service_name must not be empty."
  }
}

variable "region" {
  description = "OVHcloud region where the Kubernetes cluster will be created."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region must not be empty."
  }
}

variable "cluster_name" {
  description = "Name of the OVHcloud Managed Kubernetes cluster."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "cluster_plan" {
  description = "OVHcloud Managed Kubernetes plan."
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "standard"], var.cluster_plan)
    error_message = "cluster_plan must be either free or standard using lowercase letters."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version to use. Null allows OVHcloud to select an available version."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.kubernetes_version == null ||
      length(trimspace(var.kubernetes_version)) > 0
    )

    error_message = "kubernetes_version must be null or a non-empty version string."
  }
}


# =============================================================================
# Private Network Configuration
# =============================================================================

variable "private_network_id" {
  description = "Regional OpenStack ID of the OVHcloud private network."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.private_network_id)) > 0
    error_message = "private_network_id must not be empty."
  }
}

variable "nodes_subnet_id" {
  description = "ID of the private subnet used by the Kubernetes worker nodes."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.nodes_subnet_id)) > 0
    error_message = "nodes_subnet_id must not be empty."
  }
}

variable "default_vrack_gateway" {
  description = "Custom vRack gateway address. An empty string means no custom gateway is configured."
  type        = string
  default     = ""
}

variable "private_network_routing_as_default" {
  description = "Controls whether the private network interface is used as the default route for worker nodes."
  type        = bool
  default     = false
}


# =============================================================================
# Worker Node-Pool Configuration
# =============================================================================

variable "node_pool_name" {
  description = "Name of the Kubernetes worker-node pool."
  type        = string
  default     = "dev-pool"

  validation {
    condition = can(regex(
      "^[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$",
      var.node_pool_name
    ))

    error_message = "node_pool_name may contain only letters, numbers, and hyphens."
  }
}

variable "node_flavor" {
  description = "OVHcloud compute flavor used by the worker nodes."
  type        = string
  default     = "b3-8"

  validation {
    condition     = length(trimspace(var.node_flavor)) > 0
    error_message = "node_flavor must not be empty."
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

    error_message = "desired_nodes must be a non-negative whole number."
  }
}

variable "min_nodes" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1

  validation {
    condition = (
      var.min_nodes >= 0 &&
      floor(var.min_nodes) == var.min_nodes
    )

    error_message = "min_nodes must be a non-negative whole number."
  }
}

variable "max_nodes" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 1

  validation {
    condition = (
      var.max_nodes >= 0 &&
      floor(var.max_nodes) == var.max_nodes
    )

    error_message = "max_nodes must be a non-negative whole number."
  }
}

variable "autoscale" {
  description = "Controls whether OVHcloud worker-node autoscaling is enabled."
  type        = bool
  default     = false
}

variable "monthly_billed" {
  description = "Controls whether worker nodes use monthly billing. False means hourly billing."
  type        = bool
  default     = false
}

variable "anti_affinity" {
  description = "Controls whether anti-affinity is enabled for worker nodes."
  type        = bool
  default     = false
}


# =============================================================================
# Kubernetes API Access Configuration
# =============================================================================

variable "api_allowed_cidrs" {
  description = "Public CIDR ranges authorized to access the Kubernetes API."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.api_allowed_cidrs :
      can(cidrhost(cidr, 0))
    ])

    error_message = "Every api_allowed_cidrs value must be a valid CIDR, such as 203.0.113.10/32."
  }
}