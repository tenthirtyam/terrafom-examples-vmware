##################################################################################
# PROVIDERS
##################################################################################

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA
##################################################################################

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name = "${var.vsphere_cluster}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_folder" "folder" {
  for_each      = var.vsphere_folders
  path          = each.value["path"]
  type          = each.value["type"]
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "vsphere_resource_pool" "resource_pool" {
  for_each                = var.vsphere_resource_pools
  name                    = each.value["name"]
  parent_resource_pool_id = "${data.vsphere_compute_cluster.compute_cluster.resource_pool_id}"
}