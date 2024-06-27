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
  description = "The password for the login to the SDDC Manager instance."
}

# vSphere Objects

variable "vsphere_role" {
  type        = string
  description = "The target vSphere role to be assigned to the Aria Operations (SaaS) service account. (e.g. Aria Operations (SaaS) to vSphere Integration)"
  default     = "Aria Operations (SaaS) to vSphere Integration"
}

variable "service_account" {
  type        = string
  description = "The target service account to assign the role to. (e.g. svc-cbo-vsphere)"
}

# Active Directory

variable "domain_fqdn" {
  type        = string
  description = "The FQDN of the Active Directory domain. (e.g. sfo.rainpole.io)"
}

variable "domain_bind_username" {
  type        = string
  description = "The bind user to login to Active Directory."
}

variable "domain_bind_password" {
  type        = string
  description = "The password for the bind user to login to Active Directory."
}
