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

data "vsphere_host" "vsphere_cluster_hosts" {
  count         = length(var.vsphere_cluster_hosts)
  name          = var.vsphere_cluster_hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_nas_datastore" "datastore" {
  for_each        = var.vsphere_datastore_nfs
  type            = var.vsphere_datastore_type
  name            = each.value["name"]
  remote_hosts    = each.value["remote_hosts"]
  remote_path     = each.value["remote_path"]
  access_mode     = var.vsphere_datastore_nfs_access_mode
  folder          = var.vsphere_datastore_nfs_target_folder
  host_system_ids = data.vsphere_host.vsphere_cluster_hosts[*].id
}