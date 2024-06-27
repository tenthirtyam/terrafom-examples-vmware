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
  for_each = var.cloud_templates
  name     = each.value.project_name
}

data "vra_blueprint" "this" {
  depends_on  = [vra_blueprint.this]
  for_each    = var.cloud_templates
  name        = each.value.name
}

##################################################################################
# RESOURCES
##################################################################################

// VMware Aria Automation Assembler

# Add a cloud template to a project.

resource "vra_blueprint" "this" {
  for_each    = var.cloud_templates
  name        = each.value["name"]
  description = each.value["description"]
  project_id  = data.vra_project.this[each.key].id
  content     = each.value["content"]
}

# Version and release the cloud template.

resource "vra_blueprint_version" "this" {
  depends_on   = [vra_blueprint.this]
  for_each     = var.cloud_templates
  blueprint_id = data.vra_blueprint.this[each.key].id
  change_log   = each.value["release_changelog"]
  description  = each.value["release_description"]
  version      = each.value["release_version"]
  release      = each.value["release_status"]
}