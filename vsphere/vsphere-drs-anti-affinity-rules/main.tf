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

data "vsphere_virtual_machine" "ruleset_vms_0" {
  count         = length(var.ruleset_vms_0)
  name          = var.ruleset_vms_0[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_compute_cluster_vm_anti_affinity_rule" "ruleset_0" {
  name                = var.ruleset_name_0
  enabled             = true
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = data.vsphere_virtual_machine.ruleset_vms_0[*].id
}