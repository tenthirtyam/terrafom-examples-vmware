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
# RESOURCES
##################################################################################

resource "vsphere_role" "vsphere_role" {
  name            = var.vsphere_role
  role_privileges = var.vsphere_privileges
}

