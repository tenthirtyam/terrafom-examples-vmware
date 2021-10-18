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

# vSphere (with Tanzu) Tag

variable "tanzu_vsan_datastore" {
  type        = string
  description = "The target vSphere datastore object name. (e.g. sfo-w01-cl01-ds-vsan01)."
}

variable "tanzu_tag_category_name" {
  type        = string
  description = ""
}

variable "tanzu_tag_catagory_description" {
  type        = string
  description = ""
}

variable "tanzu_tag_catagory_cardinality" {
  type        = string
  description = ""
}

variable "tanzu_tag_catagory_types" {
  type        = list(string)
  description = ""
  default = [
    "Datastore",
  ]
}

variable "tanzu_tag_name" {
  type        = string
  description = ""
}

variable "tanzu_tag_description" {
  type        = string
  description = ""
}

# vSphere (with Tanzu) Datastores

variable "tanzu_datastores" {
  type        = list(string)
  description = ""
  default = [
    "sfo-w01-cl01-vsan01",
  ]
}

# vSphere (with Tanzu) Storage Policy

variable "tanzu_storage_policy_name" {
  type        = string
  description = ""
}

variable "tanzu_storage_policy_description" {
  type        = string
  description = ""
}