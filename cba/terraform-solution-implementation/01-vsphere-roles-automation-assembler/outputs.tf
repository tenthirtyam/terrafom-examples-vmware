##################################################################################
# OUTPUTS
##################################################################################

output "assembler_vsphere_role" {
    value = vsphere_role.assembler_vsphere.name
}

output "orchestrator_vsphere_role" {
    value = vsphere_role.orchestrator_vsphere.name
}