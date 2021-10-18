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

data "vsphere_virtual_machine" "vm_group_vms_0" {
  count         = length(var.vm_group_vms_0)
  name          = var.vm_group_vms_0[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##################################################################################
# RESOURCES
##################################################################################

# VM Group for vRealize Automation

resource "vsphere_compute_cluster_vm_group" "vm_group_name_0" {
  name                = var.vm_group_name_0                                         // vRealize Automation Virtual Machine Group Name
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = data.vsphere_virtual_machine.vm_group_vms_0[*].id           // vRealize Automation Group Virtual Machines
}

# VM-VM Group Dependency - Cross-instance Workspace ONE Access and vRealize Automation

resource "vsphere_compute_cluster_vm_dependency_rule" "vm_vm_dependency_rule_name_0" {
  compute_cluster_id       = data.vsphere_compute_cluster.cluster.id
  name                     = var.vm_vm_dependency_rule_name_0
  dependency_vm_group_name = var.dependency_vm_group_name_0                          // Cross-instance Workspace ONE Access Virtual Machine Dependency Group Name
  vm_group_name            = vsphere_compute_cluster_vm_group.vm_group_name_0.name   // vRealize Automation Virtual Machine Group Name
}