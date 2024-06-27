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

data "vra_region" "ca_region" {
  cloud_account_id = data.vra_cloud_account_vsphere.vsphere_cloud_account.id
  region           = sort(data.vra_cloud_account_vsphere.vsphere_cloud_account.regions)[0]
}

data "vra_image" "images" {
  for_each = { for image in var.image_mappings : image.name => image }
  filter   = "name eq '${each.value.image_name}'"
}

##################################################################################
# RESOURCES
##################################################################################

# Create the image mappings in VMware Aria Automation Assembler for a vCenter Server Cloud Account

resource "vra_image_profile" "image_mapping" {
  name      = var.cloud_account_vsphere
  region_id = data.vra_region.ca_region.id
  dynamic "image_mapping" {
    for_each = { for image in var.image_mappings : image.name => image }
    content {
      name     = image_mapping.value["name"]
      image_id = data.vra_image.images[image_mapping.key].id
    }
  }
}