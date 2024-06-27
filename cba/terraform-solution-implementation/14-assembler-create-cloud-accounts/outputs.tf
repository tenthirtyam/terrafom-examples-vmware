##################################################################################
# OUTPUTS
##################################################################################


output "vsphere_cloud_account" {
    value = var.cloud_accounts_vsphere.account0.name
}

output "nsx_cloud_account" {
    value = var.cloud_accounts_nsx.account0.name
}