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

data "vsphere_virtual_machine" "cba_group_vms" {
  count         = length(var.cba_group_vms)
  name          = var.cba_group_vms[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_compute_cluster_vm_group" "cba_group_name" {
  name                = var.cba_group_name
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = data.vsphere_virtual_machine.cba_group_vms[*].id
}

resource "vsphere_compute_cluster_vm_host_rule" "vm_host_group_ruleset" {
  name                     = var.cba_vm_host_rule
  enabled                  = var.cba_host_group_ruleset_enable
  mandatory                = var.cba_host_group_ruleset_mandatory
  compute_cluster_id       = data.vsphere_compute_cluster.cluster.id
  vm_group_name            = vsphere_compute_cluster_vm_group.cba_group_name.name
  affinity_host_group_name = var.vsphere_host_group
}