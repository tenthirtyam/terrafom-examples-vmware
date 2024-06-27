##################################################################################
# PROVIDERS
##################################################################################

provider "terracurl" {
  # Configuration options
}

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

# ##################################################################################
# DATA
# ##################################################################################

data "terracurl_request" "get_ova_url" {
  depends_on = [terracurl_request.get_access_token]
  name       = "ova_url"
  url        = "${var.aria_automation_uri}/api/artifact-provider?artifact=data-collector"
  method     = "GET"
  headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(terracurl_request.get_access_token.response).access_token}"
  }
}

# VMware vSphere

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
  depends_on       = [data.terracurl_request.get_ova_url]
  name             = var.cloud_proxy_name
  remote_ovf_url   = jsondecode(data.terracurl_request.get_ova_url.response).providerUrl
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  ovf_network_map = {
    "Network 1" : data.vsphere_network.network.id
  }
}

# ##################################################################################
# RESOURCES
# ##################################################################################

# Obtain Access Token from VMware Cloud Service
resource "terracurl_request" "get_access_token" {
  name           = "access_token"
  url            = "${var.csp_uri}/csp/gateway/am/api/auth/api-tokens/authorize?refresh_token=${var.csp_api_token}"
  method         = "POST"
  response_codes = [200, 400, 404, 409, 429, 500]
  headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }

  destroy_response_codes = []
  destroy_url            = ""
  destroy_method         = ""
}

# Obtain the One Time Key (OTK) from VMware Cloud Service
resource "terracurl_request" "get_otk" {
  depends_on     = [terracurl_request.get_access_token]
  name           = "ova_url"
  url            = "${var.aria_automation_uri}/api/otk-v3"
  method         = "POST"
  response_codes = [200, 400, 404, 409, 429, 500]
  headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(terracurl_request.get_access_token.response).access_token}"
  }
  request_body = <<EOF
{
  "url": "${var.aria_automation_uri}",
  "service":"cloud_assembly"
}
EOF

  destroy_response_codes = []
  destroy_url            = ""
  destroy_method         = ""
}

resource "vsphere_virtual_machine" "cloud_proxy" {
  depends_on = [
    terracurl_request.get_otk,
    data.vsphere_ovf_vm_template.ovf
  ]
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
    allow_unverified_ssl_cert = true
    remote_ovf_url            = var.cloud_proxy_ovf_remote
    disk_provisioning         = var.cloud_proxy_disk_provisioning
    ovf_network_map           = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }
  vapp {
    properties = {
      "ONE_TIME_KEY"                 = jsondecode(terracurl_request.get_otk.response).key
      "itfm_root_password"           = var.cloud_proxy_root_password
      "rdc_name"                     = var.cloud_proxy_name
      "network_proxy_hostname_or_ip" = var.cloud_proxy_network_proxy_hostname_ip
      "network_proxy_port"           = var.cloud_proxy_network_proxy_port
      "network_proxy_username"       = var.cloud_proxy_network_proxy_username
      "network_proxy_password"       = var.cloud_proxy_network_proxy_password
      "ip0"                          = var.cloud_proxy_ip_address
      "netmask0"                     = var.cloud_proxy_netmask
      "gateway"                      = var.cloud_proxy_gateway
      "DNS"                          = var.cloud_proxy_dns_servers
      "domain"                       = var.cloud_proxy_domain
      "searchpath"                   = var.cloud_proxy_dns_search
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
