##################################################################################
# PROVIDERS
##################################################################################

provider "terracurl" {
  # Configuration options
}

provider "time" {
}

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

provider "vra" {
  url                         = var.aria_automation_uri
  refresh_token               = var.csp_api_token
  insecure                    = var.aria_automation_insecure
}

# ##################################################################################
# DATA
# ##################################################################################

data "terracurl_request" "get_ova_url" {
  depends_on = [
    terracurl_request.get_access_token
  ]
  name       = "ova_url"
  url        = "${var.aria_automation_uri}/api/artifact-provider?artifact=cexp-data-collector"
  method     = "GET"
  headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(terracurl_request.get_access_token.response).access_token}"
  }
}

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
  ovf_network_map = {
    "Network 1" : data.vsphere_network.network.id
  }
}

data "vra_data_collector" "cloud_proxy" {
  depends_on = [
    time_sleep.nap
  ]
  name = var.cloud_proxy_name
}

data "tls_certificate" "example_content" {
  depends_on     = [
    data.vra_data_collector.cloud_proxy
  ]
  url = "https://${data.vra_data_collector.cloud_proxy.hostname}"
  verify_chain = false
}

##################################################################################
# RESOURCES
##################################################################################

# Obtain Access Token from VMware Cloud Service
resource "terracurl_request" "get_access_token" {
  name           = "access_token"
  url            = "${var.csp_uri}/csp/gateway/am/api/auth/api-tokens/authorize?refresh_token=${var.csp_api_token}"
  method         = "POST"
  response_codes = [200, 400, 404, 409, 429, 500]
  headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }
}

# Obtain the One Time Key (OTK) from VMware Cloud Service
resource "terracurl_request" "get_otk" {
  depends_on     = [
    terracurl_request.get_access_token
  ]
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
  "service":"cloud_assembly_extensibility"
}
EOF
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
    remote_ovf_url    = var.cloud_proxy_ovf_remote
    deployment_option = var.cloud_proxy_deployment_option
    disk_provisioning = var.cloud_proxy_disk_provisioning
    ovf_network_map   = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }
  vapp {
    properties = {
      "ONE_TIME_KEY"                 = jsondecode(terracurl_request.get_otk.response).key
      "vami.hostname"                = var.cloud_proxy_hostname
      "varoot-password"              = var.cloud_proxy_root_password
      "rdc_name"                     = var.cloud_proxy_name
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
  lifecycle { 
    ignore_changes = [ # Items to be ignored when re-applying a plan

    ]
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

resource "time_sleep" "nap" {
  depends_on = [
    vsphere_virtual_machine.cloud_proxy
  ]
  create_duration = "900s"
}

resource "terracurl_request" "create_vro_integration" {
  depends_on     = [
    terracurl_request.get_access_token,
    data.vra_data_collector.cloud_proxy,
    time_sleep.nap
  ]
  name           = "vro_integration"
  url            = "${var.aria_automation_uri}/iaas/api/integrations?apiVersion=2021-07-15"
  method         = "POST"
  response_codes = [202, 400, 403]
  headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(terracurl_request.get_access_token.response).access_token}"
  }
  request_body = <<EOF
{
	"certificateInfo": {
		"certificate": "${data.tls_certificate.example_content.certificates[0].cert_pem}"
	},
	"customProperties": {
		"endpointEnabled": true
	},
	"integrationProperties": {
		"acceptSelfSignedCertificate": false,
		"dcId": "${data.vra_data_collector.cloud_proxy.id}",
		"hostName": "https://${data.vra_data_collector.cloud_proxy.hostname}:443",
		"privateKey": "",
		"privateKeyId": "",
		"refreshToken": "${var.csp_api_token}",
		"vroAuthType": "CSP"
	},
	"integrationType": "vro",
	"name": "${var.vro_integration_name}",
	"privateKey": "",
	"privateKeyId": "",
  "tags": [
    {
      "key": "integration",
      "value": "${var.vro_integration_tag}"
    }
  ]
}
EOF
}