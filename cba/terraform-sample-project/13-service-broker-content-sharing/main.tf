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

// CLOUD ASSEMBLY

data "vra_project" "this" {
  for_each = var.catalog_source_entitlements
  name     = each.value.project_name
}

// SERVICE BROKER

data "vra_catalog_source_blueprint" "this" {
  for_each   = var.catalog_source_entitlements
  name       = each.value.source_name
}

##################################################################################
# RESOURCES
// Note: UI is 'content source' but provider is 'catalog source'.
##################################################################################

// SERVICE BROKER

# Add catalog source entitlements for cloud templates.

resource "vra_catalog_source_entitlement" "this" {
  for_each          = var.catalog_source_entitlements
  catalog_source_id = data.vra_catalog_source_blueprint.this[each.key].id
  project_id        = data.vra_project.this[each.key].id
}