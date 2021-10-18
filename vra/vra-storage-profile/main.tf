##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.vra_url
  refresh_token = var.vra_api_token
  insecure      = var.vra_insecure
}

##################################################################################
# DATA
##################################################################################

// CLOUD ASSEMBLY

data "vra_cloud_account_vsphere" "this" {
  for_each = var.storage_profile_vsphere
  name     = each.value.cloud_account_name
}

data "vra_region" "this" {
  for_each         = var.storage_profile_vsphere
  cloud_account_id = data.vra_cloud_account_vsphere.this[each.key].id
  region           = each.value.cloud_account_region
}

data "vra_fabric_datastore_vsphere" "this" {
  for_each   = var.storage_profile_vsphere
  filter     = "name eq '${each.value["datastore"]}' and cloudAccountId eq '${data.vra_cloud_account_vsphere.this[each.key].id}'"
}

data "vra_fabric_storage_policy_vsphere" "this" {
  for_each   = var.storage_profile_vsphere
  filter     = "name eq '${each.value["storage_policy"]}' and cloudAccountId eq '${data.vra_cloud_account_vsphere.this[each.key].id}'"
}

##################################################################################
# RESOURCES
##################################################################################

// CLOUD ASSEMBLY

# Add storage profiles in Cloud Assembly for a vSAN Datastores in a vCenter Server cloud account.

resource "vra_storage_profile_vsphere" "this" {
  for_each          = var.storage_profile_vsphere
  region_id         = data.vra_region.this[each.key].id
  name              = each.value["name"]
  description       = each.value["description"]
  disk_type         = each.value["disk_type"]
  default_item      = each.value["default_item"]
  provisioning_type = each.value["provisioning_type"]
  datastore_id      = data.vra_fabric_datastore_vsphere.this[each.key].id
  storage_policy_id = data.vra_fabric_storage_policy_vsphere.this[each.key].id
  tags {
    key   = "tier"
    value = each.value["tag_tier"]
  }
}