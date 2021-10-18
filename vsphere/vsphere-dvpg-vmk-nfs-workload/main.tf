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

data "vsphere_distributed_virtual_switch" "vsphere_cluster_dvs" {
  name          = var.vsphere_cluster_dvs
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_distributed_port_group" "vsphere_cluster_dvpg" {
  name                            = var.vsphere_cluster_dvpg_name
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vsphere_cluster_dvs.id
  vlan_id                         = var.vsphere_cluster_dvpg_vlan_id
  active_uplinks                  = ["uplink1", "uplink2"]
  standby_uplinks                 = []
}

resource "vsphere_vnic" "vsphere_cluster_dvs_vmk" {
  count                   = "${length(var.vsphere_cluster_hosts)}"
  host                    = "${element(data.vsphere_host.vsphere_cluster_hosts.*.id, count.index)}"
  distributed_switch_port = data.vsphere_distributed_virtual_switch.vsphere_cluster_dvs.id
  distributed_port_group  = vsphere_distributed_port_group.vsphere_cluster_dvpg.id
  ipv4 {
    ip      = "192.168.176.${count.index + 73}" // <--- change this! :)
    netmask = var.vsphere_cluster_dvpg_netmask
  }
  netstack = var.vsphere_cluster_dvpg_netstack
  mtu      = var.vsphere_cluster_dvpg_mtu
}

##################################################################################
# OUTPUTS
##################################################################################