# =============================================================================
# OVHcloud/OpenStack Security Module - Input Variables
#
# This reusable child module creates an OpenStack security group and its
# ingress and egress rules.
#
# Environment-specific values must be supplied by the root environment module:
#
# terraform/environments/dev/
# terraform/environments/test/
# terraform/environments/prod/
#
# Do not hardcode credentials, project IDs, regions, or client-specific
# network ranges inside this reusable module.
# =============================================================================

variable "region" {
  description = "OVHcloud/OpenStack region where the security group will be created."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "The region cannot be empty."
  }
}

variable "security_group_name" {
  description = "Name assigned to the OpenStack security group."
  type        = string
  nullable    = false

  validation {
    condition = can(regex(
      "^[a-z0-9]+(?:-[a-z0-9]+)*$",
      var.security_group_name
    ))

    error_message = "The security group name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "security_group_description" {
  description = "Description assigned to the OpenStack security group."
  type        = string
  default     = "Security group managed by Terraform."
  nullable    = false

  validation {
    condition     = length(trimspace(var.security_group_description)) > 0
    error_message = "The security group description cannot be empty."
  }
}

variable "delete_default_rules" {
  description = "Controls whether the OpenStack default security-group rules are removed."
  type        = bool
  default     = false
  nullable    = false

  # Keep this false during the initial POC.
  #
  # Change it to true only after every required outbound rule has been
  # explicitly defined through the egress_rules variable.
}

variable "ingress_rules" {
  description = "Map of inbound security-group rules supplied by the root environment module."

  type = map(object({
    description      = optional(string, "")
    ethertype        = optional(string, "IPv4")
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
    remote_group_id  = optional(string)
  }))

  default  = {}
  nullable = false

  # ---------------------------------------------------------------------------
  # Ethertype validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      contains(["IPv4", "IPv6"], rule.ethertype)
    ])

    error_message = "Each ingress rule ethertype must be IPv4 or IPv6."
  }

  # ---------------------------------------------------------------------------
  # Protocol validation
  #
  # The protocol may be omitted, but it cannot be an empty string.
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      try(
        rule.protocol == null ||
        length(trimspace(rule.protocol)) > 0,
        false
      )
    ])

    error_message = "An ingress protocol must be omitted or contain a non-empty value."
  }

  # ---------------------------------------------------------------------------
  # Port validation
  #
  # Both port values must:
  #   - Be omitted together for an all-port rule, or
  #   - Be supplied together with a protocol
  #   - Use values between 1 and 65535
  #   - Have a minimum value less than or equal to the maximum value
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      (
        rule.port_range_min == null &&
        rule.port_range_max == null
        ) || try(
        rule.port_range_min != null &&
        rule.port_range_max != null &&
        rule.protocol != null &&
        length(trimspace(rule.protocol)) > 0 &&
        rule.port_range_min >= 1 &&
        rule.port_range_max <= 65535 &&
        rule.port_range_min <= rule.port_range_max,
        false
      )
    ])

    error_message = "Ingress ports must either both be omitted or both be supplied with a protocol using a valid range between 1 and 65535."
  }

  # ---------------------------------------------------------------------------
  # CIDR validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      rule.remote_ip_prefix == null ||
      can(cidrhost(rule.remote_ip_prefix, 0))
    ])

    error_message = "Each ingress remote_ip_prefix must be a valid IPv4 or IPv6 CIDR range."
  }

  # ---------------------------------------------------------------------------
  # Remote-source validation
  #
  # A rule may use either a CIDR source or another security group, but not both.
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      !(
        rule.remote_ip_prefix != null &&
        rule.remote_group_id != null
      )
    ])

    error_message = "An ingress rule cannot use remote_ip_prefix and remote_group_id at the same time."
  }

  # ---------------------------------------------------------------------------
  # Remote security-group ID validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      try(
        rule.remote_group_id == null ||
        length(trimspace(rule.remote_group_id)) > 0,
        false
      )
    ])

    error_message = "An ingress remote_group_id must be omitted or contain a non-empty value."
  }
}

variable "egress_rules" {
  description = "Map of outbound security-group rules supplied by the root environment module."

  type = map(object({
    description      = optional(string, "")
    ethertype        = optional(string, "IPv4")
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
    remote_group_id  = optional(string)
  }))

  default  = {}
  nullable = false

  # ---------------------------------------------------------------------------
  # Ethertype validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      contains(["IPv4", "IPv6"], rule.ethertype)
    ])

    error_message = "Each egress rule ethertype must be IPv4 or IPv6."
  }

  # ---------------------------------------------------------------------------
  # Protocol validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      try(
        rule.protocol == null ||
        length(trimspace(rule.protocol)) > 0,
        false
      )
    ])

    error_message = "An egress protocol must be omitted or contain a non-empty value."
  }

  # ---------------------------------------------------------------------------
  # Port validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      (
        rule.port_range_min == null &&
        rule.port_range_max == null
        ) || try(
        rule.port_range_min != null &&
        rule.port_range_max != null &&
        rule.protocol != null &&
        length(trimspace(rule.protocol)) > 0 &&
        rule.port_range_min >= 1 &&
        rule.port_range_max <= 65535 &&
        rule.port_range_min <= rule.port_range_max,
        false
      )
    ])

    error_message = "Egress ports must either both be omitted or both be supplied with a protocol using a valid range between 1 and 65535."
  }

  # ---------------------------------------------------------------------------
  # CIDR validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      rule.remote_ip_prefix == null ||
      can(cidrhost(rule.remote_ip_prefix, 0))
    ])

    error_message = "Each egress remote_ip_prefix must be a valid IPv4 or IPv6 CIDR range."
  }

  # ---------------------------------------------------------------------------
  # Remote-destination validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      !(
        rule.remote_ip_prefix != null &&
        rule.remote_group_id != null
      )
    ])

    error_message = "An egress rule cannot use remote_ip_prefix and remote_group_id at the same time."
  }

  # ---------------------------------------------------------------------------
  # Remote security-group ID validation
  # ---------------------------------------------------------------------------

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      try(
        rule.remote_group_id == null ||
        length(trimspace(rule.remote_group_id)) > 0,
        false
      )
    ])

    error_message = "An egress remote_group_id must be omitted or contain a non-empty value."
  }
}