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

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vm" {
  for_each      = var.startup
  name          = each.value["vm"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_ha_vm_override" "ha_vm_override" {
  for_each           = var.startup
  compute_cluster_id = data.vsphere_compute_cluster.cluster.id
  virtual_machine_id = data.vsphere_virtual_machine.vm[each.key].id
  ha_vm_restart_priority = each.value["level"]
}