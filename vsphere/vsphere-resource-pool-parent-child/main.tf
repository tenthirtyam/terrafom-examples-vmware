terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0.2"
    }
  }
  required_version = ">= 1.0.9"
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

data "vsphere_compute_cluster" "cluster" {
  name          = "m01-cl01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "root" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "parent" {
  depends_on = [
    vsphere_resource_pool.parent
  ]
  name          = "parent"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "child" {
  depends_on = [
    vsphere_resource_pool.child
  ]
  name          = "child"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_resource_pool" "parent" {
  name = "parent"
  parent_resource_pool_id = data.vsphere_resource_pool.root.id
}

resource "vsphere_resource_pool" "child" {
  name = "child"
  parent_resource_pool_id = data.vsphere_resource_pool.parent.id
}