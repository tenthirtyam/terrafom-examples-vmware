##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-w01-dc01)."
}

variable "vsphere_cluster_hosts" {
  type        = list(string)
  description = "The target vSphere Cluster hosts."
}

# NFS Datastore Settings

variable "vsphere_cluster_dvs" {
  type        = string
  description = "The vSphere distributed virtual switch."
}

variable "vsphere_cluster_dvpg_name" {
  type        = string
  description = "The vSphere distributed virtual portgroup name."
}

variable "vsphere_cluster_dvpg_vlan_id" {
  type        = string
  description = "The vSphere distributed virtual portgroup VLAN ID."
}

variable "vsphere_cluster_dvpg_mtu" {
  type        = string
  description = "The vSphere distributed virtual portgroup MTU."
  default     = 9000
}

variable "vsphere_cluster_dvpg_netmask" {
  type        = string
  description = "The vSphere distributed virtual portgroup netmask."
}

variable "vsphere_cluster_dvpg_netstack" {
  type        = string
  description = "The vSphere distributed virtual portgroup setstack."
  default     = "defaultTcpipStack"
}