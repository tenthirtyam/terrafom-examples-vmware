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

variable "cloud_proxy_ovf_remote" {
  type        = string
  description = "The URL for the cloud proxy OVA file. Leave blank if using local."
  default     = null
}
variable "cloud_proxy_ovf_local" {
  type        = string
  description = "The local path to the cloud proxy OVA file. Leave blank if using remote."
  default     = null
}
variable "cloud_proxy_deployment_option" {
  type        = string
  description = "The deployment option for tge cloud proxy. One of `vra_cloud` or `vra_onprem`"
  default     = "vra_cloud"
}
variable "cloud_proxy_otk" {
  type        = string
  description = "The VMware Cloud Services One Time Key (OTK) to register the virtual appliance."
  sensitive   = true
}
variable "cloud_proxy_hostname" {
  type        = string
  description = "The hostname for the virtual machine. Provide the fully qualified domain name if using a static IP. Leave blank to reverse lookup the IP address if using DHCP."
}
variable "cloud_proxy_root_password" {
  type        = string
  description = "The password for the root user account."
  sensitive   = true
}
variable "cloud_proxy_root_password_mindays" {
  type        = number
  description = "The minimum days for the root user account password."
}
variable "cloud_proxy_root_password_maxdays" {
  type        = number
  description = "The maximum days for the root user account password."
}
variable "cloud_proxy_root_password_warndays" {
  type        = number
  description = "The number of days to warn on the root user account password expiration."
}
variable "cloud_proxy_name" {
  type        = string
  description = "The name for the virtual appliance in the vSphere inventory."
}
variable "cloud_proxy_display_name" {
  type        = string
  description = "The display name to identify this cloud proxy in the VMware Cloud Services portal."
}
variable "cloud_proxy_ssh_enabled" {
  type        = string
  description = "Enable SSH on the virtual appliance. One of `True` or `False`."
  default     = "False"
}
variable "cloud_proxy_fips_mode" {
  type        = string
  description = "Enable FIPS Mode for the virtual appliance. One of `disabled` or `enabled`."
  default     = "disabled"
}
variable "cloud_proxy_network_proxy_hostname_ip" {
  type        = string
  description = "The fully qualified domain name or IP address of the network proxy. Leave blank if no network proxy is required."
  default     = null
}
variable "cloud_proxy_network_proxy_port" {
  type        = string
  description = "The port for the network proxy. Leave blank if no network proxy is required."
  default     = null
}
variable "cloud_proxy_network_proxy_username" {
  type        = string
  description = "The username to authentication to the network proxy. Leave blank if no proxy authentication is required. "
  default     = null
  sensitive   = true
}
variable "cloud_proxy_network_proxy_password" {
  type        = string
  description = "The password to authentication to the network proxy. Leave blank if no proxy authentication is required."
  default     = null
  sensitive   = true
}
variable "cloud_proxy_ip_address" {
  type        = string
  description = "The IP address for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_netmask" {
  type        = string
  description = "The netmask or prefix for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_gateway" {
  type        = string
  description = "The default gateway address for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_dns_servers" {
  type        = string
  description = "The DNS server IP addresses (comma separated) for name resolution. Leave blank if DHCP is desired."
}
variable "cloud_proxy_ntp_servers" {
  type        = string
  description = "The NTP server fully qualified domain names or IP addresses (comma separated) for time synchronization."
}
variable "cloud_proxy_domain" {
  type        = string
  description = "The domain name for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_dns_search" {
  type        = string
  description = "The domain search path (comma or space separated domain names) for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_disk_provisioning" {
  type        = string
  description = "The disk provisioning option for the virtual appliance."
  default     = "thin"
}
variable "cloud_proxy_k8s_cluster_cidr" {
  type        = string
  description = "The internal CIDR for pods running in the K8s cluster."
  default     = "10.244.0.0/22"
}
variable "cloud_proxy_k8s_service_cidr" {
  type        = string
  description = "The internal CIDR for services running in the K8s cluster."
  default     = "10.244.4.0/22"
}