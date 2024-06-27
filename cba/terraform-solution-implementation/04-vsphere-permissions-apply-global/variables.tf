##################################################################################
# VARIABLES
##################################################################################

# VMware Cloud Foundation Credentials

variable "vcf_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the SDDC Manager instance. (e.g. sfo-vcf01.sfo.rainpole.io)"
}

variable "vcf_username" {
  type        = string
  description = "The username to login to the SDDC Manager instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vcf_password" {
  type        = string
  description = "The password for the login to the SDDC Manager instance"
}

# Aria Automation Assembler Role and Service Account

variable "assembler_vsphere_role" {
  type        = string
  description = "The name of the Aria Automation Assembler vSphere custom role. (e.g. Aria Automation Assembler to vSphere Integration)"
  default     = "Aria Automation Assembler to vSphere Integration"
}

variable "assembler_service_account" {
  type        = string
  description = "The target service account to assign the Aria Automation Assembler vSphere custom role to. (e.g. svc-vaa-vsphere@sfo)"
}

# Aria Automation Orchestrator Role and Service Account

variable "orchestrator_vsphere_role" {
  type        = string
  description = "The name of the Automation Orchestrator to vSphere Integration custom role. (e.g. Aria Automation Orchestrator to vSphere Integration)"
  default     = "Aria Automation Orchestrator to vSphere Integration"
}

variable "orchestrator_service_account" {
  type        = string
  description = "The target service account to assign the Aria Automation Orchestrator vSphere custom role to. (e.g. svc-vao-vsphere@sfo)"
}

# Active Directory and Bind User Credentials

variable "domain_fqdn" {
  type        = string
  description = "The FQDN of the Active Directory domain. (e.g. sfo.rainpole.io)"
}

variable "domain_bind_username" {
  type        = string
  description = "The bind user to login to Active Directory"
}

variable "domain_bind_password" {
  type        = string
  description = "The password for the bind user to login to Active Directory"
}
