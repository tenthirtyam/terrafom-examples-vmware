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

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_content_library" "content_library" {
  name            = var.vsphere_content_library_name
  description     = var.vsphere_content_library_description
  storage_backing = toset([data.vsphere_datastore.datastore.id])
  publication {
    authentication_method = var.vsphere_content_library_auth
    published             = var.vsphere_content_library_published
  }
}