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

data "vra_cloud_account_vsphere" "this" {
  name = var.cloud_account_vsphere
}

data "vra_region" "this" {
  cloud_account_id = data.vra_cloud_account_vsphere.this.id
  region           = var.region
}

data "vra_image" "this" {
  for_each = { for image in var.image_mappings : image.name => image }
  filter   = "name eq '${each.value.image_name}' and cloudAccountId eq '${data.vra_cloud_account_vsphere.this.id}'"
}

##################################################################################
# RESOURCES
##################################################################################

// CLOUD ASSEMBLY

# Create the image mappings in Cloud Assembly for a vCenter Server cloud account.

resource "vra_image_profile" "this" {
  name      = var.cloud_account_vsphere
  region_id = data.vra_region.this.id
  dynamic "image_mapping" {
    for_each = { for image in var.image_mappings : image.name => image }
    content {
      name     = image_mapping.value["name"]
      image_id = data.vra_image.this[image_mapping.key].id
    }
  }
}