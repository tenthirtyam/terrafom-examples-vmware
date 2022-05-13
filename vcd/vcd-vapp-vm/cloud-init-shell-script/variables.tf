##################################################################################
# VARIABLES
##################################################################################

# Credentials
variable "vcd_url" {
  description = "VCD URL"
  type        = string
}

variable "org" {
  type = string
}

variable "vdc" {
  type = string
}

variable "username" {
  description = "Your username Org username"
  type        = string
}

variable "password" {
  description = "Your org password"
  type        = string
  sensitive   = true
}


# VCD Settings
variable "catalog_name" {
  description = "Catalog name"
  type        = string
}

variable "template_name" {
  description = "Template name inside the catalog"
  type        = string
}

variable "direct_network_name" {
  type = string
}

# Guest VM settings
variable "guest_hostname" {
  description = "Guest hostname and instance ID to be set"
  type        = string
}


variable "guest-ssh-public-key" {
  description = "SSH public key to feed into VM. Use `ubuntu` user with this key to sign in."
  type        = string
}

variable "setup-script-name" {
  description = "CloudInit setup script name. Contains shell commands to execute after setup"
  type        = string
}
