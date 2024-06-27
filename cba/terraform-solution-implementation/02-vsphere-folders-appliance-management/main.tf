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

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_folder" "folder" {
  for_each      = var.vsphere_folders
  path          = each.value["path"]
  type          = each.value["type"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}