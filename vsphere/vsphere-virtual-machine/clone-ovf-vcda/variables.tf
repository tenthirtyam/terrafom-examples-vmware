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

# VMware Cloud Director Availability Settings

variable "vcda_local_ovf_path" {
  type        = string
  description = "The local path to the cloud proxy OVA file. Leave blank if using remote."
  default     = null
}

variable "vcda_disk_provisioning" {
  type        = string
  description = "The disk provisioning option for the virtual appliance."
  default     = "thin"
}

variable "vcda_root_password" {
  type        = string
  description = "The password for the root user account."
  sensitive   = true
}
variable "vcda_name" {
  type        = string
  description = "The name for the virtual appliance in the vSphere inventory."
}
variable "vcda_hostname" {
  type        = string
  description = "The hostname for the virtual appliance."
}

variable "vcda_ssh_enabled" {
  type        = string
  description = "Enable SSH on the virtual appliance."
  default     = "False"
}

variable "vcda_ip_address" {
  type        = string
  description = "The IP address in CIDR for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}

variable "vcda_gateway" {
  type        = string
  description = "The default gateway address for the virtual appliance. Leave blank if DHCP is desired."
}
variable "vcda_dns_servers" {
  type        = string
  description = "The DNS server IP addresses (comma separated) for name resolution. Leave blank if DHCP is desired."
}
variable "vcda_ntp_servers" {
  type        = string
  description = "The NTP server fully qualified domain names or IP addresses (comma separated) for time synchronization."
}

variable "vcda_dns_search" {
  type        = string
  description = "The domain search path (comma or space separated domain names) for the virtual appliance. Leave blank if DHCP is desired."
}

variable "vcda_mtu" {
  type        = number
  description = "The maximum transmission unit in bytes (e.g. 1500)."
}

