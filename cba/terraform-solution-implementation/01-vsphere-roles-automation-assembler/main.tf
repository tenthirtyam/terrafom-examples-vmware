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


##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_role" "assembler_vsphere" {
  name            = var.assembler_vsphere_role
  role_privileges = var.assembler_vsphere_privileges
}

resource "vsphere_role" "orchestrator_vsphere" {
  name            = var.orchestrator_vsphere_role
  role_privileges = var.orchestrator_vsphere_privileges
}
