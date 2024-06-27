##################################################################################
# PROVIDERS
##################################################################################


##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

resource "null_resource" "add_vcenter_server" {
  provisioner "local-exec" {
    command     = "Add-CEPvCenterServer -server \"${var.vcf_server}\" -user \"${var.vcf_username}\" -pass \"${var.vcf_password}\" -domain \"${var.vcf_domain}\" -apiToken \"${var.csp_api_token}\" -environment staging -extensibilityProxy \"${var.cep_server}\" -serviceAccount \"${var.orchestrator_service_account}\" -servicePassword \"${var.orchestrator_service_password}\""
    interpreter = ["PowerShell", "-Command"]
  }
}