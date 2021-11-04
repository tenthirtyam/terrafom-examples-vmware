terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0.2"
    }
  }
  required_version = ">= 1.0.10"
}

provider "vsphere" {
  vsphere_server       = "sfo-m01-vc01.rainpole.io"
  user                 = "administrator@vsphere.local"
  password             = "VMware1!"
  allow_unverified_ssl = true
}

##################################################################################
# DATA
##################################################################################

data "vsphere_datacenter" "datacenter" {
  name = "sfo-m01-dc01"
}

data "vsphere_datastore" "datastore" {
  name          = "sfo-m01-dc01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "sfo-m01-cl01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "sfo-m01-esx01.rainpole.io"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = sfo-m01-cl01-vds01-pg-mgmt"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_ovf_vm_template" "ovf" {
  name             = "Nested_ESXi7.0u3_Appliance_Template_v1"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  remote_ovf_url   = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0u3_Appliance_Template_v1.ova"
  ovf_network_map = {
    "Trunk 1" : data.vsphere_network.network.id
    "Trunk 2" : data.vsphere_network.network.id
    "Trunk 3" : data.vsphere_network.network.id
    "Trunk 4" : data.vsphere_network.network.id
  }
}
##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_virtual_machine" "nested_esxi" {
  name                 = "sfo-w01-esx01"
  folder               = "nested"
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_system_id       = data.vsphere_host.host.id
  num_cpus             = data.vsphere_ovf_vm_template.ovf.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovf.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovf.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf.guest_id
  nested_hv_enabled    = data.vsphere_ovf_vm_template.ovf.nested_hv_enabled
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0u3_Appliance_Template_v1.ova"
    disk_provisioning         = "thin"
    ovf_network_map           = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }
  vapp {
    properties = {
      "guestinfo.hostname"  = "sfo-w01-esx01.rainpole.io",
      "guestinfo.ipaddress" = "172.16.11.101",
      "guestinfo.netmask"   = "255.255.255.0",
      "guestinfo.gateway"   = "172.16.11.1",
      "guestinfo.vlan"      = "1611",
      "guestinfo.dns"       = "172.16.11.11",
      "guestinfo.domain"    = "rainpole.io",
      "guestinfo.ntp"       = "172.16.11.11",
      "guestinfo.password"  = "VMware1!"
    }
  }
  lifecycle {
    ignore_changes = [
      annotation,
      disk[0].io_share_count,
      disk[1].io_share_count,
      disk[2].io_share_count,
      vapp[0].properties,
    ]
  }
}
