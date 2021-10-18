##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}
variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
}

# vSphere Settings

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-w01-dc01)."
}

variable "vsphere_cluster_hosts" {
  type        = list(string)
  description = "The target vSphere Cluster hosts."
}

# NFS Datastore Settings

variable "vsphere_datastore_type" {
  type        = string
  description = "The datestore type. (NFS == v3 | NFS41 == v4.1)"
  default     = "NFS"
}

variable "vsphere_datastore_nfs_access_mode" {
  type        = string
  description = "The access more for the datastore."
  default     = "readWrite"
}

variable "vsphere_datastore_nfs_target_folder" {
  type        = string
  description = "The target vSphere datastore folder."
}

variable "vsphere_datastore_nfs" {
  type = map(object({
    name         = string
    remote_hosts = list(string)
    remote_path  = string
  }))
  description = "A mapping of objects for NFS datastores and their associated settings."
}