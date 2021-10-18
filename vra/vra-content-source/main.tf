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

data "vra_project" "this" {
  for_each = var.catalog_sources
  name     = each.value.project_name
}

##################################################################################
# RESOURCES
// Note: UI is 'content source' but provider is 'catalog source'.
##################################################################################

// SERVICE BROKER

# Add catalog sources for cloud templates.

resource "vra_catalog_source_blueprint" "this" {
  for_each    = var.catalog_sources
  name        = each.value["name"]
  description = each.value["description"]
  project_id  = data.vra_project.this[each.key].id
}