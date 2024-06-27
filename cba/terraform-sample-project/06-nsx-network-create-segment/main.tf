##################################################################################
# PROVIDERS
##################################################################################

provider "nsxt" {
  host                 = var.nsxt_instance
  username             = var.nsxt_username
  password             = var.nsxt_password
  allow_unverified_ssl = var.nsxt_insecure
}

##################################################################################
# DATA
##################################################################################

data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = var.nsxt_transport_zone
}

data "nsxt_policy_tier1_gateway" "t1_gw" {
  display_name = var.nsxt_t1_gw
}

##################################################################################
# RESOURCES
##################################################################################

resource "nsxt_policy_segment" "overlay_segment" {
  for_each            = { for segment in var.nsxt_segments : segment.name => segment }
  display_name        = each.value.name
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path
  connectivity_path   = data.nsxt_policy_tier1_gateway.t1_gw.path
  subnet {
    cidr = each.value.cidr
  }
}