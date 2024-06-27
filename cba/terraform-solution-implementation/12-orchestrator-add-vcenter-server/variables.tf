##################################################################################
# VARIABLES
##################################################################################

# VCF Credentials

variable "vcf_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the VMware Cloud Foundation instance. (e.g. sfo-vcf01.sfo.rainpole.io)"
}

variable "vcf_username" {
  type        = string
  description = "The username to login to the VMware Cloud Foundation instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vcf_password" {
  type        = string
  description = "The password for the login to the VMware Cloud Foundation instance"
  sensitive   = true
}

variable "vcf_domain" {
  type        = string
  description = "The Workload Domain of the VMware Cloud Foundation instance"
}

variable "csp_api_token" {
  type        = string
  description = "API token for the VMware Aria Automation endpoint"
  sensitive   = true
}

variable "cep_server" {
  type        = string
  description = "FQDN of the Cloud Extensibility Proxy"
}

variable "orchestrator_service_account" {
  type        = string
  description = "Target Aria Automation Orchestrator service account. (e.g. svc-vao-vsphere@sfo.rainpole.io)"
}

variable "orchestrator_service_password" {
  type        = string
  description = "Target Aria Automation Orchestrator service account password"
  sensitive   = true
}