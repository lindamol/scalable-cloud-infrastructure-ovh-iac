# =============================================================================
# Root Provider Configuration
#
# Credentials are read from environment variables.
# Do not hardcode credentials in this file.
# =============================================================================

provider "ovh" {}

provider "openstack" {
  region = var.region
}