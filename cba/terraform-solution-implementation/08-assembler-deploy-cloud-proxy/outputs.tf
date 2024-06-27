##################################################################################
# OUTPUTS
##################################################################################

output "vsphere_datacenter" {
  value = data.vsphere_datacenter.datacenter.name
}

output "vsphere_resource_pool" {
  value = data.vsphere_resource_pool.pool.name
}

output "vsphere_datastore" {
  value = data.vsphere_datastore.datastore.name
}

output "vsphere_folder" {
  value = vsphere_virtual_machine.cloud_proxy.folder
}

output "vsphere_network" {
  value = data.vsphere_network.network.name
}

output "cloud_proxy_name" {
  value = vsphere_virtual_machine.cloud_proxy.name
}

output "cloud_proxy_num_cpus" {
  value = vsphere_virtual_machine.cloud_proxy.num_cpus
}

output "cloud_proxy_num_cores_per_socket" {
  value = vsphere_virtual_machine.cloud_proxy.num_cores_per_socket
}

output "cloud_proxy_mem" {
  value = vsphere_virtual_machine.cloud_proxy.memory
}

output "cloud_proxy_ip_address" {
  value = vsphere_virtual_machine.cloud_proxy.vapp[0].properties.ip0
}
