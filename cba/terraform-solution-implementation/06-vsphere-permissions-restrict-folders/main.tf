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

data "vsphere_folder" "edge_folder" {
  path = "/${var.vsphere_datacenter}/vm/${var.edge_folder}"
}

data "vsphere_folder" "storage_local_folder" {
  path = "/${var.vsphere_datacenter}/datastore/${var.local_storage_folder}"
}

data "vsphere_folder" "storage_readonly_folder" {
  path = "/${var.vsphere_datacenter}/datastore/${var.readonly_storage_folder}"
}

data "vsphere_role" "role_name" {
  label = var.role_name
}

##################################################################################
# RESOURCES
##################################################################################


resource "vsphere_entity_permissions" "edge-assembler-user" {
  entity_id   = data.vsphere_folder.edge_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.assembler_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "storage-local-assembler-user" {
  entity_id   = data.vsphere_folder.storage_local_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.assembler_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "storage-readonly-assembler-user" {
  entity_id   = data.vsphere_folder.storage_readonly_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.assembler_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "edge-orchestrator-user" {
  entity_id   = data.vsphere_folder.edge_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.orchestrator_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "storage-local-orchestrator-user" {
  entity_id   = data.vsphere_folder.storage_local_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.orchestrator_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "storage-readonly-orchestrator-user" {
  entity_id   = data.vsphere_folder.storage_readonly_folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.orchestrator_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}


