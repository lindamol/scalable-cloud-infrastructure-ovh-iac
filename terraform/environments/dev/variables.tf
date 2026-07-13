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
  description = "OVHcloud region where resources will be deployed."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "The OVHcloud region cannot be empty."
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