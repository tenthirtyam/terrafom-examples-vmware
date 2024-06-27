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

data "vra_zone" "this" {
  for_each = { for zone in var.project_zones : zone.name => zone }
  name     = each.value.name
}

##################################################################################
# RESOURCES
##################################################################################

# Create a project in VMware Aria Automation Assembler and assign cloud zones.

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
}