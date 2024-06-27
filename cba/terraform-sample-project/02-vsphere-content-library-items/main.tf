##################################################################################
# PROVIDERS
##################################################################################

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA
##################################################################################

data "vsphere_content_library" "content_library" {
  name = var.content_library_name
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_content_library_item" "content_library_item" {
  for_each    = var.content_library_items
  name        = each.value["name"]
  description = each.value["description"]
  file_url    = each.value["file_url"]
  library_id  = data.vsphere_content_library.content_library.id
}