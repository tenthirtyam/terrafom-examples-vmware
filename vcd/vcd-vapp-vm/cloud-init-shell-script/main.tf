provider "vcd" {
  user                 = var.username
  password             = var.password
  auth_type            = "integrated"
  url                  = var.vcd_url
  org                  = var.org
  vdc                  = var.vdc
  allow_unverified_ssl = var.vcd_insecure
}

resource "vcd_vapp" "terminal" {
  name = format("%s-vapp", var.guest_hostname)
}

resource "vcd_vapp_org_network" "direct" {
  vapp_name        = vcd_vapp.terminal.name
  org_network_name = var.direct_network_name
  depends_on       = [vcd_vapp.terminal]
}

resource "vcd_vapp_vm" "guest-vm" {
  name      = var.guest_hostname
  vapp_name = vcd_vapp.terminal.name

  catalog_name  = var.catalog_name
  template_name = var.template_name

  cpus   = 2
  memory = 1024

  network {
    name               = vcd_vapp_org_network.direct.org_network_name
    type               = "org"
    ip_allocation_mode = "POOL"
  }

  guest_properties = {
    "instance-id" = var.guest_hostname
    "hostname"    = var.guest_hostname
    "public-keys" = var.guest-ssh-public-key
    "user-data"   = base64encode(file(var.setup-script-name))
  }

  depends_on = [vcd_vapp_org_network.direct]
}

output "external-ip" {
  description = "VM external IP. Connect to it using `ubuntu` user (e.g. ssh ubuntu@1.1.1.1)"
  value       = tolist(vcd_vapp_vm.guest-vm.network)[0].ip
}
