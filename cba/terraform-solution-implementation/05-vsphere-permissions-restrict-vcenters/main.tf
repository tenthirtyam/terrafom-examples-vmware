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

data "vsphere_folder" "folder" {
  path = var.folder_path
}

data "vsphere_role" "role_name" {
  label = var.role_name
}

##################################################################################
# RESOURCES
##################################################################################


resource "vsphere_entity_permissions" "vcenter-assembler-user" {
  entity_id   = data.vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.assembler_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "vcenter-orchestrator-user" {
  entity_id   = data.vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.orchestrator_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}
