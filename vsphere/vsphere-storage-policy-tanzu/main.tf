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

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_tag_category" "tanzu_tag_category" {
  name             = var.tanzu_tag_category_name
  description      = var.tanzu_tag_catagory_description
  cardinality      = upper(var.tanzu_tag_catagory_cardinality)
  associable_types = var.tanzu_tag_catagory_types
}

resource "vsphere_tag" "tanzu_tag" {
  name        = var.tanzu_tag_name
  category_id = vsphere_tag_category.tanzu_tag_category.id
  description = var.tanzu_tag_description
}

# Need to have the ability here to apply tag(s) to a vSAN datastore resource.
# However, today there's not a 'resource "vsphere_vsan_datastore"' resource.
# A workaround could be to use a Terrform local-exec provisioner to apply the tag(s) to a vSAN datastore resource.

resource "null_resource" "tag_vsan_datastore" {
  depends_on = [
    vsphere_tag.tanzu_tag,
  ]
  provisioner "local-exec" {
    command     = <<EOT
    Connect-VIServer -Server ${var.vsphere_server} -User ${var.vsphere_username} -Password ${var.vsphere_password}
    Write-Host "Assigning vSphere Tag ${var.tanzu_tag_name} to vSAN Datastores."
    Get-Datastore | Where-Object -Property Name -eq ${var.tanzu_vsan_datastore} | New-TagAssignment -Tag ${var.tanzu_tag_name} | Out-Null
    Write-Host "Completed."
    Disconnect-VIServer -Server ${var.vsphere_server} 
    EOT 
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "vsphere_vm_storage_policy" "tanzu_storage_policy" {
  name        = var.tanzu_storage_policy_name
  description = var.tanzu_storage_policy_description

  tag_rules {
    tag_category                 = vsphere_tag_category.tanzu_tag_category.name
    tags                         = [vsphere_tag.tanzu_tag.name]
    include_datastores_with_tags = true
  }
}
