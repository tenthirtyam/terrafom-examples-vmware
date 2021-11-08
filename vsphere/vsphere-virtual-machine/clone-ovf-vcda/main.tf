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

data "vsphere_ovf_vm_template" "vcda_onprem" {
  name             = var.vcda_hostname
  resource_pool_id = data.vsphere_resource_pool.default.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  local_ovf_path   = var.vcda_local_ovf_path
  ovf_network_map = {
    "VM Network" : data.vsphere_network.network.id
  }
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_virtual_machine" "vcda_onprem" {
  name                 = var.vcda_name
  resource_pool_id     = data.vsphere_resource_pool.default.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  num_cpus             = data.vsphere_ovf_vm_template.vcda_onprem.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.vcda_onprem.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.vcda_onprem.memory
  guest_id             = data.vsphere_ovf_vm_template.vcda_onprem.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.vcda_onprem.scsi_type
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.vcda_onprem.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  ovf_deploy {
    local_ovf_path    = var.vcda_local_ovf_path
    disk_provisioning = var.vcda_disk_provisioning
    ovf_network_map   = data.vsphere_ovf_vm_template.vcda_onprem.ovf_network_map
  }

  vapp {
    properties = {
      "guestinfo.cis.appliance.root.password" = var.vcda_root_password,
      "guestinfo.cis.appliance.ssh.enabled"   = var.vcda_ssh_enabled,
      "hostname"                              = var.vcda_hostname,
      "address"                               = var.vcda_ip_address,
      "gateway"                               = var.vcda_gateway,
      "guestinfo.cis.appliance.net.ntp"       = var.vcda_ntp_servers,
      "dnsServers"                            = var.vcda_dns_servers,
      "searchDomains"                         = var.vcda_dns_search,
      "mtu"                                   = var.vcda_mtu
    }
  }

  lifecycle {
    ignore_changes = [
      storage_policy_id,
      host_system_id,
      vapp[0]
    ]
  }
}