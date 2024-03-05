terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.19.1"
    }
  }
}

####################################
# CSP API Client Configuration
####################################
provider "restapi" {
  alias                = "csp"
  uri                  = var.csp_uri
  debug                = var.debug
  write_returns_object = true

  headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }

  create_method = "POST"
}

# Retreive CSP Access Token
resource "restapi_object" "retrieve_access_token" {
  provider     = restapi.csp
  path         = "/csp/gateway/am/api/auth/api-tokens/authorize?refresh_token=${var.refresh_token}"
  data         = ""
  id_attribute = "expires_in"
}

####################################
# VMC API Client Configuration
####################################
provider "restapi" {
  alias                = "vmc"
  uri                  = var.vmc_uri
  debug                = var.debug
  write_returns_object = true

  headers = {
    csp-auth-token = restapi_object.retrieve_access_token.api_data.access_token
    Content-Type   = "application/json"
  }
}

# Retreive SDDC Cluster ID
resource "restapi_object" "get_sddc_cluster" {
  depends_on    = [restapi_object.retrieve_access_token]
  create_method = "GET"

  provider = restapi.vmc
  path     = "/vmc/api/orgs/${var.org_id}/sddcs/${var.sddc_id}"
  data     = ""
}

# Store Cluster Id for use in the activation step
locals {
  cluster_id = [for cluster in jsondecode(restapi_object.get_sddc_cluster.api_response).resource_config.clusters : cluster.cluster_id if cluster.cluster_name == var.cluster_name][0]
}

output "debug_cluster_id" {
  value = local.cluster_id
}

# Activate Tanzu service on SDDC Cluster
resource "restapi_object" "activate_tanzu_service" {
  depends_on    = [restapi_object.retrieve_access_token, local.cluster_id]
  create_method = "POST"

  provider = restapi.vmc
  path     = "/api/wcp/v1/orgs/${var.org_id}/deployments/${var.sddc_id}/clusters/${local.cluster_id}/operations/enable-wcp"
  data     = "{\"ingress_cidr\":[\"${var.ingress_cidr}\"],\"egress_cidr\": [\"${var.egress_cidr}\"],\"service_cidr\": \"${var.service_cidr}\",\"namespace_cidr\": [\"${var.namespace_cidr}\"]}"
}

output "tanzu_service_activation_task" {
  value = restapi_object.activate_tanzu_service.api_data
}