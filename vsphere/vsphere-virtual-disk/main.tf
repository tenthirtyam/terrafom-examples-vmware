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

resource "vsphere_virtual_disk" "gh-1456" {
  size       = 100
  vmdk_path  = "gh-1456/foo.vmdk"
  datacenter = data.vsphere_datacenter.datacenter.name
  datastore  = data.vsphere_datastore.datastore.name
  type       = "eagerZeroedThick"
}