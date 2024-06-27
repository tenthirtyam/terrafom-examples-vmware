##################################################################################
# OUTPUTS
##################################################################################

output "affinity_host_group_name" {
  value = var.vsphere_host_group
}

output "vm_host_group_ruleset" {
  value = resource.vsphere_compute_cluster_vm_host_rule.vm_host_group_ruleset.name
}

output "cba_group_name" {
  value = resource.vsphere_compute_cluster_vm_group.cba_group_name.name
}