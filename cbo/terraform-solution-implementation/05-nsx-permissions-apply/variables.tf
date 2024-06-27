##################################################################################
# VARIABLES
##################################################################################

variable "nsxt_instance" {
  type        = string
  description = "The fully qualified domain name or IP address of the NSX Manager instance. (e.g. sfo-m01-nsx01.sfo.rainpole.io)"
}

variable "nsxt_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. admin)"
  default     = "admin"
}

variable "nsxt_password" {
  type        = string
  description = "The password for the login to the NSX Manager instance."
  sensitive   = true
}

variable "vidm_user" {
  type        = string
  description = "The user/group the role needs to be assigned to. (e.g. svc-cbo-nsx@sfo.rainpole.io)"
}

variable "vidm_type" {
  type        = string
  description = "The type of account. (e.g. remote_user or remote_group)"
}

variable "vidm_identity_source" {
  type        = string
  description = "The Identity Source for user/group. (e.g. LDAP, VIDM or OIDC)"
  default = "VIDM"
}

variable "nsxt_role" {
  type = string
  description = "The NSX role to be assigned. Can be one of the following auditor, enterprise_admin, gi_partner_admin, lb_admin, lb_auditor, network_engineer, network_op, netx_partner_admin, security_engineer, security_op, vpn_admin."
}