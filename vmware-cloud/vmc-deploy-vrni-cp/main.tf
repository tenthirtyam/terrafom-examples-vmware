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

data "vsphere_resource_pool" "pool" {
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

data "vsphere_ovf_vm_template" "ovf" {
  name             = var.cloud_proxy_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  remote_ovf_url   = var.cloud_proxy_ovf_remote
  local_ovf_path   = var.cloud_proxy_ovf_local
  ovf_network_map = {
    "Network 1" : data.vsphere_network.network.id
  }
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_virtual_machine" "cloud_proxy" {
  name                 = var.cloud_proxy_name
  folder               = var.vsphere_folder
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_system_id       = data.vsphere_host.host.id
  num_cpus             = data.vsphere_ovf_vm_template.ovf.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovf.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovf.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf.guest_id
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  ovf_deploy {
    remote_ovf_url    = var.cloud_proxy_ovf_remote
    local_ovf_path    = var.cloud_proxy_ovf_local
    deployment_option = var.cloud_proxy_deployment_option
    disk_provisioning = var.cloud_proxy_disk_provisioning
    ovf_network_map   = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }
  vapp {
    properties = {
      "Proxy_Shared_Secret" = var.cloud_proxy_otk
      "App_Init"            = "VRNICUSTOMPROP:IP_Address=${var.cloud_proxy_ip_address}:Netmask=${var.cloud_proxy_netmask}:Default_Gateway=${var.cloud_proxy_gateway}:DNS=${var.cloud_proxy_dns_servers}:Domain_Search=${var.cloud_proxy_dns_search}:NTP=${var.cloud_proxy_ntp_servers}:Web_Proxy_IP=${var.cloud_proxy_network_proxy_hostname_ip}:Web_Proxy_Port=${var.cloud_proxy_network_proxy_port}:Web_Proxy_Username=${var.cloud_proxy_network_proxy_username}:Web_Proxy_Password=${var.cloud_proxy_network_proxy_password}:Web_Proxy_Authtype=${var.cloud_proxy_network_proxy_auth_type}:SSH_User_Password=${var.cloud_proxy_support_password}:CLI_User_Password=${var.cloud_proxy_console_password}:Enable_Telemetry=${var.cloud_proxy_ceip_enabled}:Auto-Configure=True:VRNICUSTOMPROP",
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
  value = var.cloud_proxy_ip_address
}