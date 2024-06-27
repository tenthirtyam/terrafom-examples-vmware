##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.aria_automation_url
  refresh_token = var.aria_automation_api_token
  insecure      = var.aria_automation_insecure
}

##################################################################################
# DATA
##################################################################################

data "vra_cloud_account_vsphere" "vsphere_cloud_account" {
  name = var.cloud_account_vsphere
}

data "vra_cloud_account_nsxt" "nsx_cloud_account" {
  name = var.cloud_account_nsxt
}

data "vra_region" "ca_region" {
  cloud_account_id = data.vra_cloud_account_vsphere.vsphere_cloud_account.id
  region           = sort(data.vra_cloud_account_vsphere.vsphere_cloud_account.regions)[0]
}

data "vra_fabric_network" "fabric_network" {
  for_each = var.network_ip_ranges
  filter   = "name eq '${each.value.subnet_name}' and cloudAccountId eq '${data.vra_cloud_account_nsxt.nsx_cloud_account.id}'"
}

##################################################################################
# RESOURCES
##################################################################################

# Add network profile using the IP ranges defined in the plan.

resource "vra_network_profile" "network_profile" {
  name               = var.name
  description        = var.description
  region_id          = data.vra_region.ca_region.id
  fabric_network_ids = [for i in data.vra_fabric_network.fabric_network : i.id]
  isolation_type     = var.isolation_type
  tags {
    key   = "network"
    value = "existing"
  }
}

# Add network IP ranges for internal (non-IPAM) IP address management.

resource "vra_network_ip_range" "network_ip_range" {
  for_each          = var.network_ip_ranges
  fabric_network_id = data.vra_fabric_network.fabric_network[each.key].id
  name              = each.value["ip_range_name"]
  description       = each.value["ip_range_description"]
  start_ip_address  = each.value["start_ip_address"]
  end_ip_address    = each.value["end_ip_address"]
  ip_version        = each.value["ip_version"]
}