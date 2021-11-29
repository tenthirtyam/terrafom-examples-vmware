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

data "vsphere_resource_pool" "default" {
  name          = format("%s%s", var.vsphere_cluster, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_folder" "folder" {
  path = "/${data.vsphere_datacenter.datacenter.name}/vm"
}

##################################################################################
# RESOURCES
##################################################################################

data "vsphere_ovf_vm_template" "ovfLocal" {
  name              = "foo"
  disk_provisioning = var.infoblox_disk_provisioning
  resource_pool_id  = data.vsphere_resource_pool.default.id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.host.id
  local_ovf_path    = var.infoblox_ovf_local
  ovf_network_map = {
    "VM Network" : data.vsphere_network.network.id
  }
}

## Deployment of VM from Local OVF
resource "vsphere_virtual_machine" "infoblox" {
  name                 = var.infoblox_name
  folder               = trimprefix(data.vsphere_folder.folder.path, "/${data.vsphere_datacenter.datacenter.name}/vm")
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id
  num_cpus             = data.vsphere_ovf_vm_template.ovfLocal.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovfLocal.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovfLocal.memory
  guest_id             = data.vsphere_ovf_vm_template.ovfLocal.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovfLocal.scsi_type
  
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    local_ovf_path    = data.vsphere_ovf_vm_template.ovfLocal.local_ovf_path
    disk_provisioning = data.vsphere_ovf_vm_template.ovfLocal.disk_provisioning
    ovf_network_map   = data.vsphere_ovf_vm_template.ovfLocal.ovf_network_map
    deployment_option = var.infoblox_deployment_option
  }

  vapp {
    properties = {
      "default_admin_password" = var.infoblox_root_password
      "lan1-v4_addr"           = var.infoblox_ip_address
      "lan1-v4_netmask"        = var.infoblox_netmask
      "lan1-v4_gw"             = var.infoblox_gateway
      "temp_license"           = var.infoblox_temp_license
      "remote_console_enabled" = var.infoblox_remote_console_enabled
    }
  }
}

##################################################################################
# OUTPUTS
##################################################################################

output "vsphere_datacenter" {
  value = data.vsphere_datacenter.datacenter.name
}

output "vsphere_resource_pool" {
  value = data.vsphere_resource_pool.default.name
}

output "vsphere_datastore" {
  value = data.vsphere_datastore.datastore.name
}

output "vsphere_folder" {
  value = vsphere_virtual_machine.infoblox.folder
}

output "vsphere_network" {
  value = data.vsphere_network.network.name
}

output "infoblox_name" {
  value = vsphere_virtual_machine.infoblox.name
}

output "infoblox_num_cpus" {
  value = vsphere_virtual_machine.infoblox.num_cpus
}

output "infoblox_num_cores_per_socket" {
  value = vsphere_virtual_machine.infoblox.num_cores_per_socket
}

output "infoblox_mem" {
  value = vsphere_virtual_machine.infoblox.memory
}

output "infoblox_ip_address" {
  value = vsphere_virtual_machine.infoblox.vapp[0].properties.lan1-v4_addr
}
