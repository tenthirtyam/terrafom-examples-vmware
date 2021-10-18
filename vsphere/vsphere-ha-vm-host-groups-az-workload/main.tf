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

data "vsphere_host" "hosts_az_1" {
  count         = length(var.host_group_hosts_az_1)
  name          = var.host_group_hosts_az_1[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "hosts_az_2" {
  count         = length(var.host_group_hosts_az_2)
  name          = var.host_group_hosts_az_2[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vm_group_vms" {
  count         = length(var.vm_group_vms)
  name          = var.vm_group_vms[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

##################################################################################
# RESOURCES
##################################################################################

# Management Domain - Availability Zone 2 Host Group

resource "vsphere_compute_cluster_host_group" "host_group_az_1" {
  name               = var.host_group_name_az_1
  compute_cluster_id = data.vsphere_compute_cluster.cluster.id
  host_system_ids    = data.vsphere_host.hosts_az_1.*.id
}

# Management Domain - Availability Zone 2 Host Group

resource "vsphere_compute_cluster_host_group" "host_group_az_2" {
  name               = var.host_group_name_az_2
  compute_cluster_id = data.vsphere_compute_cluster.cluster.id
  host_system_ids    = data.vsphere_host.hosts_az_2.*.id
}

# Management Domain - VM Group

resource "vsphere_compute_cluster_vm_group" "vm_group" {
  name                = var.vm_group_name
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = data.vsphere_virtual_machine.vm_group_vms[*].id
}

# Management Domain - VM Group to Host Group Should Rule

resource "vsphere_compute_cluster_vm_host_rule" "vm_host_group_ruleset" {
  name                     = var.vm_host_group_ruleset_name
  enabled                  = var.vm_host_group_ruleset_enable
  mandatory                = var.vm_host_group_ruleset_mandatory
  compute_cluster_id       = data.vsphere_compute_cluster.cluster.id
  vm_group_name            = vsphere_compute_cluster_vm_group.vm_group.name
  affinity_host_group_name = vsphere_compute_cluster_host_group.host_group_az_1.name
}