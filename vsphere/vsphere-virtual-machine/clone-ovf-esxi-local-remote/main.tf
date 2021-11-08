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
  user                 = "administrator@vsphere.local"
  password             = "VMware1!"
  vsphere_server       = "m01-vc01.rainpole.io"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "m01-dc01"
}

data "vsphere_datastore" "datastore" {
  name          = "local-ssd-02"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "m01-cl01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "m01-esx01.rainpole.io"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "M - 172.16.11.0"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_folder" "folder" {
  path = "/${data.vsphere_datacenter.datacenter.name}/vm"
}

resource "vsphere_virtual_machine" "haproxy" {
count = length(var.haproxy_ips)
name = "${var.servername}"
resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
datastore_id = data.vsphere_datastore.datastore.id
firmware = data.vsphere_virtual_machine.centos8_template.firmware

num_cpus = 4
memory = 8192
guest_id = data.vsphere_virtual_machine.centos8_template.guest_id
memory_hot_add_enabled = true
cpu_hot_remove_enabled = true
cpu_hot_add_enabled = true

folder = "K8S-01"
scsi_type = data.vsphere_virtual_machine.centos8_template.scsi_type

network_interface {
network_id = data.vsphere_network.mrb_far.id
adapter_type = data.vsphere_virtual_machine.centos8_template.network_interface_types[0]
}

disk {
label = "disk0"
size = data.vsphere_virtual_machine.centos8_template.disks.0.size
eagerly_scrub = data.vsphere_virtual_machine.centos8_template.disks.0.eagerly_scrub
thin_provisioned = data.vsphere_virtual_machine.centos8_template.disks.0.thin_provisioned
}

clone {
template_uuid = data.vsphere_virtual_machine.centos8_template.id

customize {
  linux_options {
    host_name = "${var.servername}"
    domain    = "domain.acme"
  }

  network_interface {
    ipv4_address = var.haproxy_ips[count.index]
    ipv4_netmask = 24
  }
  
  dns_server_list = ["1.1.1.1","1.1.1.1"]
  ipv4_gateway    = "1.1.1.1"
}
}
}