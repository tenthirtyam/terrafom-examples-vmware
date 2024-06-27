##################################################################################
# OUTPUTS
##################################################################################

output "content_library_name" {
    value = vsphere_content_library.content_library.name
}

output "content_library_description" {
    value = vsphere_content_library.content_library.description
}
