##################################################################################
# VARIABLES
##################################################################################

variable "csp_api_token" {
  type        = string
  description = "API token from the VMware Aria Automation endpoint"
}

variable "cep_server" {
  type        = string
  description = "FQDN of the Cloud Extensibility Proxy"
}