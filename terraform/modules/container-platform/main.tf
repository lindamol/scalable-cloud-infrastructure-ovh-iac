resource "ovh_cloud_project_kube" "this" {
  service_name = var.service_name
  name         = var.cluster_name
  region       = var.region
  plan         = var.cluster_plan
  version      = var.kubernetes_version

  private_network_id = var.private_network_id
  nodes_subnet_id    = var.nodes_subnet_id

  private_network_configuration {
    default_vrack_gateway              = var.default_vrack_gateway
    private_network_routing_as_default = var.private_network_routing_as_default
  }

  timeouts {
    create = "60m"
    update = "45m"
    delete = "30m"
  }
}

resource "ovh_cloud_project_kube_nodepool" "this" {
  service_name = var.service_name
  kube_id      = ovh_cloud_project_kube.this.id

  name        = var.node_pool_name
  flavor_name = var.node_flavor

  desired_nodes = var.desired_nodes
  min_nodes     = var.min_nodes
  max_nodes     = var.max_nodes

  autoscale      = var.autoscale
  monthly_billed = var.monthly_billed
  anti_affinity  = var.anti_affinity

  lifecycle {
    precondition {
      condition     = var.min_nodes <= var.desired_nodes
      error_message = "desired_nodes must be greater than or equal to min_nodes."
    }

    precondition {
      condition     = var.desired_nodes <= var.max_nodes
      error_message = "desired_nodes must be less than or equal to max_nodes."
    }
  }

  timeouts {
    create = "60m"
    update = "45m"
    delete = "30m"
  }
}

resource "ovh_cloud_project_kube_iprestrictions" "this" {
  count = length(var.api_allowed_cidrs) > 0 ? 1 : 0

  service_name = var.service_name
  kube_id      = ovh_cloud_project_kube.this.id
  ips          = var.api_allowed_cidrs
}