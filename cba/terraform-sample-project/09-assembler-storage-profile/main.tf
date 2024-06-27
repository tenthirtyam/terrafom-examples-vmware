##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.aria_automation_url
  refresh_token = var.aria_automation_api_token
  insecure      = var.aria_automation_insecure
}

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA
##################################################################################

data "vra_cloud_account_vsphere" "this" {
  for_each = var.storage_profile_vsphere
  name     = each.value.cloud_account_name
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vra_region" "this" {
  for_each         = var.storage_profile_vsphere
  cloud_account_id = data.vra_cloud_account_vsphere.this[each.key].id
  region           = sort(data.vra_cloud_account_vsphere.this[each.key].regions)[0]
}

data "vra_fabric_datastore_vsphere" "this" {
  for_each = var.storage_profile_vsphere
  filter   = "name eq '${each.value["datastore"]}' and cloudAccountId eq '${data.vra_cloud_account_vsphere.this[each.key].id}'"
}

data "vra_fabric_storage_policy_vsphere" "this" {
  for_each = var.storage_profile_vsphere
  filter   = "name eq '${each.value["storage_policy"]}' and cloudAccountId eq '${data.vra_cloud_account_vsphere.this[each.key].id}'"
}

##################################################################################
# RESOURCES
##################################################################################

# Add storage profiles to VMware Aria Automation Assembler for a vSAN Datastores in a vCenter Server Cloud Account.

resource "vra_storage_profile_vsphere" "this" {
  for_each          = var.storage_profile_vsphere
  region_id         = data.vra_region.this[each.key].id
  name              = each.value["name"]
  description       = "Storage Profile for ${each.value.cloud_account_name}"
  disk_type         = each.value["disk_type"]
  default_item      = each.value["default_item"]
  provisioning_type = each.value["provisioning_type"]
  datastore_id      = data.vra_fabric_datastore_vsphere.this[each.key].id
  storage_policy_id = data.vra_fabric_storage_policy_vsphere.this[each.key].id
  tags {
    key   = "storage"
    value = each.value["tag_tier"]
  }
}