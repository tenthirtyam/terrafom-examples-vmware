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

/// CLOUD ASSEMBLY

data "vra_zone" "this" {
  for_each = { for zone in var.project_zones : zone.name => zone }
  name     = each.value.name
}

##################################################################################
# RESOURCES
##################################################################################

// CLOUD ASSEMBLY

# Create a project in Cloud Assembly and assign cloud zones.

resource "vra_project" "this" {
  name                    = var.project_name
  description             = var.project_description
  operation_timeout       = var.project_operation_timeout
  machine_naming_template = var.project_machine_naming_template
  dynamic "zone_assignments" {
    for_each = { for zone in var.project_zones : zone.name => zone }
    content {
      zone_id          = data.vra_zone.this[zone_assignments.key].id
      priority         = var.project_zone_priority
      max_instances    = var.project_zone_max_instances
      cpu_limit        = var.project_zone_cpu_limit
      memory_limit_mb  = var.project_zone_memory_limit_mb
      storage_limit_gb = var.project_zone_storage_limit_gb
    }
  }
  dynamic "administrator_roles" {
    for_each = var.project_administrator_roles
    content {
      email = administrator_roles.value["email"]
      type  = administrator_roles.value["type"]
    }
  }
  dynamic "member_roles" {
    for_each = var.project_member_roles
    content {
      email = member_roles.value["email"]
      type  = member_roles.value["type"]
    }
  }
  dynamic "viewer_roles" {
    for_each = var.project_viewer_roles
    content {
      email = viewer_roles.value["email"]
      type  = viewer_roles.value["type"]
    }
  }
}