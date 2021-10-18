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

resource "vsphere_role" "vra-vsphere" {
  name            = var.vra_vsphere_role
  role_privileges = var.vra_vsphere_privileges
}

resource "vsphere_role" "vro-vsphere" {
  name            = var.vro_vsphere_role
  role_privileges = var.vro_vsphere_privileges
}


