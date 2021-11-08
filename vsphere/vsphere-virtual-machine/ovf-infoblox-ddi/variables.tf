##################################################################################
# VARIABLES
##################################################################################

# vSphere Settings

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_insecure" {
  type        = bool
  description = "Allow insecure connections. Set to true for self-signed certificates."
  default     = false
}
variable "vsphere_host" {
  type        = string
  description = "The fully qualified domain name or IP address of the initial ESXi host."
}
variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. "
}
variable "vsphere_datastore" {
  type        = string
  description = "The target vSphere datastore object name."
}
variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name."
}
variable "vsphere_network" {
  type        = string
  description = "The target vSphere network object name."
}
variable "vsphere_folder" {
  type        = string
  description = "The target vSphere folder object name."
}

# Cloud Proxy Settings

variable "infoblox_ovf_remote" {
  type        = string
  description = "The URL for the cloud proxy OVA file. Leave blank if using local."
  default     = null
}
variable "infoblox_ovf_local" {
  type        = string
  description = "The local path to the cloud proxy OVA file. Leave blank if using remote."
  default     = null
}
variable "infoblox_deployment_option" {
  type        = string
  description = "The deployment option for tge cloud proxy. One of `vra_cloud` or `vra_onprem`"
  default     = "vra_cloud"
}
variable "infoblox_root_password" {
  type        = string
  description = "The password for the root user account."
  sensitive   = true
}
variable "infoblox_name" {
  type        = string
  description = "The name for the virtual appliance in the vSphere inventory."
}
variable "infoblox_remote_console_enabled" {
  type        = string
  description = "Enable SSH on the virtual appliance. One of `True` or `False`."
  default     = "True"
}
variable "infoblox_ip_address" {
  type        = string
  description = "The IP address for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "infoblox_netmask" {
  type        = string
  description = "The netmask or prefix for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "infoblox_gateway" {
  type        = string
  description = "The default gateway address for the virtual appliance. Leave blank if DHCP is desired."
}
variable "infoblox_disk_provisioning" {
  type        = string
  description = "The disk provisioning option for the virtual appliance."
  default     = "thin"
}
variable "infoblox_temp_license" {
  type        = string
  description = "The license for the virtual appliance."
}