##################################################################################
# OUTPUTS
##################################################################################

output "assembler_role" {
  value = var.assembler_vsphere_role
}

output "assembler_account" {
  value = var.assembler_service_account
}

output "orchestrator_role" {
  value = var.orchestrator_vsphere_role
}

output "orchestrator_account" {
  value = var.orchestrator_service_account
}