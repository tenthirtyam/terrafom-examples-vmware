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

variable "server_name" {
  type    = string
  default = "gh-1509"
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



data "vsphere_network" "network" {
  name          = "M - 172.16.11.0"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_folder" "folder" {
  path = "/${data.vsphere_datacenter.datacenter.name}/vm"
}

data "vsphere_virtual_machine" "centos8_template" {
  name          = "tpl-centos-linux-8"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "gh-1509" {
  count            = 3
  name             = "${var.server_name}-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  firmware         = data.vsphere_virtual_machine.centos8_template.firmware

  num_cpus               = 4
  memory                 = 8192
  guest_id               = data.vsphere_virtual_machine.centos8_template.guest_id
  memory_hot_add_enabled = true
  cpu_hot_remove_enabled = true
  cpu_hot_add_enabled    = true

  folder    = trimprefix(data.vsphere_folder.folder.path, "/${data.vsphere_datacenter.datacenter.name}/vm")
  scsi_type = data.vsphere_virtual_machine.centos8_template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.centos8_template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.centos8_template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.centos8_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.centos8_template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.centos8_template.id

    customize {
      linux_options {
        host_name = "${var.server_name}-${count.index}"
        domain    = "rainpole.io"
      }

      network_interface {
        ipv4_address = cidrhost("172.16.11.0/24", 100 + count.index)
        ipv4_netmask = 24
      }

      dns_server_list = ["172.16.11.11", "172.16.11.12"]
      ipv4_gateway    = "172.16.11.1"
    }
  }
}