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
      "ONE_TIME_KEY"                 = var.cloud_proxy_otk
      "vami.hostname"                = var.cloud_proxy_hostname
      "varoot-password"              = var.cloud_proxy_root_password
      "rdc_name"                     = var.cloud_proxy_display_name
      "va-ssh-enabled"               = var.cloud_proxy_ssh_enabled
      "fips-mode"                    = var.cloud_proxy_fips_mode
      "network_proxy_hostname_or_ip" = var.cloud_proxy_network_proxy_hostname_ip
      "network_proxy_port"           = var.cloud_proxy_network_proxy_port
      "network_proxy_username"       = var.cloud_proxy_network_proxy_username
      "network_proxy_password"       = var.cloud_proxy_network_proxy_password
      "ip0"                          = var.cloud_proxy_ip_address
      "netmask0"                     = var.cloud_proxy_netmask
      "gateway"                      = var.cloud_proxy_gateway
      "DNS"                          = var.cloud_proxy_dns_servers
      "ntp-servers"                  = var.cloud_proxy_ntp_servers
      "domain"                       = var.cloud_proxy_domain
      "searchpath"                   = var.cloud_proxy_dns_search
      "k8s-cluster-cidr"             = var.cloud_proxy_k8s_cluster_cidr
      "k8s-service-cidr"             = var.cloud_proxy_k8s_service_cidr
    }
  }
}

resource "null_resource" "cloud_proxy_init" {

  provisioner "remote-exec" {
    inline = [
      "chage --mindays ${var.cloud_proxy_root_password_mindays} --maxdays ${var.cloud_proxy_root_password_maxdays} --warndays ${var.cloud_proxy_root_password_warndays} root",
    ]
    connection {
      type     = "ssh"
      host     = vsphere_virtual_machine.cloud_proxy.vapp[0].properties.ip0
      user     = "root"
      password = var.cloud_proxy_root_password
      port     = "22"
      agent    = false
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
  value = vsphere_virtual_machine.cloud_proxy.vapp[0].properties.ip0
}