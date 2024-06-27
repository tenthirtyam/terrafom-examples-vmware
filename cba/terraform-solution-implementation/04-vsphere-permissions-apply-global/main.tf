##################################################################################
# PROVIDERS
##################################################################################


##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

resource "null_resource" "assembler_vsphere_role" {
  provisioner "local-exec" {
    command     = "Add-vCenterGlobalPermission -server \"${var.vcf_server}\" -user \"${var.vcf_username}\" -pass \"${var.vcf_password}\" -domain \"${var.domain_fqdn}\" -domainBindUser \"${var.domain_bind_username}\" -domainBindPass \"${var.domain_bind_password}\" -principal \"${var.assembler_service_account}\" -role \"${var.assembler_vsphere_role}\" -propagate true -type user"
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "null_resource" "orchestrator_vsphere_role" {
  provisioner "local-exec" {
    command     = "Add-vCenterGlobalPermission -server \"${var.vcf_server}\" -user \"${var.vcf_username}\" -pass \"${var.vcf_password}\" -domain \"${var.domain_fqdn}\" -domainBindUser \"${var.domain_bind_username}\" -domainBindPass \"${var.domain_bind_password}\" -principal \"${var.orchestrator_service_account}\" -role \"${var.orchestrator_vsphere_role}\" -propagate true -type user"
    interpreter = ["PowerShell", "-Command"]
  }
}