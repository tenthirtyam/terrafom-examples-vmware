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
  for_each = var.catalog_sources
  name     = each.value.project_name
}

##################################################################################
# RESOURCES
##################################################################################

// SERVICE BROKER

# Add catalog sources for cloud templates.

resource "vra_catalog_source_blueprint" "this" {
  for_each    = var.catalog_sources
  name        = each.value["name"]
  description = each.value["description"]
  project_id  = data.vra_project.this[each.key].id
}