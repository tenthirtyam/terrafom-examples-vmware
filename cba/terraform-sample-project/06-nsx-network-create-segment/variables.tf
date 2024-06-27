##################################################################################
# VARIABLES
##################################################################################

variable "nsxt_instance" {
  type        = string
  description = "The fully qualified domain name or IP address of the NSX Manager instance. (e.g. sfo-w01-nsx01.sfo.rainpole.io)"
}

variable "nsxt_username" {
  type        = string
  description = "The username to login to the NSX Manager instance. (e.g. admin)"
  default     = "admin"
}

variable "nsxt_password" {
  type        = string
  description = "The password for the login to the NSX Manager instance"
  sensitive   = true
}

variable "nsxt_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

variable "nsxt_transport_zone" {
  type        = string
  description = "The NSX transport zone for the workload domain. (e.g. overlay-tz-sfo-w01-nsx01.sfo.rainpole.io)"
}

variable "nsxt_t1_gw" {
  type        = string
  description = "The NSX Tier-1 Gateway for the workload domain. (e.g. sfo-w01-ec01-t1-gw01)"
}

variable "nsxt_segments" {
  type = list(object({
    name = string
    cidr = string
  }))
  description = "A list of objects for the creation of NSX Segments"
}